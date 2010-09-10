From: akpm@linux-foundation.org
Subject: + oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:03:19 -0700
Message-ID: <201009102303.o8AN3J6C008233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850Ab0IJXDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, ngupta@vflare.org, penberg@cs.helsinki.fi


The patch titled
     oom: always return a badness score of non-zero for eligible tasks
has been added to the -mm tree.  Its filename is
     oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch

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
Subject: oom: always return a badness score of non-zero for eligible tasks
From: David Rientjes <rientjes@google.com>

A task's badness score is roughly a proportion of its rss and swap
compared to the system's capacity.  The scale ranges from 0 to 1000 with
the highest score chosen for kill.  Thus, this scale operates on a
resolution of 0.1% of RAM + swap.  Admin tasks are also given a 3% bonus,
so the badness score of an admin task using 3% of memory, for example,
would still be 0.

It's possible that an exceptionally large number of tasks will combine to
exhaust all resources but never have a single task that uses more than
0.1% of RAM and swap (or 3.0% for admin tasks).

This patch ensures that the badness score of any eligible task is never 0
so the machine doesn't unnecessarily panic because it cannot find a task
to kill.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks mm/oom_kill.c
--- a/mm/oom_kill.c~oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks
+++ a/mm/oom_kill.c
@@ -208,8 +208,13 @@ unsigned int oom_badness(struct task_str
 	 */
 	points += p->signal->oom_score_adj;
 
-	if (points < 0)
-		return 0;
+	/*
+	 * Never return 0 for an eligible task that may be killed since it's
+	 * possible that no single user task uses more than 0.1% of memory and
+	 * no single admin tasks uses more than 3.0%.
+	 */
+	if (points <= 0)
+		return 1;
 	return (points < 1000) ? points : 1000;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
linux-next.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-mempolicy-check-return-code-of-check_range.patch
jbd-remove-dependency-on-__gfp_nofail.patch

