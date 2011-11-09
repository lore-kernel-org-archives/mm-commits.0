From: akpm@linux-foundation.org
Subject: + oom-do-not-kill-tasks-with-oom_score_adj-oom_score_adj_min.patch added to -mm tree
Date: Wed, 09 Nov 2011 14:21:41 -0800
Message-ID: <201111092221.pA9MLf8n032245@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KIWWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 17:22:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, rientjes@google.com, yinghan@google.com


The patch titled
     Subject: oom: do not kill tasks with oom_score_adj OOM_SCORE_ADJ_MIN
has been added to the -mm tree.  Its filename is
     oom-do-not-kill-tasks-with-oom_score_adj-oom_score_adj_min.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom: do not kill tasks with oom_score_adj OOM_SCORE_ADJ_MIN

c9f01245 ("oom: remove oom_disable_count") has removed the
oom_disable_count counter which has been used for early break out from
oom_badness so we could never select a task with oom_score_adj set to
OOM_SCORE_ADJ_MIN (oom disabled).

Now that the counter is gone we are always going through heuristics
calculation and we always return a non zero positive value.  This means
that we can end up killing a task with OOM disabled because it is
indistinguishable from regular tasks with 1% resp.  CAP_SYS_ADMIN tasks
with 3% usage of memory or tasks with oom_score_adj set but OOM enabled.

Let's break out early if the task should have OOM disabled.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/oom_kill.c~oom-do-not-kill-tasks-with-oom_score_adj-oom_score_adj_min mm/oom_kill.c
--- a/mm/oom_kill.c~oom-do-not-kill-tasks-with-oom_score_adj-oom_score_adj_min
+++ a/mm/oom_kill.c
@@ -185,6 +185,11 @@ unsigned int oom_badness(struct task_str
 	if (!p)
 		return 0;
 
+	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+		task_unlock(p);
+		return 0;
+	}
+
 	/*
 	 * The memory controller may have a limit of 0 bytes, so avoid a divide
 	 * by zero, if necessary.
_
Subject: Subject: oom: do not kill tasks with oom_score_adj OOM_SCORE_ADJ_MIN

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
oom-do-not-kill-tasks-with-oom_score_adj-oom_score_adj_min.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch

