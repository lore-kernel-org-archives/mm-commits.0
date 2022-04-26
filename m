Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6F6C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 07:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbiDZHOZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 03:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343716AbiDZHOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 03:14:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5919A1A819
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 00:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650957051; x=1682493051;
  h=message-id:subject:from:to:date:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Hl8yAFQOudWVjHgDscwCxkVhIkTk1aF0FZc+nO2q5Zo=;
  b=kzSkLNrV6Kjc8OI9MFd8bNBM2+JM72bkOynMJGdYBuOOa6EK4EEOJU+m
   +ncVyxnMbAGsDPVER9gVq1+Q4YOGE085OhOu9ChiBj2ur/B3anmbI+YSZ
   nFb8cLudDjnLU34xMweYsYf97ZD0Pi9KjiD25UlOBkfN0HjDSni33Xqbm
   aE5pTkHDMgW5BqaUOB+PiIRniBZpDiXarlSMI4e/XKi5trjHTwMBfCPtZ
   3Oq6r6uOn98DZSVbkYgxh1mzMM4hIWMklYIT+utjhqXR4rKFsXfJmtImO
   s6Y9nandj4MI4kksKpcJcOe+tGy8QiAOfq7XtlrGcxdY1SpuC1teNNRFE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="245403162"
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="245403162"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 00:10:47 -0700
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="579726893"
Received: from yyu16-mobl.ccr.corp.intel.com ([10.254.212.128])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 00:10:41 -0700
Message-ID: <d6f0824dd1f01fe9aebf122bfeb5940babc93c69.camel@intel.com>
Subject: Re: + mm-migration-reduce-the-rcu-lock-duration.patch added to -mm
 tree
From:   "ying.huang@intel.com" <ying.huang@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hch@lst.de, dhowells@redhat.com,
        david@redhat.com, cl@linux.com, linmiaohe@huawei.com
Date:   Tue, 26 Apr 2022 15:10:36 +0800
In-Reply-To: <20220425191047.F235FC385A7@smtp.kernel.org>
References: <20220425191047.F235FC385A7@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi, Andrew,

On Mon, 2022-04-25 at 12:10 -0700, Andrew Morton wrote:
> The patch titled
>      Subject: mm/migration: reduce the rcu lock duration
> has been added to the -mm tree.  Its filename is
>      mm-migration-reduce-the-rcu-lock-duration.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-reduce-the-rcu-lock-duration.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-reduce-the-rcu-lock-duration.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Miaohe Lin <linmiaohe@huawei.com>
> Subject: mm/migration: reduce the rcu lock duration
> 
> Patch series "A few cleanup and fixup patches for migration", v2.
> 
> This series contains a few patches to remove unneeded lock page and
> PageMovable check, reduce the rcu lock duration.  Also we fix potential
> pte_unmap on an not mapped pte.  More details can be found in the
> respective changelogs.
> 
> 
> This patch (of 4):
> 
> rcu_read_lock is required by grabbing the task refcount but it's not
> needed for ptrace_may_access.  So we could release the rcu lock after task
> refcount is successfully grabbed to reduce the rcu holding time.
> 
> Link: https://lkml.kernel.org/r/20220425132723.34824-1-linmiaohe@huawei.com
> Link: https://lkml.kernel.org/r/20220425132723.34824-2-linmiaohe@huawei.com
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I think that there is still a remaining issue to be addressed for this
patch as in the following threads,

https://lore.kernel.org/linux-mm/8735ju7as9.fsf@yhuang6-desk2.ccr.corp.intel.com/
https://lore.kernel.org/lkml/34f3aff7-0111-a8d6-a559-92bf6d0bd62a@huawei.com/

Best Regards,
Huang, Ying

> ---
> 
>  mm/migrate.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/mm/migrate.c~mm-migration-reduce-the-rcu-lock-duration
> +++ a/mm/migrate.c
> @@ -1902,17 +1902,16 @@ static struct mm_struct *find_mm_struct(
>  		return ERR_PTR(-ESRCH);
>  	}
>  	get_task_struct(task);
> +	rcu_read_unlock();
>  
> 
> 
> 
>  	/*
>  	 * Check if this process has the right to modify the specified
>  	 * process. Use the regular "ptrace_may_access()" checks.
>  	 */
>  	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
> -		rcu_read_unlock();
>  		mm = ERR_PTR(-EPERM);
>  		goto out;
>  	}
> -	rcu_read_unlock();
>  
> 
> 
> 
>  	mm = ERR_PTR(security_task_movememory(task));
>  	if (IS_ERR(mm))
> _
> 
> Patches currently in -mm which might be from linmiaohe@huawei.com are
> 
> mm-shmem-make-shmem_init-return-void.patch
> mm-memcg-remove-unneeded-nr_scanned.patch
> mm-mmapc-use-helper-mlock_future_check.patch
> mm-mremap-use-helper-mlock_future_check.patch
> mm-mremap-avoid-unneeded-do_munmap-call.patch
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
> mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
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
> mm-migration-reduce-the-rcu-lock-duration.patch
> mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
> mm-migration-return-errno-when-isolate_huge_page-failed.patch
> mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
> 


