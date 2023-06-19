Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4803FEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjFSXXj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjFSXWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697F910DC
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BAAF60F56
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BACBC433C9;
        Mon, 19 Jun 2023 23:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216913;
        bh=s7TJz0S8ebvi9yXFfE2guWn89vaSXvvYxQw4kMrzgjs=;
        h=Date:To:From:Subject:From;
        b=pCp9CDPb415ZUWcfw6B5wuobdGmo8znLNfUu0QYo4sRZhNq+gPFhjt9dSXm5jDywv
         lNTI/pjLiil127oxt7lrz7dOHoluPVlJ87RaYXqW4m7Jige9ZnRtlkoty61yKS1xef
         alBVlsff+Jc/hJ8heAdEJKEv8JtARs8fNGMRkqok=
Date:   Mon, 19 Jun 2023 16:21:53 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-clean-up-force_shm_swapin_readahead.patch removed from -mm tree
Message-Id: <20230619232153.9BACBC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: clean up force_shm_swapin_readahead()
has been removed from the -mm tree.  Its filename was
     mm-madvise-clean-up-force_shm_swapin_readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/madvise: clean up force_shm_swapin_readahead()
Date: Thu, 8 Jun 2023 18:35:14 -0700 (PDT)

Some nearby MADV_WILLNEED cleanup unrelated to pte_offset_map_lock(). 
shmem_swapin_range() is a better name than force_shm_swapin_readahead(). 
Fix unimportant off-by-one on end_index.  Call the swp_entry_t "entry"
rather than "swap": either is okay, but entry is the name used elsewhere
in mm/madvise.c.  Do not assume GFP_HIGHUSER_MOVABLE: that's right for
anon swap, but shmem should take gfp from mapping.  Pass the actual vma
and address to read_swap_cache_async(), in case a NUMA mempolicy applies. 
lru_add_drain() at outer level, like madvise_willneed()'s other branch.

Link: https://lkml.kernel.org/r/67e18875-ffb3-ec27-346-f350e07bed87@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/mm/madvise.c~mm-madvise-clean-up-force_shm_swapin_readahead
+++ a/mm/madvise.c
@@ -235,30 +235,34 @@ static const struct mm_walk_ops swapin_w
 	.pmd_entry		= swapin_walk_pmd_entry,
 };
 
-static void force_shm_swapin_readahead(struct vm_area_struct *vma,
+static void shmem_swapin_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		struct address_space *mapping)
 {
 	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
-	pgoff_t end_index = linear_page_index(vma, end + PAGE_SIZE - 1);
+	pgoff_t end_index = linear_page_index(vma, end) - 1;
 	struct page *page;
 	struct swap_iocb *splug = NULL;
 
 	rcu_read_lock();
 	xas_for_each(&xas, page, end_index) {
-		swp_entry_t swap;
+		unsigned long addr;
+		swp_entry_t entry;
 
 		if (!xa_is_value(page))
 			continue;
-		swap = radix_to_swp_entry(page);
+		entry = radix_to_swp_entry(page);
 		/* There might be swapin error entries in shmem mapping. */
-		if (non_swap_entry(swap))
+		if (non_swap_entry(entry))
 			continue;
+
+		addr = vma->vm_start +
+			((xas.xa_index - vma->vm_pgoff) << PAGE_SHIFT);
 		xas_pause(&xas);
 		rcu_read_unlock();
 
-		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
-					     NULL, 0, false, &splug);
+		page = read_swap_cache_async(entry, mapping_gfp_mask(mapping),
+					     vma, addr, false, &splug);
 		if (page)
 			put_page(page);
 
@@ -266,8 +270,6 @@ static void force_shm_swapin_readahead(s
 	}
 	rcu_read_unlock();
 	swap_read_unplug(splug);
-
-	lru_add_drain();	/* Push any new pages onto the LRU now */
 }
 #endif		/* CONFIG_SWAP */
 
@@ -291,8 +293,8 @@ static long madvise_willneed(struct vm_a
 	}
 
 	if (shmem_mapping(file->f_mapping)) {
-		force_shm_swapin_readahead(vma, start, end,
-					file->f_mapping);
+		shmem_swapin_range(vma, start, end, file->f_mapping);
+		lru_add_drain(); /* Push any new pages onto the LRU now */
 		return 0;
 	}
 #else
_

Patches currently in -mm which might be from hughd@google.com are


