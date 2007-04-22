From: akpm@linux-foundation.org
Subject: + pci-error-recovery-symbios-scsi-first-failure.patch added to -mm tree
Date: Sat, 21 Apr 2007 19:26:57 -0700
Message-ID: <200704220226.l3M2QvL0017847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbXDVC17 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 22:27:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, willy@debian.org


The patch titled
     PCI Error Recovery: Symbios SCSI First Failure
has been added to the -mm tree.  Its filename is
     pci-error-recovery-symbios-scsi-first-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI Error Recovery: Symbios SCSI First Failure
From: Linas Vepstas <linas@austin.ibm.com>

Implement the so-called "first failure data capture" (FFDC) for the symbios
PCI error recovery.  After a PCI error event is reported, the driver
requests that MMIO be enabled.  Once enabled, it then reads and dumps
assorted status registers, and concludes by requesting the usual reset
sequence.

(includes a whitespace fix for bad indentation).

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c8xx_2/sym_glue.c |   15 +++++++++++++++
 drivers/scsi/sym53c8xx_2/sym_glue.h |    1 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   18 ++++++++++++++----
 3 files changed, 30 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~pci-error-recovery-symbios-scsi-first-failure drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c~pci-error-recovery-symbios-scsi-first-failure
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1987,6 +1987,20 @@ static pci_ers_result_t sym2_io_error_de
 	disable_irq(pdev->irq);
 	pci_disable_device(pdev);
 
+	/* Request that MMIO be enabled, so register dump can be taken. */
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
+
+/**
+ * sym2_io_slot_dump -- Enable MMIO and dump debug registers
+ * @pdev: pointer to PCI device
+ */
+static pci_ers_result_t sym2_io_slot_dump (struct pci_dev *pdev)
+{
+	struct sym_hcb *np = pci_get_drvdata(pdev);
+
+	sym_dump_registers(np);
+
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -2241,6 +2255,7 @@ MODULE_DEVICE_TABLE(pci, sym2_id_table);
 
 static struct pci_error_handlers sym2_err_handler = {
 	.error_detected = sym2_io_error_detected,
+	.mmio_enabled = sym2_io_slot_dump,
 	.slot_reset = sym2_io_slot_reset,
 	.resume = sym2_io_resume,
 };
diff -puN drivers/scsi/sym53c8xx_2/sym_glue.h~pci-error-recovery-symbios-scsi-first-failure drivers/scsi/sym53c8xx_2/sym_glue.h
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h~pci-error-recovery-symbios-scsi-first-failure
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -270,5 +270,6 @@ void sym_xpt_async_bus_reset(struct sym_
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
 int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 void sym_log_bus_error(struct sym_hcb *np);
+void sym_dump_registers(struct sym_hcb *np);
 
 #endif /* SYM_GLUE_H */
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~pci-error-recovery-symbios-scsi-first-failure drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c~pci-error-recovery-symbios-scsi-first-failure
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1180,10 +1180,10 @@ static void sym_log_hard_error(struct sy
 			scr_to_cpu((int) *(u32 *)(script_base + script_ofs)));
 	}
 
-        printf ("%s: regdump:", sym_name(np));
-        for (i=0; i<24;i++)
-            printf (" %02x", (unsigned)INB_OFF(np, i));
-        printf (".\n");
+	printf ("%s: regdump:", sym_name(np));
+	for (i=0; i<24;i++)
+	    printf (" %02x", (unsigned)INB_OFF(np, i));
+	printf (".\n");
 
 	/*
 	 *  PCI BUS error.
@@ -1192,6 +1192,16 @@ static void sym_log_hard_error(struct sy
 		sym_log_bus_error(np);
 }
 
+void sym_dump_registers(struct sym_hcb *np)
+{
+	u_short sist;
+	u_char dstat;
+
+	sist = INW(np, nc_sist);
+	dstat = INB(np, nc_dstat);
+	sym_log_hard_error(np, sist, dstat);
+}
+
 static struct sym_chip sym_dev_table[] = {
  {PCI_DEVICE_ID_NCR_53C810, 0x0f, "810", 4, 8, 4, 64,
  FE_ERL}
_

Patches currently in -mm which might be from linas@austin.ibm.com are

git-powerpc.patch
pci-error-recovery-symbios-scsi-base-support.patch
pci-error-recovery-symbios-scsi-base-support-fixes.patch
pci-error-recovery-symbios-scsi-first-failure.patch
pci-error-recovery-symbios-scsi-first-failure-fix.patch
spidernet-fix-problem-sending-ip-fragments.patch
