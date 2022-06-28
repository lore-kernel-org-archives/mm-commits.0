Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA2FC43334
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiF1T03 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiF1TZr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A632228708
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42F6361889
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF8DC3411D;
        Tue, 28 Jun 2022 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656444285;
        bh=yjAtKgXCTEqdw3i9RTnj3/JjzvKfD8+Kc8uTm/upw/A=;
        h=Date:To:From:Subject:From;
        b=SmmR6j9UtcHbFauXIDkC+U30HZKHz0sZpinPmBlbyehuqo5dhVSWuffdUDld50RSd
         vV0CuYEVqekBznEJCJSNlEmTxwiNryaBubDzzflxF3+9bS0KcF0thL+53TQLyUF+4Y
         LMJ3HfIHVswlMctOJu4hcexv6cXMymyyBpmwHyQE=
Date:   Tue, 28 Jun 2022 12:24:44 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch added to mm-unstable branch
Message-Id: <20220628192445.8EF8DC3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: move code comments to vmemmap_dedup.rst
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: move code comments to vmemmap_dedup.rst
Date: Tue, 28 Jun 2022 17:22:34 +0800

All the comments which explains how HVO works are moved to
vmemmap_dedup.rst since

  commit 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory savings for compound devmaps")

except some comments above page_fixed_fake_head().  This commit moves
those comments to vmemmap_dedup.rst and improve vmemmap_dedup.rst as well.

Link: https://lkml.kernel.org/r/20220628092235.91270-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/vmemmap_dedup.rst |   70 ++++++++++++++++++---------
 include/linux/page-flags.h         |   15 -----
 2 files changed, 49 insertions(+), 36 deletions(-)

--- a/Documentation/mm/vmemmap_dedup.rst~mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -9,23 +9,23 @@ HugeTLB
 
 This section is to explain how HugeTLB Vmemmap Optimization (HVO) works.
 
-The struct page structures (page structs) are used to describe a physical
-page frame. By default, there is a one-to-one mapping from a page frame to
-it's corresponding page struct.
+The ``struct page`` structures are used to describe a physical page frame. By
+default, there is a one-to-one mapping from a page frame to it's corresponding
+``struct page``.
 
 HugeTLB pages consist of multiple base page size pages and is supported by many
 architectures. See Documentation/admin-guide/mm/hugetlbpage.rst for more
 details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB are
 currently supported. Since the base page size on x86 is 4KB, a 2MB HugeTLB page
 consists of 512 base pages and a 1GB HugeTLB page consists of 4096 base pages.
-For each base page, there is a corresponding page struct.
+For each base page, there is a corresponding ``struct page``.
 
-Within the HugeTLB subsystem, only the first 4 page structs are used to
-contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
-this upper limit. The only 'useful' information in the remaining page structs
+Within the HugeTLB subsystem, only the first 4 ``struct page`` are used to
+contain unique information about a HugeTLB page. ``__NR_USED_SUBPAGE`` provides
+this upper limit. The only 'useful' information in the remaining ``struct page``
 is the compound_head field, and this field is the same for all tail pages.
 
-By removing redundant page structs for HugeTLB pages, memory can be returned
+By removing redundant ``struct page`` for HugeTLB pages, memory can be returned
 to the buddy allocator for other uses.
 
 Different architectures support different HugeTLB pages. For example, the
@@ -46,7 +46,7 @@ page.
 |              |   64KB    |    2MB    |  512MB    |    16GB   |           |
 +--------------+-----------+-----------+-----------+-----------+-----------+
 
-When the system boot up, every HugeTLB page has more than one struct page
+When the system boot up, every HugeTLB page has more than one ``struct page``
 structs which size is (unit: pages)::
 
    struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
@@ -76,10 +76,10 @@ Where n is how many pte entries which on
 n is (PAGE_SIZE / sizeof(pte_t)).
 
 This optimization only supports 64-bit system, so the value of sizeof(pte_t)
-is 8. And this optimization also applicable only when the size of struct page
-is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
+is 8. And this optimization also applicable only when the size of ``struct page``
+is a power of two. In most cases, the size of ``struct page`` is 64 bytes (e.g.
 x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
-size of struct page structs of it is 8 page frames which size depends on the
+size of ``struct page`` structs of it is 8 page frames which size depends on the
 size of the base page.
 
 For the HugeTLB page of the pud level mapping, then::
@@ -88,7 +88,7 @@ For the HugeTLB page of the pud level ma
                = PAGE_SIZE / 8 * 8 (pages)
                = PAGE_SIZE (pages)
 
-Where the struct_size(pmd) is the size of the struct page structs of a
+Where the struct_size(pmd) is the size of the ``struct page`` structs of a
 HugeTLB page of the pmd level mapping.
 
 E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
@@ -96,7 +96,7 @@ HugeTLB page consists in 4096.
 
 Next, we take the pmd level mapping of the HugeTLB page as an example to
 show the internal implementation of this optimization. There are 8 pages
-struct page structs associated with a HugeTLB page which is pmd mapped.
+``struct page`` structs associated with a HugeTLB page which is pmd mapped.
 
 Here is how things look before optimization::
 
@@ -124,10 +124,10 @@ Here is how things look before optimizat
  +-----------+
 
 The value of page->compound_head is the same for all tail pages. The first
-page of page structs (page 0) associated with the HugeTLB page contains the 4
-page structs necessary to describe the HugeTLB. The only use of the remaining
-pages of page structs (page 1 to page 7) is to point to page->compound_head.
-Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of page structs
+page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
+``struct page`` necessary to describe the HugeTLB. The only use of the remaining
+pages of ``struct page`` (page 1 to page 7) is to point to page->compound_head.
+Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
 will be used for each HugeTLB page. This will allow us to free the remaining
 7 pages to the buddy allocator.
 
@@ -169,13 +169,37 @@ entries that can be cached in a single T
 
 The contiguous bit is used to increase the mapping size at the pmd and pte
 (last) level. So this type of HugeTLB page can be optimized only when its
-size of the struct page structs is greater than 1 page.
+size of the ``struct page`` structs is greater than **1** page.
 
 Notice: The head vmemmap page is not freed to the buddy allocator and all
 tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
-more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
-associated with each HugeTLB page. The compound_head() can handle this
-correctly (more details refer to the comment above compound_head()).
+more than one ``struct page`` struct with ``PG_head`` (e.g. 8 per 2 MB HugeTLB
+page) associated with each HugeTLB page. The ``compound_head()`` can handle
+this correctly. There is only **one** head ``struct page``, the tail
+``struct page`` with ``PG_head`` are fake head ``struct page``.  We need an
+approach to distinguish between those two different types of ``struct page`` so
+that ``compound_head()`` can return the real head ``struct page`` when the
+parameter is the tail ``struct page`` but with ``PG_head``. The following code
+snippet describes how to distinguish between real and fake head ``struct page``.
+
+.. code-block:: c
+
+	if (test_bit(PG_head, &page->flags)) {
+		unsigned long head = READ_ONCE(page[1].compound_head);
+
+		if (head & 1) {
+			if (head == (unsigned long)page + 1)
+				/* head struct page */
+			else
+				/* tail struct page */
+		} else {
+			/* head struct page */
+		}
+	}
+
+We can safely access the field of the **page[1]** with ``PG_head`` because the
+page is a compound page composed with at least two contiguous pages.
+The implementation refers to ``page_fixed_fake_head()``.
 
 Device DAX
 ==========
@@ -189,7 +213,7 @@ PMD_SIZE (2M on x86_64) and PUD_SIZE (1G
 
 The differences with HugeTLB are relatively minor.
 
-It only use 3 page structs for storing all information as opposed
+It only use 3 ``struct page`` for storing all information as opposed
 to 4 on HugeTLB pages.
 
 There's no remapping of vmemmap given that device-dax memory is not part of
--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst
+++ a/include/linux/page-flags.h
@@ -208,19 +208,8 @@ enum pageflags {
 DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 
 /*
- * If HVO is enabled, the head vmemmap page frame is reused and all of the tail
- * vmemmap addresses map to the head vmemmap page frame (furture details can
- * refer to the figure at the head of the mm/hugetlb_vmemmap.c).  In other
- * words, there are more than one page struct with PG_head associated with each
- * HugeTLB page.  We __know__ that there is only one head page struct, the tail
- * page structs with PG_head are fake head page structs.  We need an approach
- * to distinguish between those two different types of page structs so that
- * compound_head() can return the real head page struct when the parameter is
- * the tail page struct but with PG_head.
- *
- * The page_fixed_fake_head() returns the real head page struct if the @page is
- * fake page head, otherwise, returns @page which can either be a true page
- * head or tail.
+ * Return the real head page struct iff the @page is a fake head page, otherwise
+ * return the @page itself. See Documentation/mm/vmemmap_dedup.rst.
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparsemem-fix-missing-higher-order-allocation-splitting.patch
mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

