Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545E4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiESWZw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245440AbiESWZn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651F8663C5
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E5BFB828C3
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FF7C385AA;
        Thu, 19 May 2022 22:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999137;
        bh=Lv7lxBys6/a8AZTP6PIBwzVRLGFRur2OX2uMXB3U/WY=;
        h=Date:To:From:Subject:From;
        b=yTBux2/LuEiCZVtnnToPdrs+ACsuuAWpvDmklEjgAEkI3X0eZ04017KH+VUaF5cDO
         Gx7cUyXVm14bghvoA5jX+/D17mkYd7vu6Vw8F4ichMdhXIyg333tLyZCv+gLEEK8hW
         0NW5dolOLhBu8kX/x+fLPJEL2JnWbhdVVe0OkyO4=
Date:   Thu, 19 May 2022 15:25:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-unneeded-return-value-of-free_swap_slot.patch removed from -mm tree
Message-Id: <20220519222537.93FF7C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: remove unneeded return value of free_swap_slot
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unneeded-return-value-of-free_swap_slot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: remove unneeded return value of free_swap_slot

The return value of free_swap_slot is always 0 and also ignored now. 
Remove it to clean up the code.

Link: https://lkml.kernel.org/r/20220509131416.17553-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

 include/linux/swap_slots.h |    2 +-
 mm/swap_slots.c            |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/swap_slots.h~mm-swap-remove-unneeded-return-value-of-free_swap_slot
+++ a/include/linux/swap_slots.h
@@ -24,7 +24,7 @@ struct swap_slots_cache {
 void disable_swap_slots_cache_lock(void);
 void reenable_swap_slots_cache_unlock(void);
 void enable_swap_slots_cache(void);
-int free_swap_slot(swp_entry_t entry);
+void free_swap_slot(swp_entry_t entry);
 
 extern bool swap_slot_cache_enabled;
 
--- a/mm/swap_slots.c~mm-swap-remove-unneeded-return-value-of-free_swap_slot
+++ a/mm/swap_slots.c
@@ -269,7 +269,7 @@ static int refill_swap_slots_cache(struc
 	return cache->nr;
 }
 
-int free_swap_slot(swp_entry_t entry)
+void free_swap_slot(swp_entry_t entry)
 {
 	struct swap_slots_cache *cache;
 
@@ -297,8 +297,6 @@ int free_swap_slot(swp_entry_t entry)
 direct_free:
 		swapcache_free_entries(&entry, 1);
 	}
-
-	return 0;
 }
 
 swp_entry_t folio_alloc_swap(struct folio *folio)
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

