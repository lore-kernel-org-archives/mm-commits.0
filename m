Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B146C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245540AbiESW0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245492AbiESWZ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027391144E
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B228CB828AF
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A75AC385AA;
        Thu, 19 May 2022 22:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999148;
        bh=oNSJZLABBUkiE5dPZMyJwp+EpJVXpx0gcVZxP7R8pmw=;
        h=Date:To:From:Subject:From;
        b=h7gT8k3vnEpDU7klRsQeJLnUcdBCGuq5CQHcCbwdmVJab6G4i/oJa4gqhQ4V5et1N
         PVImrbDHsf5/2YiKZlbZA7UJ8ViMluVgOVumXeWvf1cu25gcDBvRPuvNvOkyyqChxj
         PZSURLjCr30EOjNUkvx7aKs1773uq4No6p5XglKM=
Date:   Thu, 19 May 2022 15:25:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-comment-about-swap-extent.patch removed from -mm tree
Message-Id: <20220519222548.6A75AC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: fix comment about swap extent
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-comment-about-swap-extent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: fix comment about swap extent

Since commit 4efaceb1c5f8 ("mm, swap: use rbtree for swap_extent"), rbtree
is used for swap extent.  Also curr_swap_extent is removed at that time. 
Update the corresponding comment.

Link: https://lkml.kernel.org/r/20220509131416.17553-16-linmiaohe@huawei.com
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

 include/linux/swap.h |    4 ++--
 mm/swapfile.c        |   15 ++++++---------
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/swap.h~mm-swap-fix-comment-about-swap-extent
+++ a/include/linux/swap.h
@@ -168,8 +168,8 @@ struct zone;
 
 /*
  * A swap extent maps a range of a swapfile's PAGE_SIZE pages onto a range of
- * disk blocks.  A list of swap extents maps the entire swapfile.  (Where the
- * term `swapfile' refers to either a blockdevice or an IS_REG file.  Apart
+ * disk blocks.  A rbtree of swap extents maps the entire swapfile (Where the
+ * term `swapfile' refers to either a blockdevice or an IS_REG file). Apart
  * from setup, they're handled identically.
  *
  * We always assume that blocks are of size PAGE_SIZE.
--- a/mm/swapfile.c~mm-swap-fix-comment-about-swap-extent
+++ a/mm/swapfile.c
@@ -2208,8 +2208,8 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
 
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
- * onto a contiguous range of disk blocks.  An ordered list of swap extents
- * is built at swapon time and is then used at swap_writepage/swap_readpage
+ * onto a contiguous range of disk blocks.  A rbtree of swap extents is
+ * built at swapon time and is then used at swap_writepage/swap_readpage
  * time for locating where on disk a page belongs.
  *
  * If the swapfile is an S_ISBLK block device, a single extent is installed.
@@ -2217,12 +2217,12 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
  * swap files identically.
  *
  * Whether the swapdev is an S_ISREG file or an S_ISBLK blockdev, the swap
- * extent list operates in PAGE_SIZE disk blocks.  Both S_ISREG and S_ISBLK
+ * extent rbtree operates in PAGE_SIZE disk blocks.  Both S_ISREG and S_ISBLK
  * swapfiles are handled *identically* after swapon time.
  *
  * For S_ISREG swapfiles, setup_swap_extents() will walk all the file's blocks
- * and will parse them into an ordered extent list, in PAGE_SIZE chunks.  If
- * some stray blocks are found which do not fall within the PAGE_SIZE alignment
+ * and will parse them into a rbtree, in PAGE_SIZE chunks.  If some stray
+ * blocks are found which do not fall within the PAGE_SIZE alignment
  * requirements, they are simply tossed out - we will never use those blocks
  * for swapping.
  *
@@ -2231,10 +2231,7 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
  *
  * The amount of disk space which a single swap extent represents varies.
  * Typically it is in the 1-4 megabyte range.  So we can have hundreds of
- * extents in the list.  To avoid much list walking, we cache the previous
- * search location in `curr_swap_extent', and start new searches from there.
- * This is extremely effective.  The average number of iterations in
- * map_swap_page() has been measured at about 0.3 per page.  - akpm.
+ * extents in the rbtree. - akpm.
  */
 static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 {
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

