From: akpm@linux-foundation.org
Subject: [merged]
 mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:36 -0800
Message-ID: <5283e34c.PxsKWZfjqlQ1Y7hW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3KMUih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, y-goto@jp.fujitsu.com, wency@cn.fujitsu.com, toshi.kani@hp.com, tangchen@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, apw@shadowen.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,apw@shadowen.org,isimatu.yasuaki@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,tangchen@cn.fujitsu.com,toshi.kani@hp.com,wency@cn.fujitsu.com,y-goto@jp.fujitsu.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:36 -0800


The patch titled
     Subject: mm/sparsemem: fix a bug in free_map_bootmem when CONFIG_SPARSEMEM_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/sparsemem: fix a bug in free_map_bootmem when CONFIG_SPARSEMEM_VMEMMAP

We pass the number of pages which hold page structs of a memory section to
free_map_bootmem().  This is right when !CONFIG_SPARSEMEM_VMEMMAP but
wrong when CONFIG_SPARSEMEM_VMEMMAP.  When CONFIG_SPARSEMEM_VMEMMAP, we
should pass the number of pages of a memory section to free_map_bootmem.

So the fix is removing the nr_pages parameter.  When
CONFIG_SPARSEMEM_VMEMMAP, we directly use the prefined marco
PAGES_PER_SECTION in free_map_bootmem.  When !CONFIG_SPARSEMEM_VMEMMAP, we
calculate page numbers needed to hold the page structs for a memory
section and use the value in free_map_bootmem().

This was found by reading the code.  And I have no machine that support
memory hot-remove to test the bug now.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/sparse.c~mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap mm/sparse.c
--- a/mm/sparse.c~mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap
+++ a/mm/sparse.c
@@ -603,10 +603,10 @@ static void __kfree_section_memmap(struc
 	vmemmap_free(start, end);
 }
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + nr_pages);
+	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
 	vmemmap_free(start, end);
 }
@@ -648,12 +648,15 @@ static void __kfree_section_memmap(struc
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
-	unsigned long magic;
+	unsigned long magic, nr_pages;
 	struct page *page = virt_to_page(memmap);
 
+	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
+		>> PAGE_SHIFT;
+
 	for (i = 0; i < nr_pages; i++, page++) {
 		magic = (unsigned long) page->lru.next;
 
@@ -756,7 +759,6 @@ static inline void clear_hwpoisoned_page
 static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 {
 	struct page *usemap_page;
-	unsigned long nr_pages;
 
 	if (!usemap)
 		return;
@@ -777,12 +779,8 @@ static void free_section_usemap(struct p
 	 * on the section which has pgdat at boot time. Just keep it as is now.
 	 */
 
-	if (memmap) {
-		nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
-			>> PAGE_SHIFT;
