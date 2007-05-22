From: akpm@linux-foundation.org
Subject: + move-three-functions-that-are-only-needed-for.patch added to -mm tree
Date: Tue, 22 May 2007 09:53:04 -0700
Message-ID: <200705221653.l4MGr4S8005829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759596AbXEVQ4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 12:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, apw@shadowen.org, y-goto@jp.fujitsu.com


The patch titled
     Move three functions that are only needed for CONFIG_MEMORY_HOTPLUG
has been added to the -mm tree.  Its filename is
     move-three-functions-that-are-only-needed-for.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move three functions that are only needed for CONFIG_MEMORY_HOTPLUG
From: Stephen Rothwell <sfr@canb.auug.org.au>

into the appropriate #ifdef.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
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
move-three-functions-that-are-only-needed-for.patch
