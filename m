From: akpm@linux-foundation.org
Subject: + mm-oom-fix-badness-score-underflow.patch added to -mm tree
Date: Fri, 08 Jun 2012 13:34:09 -0700
Message-ID: <20120608203409.A039FA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52060 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2FHUeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 16:34:10 -0400
Received: by qcsp5 with SMTP id p5so209413qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 13:34:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, davej@redhat.com, oleg@redhat.com


The patch titled
     Subject: mm, oom: fix badness score underflow
has been added to the -mm tree.  Its filename is
     mm-oom-fix-badness-score-underflow.patch

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
Subject: Subject: mm, oom: fix badness score underflow

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-oom-fix-badness-score-underflow.patch
slab-move-full-state-transition-to-an-initcall.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch

