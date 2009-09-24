From: akpm@linux-foundation.org
Subject: [merged] mwave-fix-read-buffer-overflow.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:15 -0700
Message-ID: <200909241936.n8OJaFIc002101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbZIXTgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     mwave: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     mwave-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

