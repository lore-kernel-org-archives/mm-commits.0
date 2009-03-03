From: akpm@linux-foundation.org
Subject: + epoll-dont-use-current-in-irq-context.patch added to -mm tree
Date: Tue, 03 Mar 2009 12:09:04 -0800
Message-ID: <200903032009.n23K95Z1031532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbZCCUJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 15:09:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyb@cybernetics.com, davidel@xmailserver.org


The patch titled
     epoll: don't use current in irq context
has been added to the -mm tree.  Its filename is
     epoll-dont-use-current-in-irq-context.patch

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
Subject: epoll: don't use current in irq context
From: Tony Battersby <tonyb@cybernetics.com>

ep_call_nested() (formerly ep_poll_safewake()) uses "current" (without
dereferencing it) to detect callback recursion, but it may be called from
irq context where the use of current is generally discouraged.  It would
be better to use get_cpu() and put_cpu() to detect the callback recursion.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/eventpoll.c~epoll-dont-use-current-in-irq-context fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-dont-use-current-in-irq-context
+++ a/fs/eventpoll.c
@@ -97,8 +97,8 @@ struct epoll_filefd {
  */
 struct nested_call_node {
 	struct list_head llink;
-	struct task_struct *task;
 	void *cookie;
+	int cpu;
 };
 
 /*
@@ -327,7 +327,7 @@ static int ep_call_nested(struct nested_
 {
 	int error, call_nests = 0;
 	unsigned long flags;
-	struct task_struct *this_task = current;
+	int this_cpu = get_cpu();
 	struct list_head *lsthead = &ncalls->tasks_call_list;
 	struct nested_call_node *tncur;
 	struct nested_call_node tnode;
@@ -340,20 +340,19 @@ static int ep_call_nested(struct nested_
 	 * very much limited.
 	 */
 	list_for_each_entry(tncur, lsthead, llink) {
-		if (tncur->task == this_task &&
+		if (tncur->cpu == this_cpu &&
 		    (tncur->cookie == cookie || ++call_nests > max_nests)) {
 			/*
 			 * Ops ... loop detected or maximum nest level reached.
 			 * We abort this wake by breaking the cycle itself.
 			 */
-			spin_unlock_irqrestore(&ncalls->lock, flags);
-
-			return -1;
+			error = -1;
+			goto out_unlock;
 		}
 	}
 
 	/* Add the current task and cookie to the list */
-	tnode.task = this_task;
+	tnode.cpu = this_cpu;
 	tnode.cookie = cookie;
 	list_add(&tnode.llink, lsthead);
 
@@ -365,8 +364,10 @@ static int ep_call_nested(struct nested_
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&ncalls->lock, flags);
 	list_del(&tnode.llink);
+ out_unlock:
 	spin_unlock_irqrestore(&ncalls->lock, flags);
 
+	put_cpu();
 	return error;
 }
 
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

origin.patch
linux-next.patch
vfs-improve-comment-describing-fget_light.patch
epoll-dont-use-current-in-irq-context.patch
epoll-remember-the-event-if-epoll_wait-returns-efault.patch
epoll-remove-unnecessary-xchg.patch
epoll-clean-up-ep_modify.patch
epoll-use-real-type-instead-of-void.patch
make-shm_get_stat-more-robust.patch

