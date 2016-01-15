From: akpm@linux-foundation.org
Subject: [merged] mm-zonelist-enumerate-zonelists-array-index.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:56 -0800
Message-ID: <56997398.Z5Jf81zZbuADZn3k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbcAOWc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zonelist: enumerate zonelists array index
has been removed from the -mm tree.  Its filename was
     mm-zonelist-enumerate-zonelists-array-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/zonelist: enumerate zonelists array index

Hardcoding index to zonelists array in gfp_zonelist() is not a good idea,
let's enumerate it to improve readability.

No functional change.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix CONFIG_NUMA=n build]
[n-horiguchi@ah.jp.nec.com: fix warning in comparing enumerator]
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    9 +++++----
 include/linux/mmzone.h |   20 +++++++++-----------
 mm/page_alloc.c        |    9 ++++-----
 3 files changed, 18 insertions(+), 20 deletions(-)

diff -puN include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index include/linux/gfp.h
--- a/include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index
+++ a/include/linux/gfp.h
@@ -384,10 +384,11 @@ static inline enum zone_type gfp_zone(gf
 
 static inline int gfp_zonelist(gfp_t flags)
 {
-	if (IS_ENABLED(CONFIG_NUMA) && unlikely(flags & __GFP_THISNODE))
-		return 1;
-
-	return 0;
+#ifdef CONFIG_NUMA
+	if (unlikely(flags & __GFP_THISNODE))
+		return ZONELIST_NOFALLBACK;
+#endif
+	return ZONELIST_FALLBACK;
 }
 
 /*
diff -puN include/linux/mmzone.h~mm-zonelist-enumerate-zonelists-array-index include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zonelist-enumerate-zonelists-array-index
+++ a/include/linux/mmzone.h
@@ -571,19 +571,17 @@ static inline bool zone_is_empty(struct
 /* Maximum number of zones on a zonelist */
 #define MAX_ZONES_PER_ZONELIST (MAX_NUMNODES * MAX_NR_ZONES)
 
+enum {
+	ZONELIST_FALLBACK,	/* zonelist with fallback */
 #ifdef CONFIG_NUMA
-
-/*
- * The NUMA zonelists are doubled because we need zonelists that restrict the
- * allocations to a single node for __GFP_THISNODE.
- *
- * [0]	: Zonelist with fallback
- * [1]	: No fallback (__GFP_THISNODE)
- */
-#define MAX_ZONELISTS 2
-#else
-#define MAX_ZONELISTS 1
+	/*
+	 * The NUMA zonelists are doubled because we need zonelists that
+	 * restrict the allocations to a single node for __GFP_THISNODE.
+	 */
+	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
 #endif
+	MAX_ZONELISTS
+};
 
 /*
  * This struct contains information about a zone in a zonelist. It is stored
diff -puN mm/page_alloc.c~mm-zonelist-enumerate-zonelists-array-index mm/page_alloc.c
--- a/mm/page_alloc.c~mm-zonelist-enumerate-zonelists-array-index
+++ a/mm/page_alloc.c
@@ -4148,8 +4148,7 @@ static void set_zonelist_order(void)
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int j, node, load;
-	enum zone_type i;
+	int i, node, load;
 	nodemask_t used_mask;
 	int local_node, prev_node;
 	struct zonelist *zonelist;
@@ -4169,7 +4168,7 @@ static void build_zonelists(pg_data_t *p
 	nodes_clear(used_mask);
 
 	memset(node_order, 0, sizeof(node_order));
-	j = 0;
+	i = 0;
 
 	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
 		/*
@@ -4186,12 +4185,12 @@ static void build_zonelists(pg_data_t *p
 		if (order == ZONELIST_ORDER_NODE)
 			build_zonelists_in_node_order(pgdat, node);
 		else
-			node_order[j++] = node;	/* remember order */
+			node_order[i++] = node;	/* remember order */
 	}
 
 	if (order == ZONELIST_ORDER_ZONE) {
 		/* calculate node order -- i.e., DMA last! */
-		build_zonelists_in_zone_order(pgdat, j);
+		build_zonelists_in_zone_order(pgdat, i);
 	}
 
 	build_thisnode_zonelists(pgdat);
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

