From: akpm@linux-foundation.org
Subject: + workqueues-add-comments-to-__create_workqueue_key.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:14:30 -0700
Message-ID: <200807300014.m6U0EUwD029489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbYG3AO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:14:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, dmitry.adamushko@gmail.com, mingo@elte.hu


The patch titled
     workqueues: add comments to __create_workqueue_key()
has been added to the -mm tree.  Its filename is
     workqueues-add-comments-to-__create_workqueue_key.patch

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
Subject: workqueues: add comments to __create_workqueue_key()
From: Oleg Nesterov <oleg@tv-sign.ru>

Dmitry Adamushko pointed out that the error handling in
__create_workqueue_key() is not clear, add the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN kernel/workqueue.c~workqueues-add-comments-to-__create_workqueue_key kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-add-comments-to-__create_workqueue_key
+++ a/kernel/workqueue.c
@@ -830,10 +830,21 @@ struct workqueue_struct *__create_workqu
 		start_workqueue_thread(cwq, -1);
 	} else {
 		cpu_maps_update_begin();
+		/*
+		 * We must place this wq on list even if the code below fails.
+		 * cpu_down(cpu) can remove cpu from cpu_populated_map before
+		 * destroy_workqueue() takes the lock, in that case we leak
+		 * cwq[cpu]->thread.
+		 */
 		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
 		spin_unlock(&workqueue_lock);
