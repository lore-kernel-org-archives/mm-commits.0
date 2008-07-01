From: akpm@linux-foundation.org
Subject: + memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:43:43 -0700
Message-ID: <200807010543.m615hhtq011231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbYGAFof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, apw@shadowen.org, hannes@saeurebad.de, pbadari@us.ibm.com, yhlu.kernel@gmail.com


The patch titled
     memory hotplug: small fixes to bootmem freeing for memory hotremove
has been added to the -mm tree.  Its filename is
     memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: small fixes to bootmem freeing for memory hotremove
From: Yasunori Goto <y-goto@jp.fujitsu.com>

- Change some naming
  * Magic -> types
  * MIX_INFO -> MIX_SECTION_INFO
  * Change definition of bootmem type from direct hex value

- __free_pages_bootmem() becomes __meminit.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    8 ++++----
 mm/memory_hotplug.c            |   12 ++++++------
 mm/page_alloc.c                |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove
+++ a/include/linux/memory_hotplug.h
@@ -13,12 +13,12 @@ struct mem_section;
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /*
- * Magic number for free bootmem.
+ * Types for free bootmem.
  * The normal smallest mapcount is -1. Here is smaller value than it.
  */
-#define SECTION_INFO		0xfffffffe
-#define MIX_INFO		0xfffffffd
-#define NODE_INFO		0xfffffffc
+#define SECTION_INFO		(-1 - 1)
+#define MIX_SECTION_INFO	(-1 - 2)
+#define NODE_INFO		(-1 - 3)
 
 /*
  * pgdat resizing functions
diff -puN mm/memory_hotplug.c~memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove
+++ a/mm/memory_hotplug.c
@@ -62,9 +62,9 @@ static void release_memory_resource(stru
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void get_page_bootmem(unsigned long info,  struct page *page, int magic)
+static void get_page_bootmem(unsigned long info,  struct page *page, int type)
 {
-	atomic_set(&page->_mapcount, magic);
+	atomic_set(&page->_mapcount, type);
 	SetPagePrivate(page);
 	set_page_private(page, info);
 	atomic_inc(&page->_count);
@@ -72,10 +72,10 @@ static void get_page_bootmem(unsigned lo
 
 void put_page_bootmem(struct page *page)
 {
-	int magic;
+	int type;
 
-	magic = atomic_read(&page->_mapcount);
-	BUG_ON(magic >= -1);
+	type = atomic_read(&page->_mapcount);
+	BUG_ON(type >= -1);
 
 	if (atomic_dec_return(&page->_count) == 1) {
 		ClearPagePrivate(page);
@@ -119,7 +119,7 @@ static void register_page_bootmem_info_s
 	mapsize = PAGE_ALIGN(usemap_size()) >> PAGE_SHIFT;
 
 	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_INFO);
+		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 
 }
 
diff -puN mm/page_alloc.c~memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove
+++ a/mm/page_alloc.c
@@ -533,7 +533,7 @@ static void __free_pages_ok(struct page 
 /*
  * permit the bootmem allocator to evade page validation on high-order frees
  */
-void __free_pages_bootmem(struct page *page, unsigned int order)
+void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	if (order == 0) {
 		__ClearPageReserved(page);
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

bootmem-respect-goal-more-likely.patch
bootmem-revisit-alloc_bootmem_section.patch
mm-make-register_page_bootmem_info_section-static.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch

