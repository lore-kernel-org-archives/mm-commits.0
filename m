From: akpm@linux-foundation.org
Subject: + mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch added to -mm tree
Date: Thu, 28 Feb 2013 15:10:25 -0800
Message-ID: <20130228231025.9F11A5A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63798 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3B1XK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 18:10:27 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so44888vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 15:10:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com, mgorman@suse.de, mhocko@suse.cz


The patch titled
     Subject: mm, show_mem: suppress page counts in non-blockable contexts
has been added to the -mm tree.  Its filename is
     mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, show_mem: suppress page counts in non-blockable contexts

On large systems with a lot of memory, walking all RAM to determine page
types may take a half second or even more.

In non-blockable contexts, the page allocator will emit a page allocation
failure warning unless __GFP_NOWARN is specified.  In such contexts, irqs
are typically disabled and such a lengthy delay may result in soft
lockups.

To fix this, suppress the page walk in such contexts when printing the
page allocation failure warning.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
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
@@ -900,7 +900,8 @@ extern void pagefault_out_of_memory(void
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
@@ -2009,6 +2009,13 @@ void warn_alloc_failed(gfp_t gfp_mask, i
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
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

