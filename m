From: akpm@linux-foundation.org
Subject: + usb-libusual-locking-cleanup.patch added to -mm tree
Date: Fri, 21 Dec 2007 20:20:25 -0800
Message-ID: <200712220420.lBM4KPw8016806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbXLVEVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 23:21:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, greg@kroah.com, zaitcev@redhat.com


The patch titled
     usb: libusual: locking cleanup
has been added to the -mm tree.  Its filename is
     usb-libusual-locking-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ps3-vuart-fix-error-path-locking.patch
driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
prism54-remove-questionable-down_interruptible-usage.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
docs-convert-kref-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
