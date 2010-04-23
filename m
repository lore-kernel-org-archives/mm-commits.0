From: akpm@linux-foundation.org
Subject: [folded] vmware-balloon-driver-fix.patch removed from -mm tree
Date: Fri, 23 Apr 2010 13:12:16 -0400
Message-ID: <201004232013.o3NKDpv6009563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756730Ab0DWUOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 16:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@vmware.com, avi@redhat.com, jeremy@goop.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     vmware-balloon-driver-fix
has been removed from the -mm tree.  Its filename was
     vmware-balloon-driver-fix.patch

This patch was dropped because it was folded into vmware-balloon-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmware-balloon-driver-fix
From: Dmitry Torokhov <dtor@vmware.com>

 - document rate allocation constants
 - do not compile statistics code when debugfs is disabled
 - fix compilation error when debugfs is disabled

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmware_balloon.c |   38 ++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff -puN drivers/misc/vmware_balloon.c~vmware-balloon-driver-fix drivers/misc/vmware_balloon.c
--- a/drivers/misc/vmware_balloon.c~vmware-balloon-driver-fix
+++ a/drivers/misc/vmware_balloon.c
@@ -50,12 +50,28 @@ MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
 
+/*
+ * Various constants controlling rate of inflaint/deflating balloon,
+ * measured in pages.
+ */
+
+/*
+ * Rate of allocating memory when there is no memory pressure
+ * (driver performs non-sleeping allocations).
+ */
 #define VMW_BALLOON_NOSLEEP_ALLOC_MAX	16384U
 
+/*
+ * Rates of memory allocaton when guest experiences memory pressure
+ * (driver performs sleeping allocations).
+ */
 #define VMW_BALLOON_RATE_ALLOC_MIN	512U
 #define VMW_BALLOON_RATE_ALLOC_MAX	2048U
 #define VMW_BALLOON_RATE_ALLOC_INC	16U
 
+/*
+ * Rates for releasing pages while deflating balloon.
+ */
 #define VMW_BALLOON_RATE_FREE_MIN	512U
 #define VMW_BALLOON_RATE_FREE_MAX	16384U
 #define VMW_BALLOON_RATE_FREE_INC	16U
@@ -85,6 +101,10 @@ MODULE_LICENSE("GPL");
 /* Maximum number of page allocations without yielding processor */
 #define VMW_BALLOON_YIELD_THRESHOLD	1024
 
+
+/*
+ * Hypervisor communication port definitions.
+ */
 #define VMW_BALLOON_HV_PORT		0x5670
 #define VMW_BALLOON_HV_MAGIC		0x456c6d6f
 #define VMW_BALLOON_PROTOCOL_VERSION	2
@@ -125,8 +145,7 @@ MODULE_LICENSE("GPL");
 	__stat & -1UL;					\
 })
 
-#define STATS_INC(stat) (stat)++
-
+#ifdef CONFIG_DEBUG_FS
 struct vmballoon_stats {
 	unsigned int timer;
 
@@ -152,6 +171,11 @@ struct vmballoon_stats {
 	unsigned int guest_type_fail;
 };
 
+#define STATS_INC(stat) (stat)++
+#else
+#define STATS_INC(stat)
+#endif
+
 struct vmballoon {
 
 	/* list of reserved physical pages */
@@ -174,11 +198,13 @@ struct vmballoon {
 	/* slowdown page allocations for next few cycles */
 	unsigned int slow_allocation_cycles;
 
+#ifdef CONFIG_DEBUG_FS
 	/* statistics */
 	struct vmballoon_stats stats;
 
 	/* debugfs file exporting statistics */
 	struct dentry *dbg_entry;
+#endif
 
 	struct sysinfo sysinfo;
 
@@ -637,7 +663,7 @@ static void vmballoon_work(struct work_s
 }
 
 /*
- * PROCFS Interface
+ * DEBUGFS Interface
  */
 #ifdef CONFIG_DEBUG_FS
 
@@ -727,11 +753,11 @@ static inline int vmballoon_debugfs_init
 	return 0;
 }
 
-static inline void vmballoon_debugfs_exit(void)
+static inline void vmballoon_debugfs_exit(struct vmballoon *b)
 {
 }
 
-#endif	/* CONFIG_PROC_FS */
+#endif	/* CONFIG_DEBUG_FS */
 
 static int __init vmballoon_init(void)
 {
@@ -750,8 +776,6 @@ static int __init vmballoon_init(void)
 		return -ENOMEM;
 	}
 
-	/* initialize global state */
-	memset(&balloon, 0, sizeof(balloon));
 	INIT_LIST_HEAD(&balloon.pages);
 	INIT_LIST_HEAD(&balloon.refused_pages);
 
_

Patches currently in -mm which might be from dtor@vmware.com are

vmware-balloon-driver.patch
vmware-balloon-driver-fix.patch

