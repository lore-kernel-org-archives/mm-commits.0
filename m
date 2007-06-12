From: akpm@linux-foundation.org
Subject: - move-three-functions-that-are-only-needed-for.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:56 -0700
Message-ID: <200706121856.l5CIuuB3018432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756927AbXFLS5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, apw@shadowen.org, pbadari@us.ibm.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Move three functions that are only needed for CONFIG_MEMORY_HOTPLUG
has been removed from the -mm tree.  Its filename was
     move-three-functions-that-are-only-needed-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Move three functions that are only needed for CONFIG_MEMORY_HOTPLUG
From: Stephen Rothwell <sfr@canb.auug.org.au>

into the appropriate #ifdef.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff -puN mm/sparse.c~move-three-functions-that-are-only-needed-for mm/sparse.c
--- a/mm/sparse.c~move-three-functions-that-are-only-needed-for
+++ a/mm/sparse.c
@@ -240,6 +240,27 @@ static struct page __init *sparse_early_
 	return NULL;
 }
 
+/*
+ * Allocate the accumulated non-linear sections, allocate a mem_map
+ * for each and record the physical to section mapping.
+ */
+void __init sparse_init(void)
+{
+	unsigned long pnum;
+	struct page *map;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!valid_section_nr(pnum))
+			continue;
+
+		map = sparse_early_mem_map_alloc(pnum);
+		if (!map)
+			continue;
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
+	}
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
 {
 	struct page *page, *ret;
@@ -280,27 +301,6 @@ static void __kfree_section_memmap(struc
 }
 
 /*
- * Allocate the accumulated non-linear sections, allocate a mem_map
- * for each and record the physical to section mapping.
- */
-void __init sparse_init(void)
-{
-	unsigned long pnum;
-	struct page *map;
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!valid_section_nr(pnum))
-			continue;
-
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
-			continue;
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
-	}
-}
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-/*
  * returns the number of sections whose mem_maps were properly
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
viotape-use-designated-initializers-for-fops-member.patch
git-kbuild.patch
introduce-config_virt_to_bus.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
