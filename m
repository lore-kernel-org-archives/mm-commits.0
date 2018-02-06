From: akpm@linux-foundation.org
Subject: [patch 083/114] ipc/mqueue.c: have RT tasks queue in by
 priority in wq_add()
Date: Tue, 06 Feb 2018 15:40:52 -0800
Message-ID: <20180206234052.-ULCKUp1C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXky (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bigeasy@linutronix.de, dbueso@suse.de, deepa.kernel@gmail.com, jhaws@sdl.usu.edu, manfred@colorfullife.com, mingo@kernel.org, mm-commits@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Jonathan Haws <jhaws@sdl.usu.edu>
Subject: ipc/mqueue.c: have RT tasks queue in by priority in wq_add()

Previous behavior added tasks to the work queue using the static_prio
value instead of the dynamic priority value in prio.  This caused RT tasks
to be added to the work queue in a FIFO manner rather than by priority. 
Normal tasks were handled by priority.

This fix utilizes the dynamic priority of the task to ensure that both RT
and normal tasks are added to the work queue in priority order.  Utilizing
the dynamic priority (prio) rather than the base priority (normal_prio)
was chosen to ensure that if a task had a boosted priority when it was
added to the work queue, it would be woken sooner to to ensure that it
releases any other locks it may be holding in a more timely manner.  It is
understood that the task could have a lower priority when it wakes than
when it was added to the queue in this (unlikely) case.

Link: http://lkml.kernel.org/r/1513006652-7014-1-git-send-email-jhaws@sdl.usu.edu
Signed-off-by: Jonathan Haws <jhaws@sdl.usu.edu>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~ipc-mqueue-wq_add-priority-changed-to-dynamic-priority ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-wq_add-priority-changed-to-dynamic-priority
+++ a/ipc/mqueue.c
@@ -596,7 +596,7 @@ static void wq_add(struct mqueue_inode_i
 	ewp->task = current;
 
 	list_for_each_entry(walk, &info->e_wait_q[sr].list, list) {
-		if (walk->task->static_prio <= current->static_prio) {
+		if (walk->task->prio <= current->prio) {
 			list_add_tail(&ewp->list, &walk->list);
 			return;
 		}
_
