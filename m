Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79945C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiEJEPu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiEJEPd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47FD483A9
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D81C61735
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8254FC385A6;
        Tue, 10 May 2022 04:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155872;
        bh=QQYacQqTA3CRG/IDQAoPTwv5BQ7qhTvY46he9sx6KUc=;
        h=Date:To:From:Subject:From;
        b=P+n5bsPsa82valGl9MqopTg8OxAJRPuC8wP7GFj+sCRToSb+X5AyYIhmFt23SKNUO
         fr7141FmHdVSDO2GS9RT68R7a9sEXS0k0Cotzo7Ip4whkAh2OwNotg2kjUedGpyyyt
         Gn584UPoitD/3AZh6X7zQT2oPrqHaCiab3Qm9C84=
Date:   Mon, 09 May 2022 21:11:11 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-declare-z3fold_mount-with-__init.patch removed from -mm tree
Message-Id: <20220510041112.8254FC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: declare z3fold_mount with __init
has been removed from the -mm tree.  Its filename was
     mm-z3fold-declare-z3fold_mount-with-__init.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: declare z3fold_mount with __init

Patch series "A few cleanup patches for z3fold", v2.

This series contains a few patches to simplify the code, remove unneeded
code, fix obsolete comment and so on.  More details can be found in the
respective changelogs.


This patch (of 8):

z3fold_mount is only called during init.  So we should declare it with
__init.

Link: https://lkml.kernel.org/r/20220308134311.59086-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220308134311.59086-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-declare-z3fold_mount-with-__init
+++ a/mm/z3fold.c
@@ -345,7 +345,7 @@ static struct file_system_type z3fold_fs
 };
 
 static struct vfsmount *z3fold_mnt;
-static int z3fold_mount(void)
+static int __init z3fold_mount(void)
 {
 	int ret = 0;
 
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

