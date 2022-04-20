Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE63EC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382624AbiDTVoL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382621AbiDTVoJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FB940E6F
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F09BC6197E
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5187CC385A0;
        Wed, 20 Apr 2022 21:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650490880;
        bh=4g1NefsJGMeS/hr00r3sNUSmntgFLKY10zkP/L8tOfY=;
        h=Date:To:From:Subject:From;
        b=kPIKRPRwx/taC+UoTBYlUP/kCp85MK+V8uT0egUotmMrMeBB/PKirYqpl0BW+jPIg
         h4ZHmmfWr5MGvM3ANE86RHtzLxekMjrPpNYx5cSYpHhHLf3gP7ZcdRIJt832fnrGxL
         yInhq7TAsI3+JQzf0P01XiHkx9K/1cvokx7AECFY=
Date:   Wed, 20 Apr 2022 14:41:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.l.verma@intel.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, jgg@ziepe.ca, jane.chu@oracle.com,
        hch@lst.de, dan.j.williams@intel.com, corbet@lwn.net,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch added to -mm tree
Message-Id: <20220420214120.5187CC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_vmemmap: move comment block to Documentation/vm
has been added to the -mm tree.  Its filename is
     mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb_vmemmap: move comment block to Documentation/vm

In preparation for device-dax for using hugetlbfs compound page tail
deduplication technique, move the comment block explanation into a common
place in Documentation/vm.

Link: https://lkml.kernel.org/r/20220420155310.9712-4-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/index.rst         |    1 
 Documentation/vm/vmemmap_dedup.rst |  173 +++++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c               |  168 --------------------------
 3 files changed, 175 insertions(+), 167 deletions(-)

--- a/Documentation/vm/index.rst~mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm
+++ a/Documentation/vm/index.rst
@@ -37,5 +37,6 @@ algorithms.  If you are looking for advi
    transhuge
    unevictable-lru
    vmalloced-kernel-stacks
+   vmemmap_dedup
    z3fold
    zsmalloc
--- /dev/null
+++ a/Documentation/vm/vmemmap_dedup.rst
@@ -0,0 +1,173 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+Free some vmemmap pages of HugeTLB
+==================================
+
+The struct page structures (page structs) are used to describe a physical
+page frame. By default, there is a one-to-one mapping from a page frame to
+it's corresponding page struct.
+
+HugeTLB pages consist of multiple base page size pages and is supported by many
+architectures. See Documentation/admin-guide/mm/hugetlbpage.rst for more
+details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB are
+currently supported. Since the base page size on x86 is 4KB, a 2MB HugeTLB page
+consists of 512 base pages and a 1GB HugeTLB page consists of 4096 base pages.
+For each base page, there is a corresponding page struct.
+
+Within the HugeTLB subsystem, only the first 4 page structs are used to
+contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
+this upper limit. The only 'useful' information in the remaining page structs
+is the compound_head field, and this field is the same for all tail pages.
+
+By removing redundant page structs for HugeTLB pages, memory can be returned
+to the buddy allocator for other uses.
+
+Different architectures support different HugeTLB pages. For example, the
+following table is the HugeTLB page size supported by x86 and arm64
+architectures. Because arm64 supports 4k, 16k, and 64k base pages and
+supports contiguous entries, so it supports many kinds of sizes of HugeTLB
+page.
+
++--------------+-----------+-----------------------------------------------+
+| Architecture | Page Size |                HugeTLB Page Size              |
++--------------+-----------+-----------+-----------+-----------+-----------+
+|    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
++--------------+-----------+-----------+-----------+-----------+-----------+
+|              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
+|              +-----------+-----------+-----------+-----------+-----------+
+|    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
+|              +-----------+-----------+-----------+-----------+-----------+
+|              |   64KB    |    2MB    |  512MB    |    16GB   |           |
++--------------+-----------+-----------+-----------+-----------+-----------+
+
+When the system boot up, every HugeTLB page has more than one struct page
+structs which size is (unit: pages)::
+
+   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+
+Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
+of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
+relationship::
+
+   HugeTLB_Size = n * PAGE_SIZE
+
+Then::
+
+   struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
+               = n * sizeof(struct page) / PAGE_SIZE
+
+We can use huge mapping at the pud/pmd level for the HugeTLB page.
+
+For the HugeTLB page of the pmd level mapping, then::
+
+   struct_size = n * sizeof(struct page) / PAGE_SIZE
+               = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
+               = sizeof(struct page) / sizeof(pte_t)
+               = 64 / 8
+               = 8 (pages)
+
+Where n is how many pte entries which one page can contains. So the value of
+n is (PAGE_SIZE / sizeof(pte_t)).
+
+This optimization only supports 64-bit system, so the value of sizeof(pte_t)
+is 8. And this optimization also applicable only when the size of struct page
+is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
+x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
+size of struct page structs of it is 8 page frames which size depends on the
+size of the base page.
+
+For the HugeTLB page of the pud level mapping, then::
+
+   struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
+               = PAGE_SIZE / 8 * 8 (pages)
+               = PAGE_SIZE (pages)
+
+Where the struct_size(pmd) is the size of the struct page structs of a
+HugeTLB page of the pmd level mapping.
+
+E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
+HugeTLB page consists in 4096.
+
+Next, we take the pmd level mapping of the HugeTLB page as an example to
+show the internal implementation of this optimization. There are 8 pages
+struct page structs associated with a HugeTLB page which is pmd mapped.
+
+Here is how things look before optimization::
+
+    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | -------------> |     1     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     2     | -------------> |     2     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     3     | -------------> |     3     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     4     | -------------> |     4     |
+ |    PMD    |                     +-----------+                +-----------+
+ |   level   |                     |     5     | -------------> |     5     |
+ |  mapping  |                     +-----------+                +-----------+
+ |           |                     |     6     | -------------> |     6     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     7     | -------------> |     7     |
+ |           |                     +-----------+                +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
+
+The value of page->compound_head is the same for all tail pages. The first
+page of page structs (page 0) associated with the HugeTLB page contains the 4
+page structs necessary to describe the HugeTLB. The only use of the remaining
+pages of page structs (page 1 to page 7) is to point to page->compound_head.
+Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of page structs
+will be used for each HugeTLB page. This will allow us to free the remaining
+7 pages to the buddy allocator.
+
+Here is how things look after remapping::
+
+    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                  | | | | | |
+ |           |                     |     2     | -----------------+ | | | | |
+ |           |                     +-----------+                    | | | | |
+ |           |                     |     3     | -------------------+ | | | |
+ |           |                     +-----------+                      | | | |
+ |           |                     |     4     | ---------------------+ | | |
+ |    PMD    |                     +-----------+                        | | |
+ |   level   |                     |     5     | -----------------------+ | |
+ |  mapping  |                     +-----------+                          | |
+ |           |                     |     6     | -------------------------+ |
+ |           |                     +-----------+                            |
+ |           |                     |     7     | ---------------------------+
+ |           |                     +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
+
+When a HugeTLB is freed to the buddy system, we should allocate 7 pages for
+vmemmap pages and restore the previous mapping relationship.
+
+For the HugeTLB page of the pud level mapping. It is similar to the former.
+We also can use this approach to free (PAGE_SIZE - 1) vmemmap pages.
+
+Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
+(e.g. aarch64) provides a contiguous bit in the translation table entries
+that hints to the MMU to indicate that it is one of a contiguous set of
+entries that can be cached in a single TLB entry.
+
+The contiguous bit is used to increase the mapping size at the pmd and pte
+(last) level. So this type of HugeTLB page can be optimized only when its
+size of the struct page structs is greater than 1 page.
+
+Notice: The head vmemmap page is not freed to the buddy allocator and all
+tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
+more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
+associated with each HugeTLB page. The compound_head() can handle this
+correctly (more details refer to the comment above compound_head()).
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm
+++ a/mm/hugetlb_vmemmap.c
@@ -6,173 +6,7 @@
  *
  *     Author: Muchun Song <songmuchun@bytedance.com>
  *
- * The struct page structures (page structs) are used to describe a physical
- * page frame. By default, there is a one-to-one mapping from a page frame to
- * it's corresponding page struct.
- *
- * HugeTLB pages consist of multiple base page size pages and is supported by
- * many architectures. See hugetlbpage.rst in the Documentation directory for
- * more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
- * are currently supported. Since the base page size on x86 is 4KB, a 2MB
- * HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
- * 4096 base pages. For each base page, there is a corresponding page struct.
- *
- * Within the HugeTLB subsystem, only the first 4 page structs are used to
- * contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
- * this upper limit. The only 'useful' information in the remaining page structs
- * is the compound_head field, and this field is the same for all tail pages.
- *
- * By removing redundant page structs for HugeTLB pages, memory can be returned
- * to the buddy allocator for other uses.
- *
- * Different architectures support different HugeTLB pages. For example, the
- * following table is the HugeTLB page size supported by x86 and arm64
- * architectures. Because arm64 supports 4k, 16k, and 64k base pages and
- * supports contiguous entries, so it supports many kinds of sizes of HugeTLB
- * page.
- *
- * +--------------+-----------+-----------------------------------------------+
- * | Architecture | Page Size |                HugeTLB Page Size              |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- * |    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- * |              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
- * |              +-----------+-----------+-----------+-----------+-----------+
- * |    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
- * |              +-----------+-----------+-----------+-----------+-----------+
- * |              |   64KB    |    2MB    |  512MB    |    16GB   |           |
- * +--------------+-----------+-----------+-----------+-----------+-----------+
- *
- * When the system boot up, every HugeTLB page has more than one struct page
- * structs which size is (unit: pages):
- *
- *    struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
- *
- * Where HugeTLB_Size is the size of the HugeTLB page. We know that the size
- * of the HugeTLB page is always n times PAGE_SIZE. So we can get the following
- * relationship.
- *
- *    HugeTLB_Size = n * PAGE_SIZE
- *
- * Then,
- *
- *    struct_size = n * PAGE_SIZE / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE
- *                = n * sizeof(struct page) / PAGE_SIZE
- *
- * We can use huge mapping at the pud/pmd level for the HugeTLB page.
- *
- * For the HugeTLB page of the pmd level mapping, then
- *
- *    struct_size = n * sizeof(struct page) / PAGE_SIZE
- *                = PAGE_SIZE / sizeof(pte_t) * sizeof(struct page) / PAGE_SIZE
- *                = sizeof(struct page) / sizeof(pte_t)
- *                = 64 / 8
- *                = 8 (pages)
- *
- * Where n is how many pte entries which one page can contains. So the value of
- * n is (PAGE_SIZE / sizeof(pte_t)).
- *
- * This optimization only supports 64-bit system, so the value of sizeof(pte_t)
- * is 8. And this optimization also applicable only when the size of struct page
- * is a power of two. In most cases, the size of struct page is 64 bytes (e.g.
- * x86-64 and arm64). So if we use pmd level mapping for a HugeTLB page, the
- * size of struct page structs of it is 8 page frames which size depends on the
- * size of the base page.
- *
- * For the HugeTLB page of the pud level mapping, then
- *
- *    struct_size = PAGE_SIZE / sizeof(pmd_t) * struct_size(pmd)
- *                = PAGE_SIZE / 8 * 8 (pages)
- *                = PAGE_SIZE (pages)
- *
- * Where the struct_size(pmd) is the size of the struct page structs of a
- * HugeTLB page of the pmd level mapping.
- *
- * E.g.: A 2MB HugeTLB page on x86_64 consists in 8 page frames while 1GB
- * HugeTLB page consists in 4096.
- *
- * Next, we take the pmd level mapping of the HugeTLB page as an example to
- * show the internal implementation of this optimization. There are 8 pages
- * struct page structs associated with a HugeTLB page which is pmd mapped.
- *
- * Here is how things look before optimization.
- *
- *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- * |           |                     |     0     | -------------> |     0     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | -------------> |     1     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     2     | -------------> |     2     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     3     | -------------> |     3     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     4     | -------------> |     4     |
- * |    PMD    |                     +-----------+                +-----------+
- * |   level   |                     |     5     | -------------> |     5     |
- * |  mapping  |                     +-----------+                +-----------+
- * |           |                     |     6     | -------------> |     6     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     7     | -------------> |     7     |
- * |           |                     +-----------+                +-----------+
- * |           |
- * |           |
- * |           |
- * +-----------+
- *
- * The value of page->compound_head is the same for all tail pages. The first
- * page of page structs (page 0) associated with the HugeTLB page contains the 4
- * page structs necessary to describe the HugeTLB. The only use of the remaining
- * pages of page structs (page 1 to page 7) is to point to page->compound_head.
- * Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of page structs
- * will be used for each HugeTLB page. This will allow us to free the remaining
- * 7 pages to the buddy allocator.
- *
- * Here is how things look after remapping.
- *
- *    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- * |           |                     |     0     | -------------> |     0     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
- * |           |                     +-----------+                  | | | | | |
- * |           |                     |     2     | -----------------+ | | | | |
- * |           |                     +-----------+                    | | | | |
- * |           |                     |     3     | -------------------+ | | | |
- * |           |                     +-----------+                      | | | |
- * |           |                     |     4     | ---------------------+ | | |
- * |    PMD    |                     +-----------+                        | | |
- * |   level   |                     |     5     | -----------------------+ | |
- * |  mapping  |                     +-----------+                          | |
- * |           |                     |     6     | -------------------------+ |
- * |           |                     +-----------+                            |
- * |           |                     |     7     | ---------------------------+
- * |           |                     +-----------+
- * |           |
- * |           |
- * |           |
- * +-----------+
- *
- * When a HugeTLB is freed to the buddy system, we should allocate 7 pages for
- * vmemmap pages and restore the previous mapping relationship.
- *
- * For the HugeTLB page of the pud level mapping. It is similar to the former.
- * We also can use this approach to free (PAGE_SIZE - 1) vmemmap pages.
- *
- * Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
- * (e.g. aarch64) provides a contiguous bit in the translation table entries
- * that hints to the MMU to indicate that it is one of a contiguous set of
- * entries that can be cached in a single TLB entry.
- *
- * The contiguous bit is used to increase the mapping size at the pmd and pte
- * (last) level. So this type of HugeTLB page can be optimized only when its
- * size of the struct page structs is greater than 1 page.
- *
- * Notice: The head vmemmap page is not freed to the buddy allocator and all
- * tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
- * more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
- * associated with each HugeTLB page. The compound_head() can handle this
- * correctly (more details refer to the comment above compound_head()).
+ * See Documentation/vm/vmemmap_dedup.rst
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch
mm-sparse-vmemmap-refactor-core-of-vmemmap_populate_basepages-to-helper.patch
mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch
mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch
mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch

