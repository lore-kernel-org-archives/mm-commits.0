From: akpm@linux-foundation.org
Subject: - bootmem-revisit-alloc_bootmem_section.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:13 -0700
Message-ID: <200807242324.m6ONOD8D010764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYGXXYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     bootmem: revisit alloc_bootmem_section
has been removed from the -mm tree.  Its filename was
     bootmem-revisit-alloc_bootmem_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: revisit alloc_bootmem_section
From: Johannes Weiner <hannes@saeurebad.de>

Since alloc_bootmem_core does no goal-fallback anymore and just returns
NULL if the allocation fails, we might now use it in alloc_bootmem_section
without all the fixup code for a misplaced allocation.

Also, the limit can be the first PFN of the next section as the semantics
is that the limit is _above_ the allocated region, not within.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff -puN mm/bootmem.c~bootmem-revisit-alloc_bootmem_section mm/bootmem.c
--- a/mm/bootmem.c~bootmem-revisit-alloc_bootmem_section
+++ a/mm/bootmem.c
@@ -632,30 +632,15 @@ void * __init __alloc_bootmem_node(pg_da
 void * __init alloc_bootmem_section(unsigned long size,
 				    unsigned long section_nr)
 {
-	void *ptr;
-	unsigned long limit, goal, start_nr, end_nr, pfn;
-	struct pglist_data *pgdat;
+	bootmem_data_t *bdata;
+	unsigned long pfn, goal, limit;
 
 	pfn = section_nr_to_pfn(section_nr);
-	goal = PFN_PHYS(pfn);
-	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
-	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
-	ptr = alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
-				limit);
-
-	if (!ptr)
-		return NULL;
-
-	start_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr)));
-	end_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr) + size));
-	if (start_nr != section_nr || end_nr != section_nr) {
-		printk(KERN_WARNING "alloc_bootmem failed on section %ld.\n",
-		       section_nr);
-		free_bootmem_node(pgdat, __pa(ptr), size);
-		ptr = NULL;
-	}
+	goal = pfn << PAGE_SHIFT;
+	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
-	return ptr;
+	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
 }
 #endif
 
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

