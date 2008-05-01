From: akpm@linux-foundation.org
Subject: - char-moxa-fix-tiocg-ssoftcar-param.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:57 -0700
Message-ID: <200805010928.m419Svkn030626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756871AbYEAJ3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, fix TIOC(G/S)SOFTCAR param
has been removed from the -mm tree.  Its filename was
     char-moxa-fix-tiocg-ssoftcar-param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, fix TIOC(G/S)SOFTCAR param
From: Jiri Slaby <jirislaby@gmail.com>

according to ioctl_list, both have int * as a param, not ulong *.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-fix-tiocg-ssoftcar-param drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-fix-tiocg-ssoftcar-param
+++ a/drivers/char/moxa.c
@@ -741,9 +741,9 @@ static int moxa_ioctl(struct tty_struct 
 		MoxaPortSendBreak(ch->port, arg);
 		return (0);
 	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) argp);
+		return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)argp);
 	case TIOCSSOFTCAR:
-		if(get_user(retval, (unsigned long __user *) argp))
+		if (get_user(retval, (int __user *)argp))
 			return -EFAULT;
 		arg = retval;
 		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) |
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

