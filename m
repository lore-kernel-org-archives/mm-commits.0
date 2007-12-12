From: akpm@linux-foundation.org
Subject: + amiga-serial-driver-port_write_mutex-fixup.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:50:35 -0800
Message-ID: <200712120850.lBC8oZtc001758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755574AbXLLIvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:51:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, geert@linux-m68k.org


The patch titled
     Amiga serial driver: port_write_mutex fixup
has been added to the -mm tree.  Its filename is
     amiga-serial-driver-port_write_mutex-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Amiga serial driver: port_write_mutex fixup
From: Daniel Walker <dwalker@mvista.com>

The port_write_mutex was converted from a semaphore to a mutex,
but there was still this ifdef'd init_MUTEX reference remaining.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ser_a2232.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ser_a2232.c~amiga-serial-driver-port_write_mutex-fixup drivers/char/ser_a2232.c
--- a/drivers/char/ser_a2232.c~amiga-serial-driver-port_write_mutex-fixup
+++ a/drivers/char/ser_a2232.c
@@ -653,7 +653,7 @@ static void a2232_init_portstructs(void)
 		port->gs.closing_wait = 30 * HZ;
 		port->gs.rd = &a2232_real_driver;
 #ifdef NEW_WRITE_LOCKING
-		init_MUTEX(&(port->gs.port_write_mutex));
+		mutex_init(&(port->gs.port_write_mutex));
 #endif
 		init_waitqueue_head(&port->gs.open_wait);
 		init_waitqueue_head(&port->gs.close_wait);
_

Patches currently in -mm which might be from dwalker@mvista.com are

media-video-usbvision-add-mutex_unlock-to-error-paths.patch
media-video-usbvision-add-mutex_unlock-to-error-paths-fix.patch
media-video-usbvision-remove-ctrlurblock.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
mcheck-mce_64-mce_read_sem-to-mutex.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
