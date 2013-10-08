From: akpm@linux-foundation.org
Subject: +
 mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch added to -mm tree
Date: Mon, 07 Oct 2013 17:20:06 -0700
Message-ID: <52534fb6.k/3+IYtnZ7iho+8u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3JHAUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 20:20:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, y-goto@jp.fujitsu.com, wency@cn.fujitsu.com, toshi.kani@hp.com, tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, apw@shadowen.org, zhangyanfei@cn.fujitsu.com

Subject: + mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,apw@shadowen.org,isimatu.yasuaki@jp.fujitsu.com,tangchen@cn.fujitsu.com,toshi.kani@hp.com,wency@cn.fujitsu.com,y-goto@jp.fujitsu.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 17:20:06 -0700


The patch titled
     Subject: mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2
has been added to the -mm tree.  Its filename is
     mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch

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
Subject: mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2

v2: Fix a bug introduced in v1 patch. Thanks wanpeng!

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

 mm/sparse.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/sparse.c~mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2 mm/sparse.c
--- a/mm/sparse.c~mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2
+++ a/mm/sparse.c
@@ -651,10 +651,11 @@ static void __kfree_section_memmap(struc
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
-	unsigned long magic;
+	unsigned long magic, nr_pages;
 	struct page *page = virt_to_page(memmap);
-	unsigned long nr_pages = get_order(sizeof(struct page) *
-					   PAGES_PER_SECTION);
+
+	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
+		>> PAGE_SHIFT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
 		magic = (unsigned long) page->lru.next;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
mm-sparsemem-use-pages_per_section-to-remove-redundant-nr_pages-parameter.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap.patch
mm-sparsemem-fix-a-bug-in-free_map_bootmem-when-config_sparsemem_vmemmap-v2.patch
mm-page_allocc-remove-unused-marco-long_align.patch

