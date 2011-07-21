From: akpm@linux-foundation.org
Subject: + hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch added to -mm tree
Date: Thu, 21 Jul 2011 15:44:45 -0700
Message-ID: <201107212244.p6LMijGD013772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709Ab1GUWor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 18:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: beckyb@kernel.crashing.org, benh@kernel.crashing.org


The patch titled
     hugetlb: add phys addr to struct huge_bootmem_page
has been added to the -mm tree.  Its filename is
     hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: add phys addr to struct huge_bootmem_page
From: Becky Bruce <beckyb@kernel.crashing.org>

This is needed on HIGHMEM systems - we don't always have a virtual
address so store the physical address and map it in as needed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

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
@@ -1105,8 +1105,14 @@ static void __init gather_bootmem_preall
 	struct huge_bootmem_page *m;
 
 	list_for_each_entry(m, &huge_boot_pages, list) {
-		struct page *page = virt_to_page(m);
 		struct hstate *h = m->hstate;
+#ifdef CONFIG_HIGHMEM
+		struct page *page = pfn_to_page(m->phys >> PAGE_SHIFT);
+		free_bootmem_late((unsigned long)m,
+				  sizeof(struct huge_bootmem_page));
+#else
+		struct page *page = virt_to_page(m);
+#endif
 		__ClearPageReserved(page);
 		WARN_ON(page_count(page) != 1);
 		prep_compound_huge_page(page, h->order);
_

Patches currently in -mm which might be from beckyb@kernel.crashing.org are

fs-hugetlbfs-inodec-fix-pgoff-alignment-checking-on-32-bit.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix.patch
linux-next.patch

