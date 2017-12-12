From: akpm@linux-foundation.org
Subject: + ipc-mqueue-wq_add-priority-changed-to-dynamic-priority.patch
 added to -mm tree
Date: Tue, 12 Dec 2017 14:31:07 -0800
Message-ID: <5a3058ab.y+KUvO/IwaNsn2xP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbdLLWbI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 17:31:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhaws@sdl.usu.edu, arnd@arndb.de, bigeasy@linutronix.de, dave@stgolabs.net, deepa.kernel@gmail.com, manfred@colorfullife.com, mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue.c: have RT tasks queue in by priority in wq_add()
has been added to the -mm tree.  Its filename is
     ipc-mqueue-wq_add-priority-changed-to-dynamic-priority.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueue-wq_add-priority-changed-to-dynamic-priority.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueue-wq_add-priority-changed-to-dynamic-priority.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~ipc-mqueue-wq_add-priority-changed-to-dynamic-priority ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-wq_add-priority-changed-to-dynamic-priority
+++ a/ipc/mqueue.c
@@ -546,7 +546,7 @@ static void wq_add(struct mqueue_inode_i
 	ewp->task = current;
 
 	list_for_each_entry(walk, &info->e_wait_q[sr].list, list) {
-		if (walk->task->static_prio <= current->static_prio) {
+		if (walk->task->prio <= current->prio) {
 			list_add_tail(&ewp->list, &walk->list);
 			return;
 		}
_

Patches currently in -mm which might be from jhaws@sdl.usu.edu are

ipc-mqueue-wq_add-priority-changed-to-dynamic-priority.patch

