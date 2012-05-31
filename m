From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-cleanups.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:05 -0700
Message-ID: <20120531191605.5CFBFA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:39916 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab2EaTQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:06 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so137962yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, shangw@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: cleanups
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc.c: cleanups

- make pageflag_names[] const

- remove null termination of pageflag_names[]

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-cleanups mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-cleanups
+++ a/mm/page_alloc.c
@@ -5938,7 +5938,7 @@ bool is_free_buddy_page(struct page *pag
 }
 #endif
 
-static struct trace_print_flags pageflag_names[] = {
+static const struct trace_print_flags pageflag_names[] = {
 	{1UL << PG_locked,		"locked"	},
 	{1UL << PG_error,		"error"		},
 	{1UL << PG_referenced,		"referenced"	},
@@ -5976,7 +5976,6 @@ static struct trace_print_flags pageflag
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{1UL << PG_compound_lock,	"compound_lock"	},
 #endif
-	{-1UL,				NULL		},
 };
 
 static void dump_page_flags(unsigned long flags)
@@ -5985,14 +5984,14 @@ static void dump_page_flags(unsigned lon
 	unsigned long mask;
 	int i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) - 1 != __NR_PAGEFLAGS);
+	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
 
 	printk(KERN_ALERT "page flags: %#lx(", flags);
 
 	/* remove zone id */
 	flags &= (1UL << NR_PAGEFLAGS) - 1;
 
-	for (i = 0; pageflag_names[i].name && flags; i++) {
+	for (i = 0; i < ARRAY_SIZE(pageflag_names) && flags; i++) {
 
 		mask = pageflag_names[i].mask;
 		if ((flags & mask) != mask)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

