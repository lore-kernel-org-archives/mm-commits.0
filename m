From: akpm@linux-foundation.org
Subject: + mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
 added to -mm tree
Date: Mon, 29 Feb 2016 12:49:43 -0800
Message-ID: <56d4aee7.tXqw/OYam+sCDEj+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbcB2Uto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 15:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300, c6x: CONFIG_GENERIC_BUG must depend on CONFIG_BUG
has been added to the -mm tree.  Its filename is
     mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mn10300, c6x: CONFIG_GENERIC_BUG must depend on CONFIG_BUG

CONFIG_BUG=n && CONFIG_GENERIC_BUG=y make no sense and things break:

   In file included from include/linux/page-flags.h:9:0,
                    from kernel/bounds.c:9:
   include/linux/bug.h:91:47: warning: 'struct bug_entry' declared inside parameter list
    static inline int is_warning_bug(const struct bug_entry *bug)
                                                  ^
   include/linux/bug.h:91:47: warning: its scope is only this definition or declaration, which is probably not what you want
   include/linux/bug.h: In function 'is_warning_bug':
>> include/linux/bug.h:93:12: error: dereferencing pointer to incomplete type
     return bug->flags & BUGFLAG_WARNING;

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/Kconfig     |    1 +
 arch/mn10300/Kconfig |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/c6x/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug arch/c6x/Kconfig
--- a/arch/c6x/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug
+++ a/arch/c6x/Kconfig
@@ -36,6 +36,7 @@ config GENERIC_HWEIGHT
 
 config GENERIC_BUG
 	def_bool y
+	depends on BUG
 
 config C6X_BIG_KERNEL
 	bool "Build a big kernel"
diff -puN arch/mn10300/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~mn10300-c6x-config_generic_bug-must-depend-on-config_bug
+++ a/arch/mn10300/Kconfig
@@ -53,6 +53,7 @@ config GENERIC_HWEIGHT
 
 config GENERIC_BUG
 	def_bool y
+	depends on BUG
 
 config QUICKLIST
 	def_bool y
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
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
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
mm-config_nr_zones_extended-fix.patch
mm-add-a-new-vector-based-madvise-syscall-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
net-sched-sch_mqprioc-fix-build-with-older-gcc.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

