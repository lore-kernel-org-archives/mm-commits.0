From: akpm@linux-foundation.org
Subject: + drivers-char-tty_ioc-remove-pty_sem.patch added to -mm tree
Date: Tue, 04 Dec 2007 19:05:11 -0800
Message-ID: <200712050305.lB535BUv018264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbXLEDGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 22:06:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, alan@redhat.com, hpa@zytor.com


The patch titled
     drivers/char/tty_io.c: remove pty_sem
has been added to the -mm tree.  Its filename is
     drivers-char-tty_ioc-remove-pty_sem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/tty_io.c: remove pty_sem
From: Daniel Walker <dwalker@mvista.com>

I couldn't find any users, so removing it..

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    1 -
 include/linux/tty.h   |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/char/tty_io.c~drivers-char-tty_ioc-remove-pty_sem drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~drivers-char-tty_ioc-remove-pty_sem
+++ a/drivers/char/tty_io.c
@@ -3721,7 +3721,6 @@ static void initialize_tty_struct(struct
 	tty->buf.head = tty->buf.tail = NULL;
 	tty_buffer_init(tty);
 	INIT_DELAYED_WORK(&tty->buf.work, flush_to_ldisc);
-	init_MUTEX(&tty->buf.pty_sem);
 	mutex_init(&tty->termios_mutex);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
diff -puN include/linux/tty.h~drivers-char-tty_ioc-remove-pty_sem include/linux/tty.h
--- a/include/linux/tty.h~drivers-char-tty_ioc-remove-pty_sem
+++ a/include/linux/tty.h
@@ -74,7 +74,6 @@ struct tty_buffer {
 
 struct tty_bufhead {
 	struct delayed_work work;
-	struct semaphore pty_sem;
 	spinlock_t lock;
 	struct tty_buffer *head;	/* Queue head */
 	struct tty_buffer *tail;	/* Active buffer */
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
