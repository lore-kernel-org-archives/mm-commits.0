From: akpm@linux-foundation.org
Subject: [merged] do_wait-kill-the-old-bug_on-use-while_each_thread.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:00 -0700
Message-ID: <200906182247.n5IMl03S006153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758973AbZFRWrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait: kill the old BUG_ON, use while_each_thread()
has been removed from the -mm tree.  Its filename was
     do_wait-kill-the-old-bug_on-use-while_each_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait: kill the old BUG_ON, use while_each_thread()
From: Oleg Nesterov <oleg@redhat.com>

do_wait() does BUG_ON(tsk->signal != current->signal), this looks like a
raher obsolete check.  At least, I don't think do_wait() is the best place
to verify that all threads have the same ->signal.  Remove it.

Also, change the code to use while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/exit.c~do_wait-kill-the-old-bug_on-use-while_each_thread kernel/exit.c
--- a/kernel/exit.c~do_wait-kill-the-old-bug_on-use-while_each_thread
+++ a/kernel/exit.c
@@ -1595,9 +1595,7 @@ repeat:
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
-		tsk = next_thread(tsk);
-		BUG_ON(tsk->signal != current->signal);
-	} while (tsk != current);
+	} while_each_thread(current, tsk);
 	read_unlock(&tasklist_lock);
 
 notask:
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

