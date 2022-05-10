Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCC5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbiEJEV2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236238AbiEJEUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E7A2AC0FA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0290B817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A488EC385C8;
        Tue, 10 May 2022 04:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156076;
        bh=hWaxoFBmlgVKpGy9jQ51yOV/WJDIeeg/HUY3ZQHrflg=;
        h=Date:To:From:Subject:From;
        b=VSzBhJ8E4Zqyg3o22QHgbpaB3Tskw4nDr6dt9Rk9YUe7MZiex6cIHR/rCXradbCHO
         6iGJH09KwCCvyvmObp38mwfXW6toPJUzVKne3y/4rk8iDziQ0E5okvwbYG4P6y8XpZ
         n/IPdit+8UUaoBZAtqKFJMoBzjWg8zkBa1/cbFvo=
Date:   Mon, 09 May 2022 21:14:36 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch removed from -mm tree
Message-Id: <20220510041436.A488EC385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: convert RMAP flags to a proper distinct rmap_t type
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: convert RMAP flags to a proper distinct rmap_t type

We want to pass the flags to more than one anon rmap function, getting rid
of special "do_page_add_anon_rmap()".  So let's pass around a distinct
__bitwise type and refine documentation.

Link: https://lkml.kernel.org/r/20220428083441.37290-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   22 ++++++++++++++++++----
 mm/memory.c          |    6 +++---
 mm/rmap.c            |    7 ++++---
 3 files changed, 25 insertions(+), 10 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type
+++ a/include/linux/rmap.h
@@ -160,9 +160,23 @@ static inline void anon_vma_merge(struct
 
 struct anon_vma *page_get_anon_vma(struct page *page);
 
-/* bitflags for do_page_add_anon_rmap() */
-#define RMAP_EXCLUSIVE 0x01
-#define RMAP_COMPOUND 0x02
+/* RMAP flags, currently only relevant for some anon rmap operations. */
+typedef int __bitwise rmap_t;
+
+/*
+ * No special request: if the page is a subpage of a compound page, it is
+ * mapped via a PTE. The mapped (sub)page is possibly shared between processes.
+ */
+#define RMAP_NONE		((__force rmap_t)0)
+
+/* The (sub)page is exclusive to a single process. */
+#define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
+
+/*
+ * The compound page is not mapped via PTEs, but instead via a single PMD and
+ * should be accounted accordingly.
+ */
+#define RMAP_COMPOUND		((__force rmap_t)BIT(1))
 
 /*
  * rmap interfaces called when adding or removing pte of page
@@ -171,7 +185,7 @@ void page_move_anon_rmap(struct page *,
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, bool compound);
 void do_page_add_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long address, int flags);
+		unsigned long address, rmap_t flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, bool compound);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
--- a/mm/memory.c~mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type
+++ a/mm/memory.c
@@ -3511,10 +3511,10 @@ vm_fault_t do_swap_page(struct vm_fault
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL, *swapcache;
 	struct swap_info_struct *si = NULL;
+	rmap_t rmap_flags = RMAP_NONE;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
-	int exclusive = 0;
 	vm_fault_t ret = 0;
 	void *shadow = NULL;
 
@@ -3689,7 +3689,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		vmf->flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
-		exclusive = RMAP_EXCLUSIVE;
+		rmap_flags |= RMAP_EXCLUSIVE;
 	}
 	flush_icache_page(vma, page);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
@@ -3705,7 +3705,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
-		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
+		do_page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
 	}
 
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
--- a/mm/rmap.c~mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type
+++ a/mm/rmap.c
@@ -1181,7 +1181,8 @@ static void __page_check_anon_rmap(struc
 void page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address, bool compound)
 {
-	do_page_add_anon_rmap(page, vma, address, compound ? RMAP_COMPOUND : 0);
+	do_page_add_anon_rmap(page, vma, address,
+			      compound ? RMAP_COMPOUND : RMAP_NONE);
 }
 
 /*
@@ -1190,7 +1191,7 @@ void page_add_anon_rmap(struct page *pag
  * Everybody else should continue to use page_add_anon_rmap above.
  */
 void do_page_add_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address, int flags)
+	struct vm_area_struct *vma, unsigned long address, rmap_t flags)
 {
 	bool compound = flags & RMAP_COMPOUND;
 	bool first;
@@ -1229,7 +1230,7 @@ void do_page_add_anon_rmap(struct page *
 	/* address might be in next vma when migration races vma_adjust */
 	else if (first)
 		__page_set_anon_rmap(page, vma, address,
-				flags & RMAP_EXCLUSIVE);
+				     !!(flags & RMAP_EXCLUSIVE));
 	else
 		__page_check_anon_rmap(page, vma, address);
 
_

Patches currently in -mm which might be from david@redhat.com are


