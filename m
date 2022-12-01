Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F4CC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiLAAGv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLAAFE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:05:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E226C95807
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D325D6176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DA3C4347C;
        Thu,  1 Dec 2022 00:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852933;
        bh=xUAW7tuI2lXjvT3QKNKV+Bk5R/hlmhJImU/fmzEEr0w=;
        h=Date:To:From:Subject:From;
        b=AN+x12HWK+Z2gsXbnK0IpGYI3B5YaBxQBoyAc4ag6yKfXsqi6z29f2fy5NN4BRm6E
         T1Mnjh1d5PopH6+2CVhHjHuZFNXb3VL96gj3Y44hiyN/QHdg74VEn2aAFnPZAjQbIY
         lDrZi+TYt/GTmEvc+wa1IavTLVepJOdTtUYwKVkI=
Date:   Wed, 30 Nov 2022 16:02:12 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, jhubbard@nvidia.com,
        daniel.vetter@ffwll.ch, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch removed from -mm tree
Message-Id: <20221201000213.08DA3C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: reliable R/O long-term pinning in COW mappings
has been removed from the -mm tree.  Its filename was
     mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: reliable R/O long-term pinning in COW mappings
Date: Wed, 16 Nov 2022 11:26:48 +0100

We already support reliable R/O pinning of anonymous memory. However,
assume we end up pinning (R/O long-term) a pagecache page or the shared
zeropage inside a writable private ("COW") mapping. The next write access
will trigger a write-fault and replace the pinned page by an exclusive
anonymous page in the process page tables to break COW: the pinned page no
longer corresponds to the page mapped into the process' page table.

Now that FAULT_FLAG_UNSHARE can break COW on anything mapped into a
COW mapping, let's properly break COW first before R/O long-term
pinning something that's not an exclusive anon page inside a COW
mapping. FAULT_FLAG_UNSHARE will break COW and map an exclusive anon page
instead that can get pinned safely.

With this change, we can stop using FOLL_FORCE|FOLL_WRITE for reliable
R/O long-term pinning in COW mappings.

With this change, the new R/O long-term pinning tests for non-anonymous
memory succeed:
  # [RUN] R/O longterm GUP pin ... with shared zeropage
  ok 151 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP pin ... with memfd
  ok 152 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP pin ... with tmpfile
  ok 153 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP pin ... with huge zeropage
  ok 154 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP pin ... with memfd hugetlb (2048 kB)
  ok 155 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP pin ... with memfd hugetlb (1048576 kB)
  ok 156 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP-fast pin ... with shared zeropage
  ok 157 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP-fast pin ... with memfd
  ok 158 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP-fast pin ... with tmpfile
  ok 159 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP-fast pin ... with huge zeropage
  ok 160 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP-fast pin ... with memfd hugetlb (2048 kB)
  ok 161 Longterm R/O pin is reliable
  # [RUN] R/O longterm GUP-fast pin ... with memfd hugetlb (1048576 kB)
  ok 162 Longterm R/O pin is reliable

Note 1: We don't care about short-term R/O-pinning, because they have
snapshot semantics: they are not supposed to observe modifications that
happen after pinning.

As one example, assume we start direct I/O to read from a page and store
page content into a file: modifications to page content after starting
direct I/O are not guaranteed to end up in the file. So even if we'd pin
the shared zeropage, the end result would be as expected -- getting zeroes
stored to the file.

Note 2: For shared mappings we'll now always fallback to the slow path to
lookup the VMA when R/O long-term pining. While that's the necessary price
we have to pay right now, it's actually not that bad in practice: most
FOLL_LONGTERM users already specify FOLL_WRITE, for example, along with
FOLL_FORCE because they tried dealing with COW mappings correctly ...

Note 3: For users that use FOLL_LONGTERM right now without FOLL_WRITE,
such as VFIO, we'd now no longer pin the shared zeropage. Instead, we'd
populate exclusive anon pages that we can pin. There was a concern that
this could affect the memlock limit of existing setups.

For example, a VM running with VFIO could run into the memlock limit and
fail to run. However, we essentially had the same behavior already in
commit 17839856fd58 ("gup: document and work around "COW can break either
way" issue") which got merged into some enterprise distros, and there were
not any such complaints. So most probably, we're fine.

Link: https://lkml.kernel.org/r/20221116102659.70287-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   27 ++++++++++++++++++++++++---
 mm/gup.c           |   10 +++++-----
 mm/huge_memory.c   |    2 +-
 mm/hugetlb.c       |    7 ++++---
 4 files changed, 34 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings
+++ a/include/linux/mm.h
@@ -3149,8 +3149,12 @@ static inline int vm_fault_to_errno(vm_f
  * Must be called with the (sub)page that's actually referenced via the
  * page table entry, which might not necessarily be the head page for a
  * PTE-mapped THP.
+ *
+ * If the vma is NULL, we're coming from the GUP-fast path and might have
+ * to fallback to the slow path just to lookup the vma.
  */
-static inline bool gup_must_unshare(unsigned int flags, struct page *page)
+static inline bool gup_must_unshare(struct vm_area_struct *vma,
+				    unsigned int flags, struct page *page)
 {
 	/*
 	 * FOLL_WRITE is implicitly handled correctly as the page table entry
@@ -3163,8 +3167,25 @@ static inline bool gup_must_unshare(unsi
 	 * Note: PageAnon(page) is stable until the page is actually getting
 	 * freed.
 	 */
-	if (!PageAnon(page))
-		return false;
+	if (!PageAnon(page)) {
+		/*
+		 * We only care about R/O long-term pining: R/O short-term
+		 * pinning does not have the semantics to observe successive
+		 * changes through the process page tables.
+		 */
+		if (!(flags & FOLL_LONGTERM))
+			return false;
+
+		/* We really need the vma ... */
+		if (!vma)
+			return true;
+
+		/*
+		 * ... because we only care about writable private ("COW")
+		 * mappings where we have to break COW early.
+		 */
+		return is_cow_mapping(vma->vm_flags);
+	}
 
 	/* Paired with a memory barrier in page_try_share_anon_rmap(). */
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
--- a/mm/gup.c~mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings
+++ a/mm/gup.c
@@ -603,7 +603,7 @@ retry:
 		}
 	}
 
-	if (!pte_write(pte) && gup_must_unshare(flags, page)) {
+	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
 		page = ERR_PTR(-EMLINK);
 		goto out;
 	}
@@ -2380,7 +2380,7 @@ static int gup_pte_range(pmd_t pmd, pmd_
 			goto pte_unmap;
 		}
 
-		if (!pte_write(pte) && gup_must_unshare(flags, page)) {
+		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2566,7 +2566,7 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
 	}
 
-	if (!pte_write(pte) && gup_must_unshare(flags, &folio->page)) {
+	if (!pte_write(pte) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2632,7 +2632,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return 0;
 	}
 
-	if (!pmd_write(orig) && gup_must_unshare(flags, &folio->page)) {
+	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2672,7 +2672,7 @@ static int gup_huge_pud(pud_t orig, pud_
 		return 0;
 	}
 
-	if (!pud_write(orig) && gup_must_unshare(flags, &folio->page)) {
+	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
--- a/mm/huge_memory.c~mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings
+++ a/mm/huge_memory.c
@@ -1480,7 +1480,7 @@ struct page *follow_trans_huge_pmd(struc
 	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(flags))
 		return NULL;
 
-	if (!pmd_write(*pmd) && gup_must_unshare(flags, page))
+	if (!pmd_write(*pmd) && gup_must_unshare(vma, flags, page))
 		return ERR_PTR(-EMLINK);
 
 	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
--- a/mm/hugetlb.c~mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings
+++ a/mm/hugetlb.c
@@ -6197,7 +6197,8 @@ static void record_subpages_vmas(struct
 	}
 }
 
-static inline bool __follow_hugetlb_must_fault(unsigned int flags, pte_t *pte,
+static inline bool __follow_hugetlb_must_fault(struct vm_area_struct *vma,
+					       unsigned int flags, pte_t *pte,
 					       bool *unshare)
 {
 	pte_t pteval = huge_ptep_get(pte);
@@ -6209,7 +6210,7 @@ static inline bool __follow_hugetlb_must
 		return false;
 	if (flags & FOLL_WRITE)
 		return true;
-	if (gup_must_unshare(flags, pte_page(pteval))) {
+	if (gup_must_unshare(vma, flags, pte_page(pteval))) {
 		*unshare = true;
 		return true;
 	}
@@ -6338,7 +6339,7 @@ long follow_hugetlb_page(struct mm_struc
 		 * directly from any kind of swap entries.
 		 */
 		if (absent ||
-		    __follow_hugetlb_must_fault(flags, pte, &unshare)) {
+		    __follow_hugetlb_must_fault(vma, flags, pte, &unshare)) {
 			vm_fault_t ret;
 			unsigned int fault_flags = 0;
 
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

