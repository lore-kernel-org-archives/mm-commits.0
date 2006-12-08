From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-powerpc-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:55:01 -0800
Message-ID: <200612080855.kB88t1Ai014090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37523 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425236AbWLHIzO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:55:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix tty_ioctl powerpc build
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-powerpc-fix.patch

This patch was dropped because it was folded into tty-switch-to-ktermios.patch

------------------------------------------------------
Subject: fix tty_ioctl powerpc build
From: Hugh Dickins <hugh@veritas.com>

Fix tty_ioctl.c compilation errors and warnings on PowerPC, coming from the
tty-switch-to-ktermios patches; and make its ktermios the same as its
termios (as the comment says).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_ioctl.c       |    4 ++--
 include/asm-generic/termios.h  |    4 ++--
 include/asm-powerpc/termbits.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty-switch-to-ktermios-powerpc-fix drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-switch-to-ktermios-powerpc-fix
+++ a/drivers/char/tty_ioctl.c
@@ -495,8 +495,8 @@ static int get_sgttyb(struct tty_struct 
 	struct sgttyb tmp;
 
 	mutex_lock(&tty->termios_mutex);
-	tmp.sg_ispeed = tty->c_ispeed;
-	tmp.sg_ospeed = tty->c_ospeed;
+	tmp.sg_ispeed = tty->termios->c_ispeed;
+	tmp.sg_ospeed = tty->termios->c_ospeed;
 	tmp.sg_erase = tty->termios->c_cc[VERASE];
 	tmp.sg_kill = tty->termios->c_cc[VKILL];
 	tmp.sg_flags = get_sgflags(tty);
diff -puN include/asm-generic/termios.h~tty-switch-to-ktermios-powerpc-fix include/asm-generic/termios.h
--- a/include/asm-generic/termios.h~tty-switch-to-ktermios-powerpc-fix
+++ a/include/asm-generic/termios.h
@@ -11,7 +11,7 @@
 /*
  * Translate a "termio" structure into a "termios". Ugh.
  */
-static inline int user_termio_to_kernel_termios(struct termios *termios,
+static inline int user_termio_to_kernel_termios(struct ktermios *termios,
 						struct termio __user *termio)
 {
 	unsigned short tmp;
@@ -48,7 +48,7 @@ static inline int user_termio_to_kernel_
  * Translate a "termios" structure into a "termio". Ugh.
  */
 static inline int kernel_termios_to_user_termio(struct termio __user *termio,
-						struct termios *termios)
+						struct ktermios *termios)
 {
 	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
 	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
diff -puN include/asm-powerpc/termbits.h~tty-switch-to-ktermios-powerpc-fix include/asm-powerpc/termbits.h
--- a/include/asm-powerpc/termbits.h~tty-switch-to-ktermios-powerpc-fix
+++ a/include/asm-powerpc/termbits.h
@@ -37,8 +37,8 @@ struct ktermios {
 	tcflag_t c_oflag;		/* output mode flags */
 	tcflag_t c_cflag;		/* control mode flags */
 	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
 	cc_t c_cc[NCCS];		/* control characters */
+	cc_t c_line;			/* line discipline (== c_cc[19]) */
 	speed_t c_ispeed;		/* input speed */
 	speed_t c_ospeed;		/* output speed */
 };
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
generic-bug-implementation.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
tty-switch-to-ktermios.patch
tty-switch-to-ktermios-powerpc-fix.patch

