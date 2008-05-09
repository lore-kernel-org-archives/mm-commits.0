From: akpm@linux-foundation.org
Subject: - vt-fix-canonical-input-in-utf-8-mode.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:36 -0700
Message-ID: <200805092146.m49LkaBE027130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540AbYEIVro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, stable@kernel.org, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     vt: fix canonical input in UTF-8 mode
has been removed from the -mm tree.  Its filename was
     vt-fix-canonical-input-in-utf-8-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: fix canonical input in UTF-8 mode
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

For e.g.  proper TTY canonical support, IUTF8 termios flag has to be set as
appropriate.  Linux used to not care about setting that flag for VT TTYs.

This patch fixes that by activating it according to the current mode of the
VT, and sets the default value according to the vt.default_utf8 parameter.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    6 ++++++
 1 file changed, 6 insertions(+)

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
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch

