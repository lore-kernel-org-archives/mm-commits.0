Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB50C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 06:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358213AbiD0Gor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 02:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352922AbiD0Gop (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 02:44:45 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D833DA41
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 23:41:33 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Kp8Jj6JSnz1JBhG;
        Wed, 27 Apr 2022 14:40:37 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 27 Apr 2022 14:41:31 +0800
Subject: Re: [nacked]
 mm-vmscan-activate-swap-backed-executable-folios-after-first-usage.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
References: <20220427062533.80485C385A7@smtp.kernel.org>
CC:     <mm-commits@vger.kernel.org>, <ying.huang@intel.com>,
        <osalvador@suse.de>, <iamjoonsoo.kim@lge.com>, <hch@lst.de>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <2e567a92-171e-26d5-2830-927c7f2f68a9@huawei.com>
Date:   Wed, 27 Apr 2022 14:41:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220427062533.80485C385A7@smtp.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022/4/27 14:25, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/vmscan: activate swap-backed executable folios after first usage
> has been removed from the -mm tree.  Its filename was
>      mm-vmscan-activate-swap-backed-executable-folios-after-first-usage.patch
> 
> This patch was dropped because it was nacked

Hi Andrew,

Since this patch is nacked, should I resend the whole series with this patch dropped?
And I'd like to change this patch to use the helper folio_is_file_lru too, something like below:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ed484a0e9cd0..60ccbebec4c8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1412,9 +1412,9 @@ static enum page_references folio_check_references(struct folio *folio,
                        return PAGEREF_ACTIVATE;

                /*
-                * Activate executable folios after first usage.
+                * Activate file-backed executable folios after first usage.
                 */
-               if (vm_flags & VM_EXEC)
+               if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
                        return PAGEREF_ACTIVATE;

                return PAGEREF_KEEP;

Should I send this patch separately or resend the whole series with this new change attached?

Many thanks!

> 
> ------------------------------------------------------
> From: Miaohe Lin <linmiaohe@huawei.com>
> Subject: mm/vmscan: activate swap-backed executable folios after first usage
> 
> We should activate swap-backed executable folios (e.g.  tmpfs) after first
> usage so that executable code gets yet better chance to stay in memory.
> 
> Link: https://lkml.kernel.org/r/20220425111232.23182-4-linmiaohe@huawei.com
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> Suggested-by: Huang, Ying <ying.huang@intel.com>
> Reviewed-by: Huang, Ying <ying.huang@intel.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/vmscan.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/vmscan.c~mm-vmscan-activate-swap-backed-executable-folios-after-first-usage
> +++ a/mm/vmscan.c
> @@ -1412,9 +1412,9 @@ static enum page_references folio_check_
>  			return PAGEREF_ACTIVATE;
>  
>  		/*
> -		 * Activate file-backed executable folios after first usage.
> +		 * Activate executable folios after first usage.
>  		 */
> -		if ((vm_flags & VM_EXEC) && !folio_test_swapbacked(folio))
> +		if (vm_flags & VM_EXEC)
>  			return PAGEREF_ACTIVATE;
>  
>  		return PAGEREF_KEEP;
> _
> 
> Patches currently in -mm which might be from linmiaohe@huawei.com are
> 
> mm-shmem-make-shmem_init-return-void.patch
> mm-memcg-remove-unneeded-nr_scanned.patch
> mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch
> mm-memory-failurec-dissolve-truncated-hugetlb-page.patch
> mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
> mm-vmscan-fix-comment-for-current_may_throttle.patch
> mm-vmscan-fix-comment-for-isolate_lru_pages.patch
> mm-z3fold-declare-z3fold_mount-with-__init.patch
> mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
> mm-z3fold-minor-clean-up-for-z3fold_free.patch
> mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
> mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
> mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
> mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
> mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
> mm-compaction-use-helper-isolation_suitable.patch
> drivers-base-nodec-fix-compaction-sysfs-file-leak.patch
> mm-mempolicy-clean-up-the-code-logic-in-queue_pages_pte_range.patch
> mm-migration-remove-unneeded-local-variable-mapping_locked.patch
> mm-migration-remove-unneeded-local-variable-page_lru.patch
> mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
> mm-migration-use-helper-macro-min-in-do_pages_stat.patch
> mm-migration-avoid-unneeded-nodemask_t-initialization.patch
> mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
> mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
> mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
> mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch
> mm-madvise-fix-potential-pte_unmap_unlock-pte-error.patch
> mm-mmapc-use-helper-mlock_future_check.patch
> mm-mremap-use-helper-mlock_future_check.patch
> mm-mremap-avoid-unneeded-do_munmap-call.patch
> mm-compaction-remove-unneeded-return-value-of-kcompactd_run.patch
> mm-compaction-remove-unneeded-pfn-update.patch
> mm-compaction-remove-unneeded-assignment-to-isolate_start_pfn.patch
> mm-compaction-clean-up-comment-for-sched-contention.patch
> mm-compaction-clean-up-comment-about-suitable-migration-target-recheck.patch
> mm-compaction-use-compact_cluster_max-in-compactionc.patch
> mm-compaction-use-helper-compound_nr-in-isolate_migratepages_block.patch
> mm-compaction-clean-up-comment-about-async-compaction-in-isolate_migratepages.patch
> mm-compaction-avoid-possible-null-pointer-dereference-in-kcompactd_cpu_online.patch
> mm-compaction-make-compaction_zonelist_suitable-return-false-when-compact_success.patch
> mm-compaction-simplify-the-code-in-__compact_finished.patch
> mm-compaction-make-sure-highest-is-above-the-min_pfn.patch
> mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
> mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
> mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
> mm-migration-reduce-the-rcu-lock-duration.patch
> mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
> mm-migration-return-errno-when-isolate_huge_page-failed.patch
> mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
> mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
> mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
> mm-vmscan-introduce-helper-function-reclaim_page_list.patch
> mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
> mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
> mm-vmscan-use-helper-folio_is_file_lru.patch
> 
> .
> 

