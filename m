From: akpm@linux-foundation.org
Subject: + vt-fix-canonical-input-in-utf-8-mode.patch added to -mm tree
Date: Mon, 05 May 2008 16:01:49 -0700
Message-ID: <200805052301.m45N1n9w009754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbYEEXCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 19:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, stable@kernel.org, w@1wt.eu


The patch titled
     VT : fix canonical input in UTF-8 mode
has been added to the -mm tree.  Its filename is
     vt-fix-canonical-input-in-utf-8-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VT : fix canonical input in UTF-8 mode
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Awaiting complete changelog..

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc> <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 char/vt.c.orig    |    0 
 drivers/char/vt.c |    6 ++++++
 2 files changed, 6 insertions(+)

diff -puN drivers/char/vt.c~vt-fix-canonical-input-in-utf-8-mode drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-canonical-input-in-utf-8-mode
+++ a/drivers/char/vt.c
@@ -2742,6 +2742,10 @@ static int con_open(struct tty_struct *t
 				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
 				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
 			}
+			if (vc->vc_utf)
+				tty->termios->c_iflag |= IUTF8;
+			else
+				tty->termios->c_iflag &= ~IUTF8;
 			release_console_sem();
 			vcs_make_sysfs(tty);
 			return ret;
@@ -2918,6 +2922,8 @@ int __init vty_init(void)
 	console_driver->minor_start = 1;
 	console_driver->type = TTY_DRIVER_TYPE_CONSOLE;
 	console_driver->init_termios = tty_std_termios;
+	if (default_utf8)
+		console_driver->init_termios.c_iflag |= IUTF8;
 	console_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_RESET_TERMIOS;
 	tty_set_operations(console_driver, &con_ops);
 	if (tty_register_driver(console_driver))
diff -puN drivers/char/vt.c.orig~vt-fix-canonical-input-in-utf-8-mode drivers/char/vt.c.orig
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

kconfig-improved-help-for-config_accessibility.patch
kconfig-improved-help-for-config_accessibility-fix.patch
vt-fix-canonical-input-in-utf-8-mode.patch

