From: akpm@linux-foundation.org
Subject: + add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:52:52 -0700
Message-ID: <200704070052.l370qq6q024182@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793AbXDGAxA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, sam@ravnborg.org


The patch titled
     Add white list into modpost.c for memory hotplug code and ia64's machvec section
has been added to the -mm tree.  Its filename is
     add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 scripts/mod/modpost.c |   28 ++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section mm/page_alloc.c
--- a/mm/page_alloc.c~add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section
+++ a/mm/page_alloc.c
@@ -2559,7 +2559,7 @@ void __init setup_per_cpu_pageset(void)
 
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
@@ -649,6 +649,17 @@ static int strrcmp(const char *s, const 
  *  The pattern is:
  *  tosec   = .init.text
  *  fromsec  = .paravirtprobe
+ *
+ * Pattern 10:
+ *  Some of functions are common code between boot time and hotplug
+ *  time. The bootmem allocater is called only boot time in its
+ *  functions. So it's ok to reference.
+ *  tosec    = .init.text
+ *
+ * Pattern 11:
+ *  ia64 has machvec table for each platform. It is mixture of function
+ *  pointer of .init.text and .text.
+ *  fromsec  = .machvec
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -675,6 +686,12 @@ static int secref_whitelist(const char *
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
@@ -738,6 +755,17 @@ static int secref_whitelist(const char *
 	    (strcmp(fromsec, ".paravirtprobe") == 0))
 		return 1;
 
+	/* Check for pattern 10 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strcmp(fromsec, ".text") == 0))
+		for (s = pat4sym; *s; s++)
+			if (strcmp(atsym, *s) == 0)
+				return 1;
+
+	/* Check for pattern 11 */
+	if (strcmp(fromsec, ".machvec") == 0)
+		return 1;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

move-free-pages-between-lists-on-steal-fix-2.patch
fix-section-mismatch-of-memory-hotplug-related-code.patch
add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
