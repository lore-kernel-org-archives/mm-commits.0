Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB95C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245452AbiESW0S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245479AbiESWZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF1FB35
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D83C616A0
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040AFC385AA;
        Thu, 19 May 2022 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999143;
        bh=Ua1rsvIs1hWbP+PB274rH6ZVYi6ZmhH8jc/HCezQKJA=;
        h=Date:To:From:Subject:From;
        b=iDtfkmOAVHVkvSt4ElCkJF24cAAVOS+GMGqgudY3jKZNw4Kh5RaRZCnNiEQ/N7Qtq
         x3JeFwly6HVkF4Td267uLCR5Ro94DPtwJoOEAB0FAe2XbJEfF34CQ+ah+pJncAWP6A
         XAxtfiFpqrvOG+PFFPdBnS8VrNZhaFZz1BUoP6EU=
Date:   Thu, 19 May 2022 15:25:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch removed from -mm tree
Message-Id: <20220519222543.040AFC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: avoid calling swp_swap_info when try to check SWP_STABLE_WRITES
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: avoid calling swp_swap_info when try to check SWP_STABLE_WRITES

Use flags of si directly to check SWP_STABLE_WRITES to avoid possible
READ_ONCE and thus save some cpu cycles.

[akpm@linux-foundation.org: use data_race() on si->flags, per Neil]
Link: https://lkml.kernel.org/r/20220509131416.17553-10-linmiaohe@huawei.com
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

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes
+++ a/mm/memory.c
@@ -3889,7 +3889,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 */
 			exclusive = true;
 		} else if (exclusive && PageWriteback(page) &&
-			  (swp_swap_info(entry)->flags & SWP_STABLE_WRITES)) {
+			  data_race(si->flags & SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
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

