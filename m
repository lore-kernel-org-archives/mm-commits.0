Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFE9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbiESW0R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245481AbiESWZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2E5FCC
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71CFCB828C0
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17502C385B8;
        Thu, 19 May 2022 22:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999144;
        bh=+V92rSgsAjTloVaOsNJYg1mAbn41NpYR0CTKTM4uFyg=;
        h=Date:To:From:Subject:From;
        b=yx79My8rVzr8vQ1fTQykVjpQRkeQPXKxHckrUyICjfq9aqNmLyMTRoQ87lP3249nO
         X3bNIA/3PkY6rSAlFKW7Ja06faIvodF9g8H3/zqLO/3LKEJhDCdCMweWacsnaWOUPX
         oC5p8Pl7EVJSwEtrQ3vgV8R5FcxNObvWjnwmoaKQ=
Date:   Thu, 19 May 2022 15:25:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-add-helper-swap_offset_available.patch removed from -mm tree
Message-Id: <20220519222544.17502C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: add helper swap_offset_available()
has been removed from the -mm tree.  Its filename was
     mm-swap-add-helper-swap_offset_available.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: add helper swap_offset_available()

Add helper swap_offset_available() to remove some duplicated codes.  Minor
readability improvement.

[akpm@linux-foundation.org: s/swap_offset_available/swap_offset_available_and_locked/, per Neil]
Link: https://lkml.kernel.org/r/20220509131416.17553-12-linmiaohe@huawei.com
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
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/mm/swapfile.c~mm-swap-add-helper-swap_offset_available
+++ a/mm/swapfile.c
@@ -775,6 +775,22 @@ static void set_cluster_next(struct swap
 	this_cpu_write(*si->cluster_next_cpu, next);
 }
 
+static bool swap_offset_available_and_locked(struct swap_info_struct *si,
+					     unsigned long offset)
+{
+	if (data_race(!si->swap_map[offset])) {
+		spin_lock(&si->lock);
+		return true;
+	}
+
+	if (vm_swap_full() && READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
+		spin_lock(&si->lock);
+		return true;
+	}
+
+	return false;
+}
+
 static int scan_swap_map_slots(struct swap_info_struct *si,
 			       unsigned char usage, int nr,
 			       swp_entry_t slots[])
@@ -952,15 +968,8 @@ done:
 scan:
 	spin_unlock(&si->lock);
 	while (++offset <= READ_ONCE(si->highest_bit)) {
-		if (data_race(!si->swap_map[offset])) {
-			spin_lock(&si->lock);
-			goto checks;
-		}
-		if (vm_swap_full() &&
-		    READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
-			spin_lock(&si->lock);
+		if (swap_offset_available_and_locked(si, offset))
 			goto checks;
-		}
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
@@ -969,15 +978,8 @@ scan:
 	}
 	offset = si->lowest_bit;
 	while (offset < scan_base) {
-		if (data_race(!si->swap_map[offset])) {
-			spin_lock(&si->lock);
+		if (swap_offset_available_and_locked(si, offset))
 			goto checks;
-		}
-		if (vm_swap_full() &&
-		    READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
-			spin_lock(&si->lock);
-			goto checks;
-		}
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
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

