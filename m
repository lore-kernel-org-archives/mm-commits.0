Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8076DC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Mar 2022 00:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiCCAMl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiCCAMb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 19:12:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F93C1171
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 16:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEF6361B27
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 23:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02790C004E1;
        Wed,  2 Mar 2022 23:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646263416;
        bh=XDKzSJxMG9/JiT5IJMTh7y4n7eXin+EEWF9EutmMONQ=;
        h=Date:To:From:Subject:From;
        b=e3lRSFSBDAboRjHRrVB1mh8u5SZO4gqxJp4CCsmUeZng5tZtphIw9zD6KgLMSJBa5
         nbWJt0N1f3SMphWHH1V5kIKWlEhaxmnkkXnvHp3zdlVLnyKdUziHP32cSjKQ0V37Cx
         iYbKtro9sYomrhnZEsHpL7A3XcQXA0KQcvkX7NmU=
Date:   Wed, 02 Mar 2022 15:23:35 -0800
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        xiyuyang19@fudan.edu.cn, willy@infradead.org,
        viro@zeniv.linux.org.uk, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jack@suse.cz, hughd@google.com,
        hch@infradead.org, duanxiongchun@bytedance.com,
        dan.j.williams@intel.com, apopple@nvidia.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-cache-flush-on-thp-pages.patch added to -mm tree
Message-Id: <20220302232336.02790C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: fix cache flush on THP pages
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-cache-flush-on-thp-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-cache-flush-on-thp-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-cache-flush-on-thp-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: rmap: fix cache flush on THP pages

Patch series "Fix some bugs related to rmap and dax", v4.

Patches 1-2 fix a cache flush bug.  Because subsequent patches depend on
those changes, they are placed in this series.  Patches 3-4 are
preparation for fixing a dax bug in patch 5.  Patch 6 is a code cleanup
since the previous patch removed the usage of follow_invalidate_pte().


This patch (of 6):

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page. 
Replace it with flush_cache_range() to fix this issue.  At least, no
problems were found due to this.  Maybe because the architectures that
have virtual indexed caches is less.

Link: https://lkml.kernel.org/r/20220302082718.32268-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220302082718.32268-2-songmuchun@bytedance.com
Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-cache-flush-on-thp-pages
+++ a/mm/rmap.c
@@ -968,7 +968,8 @@ static bool page_mkclean_one(struct foli
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
 				continue;
 
-			flush_cache_page(vma, address, folio_pfn(folio));
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
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
mm-rmap-fix-cache-flush-on-thp-pages.patch
dax-fix-cache-flush-on-pmd-mapped-pages.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
mm-remove-range-parameter-from-follow_invalidate_pte.patch

