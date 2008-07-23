From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:38:18 -0700
Message-ID: <200807232350.m6NNouGg018737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYGWXvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, hskinnemoen@atmel.com, krzysztof.h1@poczta.fm, linux@maxim.org.za, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch

This patch was dropped because it was folded into atmel_lcdfb-avoid-division-by-zero.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#32: FILE: drivers/video/atmel_lcdfb.c:259:
+static const struct fb_videomode *atmel_lcdfb_choose_mode(struct fb_var_screeninfo *var,

WARNING: braces {} are not necessary for single statement blocks
#40: FILE: drivers/video/atmel_lcdfb.c:267:
+	if (fbmode) {
+		fb_videomode_to_var(var, fbmode);
+	}

total: 0 errors, 2 warnings, 66 lines checked

./patches/atmel_lcdfb-avoid-division-by-zero.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes
+++ a/drivers/video/atmel_lcdfb.c
@@ -264,9 +264,8 @@ static const struct fb_videomode *atmel_
 
 	fb_var_to_videomode(&varfbmode, var);
 	fbmode = fb_find_nearest_mode(&varfbmode, &info->modelist);
-	if (fbmode) {
+	if (fbmode)
 		fb_videomode_to_var(var, fbmode);
-	}
 	return fbmode;
 }
 
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
atmel_lcdfb-avoid-division-by-zero.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

