From: akpm@linux-foundation.org
Subject: + wait-kill-is_sync_wait.patch added to -mm tree
Date: Wed, 27 Aug 2008 18:12:15 -0700
Message-ID: <200808280112.m7S1CFAZ032555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbYH1BMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 21:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, mingo@elte.hu


The patch titled
     wait: kill is_sync_wait()
has been added to the -mm tree.  Its filename is
     wait-kill-is_sync_wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait: kill is_sync_wait()
From: Tejun Heo <tj@kernel.org>

is_sync_wait() is used to distinguish between sync and async waits. 
Basically sync waits are the ones initialized with init_waitqueue_entry()
and async ones with init_waitqueue_func_entry().  The sync/async
distinction is used only in prepare_to_wait[_exclusive]() and its only
function is to skip setting the current task state if the wait is async. 
This has a few problems.

* No one uses it.  None of func_entry users use prepare_to_wait()
  functions, so the code path never gets executed.

* The distinction is bogus.  Maybe back when func_entry is used only
  by aio but it's now also used by epoll and in future possibly by 9p
  and poll/select.

* Taking @state as argument and ignoring it silenly depending on how
  @wait is initialized is just a bad error-prone API.

* It prevents func_entry waits from using wait->private for no good
  reason.

This patch kills is_sync_wait() and the associated code paths from
prepare_to_wait[_exclusive]().  As there was no user of these code paths,
this patch doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |    9 ---------
 kernel/wait.c        |   14 ++------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff -puN include/linux/wait.h~wait-kill-is_sync_wait include/linux/wait.h
--- a/include/linux/wait.h~wait-kill-is_sync_wait
+++ a/include/linux/wait.h
@@ -108,15 +108,6 @@ static inline int waitqueue_active(wait_
 	return !list_empty(&q->task_list);
 }
 
-/*
- * Used to distinguish between sync and async io wait context:
- * sync i/o typically specifies a NULL wait queue entry or a wait
- * queue entry bound to a task (current task) to wake up.
- * aio specifies a wait queue entry with an async notification
- * callback routine, not associated with any task.
- */
-#define is_sync_wait(wait)	(!(wait) || ((wait)->private))
-
 extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
 extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
diff -puN kernel/wait.c~wait-kill-is_sync_wait kernel/wait.c
--- a/kernel/wait.c~wait-kill-is_sync_wait
+++ a/kernel/wait.c
@@ -72,12 +72,7 @@ prepare_to_wait(wait_queue_head_t *q, wa
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
 		__add_wait_queue(q, wait);
-	/*
-	 * don't alter the task state if this is just going to
-	 * queue an async wait queue callback
-	 */
-	if (is_sync_wait(wait))
-		set_current_state(state);
+	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait);
@@ -91,12 +86,7 @@ prepare_to_wait_exclusive(wait_queue_hea
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
 		__add_wait_queue_tail(q, wait);
-	/*
-	 * don't alter the task state if this is just going to
- 	 * queue an async wait queue callback
-	 */
-	if (is_sync_wait(wait))
-		set_current_state(state);
+	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch
wait-kill-is_sync_wait.patch

