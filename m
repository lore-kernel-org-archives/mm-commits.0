From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-rtmutex.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:13 -0400
Message-ID: <201003150705.o2F75kRQ017114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933035Ab0COHGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:06:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: rtmutex
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-rtmutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: rtmutex
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

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
@@ -72,6 +72,9 @@
 #ifdef CONFIG_BSD_PROCESS_ACCT
 #include <linux/acct.h>
 #endif
+#ifdef CONFIG_RT_MUTEXES
+#include <linux/rtmutex.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -145,10 +148,6 @@ extern int unaligned_dump_stack;
 
 extern struct ratelimit_state printk_ratelimit_state;
 
-#ifdef CONFIG_RT_MUTEXES
-extern int max_lock_depth;
-#endif
