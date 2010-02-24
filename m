From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-c_a_d.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:27 -0800
Message-ID: <201002242019.o1OKJRpt018172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab0BXUT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:19:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     sysctl extern cleanup: C_A_D
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-c_a_d.patch

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
Subject: sysctl extern cleanup: C_A_D
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

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
@@ -72,7 +72,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int C_A_D;
 extern int print_fatal_signals;
 extern int max_threads;
 extern int core_uses_pid;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
sysctl-extern-cleanup-c_a_d.patch
sysctl-extern-cleanup-signal.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-rcu.patch
sysctl-extern-cleanup-block-iopoll.patch
sysctl-extern-cleanup-module.patch
sysctl-extern-cleanup-sg.patch
sysctl-extern-cleanup-acct.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
sysctl-extern-cleanup-poll.patch
sysctl-extern-cleanup-inotify.patch

