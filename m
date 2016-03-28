From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch added to -mm tree
Date: Mon, 28 Mar 2016 16:08:22 -0700
Message-ID: <56f9b966.vKzED19xMvKRSSwh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcC1XIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 19:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: is_mem_section_removable() can return bool
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/memory_hotplug: is_mem_section_removable() can return bool

Make is_mem_section_removable() return bool to improve readability due to
this particular function only using either one or zero as its return
value.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    6 +++---
 mm/memory_hotplug.c            |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-is_mem_section_removable-can-be-boolean include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-is_mem_section_removable-can-be-boolean
+++ a/include/linux/memory_hotplug.h
@@ -247,16 +247,16 @@ static inline void mem_hotplug_done(void
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
-extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+extern bool is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
 extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern void remove_memory(int nid, u64 start, u64 size);
 
 #else
-static inline int is_mem_section_removable(unsigned long pfn,
+static inline bool is_mem_section_removable(unsigned long pfn,
 					unsigned long nr_pages)
 {
-	return 0;
+	return false;
 }
 
 static inline void try_offline_node(int nid) {}
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-is_mem_section_removable-can-be-boolean mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-is_mem_section_removable-can-be-boolean
+++ a/mm/memory_hotplug.c
@@ -1410,7 +1410,7 @@ static struct page *next_active_pagebloc
 }
 
 /* Checks if this range of memory is likely to be hot-removable. */
-int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
+bool is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 {
 	struct page *page = pfn_to_page(start_pfn);
 	struct page *end_page = page + nr_pages;
@@ -1418,12 +1418,12 @@ int is_mem_section_removable(unsigned lo
 	/* Check the starting page of each pageblock within the range */
 	for (; page < end_page; page = next_active_pageblock(page)) {
 		if (!is_pageblock_removable_nolock(page))
-			return 0;
+			return false;
 		cond_resched();
 	}
 
 	/* All pageblocks in the memory block are likely to be hot-removable */
-	return 1;
+	return true;
 }
 
 /*
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-hugetlb-is_vm_hugetlb_page-can-be-boolean.patch
mm-memory_hotplug-is_mem_section_removable-can-be-boolean.patch
mm-vmalloc-is_vmalloc_addr-can-be-boolean.patch
mm-mempolicy-vma_migratable-can-be-boolean.patch

