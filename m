From: akpm@linux-foundation.org
Subject: - pty-prepare-for-tty-ops-changes.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:36 -0700
Message-ID: <200805010930.m419UarE030780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454AbYEAJa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     pty: prepare for tty->ops changes
has been removed from the -mm tree.  Its filename was
     pty-prepare-for-tty-ops-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pty: prepare for tty->ops changes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We are about to change the tty layer to avoid keeping private copies of all
the methods in each tty.  We have to update the pty layer first as it
currently patches the ioctl method according to the tty type.  Use multiple
tty operations sets instead.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pty.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff -puN drivers/char/pty.c~pty-prepare-for-tty-ops-changes drivers/char/pty.c
--- a/drivers/char/pty.c~pty-prepare-for-tty-ops-changes
+++ a/drivers/char/pty.c
@@ -254,6 +254,18 @@ static int pty_bsd_ioctl(struct tty_stru
 static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
 module_param(legacy_count, int, 0);
 
+static const struct tty_operations pty_ops_bsd = {
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+	.ioctl = pty_bsd_ioctl,
+};
+
 static void __init legacy_pty_init(void)
 {
 	if (legacy_count <= 0)
@@ -284,7 +296,6 @@ static void __init legacy_pty_init(void)
 	pty_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW;
 	pty_driver->other = pty_slave_driver;
 	tty_set_operations(pty_driver, &pty_ops);
-	pty_driver->ioctl = pty_bsd_ioctl;
 
 	pty_slave_driver->owner = THIS_MODULE;
 	pty_slave_driver->driver_name = "pty_slave";
@@ -377,6 +388,19 @@ static int pty_unix98_ioctl(struct tty_s
 	return -ENOIOCTLCMD;
 }
 
+static const struct tty_operations pty_unix98_ops = {
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+	.ioctl = pty_unix98_ioctl
+};
+
+
 static void __init unix98_pty_init(void)
 {
 	ptm_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
@@ -403,8 +427,7 @@ static void __init unix98_pty_init(void)
 	ptm_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	ptm_driver->other = pts_driver;
-	tty_set_operations(ptm_driver, &pty_ops);
-	ptm_driver->ioctl = pty_unix98_ioctl;
+	tty_set_operations(ptm_driver, &pty_unix98_ops);
 
 	pts_driver->owner = THIS_MODULE;
 	pts_driver->driver_name = "pty_slave";
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

