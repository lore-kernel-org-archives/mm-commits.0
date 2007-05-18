From: akpm@linux-foundation.org
Subject: + fix-unused-setup_nr_node_ids.patch added to -mm tree
Date: Fri, 18 May 2007 10:53:22 -0700
Message-ID: <200705181753.l4IHrMYP020142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:43706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbXERRzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fix unused setup_nr_node_ids
has been added to the -mm tree.  Its filename is
     fix-unused-setup_nr_node_ids.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix unused setup_nr_node_ids
From: Miklos Szeredi <mszeredi@suse.cz>

mm/page_alloc.c:931: warning: 'setup_nr_node_ids' defined but not used

This is now the only (!) compiler warning I get in my UML build :)

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff -puN mm/page_alloc.c~fix-unused-setup_nr_node_ids mm/page_alloc.c
--- a/mm/page_alloc.c~fix-unused-setup_nr_node_ids
+++ a/mm/page_alloc.c
@@ -136,6 +136,11 @@ static unsigned long __meminitdata dma_r
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
+#if MAX_NUMNODES > 1
+int nr_node_ids __read_mostly = MAX_NUMNODES;
+EXPORT_SYMBOL(nr_node_ids);
+#endif
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -669,26 +674,6 @@ static int rmqueue_bulk(struct zone *zon
 	return i;
 }
 
-#if MAX_NUMNODES > 1
-int nr_node_ids __read_mostly = MAX_NUMNODES;
-EXPORT_SYMBOL(nr_node_ids);
-
-/*
- * Figure out the number of possible node ids.
- */
-static void __init setup_nr_node_ids(void)
-{
-	unsigned int node;
-	unsigned int highest = 0;
-
-	for_each_node_mask(node, node_possible_map)
-		highest = node;
-	nr_node_ids = highest + 1;
-}
-#else
-static void __init setup_nr_node_ids(void) {}
-#endif
-
 #ifdef CONFIG_NUMA
 /*
  * Called from the vmstat counter updater to drain pagesets of this
@@ -2733,6 +2718,26 @@ void __meminit free_area_init_node(int n
 }
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+
+#if MAX_NUMNODES > 1
+/*
+ * Figure out the number of possible node ids.
+ */
+static void __init setup_nr_node_ids(void)
+{
+	unsigned int node;
+	unsigned int highest = 0;
+
+	for_each_node_mask(node, node_possible_map)
+		highest = node;
+	nr_node_ids = highest + 1;
+}
+#else
+static inline void setup_nr_node_ids(void)
+{
+}
+#endif
+
 /**
  * add_active_range - Register a range of PFNs backed by physical memory
  * @nid: The node ID the range resides on
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-generic_write_checks-for-direct_io.patch
fuse-delete-inode-on-drop.patch
fix-unused-setup_nr_node_ids.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
