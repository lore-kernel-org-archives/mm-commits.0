Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE0BC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D489864FB5
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhCMFHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhCMFH1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2A4964F8C;
        Sat, 13 Mar 2021 05:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612047;
        bh=Inc2Z/H5sEdS6I+zvm4fjbAVUEjfa21iVmt+f+z76zw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Mqpaiqcq0jly/dei3ErHlM90UmRl6dX8OPg8YCGb8BAmWXHjYsbWXn6K18zMZj/6P
         ieqwoYJSXMgn8QuHWeInwS1FyqGWYMsd4x8UvThWf9vFjcFXQBRh0UV/QnAHiCYqmj
         OIHR8qPjW4P/eum3qKUrmLlYt2KfMnVX72MfTQ5E=
Date:   Fri, 12 Mar 2021 21:07:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com, airlied@linux.ie,
        akpm@linux-foundation.org, daniel@ffwll.ch,
        david@gibson.dropbear.id.au, galpress@amazon.com, hch@lst.de,
        jack@suse.cz, jannh@google.com, jgg@ziepe.ca, kirill@shutemov.name,
        ktkhai@virtuozzo.com, linmiaohe@huawei.com,
        linux-graphics-maintainer@vmware.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, sroland@vmware.com,
        torvalds@linux-foundation.org, willy@infradead.org, wzam@amazon.com
Subject:  [patch 08/29] mm: introduce page_needs_cow_for_dma() for
 deciding whether cow
Message-ID: <20210313050726.2Cr09FU7B%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce page_needs_cow_for_dma() for deciding whether cow

We've got quite a few places (pte, pmd, pud) that explicitly checked
against whether we should break the cow right now during fork().  It's
easier to provide a helper, especially before we work the same thing on
hugetlbfs.

Since we'll reference is_cow_mapping() in mm.h, move it there too. 
Actually it suites mm.h more since internal.h is mm/ only, but mm.h is
exported to the whole kernel.  With that we should expect another patch to
use is_cow_mapping() whenever we can across the kernel since we do use it
quite a lot but it's always done with raw code against VM_* flags.

Link: https://lkml.kernel.org/r/20210217233547.93892-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Gal Pressman <galpress@amazon.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Roland Scheidegger <sroland@vmware.com>
Cc: VMware Graphics <linux-graphics-maintainer@vmware.com>
Cc: Wei Zhang <wzam@amazon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++++++++++++++++++
 mm/huge_memory.c   |    8 ++------
 mm/internal.h      |    5 -----
 mm/memory.c        |    8 +-------
 4 files changed, 24 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/include/linux/mm.h
@@ -1300,6 +1300,27 @@ static inline bool page_maybe_dma_pinned
 		GUP_PIN_COUNTING_BIAS;
 }
 
+static inline bool is_cow_mapping(vm_flags_t flags)
+{
+	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
+}
+
+/*
+ * This should most likely only be called during fork() to see whether we
+ * should break the cow immediately for a page on the src mm.
+ */
+static inline bool page_needs_cow_for_dma(struct vm_area_struct *vma,
+					  struct page *page)
+{
+	if (!is_cow_mapping(vma->vm_flags))
+		return false;
+
+	if (!atomic_read(&vma->vm_mm->has_pinned))
+		return false;
+
+	return page_maybe_dma_pinned(page);
+}
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
--- a/mm/huge_memory.c~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/mm/huge_memory.c
@@ -1100,9 +1100,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 * best effort that the pinned pages won't be replaced by another
 	 * random page during the coming copy-on-write.
 	 */
-	if (unlikely(is_cow_mapping(vma->vm_flags) &&
-		     atomic_read(&src_mm->has_pinned) &&
-		     page_maybe_dma_pinned(src_page))) {
+	if (unlikely(page_needs_cow_for_dma(vma, src_page))) {
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
@@ -1214,9 +1212,7 @@ int copy_huge_pud(struct mm_struct *dst_
 	}
 
 	/* Please refer to comments in copy_huge_pmd() */
-	if (unlikely(is_cow_mapping(vma->vm_flags) &&
-		     atomic_read(&src_mm->has_pinned) &&
-		     page_maybe_dma_pinned(pud_page(pud)))) {
+	if (unlikely(page_needs_cow_for_dma(vma, pud_page(pud)))) {
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
 		__split_huge_pud(vma, src_pud, addr);
--- a/mm/internal.h~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/mm/internal.h
@@ -296,11 +296,6 @@ static inline unsigned int buddy_order(s
  */
 #define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
 
-static inline bool is_cow_mapping(vm_flags_t flags)
-{
-	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
-}
-
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
--- a/mm/memory.c~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/mm/memory.c
@@ -809,12 +809,8 @@ copy_present_page(struct vm_area_struct
 		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
 		  struct page **prealloc, pte_t pte, struct page *page)
 {
-	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct page *new_page;
 
-	if (!is_cow_mapping(src_vma->vm_flags))
-		return 1;
-
 	/*
 	 * What we want to do is to check whether this page may
 	 * have been pinned by the parent process.  If so,
@@ -828,9 +824,7 @@ copy_present_page(struct vm_area_struct
 	 * the page count. That might give false positives for
 	 * for pinning, but it will work correctly.
 	 */
-	if (likely(!atomic_read(&src_mm->has_pinned)))
-		return 1;
-	if (likely(!page_maybe_dma_pinned(page)))
+	if (likely(!page_needs_cow_for_dma(src_vma, page)))
 		return 1;
 
 	new_page = *prealloc;
_
