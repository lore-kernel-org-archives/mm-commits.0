From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 04 Mar 2016 15:59:03 -0800
Message-ID: <56da2147.P/jkBmnJsyDoOft4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760455AbcCDX7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 18:59:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@fedoraproject.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#14: 
(lkml.kernel.org/g/<20160119112812.GA10818@mwanda>)

ERROR: code indent should use tabs where possible
#251: FILE: mm/page_poison.c:15:
+        if (!buf)$

WARNING: please, no spaces at the start of a line
#251: FILE: mm/page_poison.c:15:
+        if (!buf)$

ERROR: code indent should use tabs where possible
#252: FILE: mm/page_poison.c:16:
+                return -EINVAL;$

WARNING: please, no spaces at the start of a line
#252: FILE: mm/page_poison.c:16:
+                return -EINVAL;$

ERROR: code indent should use tabs where possible
#254: FILE: mm/page_poison.c:18:
+        if (strcmp(buf, "on") == 0)$

WARNING: please, no spaces at the start of a line
#254: FILE: mm/page_poison.c:18:
+        if (strcmp(buf, "on") == 0)$

ERROR: code indent should use tabs where possible
#255: FILE: mm/page_poison.c:19:
+                want_page_poisoning = true;$

WARNING: please, no spaces at the start of a line
#255: FILE: mm/page_poison.c:19:
+                want_page_poisoning = true;$

ERROR: code indent should use tabs where possible
#259: FILE: mm/page_poison.c:23:
+        return 0;$

WARNING: please, no spaces at the start of a line
#259: FILE: mm/page_poison.c:23:
+        return 0;$

WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#352: FILE: mm/page_poison.c:116:
+		printk(KERN_ERR "pagealloc: single bit error\n");

WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#354: FILE: mm/page_poison.c:118:
+		printk(KERN_ERR "pagealloc: memory corruption\n");

total: 6 errors, 7 warnings, 311 lines checked

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_poison.c~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes mm/page_poison.c
--- a/mm/page_poison.c~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes
+++ a/mm/page_poison.c
@@ -12,15 +12,15 @@ static bool want_page_poisoning __read_m
 
 static int early_page_poison_param(char *buf)
 {
-        if (!buf)
-                return -EINVAL;
+	if (!buf)
+		return -EINVAL;
 
-        if (strcmp(buf, "on") == 0)
-                want_page_poisoning = true;
+	if (strcmp(buf, "on") == 0)
+		want_page_poisoning = true;
 	else if (strcmp(buf, "off") == 0)
 		want_page_poisoning = false;
 
-        return 0;
+	return 0;
 }
 early_param("page_poison", early_page_poison_param);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-add-a-new-vector-based-madvise-syscall-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

