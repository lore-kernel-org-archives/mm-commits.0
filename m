From: akpm@linux-foundation.org
Subject: [merged] wait-add-wait_event_lock_irq-interface-fix.patch removed from -mm tree
Date: Mon, 03 Dec 2012 14:01:43 -0800
Message-ID: <20121203220144.2CCA7200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:44810 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2LCWBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 17:01:46 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so237828lag.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 14:01:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars.ellenberg@linbit.com, lczerner@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drbd: fix merge clash: wait_event_lock_irq() is now defined in wait.h
has been removed from the -mm tree.  Its filename was
     wait-add-wait_event_lock_irq-interface-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: drbd: fix merge clash: wait_event_lock_irq() is now defined in wait.h

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_int.h   |   27 ---------------------------
 drivers/block/drbd/drbd_state.c |    3 +--
 2 files changed, 1 insertion(+), 29 deletions(-)

diff -puN drivers/block/drbd/drbd_int.h~wait-add-wait_event_lock_irq-interface-fix drivers/block/drbd/drbd_int.h
--- a/drivers/block/drbd/drbd_int.h~wait-add-wait_event_lock_irq-interface-fix
+++ a/drivers/block/drbd/drbd_int.h
@@ -2334,30 +2334,3 @@ static inline void drbd_md_flush(struct 
 }
 
 #endif
-
-/* This is defined in drivers/md/md.h as well. Should go into wait.h */
-#define __wait_event_lock_irq(wq, condition, lock, cmd) 		\
-do {									\
-	wait_queue_t __wait;						\
-	init_waitqueue_entry(&__wait, current);				\
-									\
-	add_wait_queue(&wq, &__wait);					\
-	for (;;) {							\
-		set_current_state(TASK_UNINTERRUPTIBLE);		\
-		if (condition)						\
-			break;						\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	current->state = TASK_RUNNING;					\
-	remove_wait_queue(&wq, &__wait);				\
-} while (0)
-
-#define wait_event_lock_irq(wq, condition, lock, cmd) 			\
-do {									\
-	if (condition)	 						\
-		break;							\
-	__wait_event_lock_irq(wq, condition, lock, cmd);		\
-} while (0)
diff -puN drivers/block/drbd/drbd_state.c~wait-add-wait_event_lock_irq-interface-fix drivers/block/drbd/drbd_state.c
--- a/drivers/block/drbd/drbd_state.c~wait-add-wait_event_lock_irq-interface-fix
+++ a/drivers/block/drbd/drbd_state.c
@@ -1800,8 +1800,7 @@ _conn_request_state(struct drbd_tconn *t
 		spin_lock_irq(&tconn->req_lock);
 		wait_event_lock_irq(tconn->ping_wait,
 				(rv = _conn_rq_cond(tconn, mask, val)),
-				tconn->req_lock,
-				);
+				tconn->req_lock);
 		clear_bit(CONN_WD_ST_CHG_REQ, &tconn->flags);
 		if (rv < SS_SUCCESS)
 			goto abort;
_

Patches currently in -mm which might be from lars.ellenberg@linbit.com are

linux-next.patch

