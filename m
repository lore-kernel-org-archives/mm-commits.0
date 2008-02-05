From: akpm@linux-foundation.org
Subject: - uml-port-mutex-conversion.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:54 -0800
Message-ID: <200802052238.m15McZA8012962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761261AbYBEWpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: port mutex conversion
has been removed from the -mm tree.  Its filename was
     uml-port-mutex-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: port mutex conversion
From: Daniel Walker <dwalker@mvista.com>

The port_sem is already used as a mutex since it's using DECLARE_MUTEX(), but
the underlying construct is still a semaphore ..  This patch switches it over
to a struct mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/port_kern.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/port_kern.c~uml-port-mutex-conversion arch/um/drivers/port_kern.c
--- a/arch/um/drivers/port_kern.c~uml-port-mutex-conversion
+++ a/arch/um/drivers/port_kern.c
@@ -6,6 +6,7 @@
 #include "linux/completion.h"
 #include "linux/interrupt.h"
 #include "linux/list.h"
+#include "linux/mutex.h"
 #include "asm/atomic.h"
 #include "init.h"
 #include "irq_kern.h"
@@ -120,7 +121,7 @@ static int port_accept(struct port_list 
 	return 0;
 }
 
-static DECLARE_MUTEX(ports_sem);
+static DEFINE_MUTEX(ports_mutex);
 static LIST_HEAD(ports);
 
 static void port_work_proc(struct work_struct *unused)
@@ -161,7 +162,7 @@ void *port_data(int port_num)
 	struct port_dev *dev = NULL;
 	int fd;
 
-	down(&ports_sem);
+	mutex_lock(&ports_mutex);
 	list_for_each(ele, &ports) {
 		port = list_entry(ele, struct port_list, list);
 		if (port->port == port_num)
@@ -216,7 +217,7 @@ void *port_data(int port_num)
  out_free:
 	kfree(port);
  out:
-	up(&ports_sem);
+	mutex_unlock(&ports_mutex);
 	return dev;
 }
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
driver-base-memory-semaphore-to-mutex.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
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
