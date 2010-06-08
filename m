From: akpm@linux-foundation.org
Subject: + oom-avoid-sending-exiting-tasks-a-sigkill.patch added to -mm tree
Date: Tue, 08 Jun 2010 13:14:36 -0700
Message-ID: <201006082014.o58KEaxk022395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361Ab0FHUOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 16:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     oom: avoid sending exiting tasks a SIGKILL
has been added to the -mm tree.  Its filename is
     oom-avoid-sending-exiting-tasks-a-sigkill.patch

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
Subject: oom: avoid sending exiting tasks a SIGKILL
From: David Rientjes <rientjes@google.com>

It's unnecessary to SIGKILL a task that is already PF_EXITING and can
actually cause a NULL pointer dereference of the sighand if it has already
been detached.  Instead, simply set TIF_MEMDIE so it has access to memory
reserves and can quickly exit as the comment implies.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-avoid-sending-exiting-tasks-a-sigkill mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-sending-exiting-tasks-a-sigkill
+++ a/mm/oom_kill.c
@@ -458,7 +458,7 @@ static int oom_kill_process(struct task_
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
 	if (p->flags & PF_EXITING) {
-		__oom_kill_task(p, 0);
+		set_tsk_thread_flag(p, TIF_MEMDIE);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are

avr32-invoke-oom-killer-from-page-fault.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch

