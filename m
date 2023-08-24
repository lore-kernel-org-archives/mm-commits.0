Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397D3C6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbjHXXVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbjHXXVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2B2A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4324F64452
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C0CC433C8;
        Thu, 24 Aug 2023 23:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919258;
        bh=L90Lsp/HTTbbk3AxGazdLn1djvB0S8DSqgDd9E2o8Sw=;
        h=Date:To:From:Subject:From;
        b=OpiTYNr9aDLJ16Yyv5kvDTLZdFxHCTL7oeTn+ZzeTz0zkhBGMl9pqCF8oWZhgPcSF
         Np3FEkoyLDuU3mHwO7yas5t7YohRqMACLGJ/TKTIxdx8K/PFPtjPgWTqZbn3kfU7q5
         rLldCOgsEIfvd4dxTmtTWuOyvH/JsB19lUM8x/0k=
Date:   Thu, 24 Aug 2023 16:20:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        jannh@google.com, david@redhat.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-collapse_pte_mapped_thp-versus-uffd.patch removed from -mm tree
Message-Id: <20230824232058.94C0CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: fix collapse_pte_mapped_thp() versus uffd
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-collapse_pte_mapped_thp-versus-uffd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/khugepaged: fix collapse_pte_mapped_thp() versus uffd
Date: Mon, 21 Aug 2023 12:51:20 -0700 (PDT)

Jann Horn demonstrated how userfaultfd ioctl UFFDIO_COPY into a private
shmem mapping can add valid PTEs to page table collapse_pte_mapped_thp()
thought it had emptied: page lock on the huge page is enough to protect
against WP faults (which find the PTE has been cleared), but not enough to
protect against userfaultfd.  "BUG: Bad rss-counter state" followed.

retract_page_tables() protects against this by checking !vma->anon_vma;
but we know that MADV_COLLAPSE needs to be able to work on private shmem
mappings, even those with an anon_vma prepared for another part of the
mapping; and we know that MADV_COLLAPSE needs to work on shared shmem
mappings which are userfaultfd_armed().  Whether it needs to work on
private shmem mappings which are userfaultfd_armed(), I'm not so sure: but
assume that it does.

Just for this case, take the pmd_lock() two steps earlier: not because it
gives any protection against this case itself, but because ptlock nests
inside it, and it's the dropping of ptlock which let the bug in.  In other
cases, continue to minimize the pmd_lock() hold time.

Link: https://lkml.kernel.org/r/4d31abf5-56c0-9f3d-d12f-c9317936691@google.com
Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/linux-mm/CAG48ez0FxiRC4d3VTu_a9h=rg5FW-kYD5Rg5xo_RDBM0LTTqZQ@mail.gmail.com/
Acked-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-collapse_pte_mapped_thp-versus-uffd
+++ a/mm/khugepaged.c
@@ -1476,7 +1476,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	struct page *hpage;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
-	spinlock_t *pml, *ptl;
+	spinlock_t *pml = NULL, *ptl;
 	int nr_ptes = 0, result = SCAN_FAIL;
 	int i;
 
@@ -1572,9 +1572,25 @@ int collapse_pte_mapped_thp(struct mm_st
 				haddr, haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	notified = true;
-	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
+
+	/*
+	 * pmd_lock covers a wider range than ptl, and (if split from mm's
+	 * page_table_lock) ptl nests inside pml. The less time we hold pml,
+	 * the better; but userfaultfd's mfill_atomic_pte() on a private VMA
+	 * inserts a valid as-if-COWed PTE without even looking up page cache.
+	 * So page lock of hpage does not protect from it, so we must not drop
+	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
+	 */
+	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
+		pml = pmd_lock(mm, pmd);
+
+	start_pte = pte_offset_map_nolock(mm, pmd, haddr, &ptl);
 	if (!start_pte)		/* mmap_lock + page lock should prevent this */
 		goto abort;
+	if (!pml)
+		spin_lock(ptl);
+	else if (ptl != pml)
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
 	/* step 2: clear page table and adjust rmap */
 	for (i = 0, addr = haddr, pte = start_pte;
@@ -1608,7 +1624,9 @@ int collapse_pte_mapped_thp(struct mm_st
 		nr_ptes++;
 	}
 
-	pte_unmap_unlock(start_pte, ptl);
+	pte_unmap(start_pte);
+	if (!pml)
+		spin_unlock(ptl);
 
 	/* step 3: set proper refcount and mm_counters. */
 	if (nr_ptes) {
@@ -1616,12 +1634,12 @@ int collapse_pte_mapped_thp(struct mm_st
 		add_mm_counter(mm, mm_counter_file(hpage), -nr_ptes);
 	}
 
-	/* step 4: remove page table */
-
-	/* Huge page lock is still held, so page table must remain empty */
-	pml = pmd_lock(mm, pmd);
-	if (ptl != pml)
-		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+	/* step 4: remove empty page table */
+	if (!pml) {
+		pml = pmd_lock(mm, pmd);
+		if (ptl != pml)
+			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+	}
 	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	pmdp_get_lockless_sync();
 	if (ptl != pml)
@@ -1648,6 +1666,8 @@ abort:
 	}
 	if (start_pte)
 		pte_unmap_unlock(start_pte, ptl);
+	if (pml && pml != ptl)
+		spin_unlock(pml);
 	if (notified)
 		mmu_notifier_invalidate_range_end(&range);
 drop_hpage:
_

Patches currently in -mm which might be from hughd@google.com are


