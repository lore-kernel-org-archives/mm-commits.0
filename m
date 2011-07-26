From: akpm@linux-foundation.org
Subject: [merged] hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:00 -0700
Message-ID: <201107260751.p6Q7p3n4002913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab1GZHvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: beckyb@kernel.crashing.org, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     hugetlb: add phys addr to struct huge_bootmem_page
has been removed from the -mm tree.  Its filename was
     hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: add phys addr to struct huge_bootmem_page
From: Becky Bruce <beckyb@kernel.crashing.org>

This is needed on HIGHMEM systems - we don't always have a virtual
address so store the physical address and map it in as needed.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |   10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlb-add-phys-addr-to-struct-huge_bootmem_page include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-phys-addr-to-struct-huge_bootmem_page
+++ a/include/linux/hugetlb.h
@@ -231,6 +231,9 @@ struct hstate {
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
+#ifdef CONFIG_HIGHMEM
+	phys_addr_t phys;
+#endif
 };
 
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
diff -puN mm/hugetlb.c~hugetlb-add-phys-addr-to-struct-huge_bootmem_page mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-phys-addr-to-struct-huge_bootmem_page
+++ a/mm/hugetlb.c
@@ -1105,8 +1105,16 @@ static void __init gather_bootmem_preall
 	struct huge_bootmem_page *m;
 
 	list_for_each_entry(m, &huge_boot_pages, list) {
-		struct page *page = virt_to_page(m);
 		struct hstate *h = m->hstate;
+		struct page *page;
+
+#ifdef CONFIG_HIGHMEM
+		page = pfn_to_page(m->phys >> PAGE_SHIFT);
+		free_bootmem_late((unsigned long)m,
+				  sizeof(struct huge_bootmem_page));
+#else
+		page = virt_to_page(m);
+#endif
 		__ClearPageReserved(page);
 		WARN_ON(page_count(page) != 1);
 		prep_compound_huge_page(page, h->order);
_

Patches currently in -mm which might be from beckyb@kernel.crashing.org are

origin.patch
linux-next.patch

