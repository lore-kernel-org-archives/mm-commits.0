From: akpm@linux-foundation.org
Subject: - hotplug-memory-make-online_page-common.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:31 -0700
Message-ID: <200804282150.m3SLoVAf017482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934434AbYD1VvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, clameter@sgi.com, dave@linux.vnet.ibm.com, jeremy.fitzhardinge@citrix.com, kamez.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     hotplug-memory: make online_page() common
has been removed from the -mm tree.  Its filename was
     hotplug-memory-make-online_page-common.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hotplug-memory: make online_page() common
From: Jeremy Fitzhardinge <jeremy@goop.org>

All architectures use an effectively identical definition of online_page(), so
just make it common code.  x86-64, ia64, powerpc and sh are actually
identical; x86-32 is slightly different.

x86-32's differences arise because it puts its hotplug pages in the highmem
zone.  We can handle this in the generic code by inspecting the page to see if
its in highmem, and update the totalhigh_pages count appropriately.  This
leaves init_32.c:free_new_highpage with a single caller, so I folded it into
add_one_highpage_init.

I also removed an incorrect comment referring to the NUMA case; any NUMA
details have already been dealt with by the time online_page() is called.

[akpm@linux-foundation.org: fix indenting]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamez.hiroyu@jp.fujitsu.com>
Tested-by: KAMEZAWA Hiroyuki <kamez.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c   |    9 ---------
 arch/powerpc/mm/mem.c |    9 ---------
 arch/sh/mm/init.c     |    9 ---------
 arch/x86/mm/init_32.c |   36 +++---------------------------------
 arch/x86/mm/init_64.c |    9 ---------
 mm/memory_hotplug.c   |   19 +++++++++++++++++++
 6 files changed, 22 insertions(+), 69 deletions(-)

diff -puN arch/ia64/mm/init.c~hotplug-memory-make-online_page-common arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~hotplug-memory-make-online_page-common
+++ a/arch/ia64/mm/init.c
@@ -682,15 +682,6 @@ mem_init (void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
 int arch_add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat;
diff -puN arch/powerpc/mm/mem.c~hotplug-memory-make-online_page-common arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~hotplug-memory-make-online_page-common
+++ a/arch/powerpc/mm/mem.c
@@ -110,15 +110,6 @@ EXPORT_SYMBOL(phys_mem_access_prot);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
 #ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 start)
 {
diff -puN arch/sh/mm/init.c~hotplug-memory-make-online_page-common arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~hotplug-memory-make-online_page-common
+++ a/arch/sh/mm/init.c
@@ -307,15 +307,6 @@ void free_initrd_mem(unsigned long start
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
 int arch_add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat;
diff -puN arch/x86/mm/init_32.c~hotplug-memory-make-online_page-common arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~hotplug-memory-make-online_page-common
+++ a/arch/x86/mm/init_32.c
@@ -287,47 +287,17 @@ static void __init permanent_kmaps_init(
 	pkmap_page_table = pte;
 }
 
-static void __meminit free_new_highpage(struct page *page)
-{
-	init_page_count(page);
-	__free_page(page);
-	totalhigh_pages++;
-}
-
 void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 {
 	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn))) {
 		ClearPageReserved(page);
-		free_new_highpage(page);
+		init_page_count(page);
+		__free_page(page);
+		totalhigh_pages++;
 	} else
 		SetPageReserved(page);
 }
 
-static int __meminit
-add_one_highpage_hotplug(struct page *page, unsigned long pfn)
-{
-	free_new_highpage(page);
-	totalram_pages++;
-#ifdef CONFIG_FLATMEM
-	max_mapnr = max(pfn, max_mapnr);
-#endif
-	num_physpages++;
-
-	return 0;
-}
-
-/*
- * Not currently handling the NUMA case.
- * Assuming single node and all memory that
- * has been added dynamically that would be
- * onlined here is in HIGHMEM.
- */
-void __meminit online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	add_one_highpage_hotplug(page, page_to_pfn(page));
-}
-
 #ifndef CONFIG_NUMA
 static void __init set_highmem_pages_init(int bad_ppro)
 {
diff -puN arch/x86/mm/init_64.c~hotplug-memory-make-online_page-common arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~hotplug-memory-make-online_page-common
+++ a/arch/x86/mm/init_64.c
@@ -620,15 +620,6 @@ void __init paging_init(void)
 /*
  * Memory hotplug specific functions
  */
-void online_page(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalram_pages++;
-	num_physpages++;
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * Memory is added always to NORMAL zone. This means you will never get
diff -puN mm/memory_hotplug.c~hotplug-memory-make-online_page-common mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~hotplug-memory-make-online_page-common
+++ a/mm/memory_hotplug.c
@@ -219,6 +219,25 @@ static void grow_pgdat_span(struct pglis
 					pgdat->node_start_pfn;
 }
 
+void online_page(struct page *page)
+{
+	totalram_pages++;
+	num_physpages++;
+
+#ifdef CONFIG_HIGHMEM
+	if (PageHighMem(page))
+		totalhigh_pages++;
+#endif
+
+#ifdef CONFIG_FLATMEM
+	max_mapnr = max(page_to_pfn(page), max_mapnr);
+#endif
+
+	ClearPageReserved(page);
+	init_page_count(page);
+	__free_page(page);
+}
+
 static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 			void *arg)
 {
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
xen-make-blkif_getgeo-static.patch

