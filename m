From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-rtmutex.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:54 -0800
Message-ID: <201002242019.o1OKJsPS018219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732Ab0BXUUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:20:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     sysctl extern cleanup: rtmutex
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-rtmutex.patch

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
Subject: sysctl extern cleanup: rtmutex
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move max_lock_depth extern declaration to linux/rtmutex.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rtmutex.h |    2 ++
 kernel/sysctl.c         |    7 +++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/rtmutex.h~sysctl-extern-cleanup-rtmutex include/linux/rtmutex.h
--- a/include/linux/rtmutex.h~sysctl-extern-cleanup-rtmutex
+++ a/include/linux/rtmutex.h
@@ -16,6 +16,8 @@
 #include <linux/plist.h>
 #include <linux/spinlock_types.h>
 
+extern int max_lock_depth; /* for sysctl */
+
 /**
  * The rt_mutex structure
  *
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-rtmutex kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-rtmutex
+++ a/kernel/sysctl.c
@@ -66,6 +66,9 @@
 #ifdef CONFIG_BSD_PROCESS_ACCT
 #include <linux/acct.h>
 #endif
+#ifdef CONFIG_RT_MUTEXES
+#include <linux/rtmutex.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -142,10 +145,6 @@ extern int unaligned_dump_stack;
 
 extern struct ratelimit_state printk_ratelimit_state;
 
-#ifdef CONFIG_RT_MUTEXES
-extern int max_lock_depth;
-#endif
-
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
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

