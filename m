From: akpm@linux-foundation.org
Subject: + fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch added to -mm tree
Date: Tue, 08 May 2007 17:04:55 -0700
Message-ID: <200705090004.l4904tJu005459@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967887AbXEIAFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     Fix old SCSI adapter crashes with CD-ROM (take 2)
has been added to the -mm tree.  Its filename is
     fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix old SCSI adapter crashes with CD-ROM (take 2)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The CD-ROM layer doesn't bounce requests for old ISA controllers (and nor
should it).  However they get injected into the SCSI layer via sr_ioctl
which also doesn't bounce them and SCSI then passes the buffer along to a
device with unchecked_isa_dma set which either panics or truncates the
buffer to 24bits.

According to Jens the right long term fix is for the CD layer to route the
requests differently but in the mean time this has been tested by a victim
and verified to sort the problem out.  For the other 99.9% of users it's a
no-op and doesn't bounce data.

(akpm: placeholder fix.  Apparently the metaphorical Mike is working on a real
fix).

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sr_ioctl.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sr_ioctl.c~fix-old-scsi-adapter-crashes-with-cd-rom-take-2 drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c~fix-old-scsi-adapter-crashes-with-cd-rom-take-2
+++ a/drivers/scsi/sr_ioctl.c
@@ -187,6 +187,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
+	void *zebedee = cgc->buffer;
 
 	SDev = cd->device;
 
@@ -198,6 +199,21 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 		}
 	}
 
+	if (cgc->buflen && cd->device->host->unchecked_isa_dma) {
+		switch(cgc->data_direction) {
+			case DMA_NONE:
+				break;
+			case DMA_FROM_DEVICE:
+			case DMA_TO_DEVICE:
+				zebedee = kmalloc(cgc->buflen, GFP_KERNEL|GFP_DMA);
+				if (zebedee ==NULL) {
+					err = -ENOMEM;
+					goto out;
+				}
+		}
+		if (cgc->data_direction == DMA_TO_DEVICE)
+			memcpy(zebedee, cgc->buffer, cgc->buflen);
+	}
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
 		err = -ENODEV;
@@ -206,11 +222,16 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 
 	memset(sense, 0, sizeof(*sense));
 	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, (char *)sense,
+			      zebedee, cgc->buflen, (char *)sense,
 			      cgc->timeout, IOCTL_RETRIES, 0);
 
 	scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
 
+	if (zebedee != cgc->buffer) {
+		if (cgc->data_direction == DMA_FROM_DEVICE)
+			memcpy(cgc->buffer, zebedee, cgc->buflen);
+	}
+
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (driver_byte(result) != 0) {
 		switch (sshdr.sense_key) {
@@ -266,6 +287,8 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 
 	/* Wake up a process waiting for device */
       out:
+	if (zebedee != cgc->buffer)
+		kfree(zebedee);	/* Time for bed */
 	if (!cgc->sense)
 		kfree(sense);
 	cgc->stat = err;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
remove-redundant-check-from-proc_sys_setattr.patch
apm-fix-incorrect-comment.patch
console-utf-8-fixes.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-pata_qdic-probe-code.patch
pata_scc-fix-compilation.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
upper-32-bits.patch
tty_set_ldisc-receive_room-fix.patch
tty-add-compat_ioctl.patch
tty-add-compat_ioctl-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
