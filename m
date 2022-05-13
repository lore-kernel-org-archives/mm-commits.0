Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E506C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 22:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiEMWRk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 18:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiEMWRh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 18:17:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD43766E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 15:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCAF61026
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 22:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E38C34100;
        Fri, 13 May 2022 22:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652480255;
        bh=cmD+Vj6dE5/cwd5byw3egY5qlWtwSgnvZMkxuhpvaZU=;
        h=Date:To:From:Subject:From;
        b=zLh0yza4BF8g7ogkafr+V68Owg8QavK5x9r8YAEvrDJS0njcGPh14ebcTtGK5zjdQ
         lZkvHROoy39Oe7wnjWtdw4YQaCr+Yc7vU1cHwcMrclOFIY16myalhy27oO6BVNoAvN
         45XGpLI+7Z/4CwZYropnRTO5Tbru6U49krGnuH1Q=
Date:   Fri, 13 May 2022 15:17:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        naoya.horiguchi@nec.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-swap-break-the-loop-if-matching-device-is-found.patch removed from -mm tree
Message-Id: <20220513221735.25E38C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: break the loop if matching device is found
has been removed from the -mm tree.  Its filename was
     mm-swap-break-the-loop-if-matching-device-is-found.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: break the loop if matching device is found

We can break the loop if matching device is found to save some possible
cpu cycles because there should be only one matching device and there is
no need to continue if the matching one is already found.

Link: https://lkml.kernel.org/r/20220509131416.17553-11-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swapfile.c~mm-swap-break-the-loop-if-matching-device-is-found
+++ a/mm/swapfile.c
@@ -1691,6 +1691,8 @@ int swap_type_of(dev_t device, sector_t
 				spin_unlock(&swap_lock);
 				return type;
 			}
+
+			break;
 		}
 	}
 	spin_unlock(&swap_lock);
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

