Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3D9C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245549AbiESW0W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245483AbiESWZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C968A9FFD
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 757C4B828AF
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24563C34113;
        Thu, 19 May 2022 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999145;
        bh=0hutBuYXlfLgjpXjouM3N5PMtS9nOjW7TjDTbWyR3cw=;
        h=Date:To:From:Subject:From;
        b=iJWyre0ulJZljcIGfi4rGVwlrJtNmbI2Hrv5cSHF3TUZF7nIvREQety3IqtHZK+uV
         9PxuanH67F/YhKxyYBrM+1u4yb19QfEDWQ0ScQgf33pZKWg+H92fu+MKBB58oTHwMX
         GHIgnoZ93Mlbn6pcmcibP47odrPgi0kkiz86IdyQ=
Date:   Thu, 19 May 2022 15:25:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-the-obsolete-comment-for-swp_type_shift.patch removed from -mm tree
Message-Id: <20220519222545.24563C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: fix the obsolete comment for SWP_TYPE_SHIFT
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-the-obsolete-comment-for-swp_type_shift.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: fix the obsolete comment for SWP_TYPE_SHIFT

Since commit 3159f943aafd ("xarray: Replace exceptional entries"), there
is only one bit of 'type' can be shifted up.  Update the corresponding
comment.

Link: https://lkml.kernel.org/r/20220509131416.17553-13-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
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

 include/linux/swapops.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/swapops.h~mm-swap-fix-the-obsolete-comment-for-swp_type_shift
+++ a/include/linux/swapops.h
@@ -13,10 +13,10 @@
  * get good packing density in that tree, so the index should be dense in
  * the low-order bits.
  *
- * We arrange the `type' and `offset' fields so that `type' is at the seven
+ * We arrange the `type' and `offset' fields so that `type' is at the six
  * high-order bits of the swp_entry_t and `offset' is right-aligned in the
  * remaining bits.  Although `type' itself needs only five bits, we allow for
- * shmem/tmpfs to shift it all up a further two bits: see swp_to_radix_entry().
+ * shmem/tmpfs to shift it all up a further one bit: see swp_to_radix_entry().
  *
  * swp_entry_t's are *never* stored anywhere in their arch-dependent format.
  */
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

