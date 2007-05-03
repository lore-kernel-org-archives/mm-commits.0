From: akpm@linux-foundation.org
Subject: + do_tty_write-can-block-even-with-o_nonblock.patch added to -mm tree
Date: Thu, 03 May 2007 00:00:11 -0700
Message-ID: <200705030700.l4370Bk0006813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737AbXECHAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 03:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djohnson+linux-kernel@sw.starentnetworks.com, alan@redhat.com


The patch titled
     do_tty_write() can block even with O_NONBLOCK?
has been added to the -mm tree.  Its filename is
     do_tty_write-can-block-even-with-o_nonblock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_tty_write() can block even with O_NONBLOCK?
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>

I have two processes with the same tty open, one opens blocking and one
opens nonblocking.

If the blocking process blocks doing a write (due to flow control, just
going to fast, etc...) the nonblocking process will also block when it
writes until the blocking process unblocks.

This seems to occur because do_tty_write() isn't checking for O_NONBLOCK
when taking the tty's write mutex.

Signed-off-by: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/char/tty_io.c~do_tty_write-can-block-even-with-o_nonblock drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~do_tty_write-can-block-even-with-o_nonblock
+++ a/drivers/char/tty_io.c
@@ -1699,9 +1699,13 @@ static inline ssize_t do_tty_write(
 	ssize_t ret = 0, written = 0;
 	unsigned int chunk;
 	
-	/* FIXME: O_NDELAY ... */
-	if (mutex_lock_interruptible(&tty->atomic_write_lock)) {
-		return -ERESTARTSYS;
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&tty->atomic_write_lock))
+			return -EAGAIN;
+	}
+	else {
+		if (mutex_lock_interruptible(&tty->atomic_write_lock))
+			return -ERESTARTSYS;
 	}
 
 	/*
_

Patches currently in -mm which might be from djohnson+linux-kernel@sw.starentnetworks.com are

do_tty_write-can-block-even-with-o_nonblock.patch
do_tty_write-can-block-even-with-o_nonblock-tidy.patch
