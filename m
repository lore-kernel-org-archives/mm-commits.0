From: akpm@linux-foundation.org
Subject: [merged] mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:26 -0700
Message-ID: <20130430184426.B8D5131C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51208 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab3D3So1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:27 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so84430ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, show_mem: suppress page counts in non-blockable contexts
has been removed from the -mm tree.  Its filename was
     mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, show_mem: suppress page counts in non-blockable contexts

On large systems with a lot of memory, walking all RAM to determine page
types may take a half second or even more.

In non-blockable contexts, the page allocator will emit a page allocation
failure warning unless __GFP_NOWARN is specified.  In such contexts, irqs
are typically disabled and such a lengthy delay may even result in NMI
watchdog timeouts.

To fix this, suppress the page walk in such contexts when printing the
page allocation failure warning.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c       |    3 +++
 arch/ia64/mm/contig.c    |    2 ++
 arch/ia64/mm/discontig.c |    2 ++
 arch/parisc/mm/init.c    |    2 ++
 arch/unicore32/mm/init.c |    3 +++
 include/linux/mm.h       |    3 ++-
 lib/show_mem.c           |    3 +++
 mm/page_alloc.c          |    7 +++++++
 8 files changed, 24 insertions(+), 1 deletion(-)

diff -puN arch/arm/mm/init.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/arch/arm/mm/init.c
@@ -99,6 +99,9 @@ void show_mem(unsigned int filter)
 	printk("Mem-info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
diff -puN arch/ia64/mm/contig.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/arch/ia64/mm/contig.c
@@ -47,6 +47,8 @@ void show_mem(unsigned int filter)
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
 	printk(KERN_INFO "Node memory in pages:\n");
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
 		unsigned long flags;
diff -puN arch/ia64/mm/discontig.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/arch/ia64/mm/discontig.c
@@ -623,6 +623,8 @@ void show_mem(unsigned int filter)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 	printk(KERN_INFO "Node memory in pages:\n");
 	for_each_online_pgdat(pgdat) {
 		unsigned long present;
diff -puN arch/parisc/mm/init.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/arch/parisc/mm/init.c
@@ -697,6 +697,8 @@ void show_mem(unsigned int filter)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas(filter);
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
 #ifndef CONFIG_DISCONTIGMEM
 	i = max_mapnr;
 	while (i-- > 0) {
diff -puN arch/unicore32/mm/init.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/arch/unicore32/mm/init.c
@@ -66,6 +66,9 @@ void show_mem(unsigned int filter)
 	printk(KERN_DEFAULT "Mem-info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_bank(i, mi) {
 		struct membank *bank = &mi->bank[i];
 		unsigned int pfn1, pfn2;
diff -puN include/linux/mm.h~mm-show_mem-suppress-page-counts-in-non-blockable-contexts include/linux/mm.h
--- a/include/linux/mm.h~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/include/linux/mm.h
@@ -899,7 +899,8 @@ extern void pagefault_out_of_memory(void
  * Flags passed to show_mem() and show_free_areas() to suppress output in
  * various contexts.
  */
-#define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
+#define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
+#define SHOW_MEM_FILTER_PAGE_COUNT	(0x0002u)	/* page type count */
 
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
diff -puN lib/show_mem.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts lib/show_mem.c
--- a/lib/show_mem.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/lib/show_mem.c
@@ -18,6 +18,9 @@ void show_mem(unsigned int filter)
 	printk("Mem-Info:\n");
 	show_free_areas(filter);
 
+	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
+		return;
+
 	for_each_online_pgdat(pgdat) {
 		unsigned long i, flags;
 
diff -puN mm/page_alloc.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show_mem-suppress-page-counts-in-non-blockable-contexts
+++ a/mm/page_alloc.c
@@ -2003,6 +2003,13 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 		return;
 
 	/*
+	 * Walking all memory to count page types is very expensive and should
+	 * be inhibited in non-blockable contexts.
+	 */
+	if (!(gfp_mask & __GFP_WAIT))
+		filter |= SHOW_MEM_FILTER_PAGE_COUNT;
+
+	/*
 	 * This documents exceptions given to allocations in certain
 	 * contexts that are allowed to allocate outside current's set
 	 * of allowed nodes.
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drivers-usb-storage-realtek_crc-fix-build.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

