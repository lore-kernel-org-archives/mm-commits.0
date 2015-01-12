From: akpm@linux-foundation.org
Subject: + pm-convert-printk-to-pr_-equivalent.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:59:57 -0800
Message-ID: <54b45ffd.TdU0qeWbA4X+wbAB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbALX76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: PM: convert printk to pr_* equivalent
has been added to the -mm tree.  Its filename is
     pm-convert-printk-to-pr_-equivalent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pm-convert-printk-to-pr_-equivalent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pm-convert-printk-to-pr_-equivalent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: PM: convert printk to pr_* equivalent

While touching this area let's convert printk to pr_*.  This also makes
the printing of continuation lines done properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN kernel/power/process.c~pm-convert-printk-to-pr_-equivalent kernel/power/process.c
--- a/kernel/power/process.c~pm-convert-printk-to-pr_-equivalent
+++ a/kernel/power/process.c
@@ -84,8 +84,8 @@ static int try_to_freeze_tasks(bool user
 	elapsed_msecs = elapsed_msecs64;
 
 	if (todo) {
-		printk("\n");
-		printk(KERN_ERR "Freezing of tasks %s after %d.%03d seconds "
+		pr_cont("\n");
+		pr_err("Freezing of tasks %s after %d.%03d seconds "
 		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
 		       wakeup ? "aborted" : "failed",
 		       elapsed_msecs / 1000, elapsed_msecs % 1000,
@@ -101,7 +101,7 @@ static int try_to_freeze_tasks(bool user
 			read_unlock(&tasklist_lock);
 		}
 	} else {
-		printk("(elapsed %d.%03d seconds) ", elapsed_msecs / 1000,
+		pr_cont("(elapsed %d.%03d seconds) ", elapsed_msecs / 1000,
 			elapsed_msecs % 1000);
 	}
 
@@ -155,7 +155,7 @@ int freeze_processes(void)
 		atomic_inc(&system_freezing_cnt);
 
 	pm_wakeup_clear();
-	printk("Freezing user space processes ... ");
+	pr_info("Freezing user space processes ... ");
 	pm_freezing = true;
 	oom_kills_saved = oom_kills_count();
 	error = try_to_freeze_tasks(true);
@@ -171,13 +171,13 @@ int freeze_processes(void)
 		if (oom_kills_count() != oom_kills_saved &&
 		    !check_frozen_processes()) {
 			__usermodehelper_set_disable_depth(UMH_ENABLED);
-			printk("OOM in progress.");
+			pr_cont("OOM in progress.");
 			error = -EBUSY;
 		} else {
-			printk("done.");
+			pr_cont("done.");
 		}
 	}
-	printk("\n");
+	pr_cont("\n");
 	BUG_ON(in_atomic());
 
 	if (error)
@@ -197,13 +197,14 @@ int freeze_kernel_threads(void)
 {
 	int error;
 
-	printk("Freezing remaining freezable tasks ... ");
+	pr_info("Freezing remaining freezable tasks ... ");
+
 	pm_nosig_freezing = true;
 	error = try_to_freeze_tasks(false);
 	if (!error)
-		printk("done.");
+		pr_cont("done.");
 
-	printk("\n");
+	pr_cont("\n");
 	BUG_ON(in_atomic());
 
 	if (error)
@@ -224,7 +225,7 @@ void thaw_processes(void)
 
 	oom_killer_enable();
 
-	printk("Restarting tasks ... ");
+	pr_info("Restarting tasks ... ");
 
 	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
@@ -243,7 +244,7 @@ void thaw_processes(void)
 	usermodehelper_enable();
 
 	schedule();
-	printk("done.\n");
+	pr_cont("done.\n");
 	trace_suspend_resume(TPS("thaw_processes"), 0, false);
 }
 
@@ -252,7 +253,7 @@ void thaw_kernel_threads(void)
 	struct task_struct *g, *p;
 
 	pm_nosig_freezing = false;
-	printk("Restarting kernel threads ... ");
+	pr_info("Restarting kernel threads ... ");
 
 	thaw_workqueues();
 
@@ -264,5 +265,5 @@ void thaw_kernel_threads(void)
 	read_unlock(&tasklist_lock);
 
 	schedule();
-	printk("done.\n");
+	pr_cont("done.\n");
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

