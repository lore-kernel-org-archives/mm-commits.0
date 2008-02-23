From: akpm@linux-foundation.org
Subject: - usb-libusual-locking-cleanup.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:57 -0800
Message-ID: <200802232022.m1NKMv4Q013470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763290AbYBWU3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, greg@kroah.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     usb: libusual: locking cleanup
has been removed from the -mm tree.  Its filename was
     usb-libusual-locking-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: libusual: locking cleanup
From: Daniel Walker <dwalker@mvista.com>

I converted the usu_init_notify semaphore to normal mutex usage, and it
should still prevent the request_module before the init routine is
complete.  Before it acted more like a complete, now the mutex protects two
distinct section from running at the same time.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Greg KH <greg@kroah.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/libusual.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/usb/storage/libusual.c~usb-libusual-locking-cleanup drivers/usb/storage/libusual.c
--- a/drivers/usb/storage/libusual.c~usb-libusual-locking-cleanup
+++ a/drivers/usb/storage/libusual.c
@@ -9,6 +9,7 @@
 #include <linux/usb_usual.h>
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 
 /*
  */
@@ -30,7 +31,7 @@ static atomic_t usu_bias = ATOMIC_INIT(U
 #define BIAS_NAME_SIZE  (sizeof("usb-storage"))
 static const char *bias_names[3] = { "none", "usb-storage", "ub" };
 
-static struct semaphore usu_init_notify;
+static DEFINE_MUTEX(usu_probe_mutex);
 static DECLARE_COMPLETION(usu_end_notify);
 static atomic_t total_threads = ATOMIC_INIT(0);
 
@@ -178,10 +179,7 @@ static int usu_probe_thread(void *arg)
 	int rc;
 	unsigned long flags;
 
-	/* A completion does not work here because it's counted. */
-	down(&usu_init_notify);
-	up(&usu_init_notify);
-
+	mutex_lock(&usu_probe_mutex);
 	rc = request_module(bias_names[type]);
 	spin_lock_irqsave(&usu_lock, flags);
 	if (rc == 0 && (st->fls & USU_MOD_FL_PRESENT) == 0) {
@@ -194,6 +192,7 @@ static int usu_probe_thread(void *arg)
 	}
 	st->fls &= ~USU_MOD_FL_THREAD;
 	spin_unlock_irqrestore(&usu_lock, flags);
+	mutex_unlock(&usu_probe_mutex);
 
 	complete_and_exit(&usu_end_notify, 0);
 }
@@ -204,10 +203,9 @@ static int __init usb_usual_init(void)
 {
 	int rc;
 
-	sema_init(&usu_init_notify, 0);
-
+	mutex_lock(&usu_probe_mutex);
 	rc = usb_register(&usu_driver);
-	up(&usu_init_notify);
+	mutex_unlock(&usu_probe_mutex);
 	return rc;
 }
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
