From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-and-new-framework-irda-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:54:06 -0800
Message-ID: <200612080854.kB88s6QW014057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425218AbWLHIyN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty-switch-to-ktermios-and-new-framework-irda-fix
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-and-new-framework-irda-fix.patch

This patch was dropped because it was folded into tty-switch-to-ktermios-and-new-framework.patch

------------------------------------------------------
Subject: tty-switch-to-ktermios-and-new-framework-irda-fix
From: Andrew Morton <akpm@osdl.org>

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/net/irda/ircomm_tty.h      |    2 +-
 net/irda/ircomm/ircomm_tty_ioctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN net/irda/ircomm/ircomm_tty.c~tty-switch-to-ktermios-and-new-framework-irda-fix net/irda/ircomm/ircomm_tty.c
diff -puN net/irda/ircomm/ircomm_tty_ioctl.c~tty-switch-to-ktermios-and-new-framework-irda-fix net/irda/ircomm/ircomm_tty_ioctl.c
--- a/net/irda/ircomm/ircomm_tty_ioctl.c~tty-switch-to-ktermios-and-new-framework-irda-fix
+++ a/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -146,7 +146,7 @@ static void ircomm_tty_change_speed(stru
  *    do something rational.
  */
 void ircomm_tty_set_termios(struct tty_struct *tty, 
-			    struct termios *old_termios)
+			    struct ktermios *old_termios)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;
 	unsigned int cflag = tty->termios->c_cflag;
diff -puN include/net/irda/ircomm_tty.h~tty-switch-to-ktermios-and-new-framework-irda-fix include/net/irda/ircomm_tty.h
--- a/include/net/irda/ircomm_tty.h~tty-switch-to-ktermios-and-new-framework-irda-fix
+++ a/include/net/irda/ircomm_tty.h
@@ -126,7 +126,7 @@ extern int ircomm_tty_tiocmset(struct tt
 extern int ircomm_tty_ioctl(struct tty_struct *tty, struct file *file, 
 			    unsigned int cmd, unsigned long arg);
 extern void ircomm_tty_set_termios(struct tty_struct *tty, 
-				   struct termios *old_termios);
+				   struct ktermios *old_termios);
 extern hashbin_t *ircomm_tty;
 
 #endif
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

