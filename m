From: akpm@linux-foundation.org
Subject: [patch 055/114] ipc/sem: use proper list api for pending_list
 wakeups
Date: Wed, 14 Dec 2016 15:06:43 -0800
Message-ID: <5851d083.X/vcPgeG/mxWQccj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34936 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754615AbcLNXH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: use proper list api for pending_list wakeups

... saves some LoC and looks cleaner than re-implementing the
calls.

Link: http://lkml.kernel.org/r/1474225896-10066-6-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff -puN ipc/sem.c~ipc-sem-use-proper-list-api-for-pending_list-wakeups ipc/sem.c
--- a/ipc/sem.c~ipc-sem-use-proper-list-api-for-pending_list-wakeups
+++ a/ipc/sem.c
@@ -813,8 +813,7 @@ static inline int check_restart(struct s
 static int wake_const_ops(struct sem_array *sma, int semnum,
 			  struct wake_q_head *wake_q)
 {
-	struct sem_queue *q;
-	struct list_head *walk;
+	struct sem_queue *q, *tmp;
 	struct list_head *pending_list;
 	int semop_completed = 0;
 
@@ -823,25 +822,19 @@ static int wake_const_ops(struct sem_arr
 	else
 		pending_list = &sma->sem_base[semnum].pending_const;
 
-	walk = pending_list->next;
-	while (walk != pending_list) {
-		int error;
+	list_for_each_entry_safe(q, tmp, pending_list, list) {
+		int error = perform_atomic_semop(sma, q);
 
-		q = container_of(walk, struct sem_queue, list);
-		walk = walk->next;
-
-		error = perform_atomic_semop(sma, q);
-
-		if (error <= 0) {
-			/* operation completed, remove from queue & wakeup */
-
-			unlink_queue(sma, q);
-
-			wake_up_sem_queue_prepare(q, error, wake_q);
-			if (error == 0)
-				semop_completed = 1;
-		}
+		if (error > 0)
+			continue;
+		/* operation completed, remove from queue & wakeup */
+		unlink_queue(sma, q);
+
+		wake_up_sem_queue_prepare(q, error, wake_q);
+		if (error == 0)
+			semop_completed = 1;
 	}
+
 	return semop_completed;
 }
 
@@ -914,8 +907,7 @@ static int do_smart_wakeup_zero(struct s
  */
 static int update_queue(struct sem_array *sma, int semnum, struct wake_q_head *wake_q)
 {
-	struct sem_queue *q;
-	struct list_head *walk;
+	struct sem_queue *q, *tmp;
 	struct list_head *pending_list;
 	int semop_completed = 0;
 
@@ -925,13 +917,9 @@ static int update_queue(struct sem_array
 		pending_list = &sma->sem_base[semnum].pending_alter;
 
 again:
-	walk = pending_list->next;
-	while (walk != pending_list) {
+	list_for_each_entry_safe(q, tmp, pending_list, list) {
 		int error, restart;
 
-		q = container_of(walk, struct sem_queue, list);
-		walk = walk->next;
