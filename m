From: akpm@linux-foundation.org
Subject: + schedh-dont-include-mm_typesh-fix.patch added to -mm tree
Date: Wed, 19 Aug 2015 16:35:02 -0700
Message-ID: <55d512a6.ZEPy6m8YVI9VeqyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbHSXfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Aug 2015 19:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mgorman@techsingularity.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: schedh-dont-include-mm_typesh-fix
has been added to the -mm tree.  Its filename is
     schedh-dont-include-mm_typesh-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/schedh-dont-include-mm_typesh-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/schedh-dont-include-mm_typesh-fix.patch

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
Subject: schedh-dont-include-mm_typesh-fix

move struct task_rss_stat to mm-rss.h

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm-rss.h |    9 +++++++++
 include/linux/sched.h  |    8 --------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/mm-rss.h~schedh-dont-include-mm_typesh-fix include/linux/mm-rss.h
--- a/include/linux/mm-rss.h~schedh-dont-include-mm_typesh-fix
+++ a/include/linux/mm-rss.h
@@ -1,6 +1,7 @@
 #ifndef MM_RSS_H_INCLUDED
 #define MM_RSS_H_INCLUDED
 
+#include <linux/mm-config.h>
 #include <asm-generic/atomic-long.h>
 
 enum {
@@ -14,4 +15,12 @@ struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
 };
 
+#ifdef SPLIT_RSS_COUNTING
+/* per-thread cached information, */
+struct task_rss_stat {
+	int events;	/* for synchronization threshold */
+	int count[NR_MM_COUNTERS];
+};
+#endif /* USE_SPLIT_PTE_PTLOCKS */
+
 #endif		/* MM_RSS_H_INCLUDED */
diff -puN include/linux/sched.h~schedh-dont-include-mm_typesh-fix include/linux/sched.h
--- a/include/linux/sched.h~schedh-dont-include-mm_typesh-fix
+++ a/include/linux/sched.h
@@ -1294,14 +1294,6 @@ struct tlbflush_unmap_batch {
 	bool writable;
 };
 
-#ifdef SPLIT_RSS_COUNTING
-/* per-thread cached information, */
-struct task_rss_stat {
-	int events;	/* for synchronization threshold */
-	int count[NR_MM_COUNTERS];
-};
-#endif /* USE_SPLIT_PTE_PTLOCKS */
-
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
mm-make-page-pfmemalloc-check-more-robust-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-2.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next.patch
linux-next-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
schedh-dont-include-mm_typesh.patch
schedh-dont-include-mm_typesh-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

