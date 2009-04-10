From: akpm@linux-foundation.org
Subject: + kernel-sysc-clean-up-sys_shutdown-exit-path.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:14:20 -0700
Message-ID: <200904100514.n3A5EKEG006110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZDJFQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:16:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com


The patch titled
     kernel/sys.c: clean up sys_shutdown exit path
has been added to the -mm tree.  Its filename is
     kernel-sysc-clean-up-sys_shutdown-exit-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

x86-simplify-highmem-related-kconfig-entries.patch
update-nsigtrap-in-asm-generic-siginfoh.patch
kernel-sysc-clean-up-sys_shutdown-exit-path.patch

