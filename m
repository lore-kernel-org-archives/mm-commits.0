Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BDFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357830AbiEMTW1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383746AbiEMTWS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB6339B8C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE41DCE3301
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A353C34100;
        Fri, 13 May 2022 19:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469695;
        bh=3yvO/kb3stld6x+ELIs6C9P+zuk6s7qDYNSJ9gZ1OVw=;
        h=Date:To:From:Subject:From;
        b=BJBd1i4VlJ/+hgkO58uWbiJQoe8+8sFOd2IjYj2r6HxXeJdylO280/nwtPlnt86YP
         N90Zq85FSR0vg1Cw9DPjNOoXcPqRLbHfnfaMrN6ybePdnYyP+Y1xSKnsRANXpFkBjv
         G+PBWRUus88Xt2P38X1qoZtQL5SlYVeo416MnQrw=
Date:   Fri, 13 May 2022 12:21:34 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, iamjoonsoo.kim@lge.com, hch@lst.de,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch removed from -mm tree
Message-Id: <20220513192135.1A353C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: take all base pages of THP into account when race with speculative reference
has been removed from the -mm tree.  Its filename was
     mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: take all base pages of THP into account when race with speculative reference

If the page has buffers, shrink_page_list will try to free the buffer
mappings associated with the page and try to free the page as well.  In
the rare race with speculative reference, the page will be freed shortly
by speculative reference.  But nr_reclaimed is not incremented correctly
when we come across the THP.  We need to account all the base pages in
this case.

Link: https://lkml.kernel.org/r/20220425111232.23182-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference
+++ a/mm/vmscan.c
@@ -1884,7 +1884,7 @@ retry:
 					 * increment nr_reclaimed here (and
 					 * leave it off the LRU).
 					 */
-					nr_reclaimed++;
+					nr_reclaimed += nr_pages;
 					continue;
 				}
 			}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

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

