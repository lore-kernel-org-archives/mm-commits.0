From: akpm@linux-foundation.org
Subject: [merged] mm-oom-fix-badness-score-underflow.patch removed from -mm tree
Date: Mon, 11 Jun 2012 12:47:57 -0700
Message-ID: <20120611194758.D7862A030B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58147 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2FKTsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 15:48:00 -0400
Received: by qabg24 with SMTP id g24so371738qab.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 12:47:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, davej@redhat.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix badness score underflow
has been removed from the -mm tree.  Its filename was
     mm-oom-fix-badness-score-underflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: fix badness score underflow

If the privileges given to root threads (3% of allowable memory) or a
negative value of /proc/pid/oom_score_adj happen to exceed the amount of
rss of a thread, its badness score overflows as a result of a7f638f999ff
("mm, oom: normalize oom scores to oom_score_adj scale only for
userspace").

Fix this by making the type signed and return 1, meaning the thread is
still eligible for kill, if the value is negative.

Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-fix-badness-score-underflow mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fix-badness-score-underflow
+++ a/mm/oom_kill.c
@@ -183,7 +183,7 @@ static bool oom_unkillable_task(struct t
 unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 			  const nodemask_t *nodemask, unsigned long totalpages)
 {
-	unsigned long points;
+	long points;
 
 	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
@@ -223,7 +223,7 @@ unsigned long oom_badness(struct task_st
 	 * Never return 0 for an eligible task regardless of the root bonus and
 	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
 	 */
-	return points ? points : 1;
+	return points > 0 ? points : 1;
 }
 
 /*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-move-full-state-transition-to-an-initcall.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch

