From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-lockdep.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:56 -0800
Message-ID: <201002242019.o1OKJuHh018226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758051Ab0BXUWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:22:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     sysctl extern cleanup: lockdep
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-lockdep.patch

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
Subject: sysctl extern cleanup: lockdep
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move lockdep extern declarations to linux/lockdep.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    4 ++++
 kernel/sysctl.c         |    6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN include/linux/lockdep.h~sysctl-extern-cleanup-lockdep include/linux/lockdep.h
--- a/include/linux/lockdep.h~sysctl-extern-cleanup-lockdep
+++ a/include/linux/lockdep.h
@@ -12,6 +12,10 @@
 struct task_struct;
 struct lockdep_map;
 
+/* for sysctl */
+extern int prove_locking;
+extern int lock_stat;
+
 #ifdef CONFIG_LOCKDEP
 
 #include <linux/linkage.h>
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-lockdep kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-lockdep
+++ a/kernel/sysctl.c
@@ -69,6 +69,9 @@
 #ifdef CONFIG_RT_MUTEXES
 #include <linux/rtmutex.h>
 #endif
+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
+#include <linux/lockdep.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -179,9 +182,6 @@ extern struct ctl_table inotify_table[];
 extern struct ctl_table epoll_table[];
 #endif
 
-extern int prove_locking;
-extern int lock_stat;
-
 /* The default sysctl tables: */
 
 static struct ctl_table root_table[] = {
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

