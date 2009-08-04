From: akpm@linux-foundation.org
Subject: + mwave-fix-read-buffer-overflow.patch added to -mm tree
Date: Tue, 04 Aug 2009 14:34:49 -0700
Message-ID: <200908042134.n74LYne8001904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601AbZHDVfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 17:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org


The patch titled
     mwave: fix read buffer overflow
has been added to the -mm tree.  Its filename is
     mwave-fix-read-buffer-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mwave: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before grabbing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mwave/mwavedd.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/char/mwave/mwavedd.c~mwave-fix-read-buffer-overflow drivers/char/mwave/mwavedd.c
--- a/drivers/char/mwave/mwavedd.c~mwave-fix-read-buffer-overflow
+++ a/drivers/char/mwave/mwavedd.c
@@ -281,12 +281,6 @@ static long mwave_ioctl(struct file *fil
 		case IOCTL_MW_REGISTER_IPC: {
 			unsigned int ipcnum = (unsigned int) ioarg;
 	
-			PRINTK_3(TRACE_MWAVE,
-				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
-				" ipcnum %x entry usIntCount %x\n",
-				ipcnum,
-				pDrvData->IPCs[ipcnum].usIntCount);
-	
 			if (ipcnum >= ARRAY_SIZE(pDrvData->IPCs)) {
 				PRINTK_ERROR(KERN_ERR_MWAVE
 						"mwavedd::mwave_ioctl:"
@@ -295,6 +289,12 @@ static long mwave_ioctl(struct file *fil
 						ipcnum);
 				return -EINVAL;
 			}
+			PRINTK_3(TRACE_MWAVE,
+				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
+				" ipcnum %x entry usIntCount %x\n",
+				ipcnum,
+				pDrvData->IPCs[ipcnum].usIntCount);
+
 			lock_kernel();
 			pDrvData->IPCs[ipcnum].bIsHere = FALSE;
 			pDrvData->IPCs[ipcnum].bIsEnabled = TRUE;
@@ -310,11 +310,6 @@ static long mwave_ioctl(struct file *fil
 		case IOCTL_MW_GET_IPC: {
 			unsigned int ipcnum = (unsigned int) ioarg;
 	
-			PRINTK_3(TRACE_MWAVE,
-				"mwavedd::mwave_ioctl IOCTL_MW_GET_IPC"
-				" ipcnum %x, usIntCount %x\n",
-				ipcnum,
-				pDrvData->IPCs[ipcnum].usIntCount);
 			if (ipcnum >= ARRAY_SIZE(pDrvData->IPCs)) {
 				PRINTK_ERROR(KERN_ERR_MWAVE
 						"mwavedd::mwave_ioctl:"
@@ -322,6 +317,11 @@ static long mwave_ioctl(struct file *fil
 						" Invalid ipcnum %x\n", ipcnum);
 				return -EINVAL;
 			}
+			PRINTK_3(TRACE_MWAVE,
+				"mwavedd::mwave_ioctl IOCTL_MW_GET_IPC"
+				" ipcnum %x, usIntCount %x\n",
+				ipcnum,
+				pDrvData->IPCs[ipcnum].usIntCount);
 	
 			lock_kernel();
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
kgdb-remove-redundant-test.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-fsl-booke-read-buffer-overflow.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
hid-fix-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
kvm-fix-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
mips-read-buffer-overflow.patch
slram-read-buffer-overflow.patch
slram-read-buffer-overflow-cleanup.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
drivers-parisc-pdc_stablec-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
perf-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-iprh-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
usb-gadget-read-buffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

