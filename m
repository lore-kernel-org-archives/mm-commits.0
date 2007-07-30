From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:46:41 -0700
Message-ID: <200707302346.l6UNkf2l004643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166AbXG3Xqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, mchehab@infradead.org, satyam@infradead.org


The patch titled
     Use mutex instead of semaphore in the DVB frontend tuning interface
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use mutex instead of semaphore in the DVB frontend tuning interface
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The DVB frontend tuning interface uses a semaphore as mutex.  Use the mutex
API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Reviewed-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dvb_frontend.c |   10 +++++-----
 drivers/media/dvb/dvb-core/dvb_frontend.h |    3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -138,7 +138,7 @@ static void dvb_frontend_add_event(struc
 
 	dprintk ("%s\n", __FUNCTION__);
 
-	if (down_interruptible (&events->sem))
+	if (mutex_lock_interruptible (&events->mtx))
 		return;
 
 	wp = (events->eventw + 1) % MAX_EVENT;
@@ -159,7 +159,7 @@ static void dvb_frontend_add_event(struc
 
 	events->eventw = wp;
 
-	up (&events->sem);
+	mutex_unlock(&events->mtx);
 
 	e->status = status;
 
@@ -197,7 +197,7 @@ static int dvb_frontend_get_event(struct
 			return ret;
 	}
 
-	if (down_interruptible (&events->sem))
+	if (mutex_lock_interruptible (&events->mtx))
 		return -ERESTARTSYS;
 
 	memcpy (event, &events->events[events->eventr],
@@ -205,7 +205,7 @@ static int dvb_frontend_get_event(struct
 
 	events->eventr = (events->eventr + 1) % MAX_EVENT;
 
-	up (&events->sem);
+	mutex_unlock(&events->mtx);
 
 	return 0;
 }
@@ -1127,7 +1127,7 @@ int dvb_register_frontend(struct dvb_ada
 	init_MUTEX (&fepriv->sem);
 	init_waitqueue_head (&fepriv->wait_queue);
 	init_waitqueue_head (&fepriv->events.wait_queue);
-	init_MUTEX (&fepriv->events.sem);
+	mutex_init(&fepriv->events.mtx);
 	fe->dvb = dvb;
 	fepriv->inversion = INVERSION_OFF;
 
diff -puN drivers/media/dvb/dvb-core/dvb_frontend.h~use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface drivers/media/dvb/dvb-core/dvb_frontend.h
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h~use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
+#include <linux/mutex.h>
 
 #include <linux/dvb/frontend.h>
 
@@ -142,7 +143,7 @@ struct dvb_fe_events {
 	int			  eventr;
 	int			  overflow;
 	wait_queue_head_t	  wait_queue;
-	struct semaphore	  sem;
+	struct mutex		  mtx;
 };
 
 struct dvb_frontend {
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch
