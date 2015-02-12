From: akpm@linux-foundation.org
Subject: [merged] pm-convert-printk-to-pr_-equivalent.patch removed from
 -mm tree
Date: Thu, 12 Feb 2015 11:37:06 -0800
Message-ID: <54dd00e2.6A1hKnmt99Att/ts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbBLThH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: PM: convert printk to pr_* equivalent
has been removed from the -mm tree.  Its filename was
     pm-convert-printk-to-pr_-equivalent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

