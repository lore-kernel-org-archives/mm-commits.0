From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-rcu.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:02 -0400
Message-ID: <201003150705.o2F75ZVm017101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933035Ab0COHFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, josh@joshtriplett.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: rcu
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: rcu
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move rcutorture_runnable extern declaration to linux/rcupdate.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |    4 ++++
 kernel/sysctl.c          |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/rcupdate.h~sysctl-extern-cleanup-rcu include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~sysctl-extern-cleanup-rcu
+++ a/include/linux/rcupdate.h
@@ -41,6 +41,10 @@
 #include <linux/lockdep.h>
 #include <linux/completion.h>
 
+#ifdef CONFIG_RCU_TORTURE_TEST
+extern int rcutorture_runnable; /* for sysctl */
+#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
+
 /**
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-rcu kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-rcu
+++ a/kernel/sysctl.c
@@ -82,9 +82,6 @@ extern int percpu_pagelist_fraction;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
-#ifdef CONFIG_RCU_TORTURE_TEST
-extern int rcutorture_runnable;
-#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
linux-next.patch

