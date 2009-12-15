From: akpm@linux-foundation.org
Subject: [folded] hugetlb-offload-per-node-attribute-registrations-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 16:57:53 -0800
Message-ID: <200912150057.nBF0vroH019998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757597AbZLOA6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: offload per node attribute registrations fix
has been removed from the -mm tree.  Its filename was
     hugetlb-offload-per-node-attribute-registrations-fix.patch

This patch was dropped because it was folded into hugetlb-offload-per-node-attribute-registrations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: offload per node attribute registrations fix
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Fix build failure when MEMORY_HOTPLUG_SPARSE and !HUGETLBFS:

drivers/base/node.c:484: error: implicit declaration of function 'init_node_hugetlb_work'
drivers/base/node.c:582: error: 'node_memory_callback' undeclared (first use in this function)

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/base/node.c~hugetlb-offload-per-node-attribute-registrations-fix drivers/base/node.c
--- a/drivers/base/node.c~hugetlb-offload-per-node-attribute-registrations-fix
+++ a/drivers/base/node.c
@@ -445,8 +445,12 @@ static int node_memory_callback(struct n
 }
 #endif	/* CONFIG_HUGETLBFS */
 #else	/* !CONFIG_MEMORY_HOTPLUG_SPARSE */
+
 static int link_mem_sections(int nid) { return 0; }
+#endif	/* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+#if !defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || \
+    !defined(CONFIG_HUGETLBFS)
 static inline int node_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
@@ -455,7 +459,7 @@ static inline int node_memory_callback(s
 
 static void init_node_hugetlb_work(int nid) { }
 
-#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
+#endif
 
 int register_one_node(int nid)
 {
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

hugetlb-offload-per-node-attribute-registrations.patch
hugetlb-offload-per-node-attribute-registrations-fix.patch
swap-rework-map_swap_page-again.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-remove-unevictable_migrate_page-function.patch
mlock-replace-stale-comments-in-munlock_vma_page.patch

