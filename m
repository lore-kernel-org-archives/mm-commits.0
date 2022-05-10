Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3947C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiEJEPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiEJEOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04A023885A
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F4F661737
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2319C385C5;
        Tue, 10 May 2022 04:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155835;
        bh=BDW6WU82DxB8tipZfKN94sSPdP7JGZYzCQgiJnWvfUo=;
        h=Date:To:From:Subject:From;
        b=WhcPrSC8p+sGNaAksFhYyK8gjBMI/MN/ld3Q4WZLgtNGxC1TxE9kQXK3veWT/9mUv
         c3wYO7cIslDCYRVJ7mYmU+NgUmGEX/mGYj3e91TYpfxJgY3wFevvlWbQWzE3F1UbVV
         XTYT+2EFKWq2jl1yfQDxK6xxYVQLfNZNEYKzJ1Dc=
Date:   Mon, 09 May 2022 21:10:35 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        hughd@google.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-make-shmem_init-return-void.patch removed from -mm tree
Message-Id: <20220510041035.D2319C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: shmem: make shmem_init return void
has been removed from the -mm tree.  Its filename was
     mm-shmem-make-shmem_init-return-void.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: shmem: make shmem_init return void

The return value of shmem_init is never used.  So we can make it return
void now.

[akpm@linux-foundation.org: remove `return;' from void-returning function, per Muchun Song]
Link: https://lkml.kernel.org/r/20220328112707.22217-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 mm/shmem.c               |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-make-shmem_init-return-void
+++ a/include/linux/shmem_fs.h
@@ -56,7 +56,7 @@ static inline struct shmem_inode_info *S
  * Functions in mm/shmem.c called directly from elsewhere:
  */
 extern const struct fs_parameter_spec shmem_fs_parameters[];
-extern int shmem_init(void);
+extern void shmem_init(void);
 extern int shmem_init_fs_context(struct fs_context *fc);
 extern struct file *shmem_file_setup(const char *name,
 					loff_t size, unsigned long flags);
--- a/mm/shmem.c~mm-shmem-make-shmem_init-return-void
+++ a/mm/shmem.c
@@ -3888,7 +3888,7 @@ static struct file_system_type shmem_fs_
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
-int __init shmem_init(void)
+void __init shmem_init(void)
 {
 	int error;
 
@@ -3913,14 +3913,13 @@ int __init shmem_init(void)
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
 #endif
-	return 0;
+	return;
 
 out1:
 	unregister_filesystem(&shmem_fs_type);
 out2:
 	shmem_destroy_inodecache();
 	shm_mnt = ERR_PTR(error);
-	return error;
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
@@ -3998,14 +3997,12 @@ static struct file_system_type shmem_fs_
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
-int __init shmem_init(void)
+void __init shmem_init(void)
 {
 	BUG_ON(register_filesystem(&shmem_fs_type) != 0);
 
 	shm_mnt = kern_mount(&shmem_fs_type);
 	BUG_ON(IS_ERR(shm_mnt));
-
-	return 0;
 }
 
 int shmem_unuse(unsigned int type)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-migration-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
mm-vmscan-use-helper-folio_is_file_lru-fix.patch
mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead.patch
mm-swap-use-helper-macro-__attr_rw.patch
mm-swap-fold-__swap_info_get-into-its-sole-caller.patch
mm-swap-remove-unneeded-return-value-of-free_swap_slot.patch
mm-swap-print-bad-swap-offset-entry-in-get_swap_device.patch
mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache.patch
mm-swap-remove-unneeded-p-=-null-check-in-__swap_duplicate.patch
mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch
mm-swap-add-helper-swap_offset_available.patch
mm-swap-fix-the-obsolete-comment-for-swp_type_shift.patch
mm-swap-clean-up-the-comment-of-find_next_to_unuse.patch
mm-swap-fix-the-comment-of-get_kernel_pages.patch
mm-swap-fix-comment-about-swap-extent.patch

