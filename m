Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6C3C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiLLCPZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiLLCOd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0CFDF0B
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14B9360E77
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9DEC433F1;
        Mon, 12 Dec 2022 02:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811254;
        bh=U6VmudzSxLuGS15352X9b/ssjlVSA5QEmHE8WTOestQ=;
        h=Date:To:From:Subject:From;
        b=h61CxQF/5UWM+Lz4yph9NOKhmT230PeWFA100jVDWje0TBrEZaYYMI3nZZg6Y4MC7
         MNjLUStdCAP0rROCV3u+Q7RX4i78jkkI9JwVGF8XQgb4jBvRLFLy0eShwMHrcNwdWQ
         m2Yn6/aylmcNOINqqf31TikzIsu41hQ0/ERc7+o0=
Date:   Sun, 11 Dec 2022 18:14:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linux@rasmusvillemoes.dk,
        linmiaohe@huawei.com, jhubbard@nvidia.com,
        harperchen1110@gmail.com, david@redhat.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio-dtor-and-order-setter-functions.patch removed from -mm tree
Message-Id: <20221212021414.6F9DEC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio dtor and order setter functions
has been removed from the -mm tree.  Its filename was
     mm-add-folio-dtor-and-order-setter-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: add folio dtor and order setter functions
Date: Tue, 29 Nov 2022 14:50:30 -0800

Patch series "convert core hugetlb functions to folios", v5.

============== OVERVIEW ===========================
Now that many hugetlb helper functions that deal with hugetlb specific
flags[1] and hugetlb cgroups[2] are converted to folios, higher level
allocation, prep, and freeing functions within hugetlb can also be
converted to operate in folios.

Patch 1 of this series implements the wrapper functions around setting the
compound destructor and compound order for a folio.  Besides the user
added in patch 1, patch 2 and patch 9 also use these helper functions.

Patches 2-10 convert the higher level hugetlb functions to folios.

============== TESTING ===========================
LTP:
	Ran 10 back to back rounds of the LTP hugetlb test suite.

Gigantic Huge Pages:
	Test allocation and freeing via hugeadm commands:
		hugeadm --pool-pages-min 1GB:10
		hugeadm --pool-pages-min 1GB:0

Demote:
	Demote 1 1GB hugepages to 512 2MB hugepages
		echo 1 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
		echo 1 > /sys/kernel/mm/hugepages/hugepages-1048576kB/demote
		cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
			# 512
		cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
			# 0

[1] https://lore.kernel.org/lkml/20220922154207.1575343-1-sidhartha.kumar@oracle.com/
[2] https://lore.kernel.org/linux-mm/20221101223059.460937-1-sidhartha.kumar@oracle.com/


This patch (of 10):

Add folio equivalents for set_compound_order() and
set_compound_page_dtor().

Also remove extra new-lines introduced by mm/hugetlb: convert
move_hugetlb_state() to folios and mm/hugetlb_cgroup: convert
hugetlb_cgroup_uncharge_page() to folios.

[sidhartha.kumar@oracle.com: clarify folio_set_compound_order() zero support]
  Link: https://lkml.kernel.org/r/20221207223731.32784-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20221129225039.82257-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20221129225039.82257-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   23 +++++++++++++++++++++++
 mm/hugetlb.c       |    4 +---
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-add-folio-dtor-and-order-setter-functions
+++ a/include/linux/mm.h
@@ -997,6 +997,13 @@ static inline void set_compound_page_dto
 	page[1].compound_dtor = compound_dtor;
 }
 
+static inline void folio_set_compound_dtor(struct folio *folio,
+		enum compound_dtor_id compound_dtor)
+{
+	VM_BUG_ON_FOLIO(compound_dtor >= NR_COMPOUND_DTORS, folio);
+	folio->_folio_dtor = compound_dtor;
+}
+
 void destroy_large_folio(struct folio *folio);
 
 static inline int head_compound_pincount(struct page *head)
@@ -1012,6 +1019,22 @@ static inline void set_compound_order(st
 #endif
 }
 
+/*
+ * folio_set_compound_order is generally passed a non-zero order to
+ * initialize a large folio.  However, hugetlb code abuses this by
+ * passing in zero when 'dissolving' a large folio.
+ */
+static inline void folio_set_compound_order(struct folio *folio,
+		unsigned int order)
+{
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+
+	folio->_folio_order = order;
+#ifdef CONFIG_64BIT
+	folio->_folio_nr_pages = order ? 1U << order : 0;
+#endif
+}
+
 /* Returns the number of pages in this potentially compound page. */
 static inline unsigned long compound_nr(struct page *page)
 {
--- a/mm/hugetlb.c~mm-add-folio-dtor-and-order-setter-functions
+++ a/mm/hugetlb.c
@@ -1780,7 +1780,7 @@ static void __prep_new_hugetlb_folio(str
 {
 	hugetlb_vmemmap_optimize(h, &folio->page);
 	INIT_LIST_HEAD(&folio->lru);
-	folio->_folio_dtor = HUGETLB_PAGE_DTOR;
+	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
 	hugetlb_set_folio_subpool(folio, NULL);
 	set_hugetlb_cgroup(folio, NULL);
 	set_hugetlb_cgroup_rsvd(folio, NULL);
@@ -2938,7 +2938,6 @@ struct page *alloc_huge_page(struct vm_a
 	 * a reservation exists for the allocation.
 	 */
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
-
 	if (!page) {
 		spin_unlock_irq(&hugetlb_lock);
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
@@ -7343,7 +7342,6 @@ void move_hugetlb_state(struct folio *ol
 		int old_nid = folio_nid(old_folio);
 		int new_nid = folio_nid(new_folio);
 
-
 		folio_set_hugetlb_temporary(old_folio);
 		folio_clear_hugetlb_temporary(new_folio);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


