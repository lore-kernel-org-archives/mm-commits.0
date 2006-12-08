From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-3270-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:54:59 -0800
Message-ID: <200612080854.kB88sxjl014087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37596 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425250AbWLHIzr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:55:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     2.6.19-rc2-mm2 warning fix for tty3270
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-3270-fix.patch

This patch was dropped because it was folded into tty-switch-to-ktermios.patch

------------------------------------------------------
Subject: 2.6.19-rc2-mm2 warning fix for tty3270
From: Martin Peschke <mp3@de.ibm.com>

Changing the type of the termios parameter to conform with struct
tty_operations. This is trivial as tty3270_set_termios doesn't use it.

  CC      drivers/s390/char/tty3270.o
drivers/s390/char/tty3270.c:1755: warning: initialization from incompatible pointer type

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/char/tty3270.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/s390/char/tty3270.c~tty-switch-to-ktermios-3270-fix drivers/s390/char/tty3270.c
--- a/drivers/s390/char/tty3270.c~tty-switch-to-ktermios-3270-fix
+++ a/drivers/s390/char/tty3270.c
@@ -1659,7 +1659,7 @@ tty3270_flush_buffer(struct tty_struct *
  * Check for visible/invisible input switches
  */
 static void
-tty3270_set_termios(struct tty_struct *tty, struct termios *old)
+tty3270_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct tty3270 *tp;
 	int new;
_

Patches currently in -mm which might be from mp3@de.ibm.com are

tty-switch-to-ktermios.patch
tty-switch-to-ktermios-3270-fix.patch

