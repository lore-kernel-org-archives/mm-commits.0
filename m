Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646A3C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245497AbiESWZ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245451AbiESWZn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A666699
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 620106166C
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B10C34113;
        Thu, 19 May 2022 22:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999139;
        bh=NVW9jTcht38CRpxX0ohBE/LxQyw3+FvIk8Gakip+Ys8=;
        h=Date:To:From:Subject:From;
        b=IQa6gAnYk6ox/sp0UuOiwJ8U2XUsk/3ds4nzre59pa55kXhaGjB3bzhWMSYsoXFwt
         LodBt2ZhSMkNODg4YDfhFOXUFlQtJK87xX4zzODlOten/ZryBO+g7NIXgmiSSLzejw
         kIVtQ4IQ7dbujmqJ12kn4mUErTyICaKxKjA9upWE=
Date:   Thu, 19 May 2022 15:25:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache.patch removed from -mm tree
Message-Id: <20220519222539.B6B10C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: remove buggy cache->nr check in refill_swap_slots_cache
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: remove buggy cache->nr check in refill_swap_slots_cache

refill_swap_slots_cache is always called when cache->nr is 0.  So remove
such buggy and confusing check.

Link: https://lkml.kernel.org/r/20220509131416.17553-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_slots.c~mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache
+++ a/mm/swap_slots.c
@@ -258,7 +258,7 @@ out_unlock:
 /* called with swap slot cache's alloc lock held */
 static int refill_swap_slots_cache(struct swap_slots_cache *cache)
 {
-	if (!use_swap_slot_cache || cache->nr)
+	if (!use_swap_slot_cache)
 		return 0;
 
 	cache->cur = 0;
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
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch
mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

