From: akpm@linux-foundation.org
Subject: - uml-debug_shirq-fixes.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:18 -0800
Message-ID: <200802052237.m15MbxjN012911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762504AbYBEWm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, magotari@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: DEBUG_SHIRQ fixes
has been removed from the -mm tree.  Its filename was
     uml-debug_shirq-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: DEBUG_SHIRQ fixes
From: Jeff Dike <jdike@addtoit.com>

A couple more DEBUG_SHIRQ fixes.

The previous mconsole blocking fix exposed the lack of O_NONBLOCK on the
mconsole socket.

Also, winch_interrupt started crashing because it is called at irq free time
and it tries to dereference tty->driver_data, which has already been set to
NULL.

I added some error cleanup in mconsole_init while I was there.

Cc: "Karol Swietlicki" <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c          |    8 +++++---
 arch/um/drivers/mconsole_kern.c |    8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN arch/um/drivers/line.c~uml-debug_shirq-fixes arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/line.c
@@ -774,9 +774,11 @@ static irqreturn_t winch_interrupt(int i
 	tty = winch->tty;
 	if (tty != NULL) {
 		line = tty->driver_data;
-		chan_window_size(&line->chan_list, &tty->winsize.ws_row,
-				 &tty->winsize.ws_col);
-		kill_pgrp(tty->pgrp, SIGWINCH, 1);
+		if (line != NULL) {
+			chan_window_size(&line->chan_list, &tty->winsize.ws_row,
+					 &tty->winsize.ws_col);
+			kill_pgrp(tty->pgrp, SIGWINCH, 1);
+		}
 	}
  out:
 	if (winch->fd != -1)
diff -puN arch/um/drivers/mconsole_kern.c~uml-debug_shirq-fixes arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/mconsole_kern.c
@@ -792,6 +792,8 @@ static int __init mconsole_init(void)
 		printk(KERN_ERR "Failed to initialize management console\n");
 		return 1;
 	}
+	if (os_set_fd_block(sock, 0))
+		goto out;
 
 	register_reboot_notifier(&reboot_notifier);
 
@@ -800,7 +802,7 @@ static int __init mconsole_init(void)
 			     "mconsole", (void *)sock);
 	if (err) {
 		printk(KERN_ERR "Failed to get IRQ for management console\n");
-		return 1;
+		goto out;
 	}
 
 	if (notify_socket != NULL) {
@@ -816,6 +818,10 @@ static int __init mconsole_init(void)
 	printk(KERN_INFO "mconsole (version %d) initialized on %s\n",
 	       MCONSOLE_VERSION, mconsole_socket_name);
 	return 0;
+
+ out:
+	os_close_file(sock);
+	return 1;
 }
 
 __initcall(mconsole_init);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
