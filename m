From: akpm@osdl.org
Subject: - tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:43:26 -0800
Message-ID: <200612080843.kB88hQ68013740@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425190AbWLHInn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:43:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, a.p.zijlstra@chello.nl, alan@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tty-signal-tty-locking-post-viro-trainwreck-fix-fix
has been removed from the -mm tree.  Its filename was
     tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch

This patch was dropped because it was folded into tty-signal-tty-locking.patch

------------------------------------------------------
Subject: tty-signal-tty-locking-post-viro-trainwreck-fix-fix
From: Andrew Morton <akpm@osdl.org>

WARNING: "proc_clear_tty" [arch/sparc64/solaris/solaris.ko] undefined!

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/tty_io.c~tty-signal-tty-locking-post-viro-trainwreck-fix-fix drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-signal-tty-locking-post-viro-trainwreck-fix-fix
+++ a/drivers/char/tty_io.c
@@ -3847,6 +3847,7 @@ void proc_clear_tty(struct task_struct *
 	p->signal->tty = NULL;
 	spin_unlock_irq(&p->sighand->siglock);
 }
+EXPORT_SYMBOL(proc_clear_tty);
 
 void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
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

