From: akpm@linux-foundation.org
Subject: - workqueues-add-comments-to-__create_workqueue_key.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:33 -0700
Message-ID: <200807301915.m6UJFX9x011033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbYG3T0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, dmitry.adamushko@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueues: add comments to __create_workqueue_key()
has been removed from the -mm tree.  Its filename was
     workqueues-add-comments-to-__create_workqueue_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
