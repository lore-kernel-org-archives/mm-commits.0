From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-uml-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:55:04 -0800
Message-ID: <200612080855.kB88t4Rc014093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425235AbWLHIzI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:55:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, alan@lxorguk.ukuu.org.uk, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: fix ->set_termios declaration
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-uml-fix.patch

This patch was dropped because it was folded into tty-switch-to-ktermios.patch

------------------------------------------------------
Subject: uml: fix ->set_termios declaration
From: Jeff Dike <jdike@addtoit.com>

The 'old' argument of tty_operations->set_termios changed from struct
termios to struct ktermios.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/line.c |    2 +-
 arch/um/include/line.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/line.c~tty-switch-to-ktermios-uml-fix arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~tty-switch-to-ktermios-uml-fix
+++ a/arch/um/drivers/line.c
@@ -246,7 +246,7 @@ out_up:
 	return ret;
 }
 
-void line_set_termios(struct tty_struct *tty, struct termios * old)
+void line_set_termios(struct tty_struct *tty, struct ktermios * old)
 {
 	/* nothing */
 }
diff -puN arch/um/include/line.h~tty-switch-to-ktermios-uml-fix arch/um/include/line.h
--- a/arch/um/include/line.h~tty-switch-to-ktermios-uml-fix
+++ a/arch/um/include/line.h
@@ -76,7 +76,7 @@ extern int line_setup(struct line *lines
 extern int line_write(struct tty_struct *tty, const unsigned char *buf,
 		      int len);
 extern void line_put_char(struct tty_struct *tty, unsigned char ch);
-extern void line_set_termios(struct tty_struct *tty, struct termios * old);
+extern void line_set_termios(struct tty_struct *tty, struct ktermios * old);
 extern int line_chars_in_buffer(struct tty_struct *tty);
 extern void line_flush_buffer(struct tty_struct *tty);
 extern void line_flush_chars(struct tty_struct *tty);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
tty-signal-tty-locking.patch
uml-add-generic-bug-support.patch
add-process_session-helper-routine-deprecate-old-field.patch
tty-switch-to-ktermios.patch
tty-switch-to-ktermios-uml-fix.patch

