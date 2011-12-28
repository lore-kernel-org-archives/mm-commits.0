From: akpm@linux-foundation.org
Subject: [merged] oom-fix-integer-overflow-of-points-in-oom_badness.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:41 -0800
Message-ID: <20111228220442.57DC05C0076@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61594 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fhrbata@redhat.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: fix integer overflow of points in oom_badness
has been removed from the -mm tree.  Its filename was
     oom-fix-integer-overflow-of-points-in-oom_badness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frantisek Hrbata <fhrbata@redhat.com>
Subject: oom: fix integer overflow of points in oom_badness

An integer overflow will happen on 64bit archs if task's sum of rss,
swapents and nr_ptes exceeds (2^31)/1000 value.  This was introduced by
commit

f755a04 oom: use pte pages in OOM score

where the oom score computation was divided into several steps and it's no
longer computed as one expression in unsigned long(rss, swapents, nr_pte
are unsigned long), where the result value assigned to points(int) is in
range(1..1000).  So there could be an int overflow while computing

176          points *= 1000;

and points may have negative value. Meaning the oom score for a mem hog task
will be one.

196          if (points <= 0)
197                  return 1;

For example:
[ 3366]     0  3366 35390480 24303939   5       0             0 oom01
Out of memory: Kill process 3366 (oom01) score 1 or sacrifice child

Here the oom1 process consumes more than 24303939(rss)*4096~=92GB physical
memory, but it's oom score is one.

In this situation the mem hog task is skipped and oom killer kills another and
most probably innocent task with oom score greater than one.

The points variable should be of type long instead of int to prevent the
int overflow.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>		[2.6.36+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-fix-integer-overflow-of-points-in-oom_badness mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-integer-overflow-of-points-in-oom_badness
+++ a/mm/oom_kill.c
@@ -176,7 +176,7 @@ static bool oom_unkillable_task(struct t
 unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 		      const nodemask_t *nodemask, unsigned long totalpages)
 {
-	int points;
+	long points;
 
 	if (oom_unkillable_task(p, mem, nodemask))
 		return 0;
_

Patches currently in -mm which might be from fhrbata@redhat.com are


