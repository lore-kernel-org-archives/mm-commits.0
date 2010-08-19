From: akpm@linux-foundation.org
Subject: + oom-fix-null-pointer-dereference.patch added to -mm tree
Date: Thu, 19 Aug 2010 09:22:21 -0700
Message-ID: <201008191619.o7JGJand028161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab0HSQTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 12:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     oom: fix NULL pointer dereference
has been added to the -mm tree.  Its filename is
     oom-fix-null-pointer-dereference.patch

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
Subject: oom: fix NULL pointer dereference
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit b940fd7035 (oom: remove unnecessary code and cleanup) added
unnecessary NULL pointer dereference. remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom-fix-null-pointer-dereference mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-null-pointer-dereference
+++ a/mm/oom_kill.c
@@ -401,10 +401,9 @@ static void dump_header(struct task_stru
 static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 {
 	p = find_lock_task_mm(p);
-	if (!p) {
-		task_unlock(p);
+	if (!p)
 		return 1;
-	}
+
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(p), p->comm, K(p->mm->total_vm),
 		K(get_mm_counter(p->mm, MM_ANONPAGES)),
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

oom-fix-null-pointer-dereference.patch
oom-fix-tasklist_lock-leak.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
reiser4.patch

