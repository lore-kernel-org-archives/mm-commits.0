From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-clean-up-sys_shutdown-exit-path.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:48 -0700
Message-ID: <200904141949.n3EJnm11019822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754242AbZDNTvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     kernel/sys.c: clean up sys_shutdown exit path
has been removed from the -mm tree.  Its filename was
     kernel-sysc-clean-up-sys_shutdown-exit-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sys.c: clean up sys_shutdown exit path
From: Andi Kleen <andi@firstfloor.org>

Impact: cleanup, fix

Clean up sys_shutdown() exit path.  Factor out common code.  Return
correct error code instead of always 0 on failure.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-clean-up-sys_shutdown-exit-path kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-clean-up-sys_shutdown-exit-path
+++ a/kernel/sys.c
@@ -360,6 +360,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 		void __user *, arg)
 {
 	char buffer[256];
+	int ret = 0;
 
 	/* We only trust the superuser with rebooting the system. */
 	if (!capable(CAP_SYS_BOOT))
@@ -397,7 +398,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 		kernel_halt();
 		unlock_kernel();
 		do_exit(0);
-		break;
+		panic("cannot halt");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		kernel_power_off();
@@ -417,29 +418,22 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 
 #ifdef CONFIG_KEXEC
 	case LINUX_REBOOT_CMD_KEXEC:
-		{
-			int ret;
-			ret = kernel_kexec();
-			unlock_kernel();
-			return ret;
-		}
+		ret = kernel_kexec();
+		break;
 #endif
 
 #ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
-		{
-			int ret = hibernate();
-			unlock_kernel();
-			return ret;
-		}
+		ret = hibernate();
+		break;
 #endif
 
 	default:
-		unlock_kernel();
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 	}
 	unlock_kernel();
-	return 0;
+	return ret;
 }
 
 static void deferred_cad(struct work_struct *dummy)
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
x86-simplify-highmem-related-kconfig-entries.patch

