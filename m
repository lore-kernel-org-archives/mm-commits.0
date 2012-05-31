From: akpm@linux-foundation.org
Subject: [merged] mm-do_migrate_pages-rename-arguments.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:23 -0700
Message-ID: <20120531191423.66C01A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58058 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab2EaTOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:25 -0400
Received: by eeit10 with SMTP id t10so76254eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, mkosaki@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do_migrate_pages(): rename arguments
has been removed from the -mm tree.  Its filename was
     mm-do_migrate_pages-rename-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: do_migrate_pages(): rename arguments

s/from_nodes/from and s/to_nodes/to/.  The "_nodes" is redundant - it
duplicates the argument's type.

Done in a fit of irritation over 80-col issues :(

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <mkosaki@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    9 ++++-----
 mm/mempolicy.c            |   18 +++++++++---------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff -puN include/linux/mempolicy.h~mm-do_migrate_pages-rename-arguments include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-do_migrate_pages-rename-arguments
+++ a/include/linux/mempolicy.h
@@ -225,8 +225,8 @@ static inline void check_highest_zone(en
 		policy_zone = k;
 }
 
-int do_migrate_pages(struct mm_struct *mm,
-	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags);
+int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
+		     const nodemask_t *to, int flags);
 
 
 #ifdef CONFIG_TMPFS
@@ -354,9 +354,8 @@ static inline bool mempolicy_nodemask_in
 	return false;
 }
 
-static inline int do_migrate_pages(struct mm_struct *mm,
-			const nodemask_t *from_nodes,
-			const nodemask_t *to_nodes, int flags)
+static inline int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
+				   const nodemask_t *to, int flags)
 {
 	return 0;
 }
diff -puN mm/mempolicy.c~mm-do_migrate_pages-rename-arguments mm/mempolicy.c
--- a/mm/mempolicy.c~mm-do_migrate_pages-rename-arguments
+++ a/mm/mempolicy.c
@@ -950,8 +950,8 @@ static int migrate_to_node(struct mm_str
  *
  * Returns the number of page that could not be moved.
  */
-int do_migrate_pages(struct mm_struct *mm,
-	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags)
+int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
+		     const nodemask_t *to, int flags)
 {
 	int busy = 0;
 	int err;
@@ -963,7 +963,7 @@ int do_migrate_pages(struct mm_struct *m
 
 	down_read(&mm->mmap_sem);
 
-	err = migrate_vmas(mm, from_nodes, to_nodes, flags);
+	err = migrate_vmas(mm, from, to, flags);
 	if (err)
 		goto out;
 
@@ -998,7 +998,7 @@ int do_migrate_pages(struct mm_struct *m
 	 * moved to an empty node, then there is nothing left worth migrating.
 	 */
 
-	tmp = *from_nodes;
+	tmp = *from;
 	while (!nodes_empty(tmp)) {
 		int s,d;
 		int source = -1;
@@ -1021,11 +1021,11 @@ int do_migrate_pages(struct mm_struct *m
 			 *          [0-7] - > [3,4,5] moves only 0,1,2,6,7.
 			 */
 
-			if ((nodes_weight(*from_nodes) != nodes_weight(*to_nodes)) &&
-						(node_isset(s, *to_nodes)))
+			if ((nodes_weight(*from) != nodes_weight(*to)) &&
+						(node_isset(s, *to)))
 				continue;
 
-			d = node_remap(s, *from_nodes, *to_nodes);
+			d = node_remap(s, *from, *to);
 			if (s == d)
 				continue;
 
@@ -1085,8 +1085,8 @@ static void migrate_page_add(struct page
 {
 }
 
-int do_migrate_pages(struct mm_struct *mm,
-	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags)
+int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
+		     const nodemask_t *to, int flags)
 {
 	return -ENOSYS;
 }
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

