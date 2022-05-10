Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E21C43217
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbiEJEUx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiEJEUA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DBD2AC6D2
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61831B817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1635CC385C5;
        Tue, 10 May 2022 04:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156088;
        bh=hbIiOAooz0FfrAHV0CGMjJYfnzrKhFIep0Li3PuO80A=;
        h=Date:To:From:Subject:From;
        b=aSEIVTLeX1HYlVeqMwgRc50Xz/UaJzVvfsi0L5wxGSOwMX+N4Es46Xl/jT30qST5a
         rrosH5KykptVhVQnHFEdS4oJXdBHjIJi8xAUyLTRMLx58JObwRYqjE2c4AR2qeCpi8
         NGQl7KEd4669H8hOn0HNwt1BnYr0BxSVD2qAeJjY=
Date:   Mon, 09 May 2022 21:14:47 -0700
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
Subject: [merged mm-stable] mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails.patch removed from -mm tree
Message-Id: <20220510041448.1635CC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: fail try_to_migrate() early when setting a PMD migration entry fails
has been removed from the -mm tree.  Its filename was
     mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: fail try_to_migrate() early when setting a PMD migration entry fails

Let's fail right away in case we cannot clear PG_anon_exclusive because
the anon THP may be pinned.  Right now, we continue trying to install
migration entries and the caller of try_to_migrate() will realize that the
page is still mapped and has to restore the migration entries.  Let's just
fail fast just like for PTE migration entries.

Link: https://lkml.kernel.org/r/20220428083441.37290-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
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

 include/linux/swapops.h |    4 ++--
 mm/huge_memory.c        |    8 +++++---
 mm/rmap.c               |    6 +++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/swapops.h~mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails
+++ a/include/linux/swapops.h
@@ -299,7 +299,7 @@ static inline bool is_pfn_swap_entry(swp
 struct page_vma_mapped_walk;
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-extern void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page);
 
 extern void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
@@ -332,7 +332,7 @@ static inline int is_pmd_migration_entry
 	return !pmd_present(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
 }
 #else
-static inline void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
 	BUILD_BUG();
--- a/mm/huge_memory.c~mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails
+++ a/mm/huge_memory.c
@@ -3071,7 +3071,7 @@ late_initcall(split_huge_pages_debugfs);
 #endif
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
 	struct vm_area_struct *vma = pvmw->vma;
@@ -3083,7 +3083,7 @@ void set_pmd_migration_entry(struct page
 	pmd_t pmdswp;
 
 	if (!(pvmw->pmd && !pvmw->pte))
-		return;
+		return 0;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
 	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
@@ -3091,7 +3091,7 @@ void set_pmd_migration_entry(struct page
 	anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 	if (anon_exclusive && page_try_share_anon_rmap(page)) {
 		set_pmd_at(mm, address, pvmw->pmd, pmdval);
-		return;
+		return -EBUSY;
 	}
 
 	if (pmd_dirty(pmdval))
@@ -3109,6 +3109,8 @@ void set_pmd_migration_entry(struct page
 	page_remove_rmap(page, vma, true);
 	put_page(page);
 	trace_set_migration_pmd(address, pmd_val(pmdswp));
+
+	return 0;
 }
 
 void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
--- a/mm/rmap.c~mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails
+++ a/mm/rmap.c
@@ -1856,7 +1856,11 @@ static bool try_to_migrate_one(struct fo
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
 
-			set_pmd_migration_entry(&pvmw, subpage);
+			if (set_pmd_migration_entry(&pvmw, subpage)) {
+				ret = false;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
 			continue;
 		}
 #endif
_

Patches currently in -mm which might be from david@redhat.com are


