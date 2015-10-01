From: akpm@linux-foundation.org
Subject: +
 coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch
 added to -mm tree
Date: Thu, 01 Oct 2015 14:53:46 -0700
Message-ID: <560dab6a.paTjbTUNzyohqlqV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbJAVxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 17:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kwalker@redhat.com, mhocko@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: change zap_threads() and zap_process() to use for_each_thread()
has been added to the -mm tree.  Its filename is
     coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: change zap_threads() and zap_process() to use for_each_thread()

Change zap_threads() paths to use for_each_thread() rather than
while_each_thread().

While at it, change zap_threads() to avoid the nested if's to make the
code more readable and lessen the indentation.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Kozina <skozina@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN fs/coredump.c~coredump-change-zap_threads-and-zap_process-to-use-for_each_thread fs/coredump.c
--- a/fs/coredump.c~coredump-change-zap_threads-and-zap_process-to-use-for_each_thread
+++ a/fs/coredump.c
@@ -290,15 +290,14 @@ static int zap_process(struct task_struc
 	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
-	t = start;
-	do {
+	for_each_thread(start, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 		if (t != current && t->mm) {
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
 			nr++;
 		}
-	} while_each_thread(start, t);
+	}
 
 	return nr;
 }
@@ -360,18 +359,18 @@ static int zap_threads(struct task_struc
 			continue;
 		if (g->flags & PF_KTHREAD)
 			continue;
-		p = g;
-		do {
-			if (p->mm) {
-				if (unlikely(p->mm == mm)) {
-					lock_task_sighand(p, &flags);
-					nr += zap_process(p, exit_code,
-							  SIGNAL_GROUP_EXIT);
-					unlock_task_sighand(p, &flags);
-				}
-				break;
+
+		for_each_thread(g, p) {
+			if (unlikely(!p->mm))
+				continue;
+			if (unlikely(p->mm == mm)) {
+				lock_task_sighand(p, &flags);
+				nr += zap_process(p, exit_code,
+							SIGNAL_GROUP_EXIT);
+				unlock_task_sighand(p, &flags);
 			}
-		} while_each_thread(g, p);
+			break;
+		}
 	}
 	rcu_read_unlock();
 done:
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

