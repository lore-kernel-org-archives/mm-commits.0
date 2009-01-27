From: akpm@linux-foundation.org
Subject: + kthread-dont-looking-for-a-task-in-create_kthread-2.patch added to -mm tree
Date: Mon, 26 Jan 2009 23:48:26 -0800
Message-ID: <200901270748.n0R7mQ3L018096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbZA0Hsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 02:48:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgusev@openvz.org, hch@lst.de, oleg@redhat.com, xemul@openvz.org


The patch titled
     kthread: don't looking for a task in create_kthread()
has been added to the -mm tree.  Its filename is
     kthread-dont-looking-for-a-task-in-create_kthread-2.patch

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
Subject: kthread: don't looking for a task in create_kthread()
From: Vitaliy Gusev <vgusev@openvz.org>

Remove the unnecessary find_task_by_pid_ns().  kthread() can just use
"current" to get the same result.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/kthread.c~kthread-dont-looking-for-a-task-in-create_kthread-2 kernel/kthread.c
--- a/kernel/kthread.c~kthread-dont-looking-for-a-task-in-create_kthread-2
+++ a/kernel/kthread.c
@@ -76,6 +76,7 @@ static int kthread(void *_create)
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
+	create->result = current;
 	complete(&create->started);
 	schedule();
 
@@ -101,9 +102,6 @@ static void create_kthread(struct kthrea
 	} else {
 		struct sched_param param = { .sched_priority = 0 };
 		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid_ns(pid, &init_pid_ns);
-		read_unlock(&tasklist_lock);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
_

Patches currently in -mm which might be from vgusev@openvz.org are

kthread-dont-looking-for-a-task-in-create_kthread-2.patch

