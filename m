From: akpm@linux-foundation.org
Subject: + oom-do-not-dump-task-state-for-non-thread-group-leaders.patch added to -mm tree
Date: Mon, 27 Oct 2008 17:32:50 -0700
Message-ID: <200810280032.m9S0Worn001806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbYJ1Ac4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 20:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux-foundation.org


The patch titled
     oom: do not dump task state for non thread group leaders
has been added to the -mm tree.  Its filename is
     oom-do-not-dump-task-state-for-non-thread-group-leaders.patch

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
Subject: oom: do not dump task state for non thread group leaders
From: David Rientjes <rientjes@google.com>

When /proc/sys/vm/oom_dump_tasks is enabled, it's only necessary to dump
task state information for thread group leaders.  The kernel log gets
quickly overwhelmed on machines with a massive number of threads by
dumping non-thread group leaders.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~oom-do-not-dump-task-state-for-non-thread-group-leaders mm/oom_kill.c
--- a/mm/oom_kill.c~oom-do-not-dump-task-state-for-non-thread-group-leaders
+++ a/mm/oom_kill.c
@@ -295,6 +295,8 @@ static void dump_tasks(const struct mem_
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
+		if (!thread_group_leader(p))
+			continue;
 
 		task_lock(p);
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
_

Patches currently in -mm which might be from rientjes@google.com are

oom-do-not-dump-task-state-for-non-thread-group-leaders.patch

