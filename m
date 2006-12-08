From: akpm@osdl.org
Subject: - sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:06:49 -0800
Message-ID: <200612080906.kB896nxe014434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425267AbWLHJGv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:06:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3
has been removed from the -mm tree.  Its filename was
     sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch

This patch was dropped because it was folded into sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch

------------------------------------------------------
Subject: sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3
From: Andrew Morton <akpm@osdl.org>

kernel/sysctl.c:2676: warning: 'sysctl_ipc_data' defined but not used

Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/sysctl.c~sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3 kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3
+++ a/kernel/sysctl.c
@@ -150,9 +150,11 @@ static int sysctl_uts_string(ctl_table *
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen, void **context);
 
+#ifdef CONFIG_SYSVIPC
 static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen, void **context);
+#endif
 
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
@@ -2669,6 +2671,7 @@ static int sysctl_uts_string(ctl_table *
 	return r;
 }
 
+#ifdef CONFIG_SYSVIPC
 /* The generic sysctl ipc data routine. */
 static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
@@ -2707,6 +2710,7 @@ static int sysctl_ipc_data(ctl_table *ta
 	}
 	return 1;
 }
+#endif
 
 #else /* CONFIG_SYSCTL_SYSCALL */
 
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
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

