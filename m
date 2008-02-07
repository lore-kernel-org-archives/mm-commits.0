From: akpm@linux-foundation.org
Subject: - amiga-serial-driver-port_write_mutex-fixup.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:41 -0800
Message-ID: <200802070024.m170OM0k006601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934478AbYBGAr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:47:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Amiga serial driver: port_write_mutex fixup
has been removed from the -mm tree.  Its filename was
     amiga-serial-driver-port_write_mutex-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
driver-base-memory-semaphore-to-mutex.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
