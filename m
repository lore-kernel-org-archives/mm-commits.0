From: akpm@linux-foundation.org
Subject: - drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:00 -0800
Message-ID: <200802070023.m170NflC006548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765794AbYBGAo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/i4l/isdn_tty.c: remove write_sem
has been removed from the -mm tree.  Its filename was
     drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn/i4l/isdn_tty.c: remove write_sem
From: Daniel Walker <dwalker@mvista.com>

I couldn't find any users, so removing it..

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_tty.c |    1 -
 include/linux/isdn.h        |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/isdn/i4l/isdn_tty.c~drivers-isdn-i4l-isdn_ttyc-remove-write_sem drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~drivers-isdn-i4l-isdn_ttyc-remove-write_sem
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -1917,7 +1917,6 @@ isdn_tty_modem_init(void)
 		info->owner = THIS_MODULE;
 #endif
 		spin_lock_init(&info->readlock);
-		init_MUTEX(&info->write_sem);
 		sprintf(info->last_cause, "0000");
 		sprintf(info->last_num, "none");
 		info->last_dir = 0;
diff -puN include/linux/isdn.h~drivers-isdn-i4l-isdn_ttyc-remove-write_sem include/linux/isdn.h
--- a/include/linux/isdn.h~drivers-isdn-i4l-isdn_ttyc-remove-write_sem
+++ a/include/linux/isdn.h
@@ -507,7 +507,6 @@ typedef struct modem_info {
   struct ktermios	normal_termios;  /* For saving termios structs     */
   struct ktermios	callout_termios;
   wait_queue_head_t	open_wait, close_wait;
-  struct semaphore      write_sem;
   spinlock_t	        readlock;
 } modem_info;
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
driver-base-memory-semaphore-to-mutex.patch
usb-microtek-remove-unused-semaphore.patch
usb-libusual-locking-cleanup.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
