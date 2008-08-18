From: akpm@linux-foundation.org
Subject: - kexec-jump-remove-duplication-of-kexec_restart_prepare.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:30 -0700
Message-ID: <200808181939.m7IJdUSN008326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758365AbYHRTkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@suse.cz, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump: remove duplication of kexec_restart_prepare()
has been removed from the -mm tree.  Its filename was
     kexec-jump-remove-duplication-of-kexec_restart_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: remove duplication of kexec_restart_prepare()
From: Huang Ying <ying.huang@intel.com>

Call kernel_restart_prepare() in kernel_kexec() instead of duplicating the
code.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Pavel Machek <pavel@suse.cz>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    1 +
 kernel/kexec.c         |    6 +-----
 kernel/sys.c           |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff -puN include/linux/reboot.h~kexec-jump-remove-duplication-of-kexec_restart_prepare include/linux/reboot.h
--- a/include/linux/reboot.h~kexec-jump-remove-duplication-of-kexec_restart_prepare
+++ a/include/linux/reboot.h
@@ -59,6 +59,7 @@ extern void machine_crash_shutdown(struc
  * Architecture independent implemenations of sys_reboot commands.
  */
 
+extern void kernel_restart_prepare(char *cmd);
 extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
diff -puN kernel/kexec.c~kexec-jump-remove-duplication-of-kexec_restart_prepare kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-remove-duplication-of-kexec_restart_prepare
+++ a/kernel/kexec.c
@@ -1472,11 +1472,7 @@ int kernel_kexec(void)
 	} else
 #endif
 	{
-		blocking_notifier_call_chain(&reboot_notifier_list,
-					     SYS_RESTART, NULL);
-		system_state = SYSTEM_RESTART;
-		device_shutdown();
-		sysdev_shutdown();
+		kernel_restart_prepare(NULL);
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();
 	}
diff -puN kernel/sys.c~kexec-jump-remove-duplication-of-kexec_restart_prepare kernel/sys.c
--- a/kernel/sys.c~kexec-jump-remove-duplication-of-kexec_restart_prepare
+++ a/kernel/sys.c
@@ -274,7 +274,7 @@ void emergency_restart(void)
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
 
-static void kernel_restart_prepare(char *cmd)
+void kernel_restart_prepare(char *cmd)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
 	system_state = SYSTEM_RESTART;
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch

