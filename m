From: akpm@linux-foundation.org
Subject: - add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:37 -0700
Message-ID: <200705090243.l492hbA0008495@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970020AbXEICnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Add white list into modpost.c for memory hotplug code and ia64's machvec section
has been removed from the -mm tree.  Its filename was
     add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add white list into modpost.c for memory hotplug code and ia64's machvec section
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This patch is add white list into modpost.c for some functions and
ia64's section to fix section mismatchs.

  sparse_index_alloc() and zone_wait_table_init() calls bootmem allocator
  at boot time, and kmalloc/vmalloc at hotplug time. If config
  memory hotplug is on, there are references of bootmem allocater(init text)
  from them (normal text). This is cause of section mismatch.

  Bootmem is called by many functions and it must be
  used only at boot time. I think __init of them should keep for
  section mismatch check. So, I would like to register sparse_index_alloc()
  and zone_wait_table_init() into white list.

  In addition, ia64's .machvec section is function table of some platform
  dependent code. It is mixture of .init.text and normal text. These
  reference of __init functions are valid too.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c       |    2 +-
 mm/sparse.c           |    2 +-
 scripts/mod/modpost.c |   27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section mm/page_alloc.c
--- a/mm/page_alloc.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section
+++ a/mm/page_alloc.c
@@ -2179,7 +2179,7 @@ void __init setup_per_cpu_pageset(void)
 
 #endif
 
-static __meminit
+static __meminit noinline
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
 {
 	int i;
diff -puN mm/sparse.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section mm/sparse.c
--- a/mm/sparse.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section
+++ a/mm/sparse.c
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(page_to_nid);
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-static struct mem_section *sparse_index_alloc(int nid)
+static struct mem_section noinline *sparse_index_alloc(int nid)
 {
 	struct mem_section *section = NULL;
 	unsigned long array_size = SECTIONS_PER_ROOT *
diff -puN scripts/mod/modpost.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section
+++ a/scripts/mod/modpost.c
@@ -642,6 +642,16 @@ static int strrcmp(const char *s, const 
  *  tosec   = .init.text
  *  fromsec  = .paravirtprobe
  *
+ * Pattern 9:
+ *  Some of functions are common code between boot time and hotplug
+ *  time. The bootmem allocater is called only boot time in its
+ *  functions. So it's ok to reference.
+ *  tosec    = .init.text
+ *
+ * Pattern 10:
+ *  ia64 has machvec table for each platform. It is mixture of function
+ *  pointer of .init.text and .text.
+ *  fromsec  = .machvec
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -668,6 +678,12 @@ static int secref_whitelist(const char *
 		NULL
 	};
 
+	const char *pat4sym[] = {
+		"sparse_index_alloc",
+		"zone_wait_table_init",
+		NULL
+	};
+
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)
 		f1 = 0;
@@ -726,6 +742,17 @@ static int secref_whitelist(const char *
 	    (strcmp(fromsec, ".paravirtprobe") == 0))
 		return 1;
 
+	/* Check for pattern 9 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strcmp(fromsec, ".text") == 0))
+		for (s = pat4sym; *s; s++)
+			if (strcmp(atsym, *s) == 0)
+				return 1;
+
+	/* Check for pattern 10 */
+	if (strcmp(fromsec, ".machvec") == 0)
+		return 1;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
fix-unnecesary-meminit.patch
move-free-pages-between-lists-on-steal.patch
create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch
handle-kernelcore=-generic.patch
