Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC798C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbiEJEUt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiEJEUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675312AC0FD
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 057D06175C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599B7C385A6;
        Tue, 10 May 2022 04:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156079;
        bh=lD/I1l/Gc8H4IiM8mLAli1t8tCoDD6jKVSAD+ao1c38=;
        h=Date:To:From:Subject:From;
        b=BGpBba1MhajDNl2ZpfdJ75vsdiNCWSbM5ib00WkLZH4gzfh0FuT0sqeS7DjEI/8jR
         F+89gFvPDcSgwywRdvP/j5rSTi/p0DRtHSilWOPed+7qH8Nkj+4BH9eJs9LQw+Bma8
         SbPRJONowWmZgq/bVHRjY5lcYJ+PRglmIvCCEsQ0=
Date:   Mon, 09 May 2022 21:14:38 -0700
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
Subject: [merged mm-stable] mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch removed from -mm tree
Message-Id: <20220510041439.599B7C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: pass rmap flags to hugepage_add_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: pass rmap flags to hugepage_add_anon_rmap()

Let's prepare for passing RMAP_EXCLUSIVE, similarly as we do for
page_add_anon_rmap() now.  RMAP_COMPOUND is implicit for hugetlb pages and
ignored.

Link: https://lkml.kernel.org/r/20220428083441.37290-8-david@redhat.com
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

 include/linux/rmap.h |    2 +-
 mm/migrate.c         |    3 ++-
 mm/rmap.c            |    9 ++++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap
+++ a/include/linux/rmap.h
@@ -191,7 +191,7 @@ void page_add_file_rmap(struct page *, s
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long address);
+		unsigned long address, rmap_t flags);
 void hugepage_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address);
 
--- a/mm/migrate.c~mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap
+++ a/mm/migrate.c
@@ -232,7 +232,8 @@ static bool remove_migration_pte(struct
 			pte = pte_mkhuge(pte);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
-				hugepage_add_anon_rmap(new, vma, pvmw.address);
+				hugepage_add_anon_rmap(new, vma, pvmw.address,
+						       RMAP_NONE);
 			else
 				page_dup_file_rmap(new, true);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
--- a/mm/rmap.c~mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap
+++ a/mm/rmap.c
@@ -2391,9 +2391,11 @@ void rmap_walk_locked(struct folio *foli
  * The following two functions are for anonymous (private mapped) hugepages.
  * Unlike common anonymous pages, anonymous hugepages have no accounting code
  * and no lru code, because we handle hugepages differently from common pages.
+ *
+ * RMAP_COMPOUND is ignored.
  */
-void hugepage_add_anon_rmap(struct page *page,
-			    struct vm_area_struct *vma, unsigned long address)
+void hugepage_add_anon_rmap(struct page *page, struct vm_area_struct *vma,
+			    unsigned long address, rmap_t flags)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	int first;
@@ -2403,7 +2405,8 @@ void hugepage_add_anon_rmap(struct page
 	/* address might be in next vma when migration races vma_adjust */
 	first = atomic_inc_and_test(compound_mapcount_ptr(page));
 	if (first)
-		__page_set_anon_rmap(page, vma, address, 0);
+		__page_set_anon_rmap(page, vma, address,
+				     !!(flags & RMAP_EXCLUSIVE));
 }
 
 void hugepage_add_new_anon_rmap(struct page *page,
_

Patches currently in -mm which might be from david@redhat.com are


