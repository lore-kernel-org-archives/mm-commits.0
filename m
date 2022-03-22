Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A687DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiCVTOF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCVTOE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:14:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7353D8F9B3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D13861658
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64980C340EC;
        Tue, 22 Mar 2022 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976355;
        bh=H82V/RjEhCiocqbvM3VhHcepYlwS0OlnUGkvNCEZIas=;
        h=Date:To:From:Subject:From;
        b=pHJae/06Z8SZ677zLOnKxCE390dHcU1tkPLnh7nDIKHXCdI/Zv0QDOBy2R5npI6RO
         Fwpb+P51N/pnofSJgtFaO6Wu/DBOFF5kmXADTnKtAPz5z8V/N4pA3z34KiZRFhPfcK
         yof7rGcMgbulG/AWRqnOM+pGkLtNIUOjIwGhCYAc=
Date:   Tue, 22 Mar 2022 12:12:34 -0700
To:     mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com,
        joao.m.martins@oracle.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page-fix.patch removed from -mm tree
Message-Id: <20220322191235.64980C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page-fix.patch

This patch was dropped because it was folded into mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page-fix

restore lost comment changes

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   42 +++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page-fix
+++ a/mm/hugetlb_vmemmap.c
@@ -124,9 +124,9 @@
  * page of page structs (page 0) associated with the HugeTLB page contains the 4
  * page structs necessary to describe the HugeTLB. The only use of the remaining
  * pages of page structs (page 1 to page 7) is to point to page->compound_head.
- * Therefore, we can remap pages 2 to 7 to page 1. Only 2 pages of page structs
+ * Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of page structs
  * will be used for each HugeTLB page. This will allow us to free the remaining
- * 6 pages to the buddy allocator.
+ * 7 pages to the buddy allocator.
  *
  * Here is how things look after remapping.
  *
@@ -134,30 +134,30 @@
  * +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
  * |           |                     |     0     | -------------> |     0     |
  * |           |                     +-----------+                +-----------+
- * |           |                     |     1     | -------------> |     1     |
- * |           |                     +-----------+                +-----------+
- * |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- * |           |                     +-----------+                   | | | | |
- * |           |                     |     3     | ------------------+ | | | |
- * |           |                     +-----------+                     | | | |
- * |           |                     |     4     | --------------------+ | | |
- * |    PMD    |                     +-----------+                       | | |
- * |   level   |                     |     5     | ----------------------+ | |
- * |  mapping  |                     +-----------+                         | |
- * |           |                     |     6     | ------------------------+ |
- * |           |                     +-----------+                           |
- * |           |                     |     7     | --------------------------+
+ * |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
+ * |           |                     +-----------+                  | | | | | |
+ * |           |                     |     2     | -----------------+ | | | | |
+ * |           |                     +-----------+                    | | | | |
+ * |           |                     |     3     | -------------------+ | | | |
+ * |           |                     +-----------+                      | | | |
+ * |           |                     |     4     | ---------------------+ | | |
+ * |    PMD    |                     +-----------+                        | | |
+ * |   level   |                     |     5     | -----------------------+ | |
+ * |  mapping  |                     +-----------+                          | |
+ * |           |                     |     6     | -------------------------+ |
+ * |           |                     +-----------+                            |
+ * |           |                     |     7     | ---------------------------+
  * |           |                     +-----------+
  * |           |
  * |           |
  * |           |
  * +-----------+
  *
- * When a HugeTLB is freed to the buddy system, we should allocate 6 pages for
+ * When a HugeTLB is freed to the buddy system, we should allocate 7 pages for
  * vmemmap pages and restore the previous mapping relationship.
  *
  * For the HugeTLB page of the pud level mapping. It is similar to the former.
- * We also can use this approach to free (PAGE_SIZE - 2) vmemmap pages.
+ * We also can use this approach to free (PAGE_SIZE - 1) vmemmap pages.
  *
  * Apart from the HugeTLB page of the pmd/pud level mapping, some architectures
  * (e.g. aarch64) provides a contiguous bit in the translation table entries
@@ -166,7 +166,13 @@
  *
  * The contiguous bit is used to increase the mapping size at the pmd and pte
  * (last) level. So this type of HugeTLB page can be optimized only when its
- * size of the struct page structs is greater than 2 pages.
+ * size of the struct page structs is greater than 1 page.
+ *
+ * Notice: The head vmemmap page is not freed to the buddy allocator and all
+ * tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
+ * more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
+ * associated with each HugeTLB page. The compound_head() can handle this
+ * correctly (more details refer to the comment above compound_head()).
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch
mm-introduce-kmem_cache_alloc_lru.patch
fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch
fs-allocate-inode-by-using-alloc_inode_sb.patch
f2fs-allocate-inode-by-using-alloc_inode_sb.patch
mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch
xarray-use-kmem_cache_alloc_lru-to-allocate-xa_node.patch
mm-memcontrol-move-memcg_online_kmem-to-mem_cgroup_css_online.patch
mm-list_lru-allocate-list_lru_one-only-when-needed.patch
mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus.patch
mm-list_lru-replace-linear-array-with-xarray.patch
mm-memcontrol-reuse-memory-cgroup-id-for-kmem-id.patch
mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch
mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch
mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id.patch
mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

