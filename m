From: akpm@linux-foundation.org
Subject: - security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:20:42 -0700
Message-ID: <200807232333.m6NNXJWJ017884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbYGWXeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch

This patch was dropped because it was folded into security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: return is not a function, parentheses are not required
#113: FILE: security/commoncap.c:263:
+	return (bprm->cap_effective ? ret : 0);

total: 1 errors, 0 warnings, 180 lines checked

./patches/security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrew G. Morgan <morgan@kernel.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/binfmts.h~security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes include/linux/binfmts.h
diff -puN security/commoncap.c~security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes security/commoncap.c
--- a/security/commoncap.c~security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes
+++ a/security/commoncap.c
@@ -258,7 +258,7 @@ static inline int cap_from_disk(struct v
 	 * do not have enough capabilities, we return an error if they are
 	 * missing some "forced" (aka file-permitted) capabilities.
 	 */
-	return (bprm->cap_effective ? ret : 0);
+	return bprm->cap_effective ? ret : 0;
 }
 
 /* Locate any VFS capabilities: */
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
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
rtc-cmos-improve-hpet-irq-glue-build-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

