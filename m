From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-c_a_d.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:57 -0400
Message-ID: <201003150705.o2F75UF7017094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759731Ab0COHFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: C_A_D
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-c_a_d.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: C_A_D
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move C_A_D extern variable declaration to linux/reboot.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    1 +
 kernel/sysctl.c        |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/reboot.h~sysctl-extern-cleanup-c_a_d include/linux/reboot.h
--- a/include/linux/reboot.h~sysctl-extern-cleanup-c_a_d
+++ a/include/linux/reboot.h
@@ -64,6 +64,7 @@ extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
 
+extern int C_A_D; /* for sysctl */
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-c_a_d kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-c_a_d
+++ a/kernel/sysctl.c
@@ -65,7 +65,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int C_A_D;
 extern int print_fatal_signals;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
linux-next.patch

