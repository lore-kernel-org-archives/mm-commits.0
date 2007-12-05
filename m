From: akpm@linux-foundation.org
Subject: + drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch added to -mm tree
Date: Tue, 04 Dec 2007 19:05:13 -0800
Message-ID: <200712050305.lB535DlS018267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbXLEDFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 22:05:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, kkeil@suse.de


The patch titled
     drivers/isdn/i4l/isdn_tty.c: remove write_sem
has been added to the -mm tree.  Its filename is
     drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1915,7 +1915,6 @@ isdn_tty_modem_init(void)
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

drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
