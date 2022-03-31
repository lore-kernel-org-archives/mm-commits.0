Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54990C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiCaEef (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCaEea (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:34:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594355A15C
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC0AA6146B
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388C2C340ED;
        Thu, 31 Mar 2022 04:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701159;
        bh=kw4JjFQevLMXzKDN3tyQrxRr/swySxc1032VUjdlgUI=;
        h=Date:To:From:Subject:From;
        b=RnQPMtrB+KWGTbzt+w0StSafs3yIIvwoYz8J1ww7CQuBCrNGcNND7O7hfL0sgyhxk
         VyXUiJ2xckehj0Ai63ihPgzMGQscZm7dpIljwuWFUE37OPXfOAkyajSjEmfHc9fVKe
         esxD+Pe8Fq6onMv3P/n0KcjjSK9bQuGsqJNyeED0=
Date:   Wed, 30 Mar 2022 21:32:38 -0700
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
Subject: + mm-memory-slightly-simplify-copy_present_pte.patch added to -mm tree
Message-Id: <20220331043239.388C2C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: slightly simplify copy_present_pte()
has been added to the -mm tree.  Its filename is
     mm-memory-slightly-simplify-copy_present_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-slightly-simplify-copy_present_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-slightly-simplify-copy_present_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: slightly simplify copy_present_pte()

Let's move the pinning check into the caller, to simplify return code
logic and prepare for further changes: relocating the
page_needs_cow_for_dma() into rmap handling code.

While at it, remove the unused pte parameter and simplify the comments a
bit.

No functional change intended.

Link: https://lkml.kernel.org/r/20220329160440.193848-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   53 +++++++++++++++-----------------------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

--- a/mm/memory.c~mm-memory-slightly-simplify-copy_present_pte
+++ a/mm/memory.c
@@ -862,19 +862,11 @@ copy_nonpresent_pte(struct mm_struct *ds
 }
 
 /*
- * Copy a present and normal page if necessary.
+ * Copy a present and normal page.
  *
- * NOTE! The usual case is that this doesn't need to do
- * anything, and can just return a positive value. That
- * will let the caller know that it can just increase
- * the page refcount and re-use the pte the traditional
- * way.
- *
- * But _if_ we need to copy it because it needs to be
- * pinned in the parent (and the child should get its own
- * copy rather than just a reference to the same page),
- * we'll do that here and return zero to let the caller
- * know we're done.
+ * NOTE! The usual case is that this isn't required;
+ * instead, the caller can just increase the page refcount
+ * and re-use the pte the traditional way.
  *
  * And if we need a pre-allocated page but don't yet have
  * one, return a negative error to let the preallocation
@@ -884,25 +876,10 @@ copy_nonpresent_pte(struct mm_struct *ds
 static inline int
 copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		  struct page **prealloc, pte_t pte, struct page *page)
+		  struct page **prealloc, struct page *page)
 {
 	struct page *new_page;
-
-	/*
-	 * What we want to do is to check whether this page may
-	 * have been pinned by the parent process.  If so,
-	 * instead of wrprotect the pte on both sides, we copy
-	 * the page immediately so that we'll always guarantee
-	 * the pinned page won't be randomly replaced in the
-	 * future.
-	 *
-	 * The page pinning checks are just "has this mm ever
-	 * seen pinning", along with the (inexact) check of
-	 * the page count. That might give false positives for
-	 * for pinning, but it will work correctly.
-	 */
-	if (likely(!page_needs_cow_for_dma(src_vma, page)))
-		return 1;
+	pte_t pte;
 
 	new_page = *prealloc;
 	if (!new_page)
@@ -944,14 +921,16 @@ copy_present_pte(struct vm_area_struct *
 	struct page *page;
 
 	page = vm_normal_page(src_vma, addr, pte);
-	if (page) {
-		int retval;
-
-		retval = copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
-					   addr, rss, prealloc, pte, page);
-		if (retval <= 0)
-			return retval;
-
+	if (page && unlikely(page_needs_cow_for_dma(src_vma, page))) {
+		/*
+		 * If this page may have been pinned by the parent process,
+		 * copy the page immediately for the child so that we'll always
+		 * guarantee the pinned page won't be randomly replaced in the
+		 * future.
+		 */
+		return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
+					 addr, rss, prealloc, page);
+	} else if (page) {
 		get_page(page);
 		page_dup_rmap(page, false);
 		rss[mm_counter(page)]++;
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

