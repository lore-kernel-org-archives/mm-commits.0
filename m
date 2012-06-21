From: akpm@linux-foundation.org
Subject: [merged] mm-oom-fix-and-cleanup-oom-score-calculations.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:15 -0700
Message-ID: <20120621192515.740CDA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59484 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759961Ab2FUTZS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:18 -0400
Received: by bkty5 with SMTP id y5so63386bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, davej@redhat.com, kosaki.motohiro@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix and cleanup oom score calculations
has been removed from the -mm tree.  Its filename was
     mm-oom-fix-and-cleanup-oom-score-calculations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: fix and cleanup oom score calculations

The divide in p->signal->oom_score_adj * totalpages / 1000 within
oom_badness() was causing an overflow of the signed long data type.

This adds both the root bias and p->signal->oom_score_adj before doing the
normalization which fixes the issue and also cleans up the calculation.

Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-fix-and-cleanup-oom-score-calculations mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fix-and-cleanup-oom-score-calculations
+++ a/mm/oom_kill.c
@@ -184,6 +184,7 @@ unsigned long oom_badness(struct task_st
 			  const nodemask_t *nodemask, unsigned long totalpages)
 {
 	long points;
+	long adj;
 
 	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
@@ -192,7 +193,8 @@ unsigned long oom_badness(struct task_st
 	if (!p)
 		return 0;
 
-	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+	adj = p->signal->oom_score_adj;
+	if (adj == OOM_SCORE_ADJ_MIN) {
 		task_unlock(p);
 		return 0;
 	}
@@ -210,14 +212,11 @@ unsigned long oom_badness(struct task_st
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30 * totalpages / 1000;
+		adj -= 30;
 
-	/*
-	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
-	 * either completely disable oom killing or always prefer a certain
-	 * task.
-	 */
-	points += p->signal->oom_score_adj * totalpages / 1000;
+	/* Normalize to oom_score_adj units */
+	adj *= totalpages / 1000;
+	points += adj;
 
 	/*
 	 * Never return 0 for an eligible task regardless of the root bonus and
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
slab-move-full-state-transition-to-an-initcall.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-buddy-get-the-allownodes-for-dump-at-once.patch

