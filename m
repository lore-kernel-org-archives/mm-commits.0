From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-and-new-framework-warning-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:54:03 -0800
Message-ID: <200612080854.kB88s3EM014051@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425218AbWLHIyL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:54:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty-switch-to-ktermios-and-new-framework-warning-fix
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-and-new-framework-warning-fix.patch

This patch was dropped because it was folded into tty-switch-to-ktermios-and-new-framework.patch

------------------------------------------------------
Subject: tty-switch-to-ktermios-and-new-framework-warning-fix
From: Andrew Morton <akpm@osdl.org>

drivers/char/tty_ioctl.c: In function 'tty_termios_input_baud_rate':
drivers/char/tty_ioctl.c:198: warning: unused variable 'cbaud'

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_ioctl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty-switch-to-ktermios-and-new-framework-warning-fix drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-switch-to-ktermios-and-new-framework-warning-fix
+++ a/drivers/char/tty_ioctl.c
@@ -195,10 +195,8 @@ EXPORT_SYMBOL(tty_termios_baud_rate);
 
 speed_t tty_termios_input_baud_rate(struct ktermios *termios)
 {
-	unsigned int cbaud;
-
 #ifdef IBSHIFT
-	cbaud = (termios->c_cflag >> IBSHIFT) & CBAUD;
+	unsigned int cbaud = (termios->c_cflag >> IBSHIFT) & CBAUD;
 
 	if (cbaud == B0)
 		return tty_termios_baud_rate(termios);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
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

