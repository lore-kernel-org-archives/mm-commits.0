From: akpm@linux-foundation.org
Subject: [merged] epoll-dont-use-current-in-irq-context.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:27 -0700
Message-ID: <200904011840.n31IeRUC009004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763093AbZDASnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll: don't use current in irq context
has been removed from the -mm tree.  Its filename was
     epoll-dont-use-current-in-irq-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
vfs-improve-comment-describing-fget_light.patch
make-shm_get_stat-more-robust.patch

