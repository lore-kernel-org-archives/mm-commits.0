From: akpm@linux-foundation.org
Subject: + initio-merge-fallout.patch added to -mm tree
Date: Wed, 17 Oct 2007 18:22:16 -0700
Message-ID: <200710180122.l9I1MGIW017983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38233 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759900AbXJRBWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 21:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, James.Bottomley@steeleye.com, alan@redhat.com


The patch titled
     initio: merge fallout
has been added to the -mm tree.  Its filename is
     initio-merge-fallout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: initio: merge fallout
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Fix IRQ reporting - just assign the ->pci_dev pointer earlier and use the
pci_dev irq field rather than keeping a private one

Init the spinlock as it works better on SMP that way

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/initio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/initio.c~initio-merge-fallout drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~initio-merge-fallout
+++ a/drivers/scsi/initio.c
@@ -665,7 +665,7 @@ static void initio_init(struct initio_ho
 		host->max_tags[i] = 0xFF;
 	}			/* for                          */
 	printk("i91u: PCI Base=0x%04X, IRQ=%d, BIOS=0x%04X0, SCSI ID=%d\n",
-	       host->addr, host->irq,
+	       host->addr, host->pci_dev->irq,
 	       host->bios_addr, host->scsi_id);
 	/* Reset SCSI Bus */
 	if (host->config & HCC_SCSI_RESET) {
@@ -2892,6 +2892,8 @@ static int initio_probe_one(struct pci_d
 		goto out_release_region;
 	}
 
+	host->pci_dev = pdev;
+
 	host->num_scbs = num_scb;
 	host->scb = scb;
 	host->next_pending = scb;
@@ -2906,6 +2908,7 @@ static int initio_probe_one(struct pci_d
 	host->scb_end = tmp;
 	host->first_avail = scb;
 	host->last_avail = prev;
+	spin_lock_init(&host->avail_lock);
 
 	initio_init(host, phys_to_virt(bios_seg << 4));
 
@@ -2929,7 +2932,6 @@ static int initio_probe_one(struct pci_d
 	}
 
 	pci_set_drvdata(pdev, shost);
-	host->pci_dev = pdev;
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-make-request_key-and-co-fundamentally-asynchronous.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-right.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate.patch
git-libata-all.patch
pata_cs5536-mwdma-fix.patch
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
initio-merge-fallout.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
