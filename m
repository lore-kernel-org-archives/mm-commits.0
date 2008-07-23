From: akpm@linux-foundation.org
Subject: - drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:36:54 -0700
Message-ID: <200807232349.m6NNnWg6018596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825AbYGWXtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, benh@kernel.crashing.org, tony@bakeyournoodle.com, mm-commits@vger.kernel.org


The patch titled
     drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#36: FILE: drivers/video/aty/radeon_base.c:2344:
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);

WARNING: line over 80 characters
#39: FILE: drivers/video/aty/radeon_base.c:2346:
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);

ERROR: code indent should use tabs where possible
#42: FILE: drivers/video/aty/radeon_base.c:2349:
+^I^I           __func__);$

total: 1 errors, 2 warnings, 21 lines checked

./patches/drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Cc: tony@bakeyournoodle.com (Tony Breeds)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes
+++ a/drivers/video/aty/radeon_base.c
@@ -2341,12 +2341,14 @@ static int __devinit radeonfb_pci_regist
 
 	/* Register some sysfs stuff (should be done better) */
 	if (rinfo->mon1_EDID)
-		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj,
+						&edid1_attr);
 	if (rinfo->mon2_EDID)
-		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj,
+						&edid2_attr);
 	if (err)
 		pr_warning("%s() Creating sysfs files failed, continuing\n",
-		           __func__);
+			   __func__);
 
 	/* save current mode regs before we switch into the new one
 	 * so we can restore this upon __exit
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
kill-generic_file_direct_io.patch
use-generic_access_phys-for-dev-mem-mappings.patch
spufs-use-the-new-vm_ops-access.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
page-flags-record-page-flag-overlays-explicitly.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that.patch
vmallocinfo-add-numa-information.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
bootmem-add-debugging-framework.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
flag-parameters-paccept.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-inotify_init.patch
flag-parameters-check-magic-constants.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
rtc-cmos-improve-hpet-irq-glue.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

