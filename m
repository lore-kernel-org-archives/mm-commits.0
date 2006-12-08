From: akpm@osdl.org
Subject: - tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:57:30 -0800
Message-ID: <200612080857.kB88vURC014171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37830 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425206AbWLHI5h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:57:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix
has been removed from the -mm tree.  Its filename was
     tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch

This patch was dropped because it was folded into tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch

------------------------------------------------------
Subject: tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix
From: Andrew Morton <akpm@osdl.org>

drivers/char/tty_ioctl.c: In function 'set_termios':
drivers/char/tty_ioctl.c:448: error: invalid storage class for function 'get_termio'
drivers/char/tty_ioctl.c:447: warning: ISO C90 forbids mixed declarations and code
drivers/char/tty_ioctl.c:455: error: invalid storage class for function 'inq_canon'
drivers/char/tty_ioctl.c:647: error: invalid storage class for function 'send_prio_char'
drivers/char/tty_ioctl.c:845: error: non-static declaration of 'n_tty_ioctl' follows static declaration
drivers/char/tty_ioctl.c:669: error: previous definition of 'n_tty_ioctl' was here
drivers/char/tty_ioctl.c:845: error: expected declaration or statement at end of input

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tty_ioctl.c~tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix
+++ a/drivers/char/tty_ioctl.c
@@ -416,7 +416,7 @@ static int set_termios(struct tty_struct
 			return -EFAULT;
 	}
 #else
-	else if (user_termios_to_kernel_termios(&tmp_termios,
+	} else if (user_termios_to_kernel_termios(&tmp_termios,
 					(struct termios __user *)arg))
 		return -EFAULT;
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
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
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

