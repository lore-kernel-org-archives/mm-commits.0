From: akpm@linux-foundation.org
Subject: + libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch added to -mm tree
Date: Tue, 20 May 2008 11:57:29 -0700
Message-ID: <200805201857.m4KIvUDH006187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757717AbYETS6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 14:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata-sff: fix oops reported in kerneloops.org for pnp devices with no ctl
has been added to the -mm tree.  Its filename is
     libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata-sff: fix oops reported in kerneloops.org for pnp devices with no ctl
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This fixes most common oops #5 on Arjan's kerneloops.org site

Not all controllers have ctl/altstatus.  In particular many ISAPnP
controllers omit them.  While libata should handle this it generally only
got the ctl port (the write side) correct.

Functions
- ata_sff_maybe_altstatus - this uses the status if altstatus is not available.
  In the longer term I believe each use of it is in fact removable but don't
  want to perturb anything during the -rc releases
- ata_sff_pause - don't use altstatus I/O for fencing if we don't have one
- ata_sff_sync - add a fencing call so we can distinguish fencing from real
		 altstatus usage. All non ctl/altstatus controllers are PIO
		 so do not need a fence

Code wise we then use maybe_altstatus in the IRQ path (where we should
only check status and the current code is actually I think buggy), and for
DMA completion (no non ctl/altstatus controller does DMA but need to
finish verifying the calling cases).

This has been tested with ctl/altstatus faked to be unavailable on
controllers I have and works.  You get some spew about failed identify but
that is another issue that can be fixed later and it does all work.  Also
the spew only occurs on controllers that currently just go wrong.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c  |   81 ++++++++++++++++++++++++++++++++----
 drivers/ata/pata_icside.c |    2 
 include/linux/libata.h    |   14 ------
 3 files changed, 76 insertions(+), 21 deletions(-)

diff -puN drivers/ata/libata-sff.c~libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl
+++ a/drivers/ata/libata-sff.c
@@ -256,6 +256,72 @@ u8 ata_sff_altstatus(struct ata_port *ap
 }
 
 /**
+ *	ata_sff_maybe_altstatus - Read device alternate status reg
+ *	@ap: port where the device is
+ *
+ *	TEMPORARY:
+ *
+ *	Reads ATA taskfile alternate status register for
+ *	currently-selected device and return its value. Uses the
+ *	status register as an alternative.
+ *
+ *	Note: may NOT be used as the check_altstatus() entry in
+ *	ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static u8 ata_sff_maybe_altstatus(struct ata_port *ap)
+{
+	if (ap->ops->sff_check_altstatus)
+		return ap->ops->sff_check_altstatus(ap);
+	else if (ap->ioaddr.altstatus_addr)
+		return ioread8(ap->ioaddr.altstatus_addr);
+	else
+		return ata_sff_check_status(ap);
+}
+
+/**
+ *	ata_sff_sync - Flush writes
+ *	@ap: Port to wait for.
+ *
+ *	CAUTION:
+ *	If we have an mmio device with no ctl and no altstatus
+ *	method this will fail. No such devices are known to exist.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+static void ata_sff_sync(struct ata_port *ap)
+{
+	if (ap->ops->sff_check_altstatus)
+		ap->ops->sff_check_altstatus(ap);
+	else if (ap->ioaddr.altstatus_addr)
+		ioread8(ap->ioaddr.altstatus_addr);
+	ndelay(400);
+}
+
+/**
+ *	ata_sff_pause - Flush writes and wait 400nS
+ *	@ap: Port to wait for.
+ *
+ *	CAUTION:
+ *	If we have an mmio device with no ctl and no altstatus
+ *	method this will fail. No such devices are known to exist.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+void ata_sff_pause(struct ata_port *ap)
+{
+	ata_sff_sync(ap);
+	ndelay(400);
+}
+
+
+/**
  *	ata_sff_busy_sleep - sleep until BSY clears, or timeout
  *	@ap: port containing status register to be polled
  *	@tmout_pat: impatience timeout
@@ -742,7 +808,7 @@ static void ata_pio_sectors(struct ata_q
 	} else
 		ata_pio_sector(qc);
 
-	ata_sff_altstatus(qc->ap); /* flush */
+	ata_sff_sync(qc->ap); /* flush */
 }
 
 /**
@@ -763,7 +829,7 @@ static void atapi_send_cdb(struct ata_po
 	WARN_ON(qc->dev->cdb_len < 12);
 
 	ap->ops->sff_data_xfer(qc->dev, qc->cdb, qc->dev->cdb_len, 1);
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_pause(ap);
 
 	switch (qc->tf.protocol) {
 	case ATAPI_PROT_PIO:
@@ -905,7 +971,7 @@ static void atapi_pio_bytes(struct ata_q
 
 	if (unlikely(__atapi_pio_bytes(qc, bytes)))
 		goto err_out;
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_pause(ap); /* flush */
 
 	return;
 
@@ -1489,8 +1555,8 @@ inline unsigned int ata_sff_host_intr(st
 		goto idle_irq;
 	}
 
-	/* check altstatus */
-	status = ata_sff_altstatus(ap);
+	/* check altstatus: We don't need to do this here */
+	status = ata_sff_maybe_altstatus(ap);
 	if (status & ATA_BUSY)
 		goto idle_irq;
 
@@ -2030,7 +2096,7 @@ void ata_sff_error_handler(struct ata_po
 		ap->ops->bmdma_stop(qc);
 	}
 
-	ata_sff_altstatus(ap);
+	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
 
@@ -2203,7 +2269,7 @@ void ata_bmdma_stop(struct ata_queued_cm
 		 mmio + ATA_DMA_CMD);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_altstatus(ap);        /* dummy read */
+	ata_sff_maybe_altstatus(ap);        /* dummy read */
 }
 
 /**
@@ -2723,6 +2789,7 @@ EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dev_select);
 EXPORT_SYMBOL_GPL(ata_sff_check_status);
 EXPORT_SYMBOL_GPL(ata_sff_altstatus);
+EXPORT_SYMBOL_GPL(ata_sff_pause);
 EXPORT_SYMBOL_GPL(ata_sff_busy_sleep);
 EXPORT_SYMBOL_GPL(ata_sff_wait_ready);
 EXPORT_SYMBOL_GPL(ata_sff_tf_load);
diff -puN drivers/ata/pata_icside.c~libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl drivers/ata/pata_icside.c
--- a/drivers/ata/pata_icside.c~libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl
+++ a/drivers/ata/pata_icside.c
@@ -269,7 +269,7 @@ static void pata_icside_bmdma_stop(struc
 
 	disable_dma(state->dma);
 
-	/* see ata_bmdma_stop */
+	/* see ata_bmdma_stop: we know we have a ctl port in this case */
 	ata_sff_altstatus(ap);
 }
 
diff -puN include/linux/libata.h~libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl include/linux/libata.h
--- a/include/linux/libata.h~libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl
+++ a/include/linux/libata.h
@@ -1435,6 +1435,7 @@ extern void ata_sff_qc_prep(struct ata_q
 extern void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
+extern void ata_sff_pause(struct ata_port *ap);
 extern u8 ata_sff_altstatus(struct ata_port *ap);
 extern int ata_sff_busy_sleep(struct ata_port *ap,
 			      unsigned long timeout_pat, unsigned long timeout);
@@ -1496,19 +1497,6 @@ extern int ata_pci_sff_init_one(struct p
 #endif /* CONFIG_PCI */
 
 /**
- *	ata_sff_pause - Flush writes and pause 400 nanoseconds.
- *	@ap: Port to wait for.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-static inline void ata_sff_pause(struct ata_port *ap)
-{
-	ata_sff_altstatus(ap);
-	ndelay(400);
-}
