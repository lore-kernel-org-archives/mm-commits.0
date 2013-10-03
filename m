From: akpm@linux-foundation.org
Subject: +
 mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch added to -mm tree
Date: Thu, 03 Oct 2013 16:21:50 -0700
Message-ID: <524dfc0e.qt+ZzLAZlS+l3To3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3JCXVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 19:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, y-goto@jp.fujitsu.com, wency@cn.fujitsu.com, toshi.kani@hp.com, tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, apw@shadowen.org, zhangyanfei@cn.fujitsu.com

Subject: + mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,apw@shadowen.org,isimatu.yasuaki@jp.fujitsu.com,tangchen@cn.fujitsu.com,toshi.kani@hp.com,wency@cn.fujitsu.com,y-goto@jp.fujitsu.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 16:21:50 -0700


The patch titled
     Subject: mm/sparsemem: fix a bug in free_map_bootmem when CONFIG_SPARSEMEM_VMEMMAP
has been added to the -mm tree.  Its filename is
     mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/sparsemem: fix a bug in free_map_bootmem when CONFIG_SPARSEMEM_VMEMMAP

We pass the number of pages which hold page structs of a memory section to
function free_map_bootmem.  This is right when !CONFIG_SPARSEMEM_VMEMMAP
but wrong when CONFIG_SPARSEMEM_VMEMMAP.  When CONFIG_SPARSEMEM_VMEMMAP,
we should pass the number of pages of a memory section to
free_map_bootmem.

So the fix is removing the nr_pages parameter.  When
CONFIG_SPARSEMEM_VMEMMAP, we directly use the prefined marco
PAGES_PER_SECTION in free_map_bootmem.  When !CONFIG_SPARSEMEM_VMEMMAP, we
calculate page numbers needed to hold the page structs for a memory
section and use the value in free_map_bootmem.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

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
@@ -648,11 +648,13 @@ static void __kfree_section_memmap(struc
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
 	unsigned long magic;
 	struct page *page = virt_to_page(memmap);
+	unsigned long nr_pages = get_order(sizeof(struct page) *
+					   PAGES_PER_SECTION);
 
 	for (i = 0; i < nr_pages; i++, page++) {
 		magic = (unsigned long) page->lru.next;
@@ -756,7 +758,6 @@ static inline void clear_hwpoisoned_page
 static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 {
 	struct page *usemap_page;
-	unsigned long nr_pages;
 
 	if (!usemap)
 		return;
@@ -777,12 +778,8 @@ static void free_section_usemap(struct p
 	 * on the section which has pgdat at boot time. Just keep it as is now.
 	 */
 
-	if (memmap) {
-		nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
-			>> PAGE_SHIFT;
