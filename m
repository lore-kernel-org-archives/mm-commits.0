From: akpm@osdl.org
Subject: - add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:52:23 -0800
Message-ID: <200612080852.kB88qNG3013994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37277 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032528AbWLHIwY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:52:24 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kB88qNID021853
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 8 Dec 2006 00:52:23 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, mm-commits@vger.kernel.org


The patch titled
     add-process_session-helper-routine-deprecate-old-field-fix-warnings-2
has been removed from the -mm tree.  Its filename was
     add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch

This patch was dropped because it was folded into add-process_session-helper-routine-deprecate-old-field.patch

------------------------------------------------------
Subject: add-process_session-helper-routine-deprecate-old-field-fix-warnings-2
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/tty.h~add-process_session-helper-routine-deprecate-old-field-fix-warnings-2 include/linux/tty.h
diff -puN drivers/char/tty_io.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings-2 drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~add-process_session-helper-routine-deprecate-old-field-fix-warnings-2
+++ a/drivers/char/tty_io.c
@@ -3850,7 +3850,7 @@ void proc_clear_tty(struct task_struct *
 void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	if (tty) {
-		tty->session = tsk->signal->session;
+		tty->session = process_session(tsk);
 		tty->pgrp = process_group(tsk);
 	}
 	tsk->signal->tty = tty;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

