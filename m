From: akpm@osdl.org
Subject: - add-process_session-helper-routine-deprecate-old-field-tidy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:52:12 -0800
Message-ID: <200612080852.kB88qDKv013985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425209AbWLHIw0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:52:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add-process_session-helper-routine-deprecate-old-field-tidy
has been removed from the -mm tree.  Its filename was
     add-process_session-helper-routine-deprecate-old-field-tidy.patch

This patch was dropped because it was folded into add-process_session-helper-routine-deprecate-old-field.patch

------------------------------------------------------
Subject: add-process_session-helper-routine-deprecate-old-field-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/init_task.h~add-process_session-helper-routine-deprecate-old-field-tidy include/linux/init_task.h
--- a/include/linux/init_task.h~add-process_session-helper-routine-deprecate-old-field-tidy
+++ a/include/linux/init_task.h
@@ -68,7 +68,7 @@
 	.rlim		= INIT_RLIMITS,					\
 	.pgrp		= 1,						\
 	.tty_old_pgrp   = 0,						\
-	{ .session      = 1},						\
+	{ .__session      = 1},						\
 }
 
 extern struct nsproxy init_nsproxy;
diff -puN include/linux/sched.h~add-process_session-helper-routine-deprecate-old-field-tidy include/linux/sched.h
--- a/include/linux/sched.h~add-process_session-helper-routine-deprecate-old-field-tidy
+++ a/include/linux/sched.h
@@ -439,7 +439,7 @@ struct signal_struct {
 	pid_t tty_old_pgrp;
 
 	union {
-		pid_t session __attribute ((deprecated));
+		pid_t session __deprecated;
 		pid_t __session;
 	};
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
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

