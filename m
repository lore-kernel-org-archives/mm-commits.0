Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A4BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiCaEer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiCaEef (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:34:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF33B5A17C
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A05C4B81EC2
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28405C34111;
        Thu, 31 Mar 2022 04:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701165;
        bh=Y4PZgXsZHl7Q2enAb58FImT57XHXAuJBeso9BpCLx2E=;
        h=Date:To:From:Subject:From;
        b=xlr26DnTK0b1QFOerlbT0NA24yCNmS2GsZ9gEDAG2w3U/9RnXu4Mes/C635zvnwOF
         3ggQ1davaId5kqNgGX8d3EKSJxO5JMPqIFOWFUh85ycfeWgTCJZVE9lJl1Yg4TmYym
         vHFcevsYJJmKQp9Qvl+fFs/vN9Fwpkm4axUTdYuM=
Date:   Wed, 30 Mar 2022 21:32:44 -0700
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
Subject: + mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch added to -mm tree
Message-Id: <20220331043245.28405C34111@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: convert RMAP flags to a proper distinct rmap_t type
has been added to the -mm tree.  Its filename is
     mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch

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
Subject: mm/rmap: convert RMAP flags to a proper distinct rmap_t type

We want to pass the flags to more than one anon rmap function, getting rid
of special "do_page_add_anon_rmap()".  So let's pass around a distinct
__bitwise type and refine documentation.

Link: https://lkml.kernel.org/r/20220329160440.193848-6-david@redhat.com
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
@@ -3507,10 +3507,10 @@ vm_fault_t do_swap_page(struct vm_fault
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
 
@@ -3685,7 +3685,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		vmf->flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
-		exclusive = RMAP_EXCLUSIVE;
+		rmap_flags |= RMAP_EXCLUSIVE;
 	}
 	flush_icache_page(vma, page);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
@@ -3701,7 +3701,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
-		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
+		do_page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
 	}
 
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
--- a/mm/rmap.c~mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type
+++ a/mm/rmap.c
@@ -1137,7 +1137,8 @@ static void __page_check_anon_rmap(struc
 void page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address, bool compound)
 {
-	do_page_add_anon_rmap(page, vma, address, compound ? RMAP_COMPOUND : 0);
+	do_page_add_anon_rmap(page, vma, address,
+			      compound ? RMAP_COMPOUND : RMAP_NONE);
 }
 
 /*
@@ -1146,7 +1147,7 @@ void page_add_anon_rmap(struct page *pag
  * Everybody else should continue to use page_add_anon_rmap above.
  */
 void do_page_add_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address, int flags)
+	struct vm_area_struct *vma, unsigned long address, rmap_t flags)
 {
 	bool compound = flags & RMAP_COMPOUND;
 	bool first;
@@ -1185,7 +1186,7 @@ void do_page_add_anon_rmap(struct page *
 	/* address might be in next vma when migration races vma_adjust */
 	else if (first)
 		__page_set_anon_rmap(page, vma, address,
-				flags & RMAP_EXCLUSIVE);
+				     !!(flags & RMAP_EXCLUSIVE));
 	else
 		__page_check_anon_rmap(page, vma, address);
 
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

