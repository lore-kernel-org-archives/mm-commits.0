From: akpm@linux-foundation.org
Subject: + uml-mconsole-mutex-conversion.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:23:46 -0800
Message-ID: <200801280524.m0S5OeHJ013809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYA1FZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, jdike@linux.intel.com


The patch titled
     uml: mconsole mutex conversion
has been added to the -mm tree.  Its filename is
     uml-mconsole-mutex-conversion.patch

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
Subject: uml: mconsole mutex conversion
From: Daniel Walker <dwalker@mvista.com>

The plug_mem_mutex is already used as a mutex since it's using
DECLARE_MUTEX(), but the underlying construct is still a semaphore ..  This
patch switches it over to a struct mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-mconsole-mutex-conversion arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-mconsole-mutex-conversion
+++ a/arch/um/drivers/mconsole_kern.c
@@ -17,6 +17,7 @@
 #include "linux/syscalls.h"
 #include "linux/utsname.h"
 #include "linux/workqueue.h"
+#include "linux/mutex.h"
 #include "asm/uaccess.h"
 #include "init.h"
 #include "irq_kern.h"
@@ -360,7 +361,7 @@ struct unplugged_pages {
 	void *pages[UNPLUGGED_PER_PAGE];
 };
 
-static DECLARE_MUTEX(plug_mem_mutex);
+static DEFINE_MUTEX(plug_mem_mutex);
 static unsigned long long unplugged_pages_count = 0;
 static LIST_HEAD(unplugged_pages);
 static int unplug_index = UNPLUGGED_PER_PAGE;
@@ -396,7 +397,7 @@ static int mem_config(char *str, char **
 
 	diff /= PAGE_SIZE;
 
-	down(&plug_mem_mutex);
+	mutex_lock(&plug_mem_mutex);
 	for (i = 0; i < diff; i++) {
 		struct unplugged_pages *unplugged;
 		void *addr;
@@ -453,7 +454,7 @@ static int mem_config(char *str, char **
 
 	err = 0;
 out_unlock:
-	up(&plug_mem_mutex);
+	mutex_unlock(&plug_mem_mutex);
 out:
 	return err;
 }
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
git-mips.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
prism54-remove-questionable-down_interruptible-usage.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
uml-ldt-mutex-conversion.patch
uml-mconsole-mutex-conversion.patch
uml-port-mutex-conversion.patch
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
