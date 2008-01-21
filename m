From: akpm@linux-foundation.org
Subject: - scsi-only-print-data-direction-warning-once-for-a-command.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:13:33 -0800
Message-ID: <200801212313.m0LNDXVC024910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802AbYAUXNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:13:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, James.Bottomley@steeleye.com, dougg@torque.net, mm-commits@vger.kernel.org


The patch titled
     scsi: only print data direction warning once for a command
has been removed from the -mm tree.  Its filename was
     scsi-only-print-data-direction-warning-once-for-a-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: only print data direction warning once for a command
From: Andi Kleen <ak@suse.de>

When I use cdparanoia my logs get spammed a lot by

printk: 464 messages suppressed.
sg_write: data in/out 30576/30576 bytes for SCSI command 0xbe--guessing data in;
   program cdparanoia not setting count and/or reply_len properly
printk: 1078 messages suppressed.

and many more of those. With this patch the message is only printed once
for a command in a row.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Douglas Gilbert <dougg@torque.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/sg.c~scsi-only-print-data-direction-warning-once-for-a-command drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~scsi-only-print-data-direction-warning-once-for-a-command
+++ a/drivers/scsi/sg.c
@@ -602,8 +602,9 @@ sg_write(struct file *filp, const char _
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
-	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
-		if (printk_ratelimit())
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
+		static char cmd[TASK_COMM_LEN];
+		if (strcmp(current->comm, cmd) && printk_ratelimit()) {
 			printk(KERN_WARNING
 			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
 			       "guessing data in;\n" KERN_WARNING "   "
@@ -611,6 +612,9 @@ sg_write(struct file *filp, const char _
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
 			       input_size, (unsigned int) cmnd[0],
 			       current->comm);
+			strcpy(cmd, current->comm);
+		}
+	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
_

Patches currently in -mm which might be from ak@suse.de are

git-cifs.patch
git-kbuild.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-scsi-misc.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-xfs.patch
swapin_readahead-excise-numa-bogosity.patch
remove-unused-arguments-in-zone_init_free_lists.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
make-config_hpet_emulate_rtc-usable-from-modules.patch
use-the-irq-callback-interface-in-old-rtc-driver.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
modules-handle-symbols-that-have-a-zero-value.patch
allow-executables-larger-than-2gb.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
