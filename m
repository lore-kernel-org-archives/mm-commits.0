From: akpm@linux-foundation.org
Subject: + ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch
 added to -mm tree
Date: Tue, 25 Oct 2016 15:58:20 -0700
Message-ID: <580fe38c.TPV0LxCVyKH+CtXF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753342AbcJYW6V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 18:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: use proper list api for pending_list wakeups
has been added to the -mm tree.  Its filename is
     ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -829,8 +829,7 @@ static inline int check_restart(struct s
 static int wake_const_ops(struct sem_array *sma, int semnum,
 			  struct wake_q_head *wake_q)
 {
-	struct sem_queue *q;
-	struct list_head *walk;
+	struct sem_queue *q, *tmp;
 	struct list_head *pending_list;
 	int semop_completed = 0;
 
@@ -839,25 +838,19 @@ static int wake_const_ops(struct sem_arr
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
 
@@ -930,8 +923,7 @@ static int do_smart_wakeup_zero(struct s
  */
 static int update_queue(struct sem_array *sma, int semnum, struct wake_q_head *wake_q)
 {
-	struct sem_queue *q;
-	struct list_head *walk;
+	struct sem_queue *q, *tmp;
 	struct list_head *pending_list;
 	int semop_completed = 0;
 
@@ -941,13 +933,9 @@ static int update_queue(struct sem_array
 		pending_list = &sma->sem_base[semnum].pending_alter;
 
 again:
-	walk = pending_list->next;
-	while (walk != pending_list) {
+	list_for_each_entry_safe(q, tmp, pending_list, list) {
 		int error, restart;
 
-		q = container_of(walk, struct sem_queue, list);
-		walk = walk->next;
