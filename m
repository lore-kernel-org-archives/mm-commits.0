From: akpm@linux-foundation.org
Subject: + mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace.patch added to -mm tree
Date: Wed, 23 May 2012 15:37:38 -0700
Message-ID: <20120523223738.AED45A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36083 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2EWWhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 18:37:39 -0400
Received: by qabg24 with SMTP id g24so601377qab.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 15:37:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, davej@redhat.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm, oom: normalize oom scores to oom_score_adj scale only for userspace
has been added to the -mm tree.  Its filename is
     mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: normalize oom scores to oom_score_adj scale only for userspace

The oom_score_adj scale ranges from -1000 to 1000 and represents the
proportion of memory available to the process at allocation time.  This
means an oom_score_adj value of 300, for example, will bias a process as
though it was using an extra 30.0% of available memory and a value of -350
will discount 35.0% of available memory from its usage.

The oom killer badness heuristic also uses this scale to report the oom
score for each eligible process in determining the "best" process to kill.
 Thus, it can only differentiate each process's memory usage by 0.1% of
system RAM.

On large systems, this can end up being a large amount of memory: 256MB on
256GB systems, for example.

This can be fixed by having the badness heuristic to use the actual memory
usage in scoring threads and then normalizing it to the oom_score_adj
scale for userspace.  This results in better comparison between eligible
threads for kill and no change from the userspace perspective.

Suggested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |    5 ++--
 include/linux/oom.h |    5 ++--
 mm/oom_kill.c       |   44 +++++++++++++++---------------------------
 3 files changed, 22 insertions(+), 32 deletions(-)

diff -puN fs/proc/base.c~mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace fs/proc/base.c
--- a/fs/proc/base.c~mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace
+++ a/fs/proc/base.c
@@ -411,12 +411,13 @@ static const struct file_operations proc
 
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
+	unsigned long totalpages = totalram_pages + total_swap_pages;
 	unsigned long points = 0;
 
 	read_lock(&tasklist_lock);
 	if (pid_alive(task))
-		points = oom_badness(task, NULL, NULL,
-					totalram_pages + total_swap_pages);
+		points = oom_badness(task, NULL, NULL, totalpages) *
+						1000 / totalpages;
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
diff -puN include/linux/oom.h~mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace
+++ a/include/linux/oom.h
@@ -43,8 +43,9 @@ enum oom_constraint {
 extern void compare_swap_oom_score_adj(int old_val, int new_val);
 extern int test_set_oom_score_adj(int new_val);
 
-extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
-			const nodemask_t *nodemask, unsigned long totalpages);
+extern unsigned long oom_badness(struct task_struct *p,
+		struct mem_cgroup *memcg, const nodemask_t *nodemask,
+		unsigned long totalpages);
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
diff -puN mm/oom_kill.c~mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace
+++ a/mm/oom_kill.c
@@ -180,10 +180,10 @@ static bool oom_unkillable_task(struct t
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
-		      const nodemask_t *nodemask, unsigned long totalpages)
+unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
+			  const nodemask_t *nodemask, unsigned long totalpages)
 {
-	long points;
+	unsigned long points;
 
 	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
@@ -198,21 +198,11 @@ unsigned int oom_badness(struct task_str
 	}
 
 	/*
-	 * The memory controller may have a limit of 0 bytes, so avoid a divide
-	 * by zero, if necessary.
-	 */
-	if (!totalpages)
-		totalpages = 1;
-
-	/*
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + p->mm->nr_ptes;
-	points += get_mm_counter(p->mm, MM_SWAPENTS);
-
-	points *= 1000;
-	points /= totalpages;
+	points = get_mm_rss(p->mm) + p->mm->nr_ptes +
+		 get_mm_counter(p->mm, MM_SWAPENTS);
 	task_unlock(p);
 
 	/*
@@ -220,23 +210,20 @@ unsigned int oom_badness(struct task_str
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30;
+		points -= 30 * totalpages / 1000;
 
 	/*
 	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
 	 * either completely disable oom killing or always prefer a certain
 	 * task.
 	 */
-	points += p->signal->oom_score_adj;
+	points += p->signal->oom_score_adj * totalpages / 1000;
 
 	/*
-	 * Never return 0 for an eligible task that may be killed since it's
-	 * possible that no single user task uses more than 0.1% of memory and
-	 * no single admin tasks uses more than 3.0%.
+	 * Never return 0 for an eligible task regardless of the root bonus and
+	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
 	 */
-	if (points <= 0)
-		return 1;
-	return (points < 1000) ? points : 1000;
+	return points ? points : 1;
 }
 
 /*
@@ -314,7 +301,7 @@ static struct task_struct *select_bad_pr
 {
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
-	*ppoints = 0;
+	unsigned long chosen_points = 0;
 
 	do_each_thread(g, p) {
 		unsigned int points;
@@ -354,7 +341,7 @@ static struct task_struct *select_bad_pr
 			 */
 			if (p == current) {
 				chosen = p;
-				*ppoints = 1000;
+				chosen_points = ULONG_MAX;
 			} else if (!force_kill) {
 				/*
 				 * If this task is not being ptraced on exit,
@@ -367,12 +354,13 @@ static struct task_struct *select_bad_pr
 		}
 
 		points = oom_badness(p, memcg, nodemask, totalpages);
-		if (points > *ppoints) {
+		if (points > chosen_points) {
 			chosen = p;
-			*ppoints = points;
+			chosen_points = points;
 		}
 	} while_each_thread(g, p);
 
+	*ppoints = chosen_points * 1000 / totalpages;
 	return chosen;
 }
 
@@ -572,7 +560,7 @@ void mem_cgroup_out_of_memory(struct mem
 	}
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
-	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT;
+	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	read_lock(&tasklist_lock);
 	p = select_bad_process(&points, limit, memcg, NULL, false);
 	if (p && PTR_ERR(p) != -1UL)
_
Subject: Subject: mm, oom: normalize oom scores to oom_score_adj scale only for userspace

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-fix-null-ptr-deref-when-walking-hugepages.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch
mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch
mm-thp-remove-unnecessary-ret-variable.patch
mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch
thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch
mm-oom-normalize-oom-scores-to-oom_score_adj-scale-only-for-userspace.patch

