From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-lockdep.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:16 -0400
Message-ID: <201003150705.o2F75nXt017117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935829Ab0COHGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: lockdep
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-lockdep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: lockdep
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

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
@@ -75,6 +75,9 @@
 #ifdef CONFIG_RT_MUTEXES
 #include <linux/rtmutex.h>
 #endif
+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
+#include <linux/lockdep.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -186,9 +189,6 @@ extern struct ctl_table epoll_table[];
 int sysctl_legacy_va_layout;
 #endif
 
-extern int prove_locking;
-extern int lock_stat;
