Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D290AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbiEJEVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4203D2AD745
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F15C4B81AFD
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADACDC385C2;
        Tue, 10 May 2022 04:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156111;
        bh=GAeg/p4bUDILQ96tcfuXjwsWcglJVSvxZ5YAr6fGfjg=;
        h=Date:To:From:Subject:From;
        b=Dmw/dWp21nbhBHob+u39jcyMSDgY26ScRLUtZ4GvJk9ZR4U9/ry0NIu6gx8isziO5
         MXofbZskA8G1Pjqs3/x77zmelZJ9VbxaZMlZ/F66Y4J8cdV3sqKyxGp9oA8AJD8Gmj
         wR34OZ21K+YoH3GVAO1TYVkKoy4qI0lSi6x9UoCE=
Date:   Mon, 09 May 2022 21:15:11 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch removed from -mm tree
Message-Id: <20220510041511.ADACDC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reclaim mustn't enter FS for SWP_FS_OPS swap-space
has been removed from the -mm tree.  Its filename was
     mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: reclaim mustn't enter FS for SWP_FS_OPS swap-space

If swap-out is using filesystem operations (SWP_FS_OPS), then it is not
safe to enter the FS for reclaim.  So only down-grade the requirement for
swap pages to __GFP_IO after checking that SWP_FS_OPS are not being used.

This makes the calculation of "may_enter_fs" slightly more complex, so
move it into a separate function.  with that done, there is little value
in maintaining the bool variable any more.  So replace the may_enter_fs
variable with a may_enter_fs() function.  This removes any risk for the
variable becoming out-of-date.

Link: https://lkml.kernel.org/r/164859778124.29473.16176717935781721855.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: David Howells <dhowells@redhat.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h   |    8 ++++++++
 mm/vmscan.c |   29 ++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

--- a/mm/swap.h~mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space
+++ a/mm/swap.h
@@ -50,6 +50,10 @@ struct page *swap_cluster_readahead(swp_
 struct page *swapin_readahead(swp_entry_t entry, gfp_t flag,
 			      struct vm_fault *vmf);
 
+static inline unsigned int page_swap_flags(struct page *page)
+{
+	return page_swap_info(page)->flags;
+}
 #else /* CONFIG_SWAP */
 static inline int swap_readpage(struct page *page, bool do_poll)
 {
@@ -129,5 +133,9 @@ static inline void clear_shadow_from_swa
 {
 }
 
+static inline unsigned int page_swap_flags(struct page *page)
+{
+	return 0;
+}
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
--- a/mm/vmscan.c~mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space
+++ a/mm/vmscan.c
@@ -1502,6 +1502,22 @@ static unsigned int demote_page_list(str
 	return nr_succeeded;
 }
 
+static bool may_enter_fs(struct page *page, gfp_t gfp_mask)
+{
+	if (gfp_mask & __GFP_FS)
+		return true;
+	if (!PageSwapCache(page) || !(gfp_mask & __GFP_IO))
+		return false;
+	/*
+	 * We can "enter_fs" for swap-cache with only __GFP_IO
+	 * providing this isn't SWP_FS_OPS.
+	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * but that will never affect SWP_FS_OPS, so the data_race
+	 * is safe.
+	 */
+	return !data_race(page_swap_flags(page) & SWP_FS_OPS);
+}
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -1528,7 +1544,7 @@ retry:
 		struct page *page;
 		struct folio *folio;
 		enum page_references references = PAGEREF_RECLAIM;
-		bool dirty, writeback, may_enter_fs;
+		bool dirty, writeback;
 		unsigned int nr_pages;
 
 		cond_resched();
@@ -1553,9 +1569,6 @@ retry:
 		if (!sc->may_unmap && page_mapped(page))
 			goto keep_locked;
 
-		may_enter_fs = (sc->gfp_mask & __GFP_FS) ||
-			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
-
 		/*
 		 * The number of dirty pages determines if a node is marked
 		 * reclaim_congested. kswapd will stall and start writing
@@ -1598,7 +1611,7 @@ retry:
 		 *    not to fs). In this case mark the page for immediate
 		 *    reclaim and continue scanning.
 		 *
-		 *    Require may_enter_fs because we would wait on fs, which
+		 *    Require may_enter_fs() because we would wait on fs, which
 		 *    may not have submitted IO yet. And the loop driver might
 		 *    enter reclaim, and deadlock if it waits on a page for
 		 *    which it is needed to do the write (loop masks off
@@ -1630,7 +1643,7 @@ retry:
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
-			    !PageReclaim(page) || !may_enter_fs) {
+			    !PageReclaim(page) || !may_enter_fs(page, sc->gfp_mask)) {
 				/*
 				 * This is slightly racy - end_page_writeback()
 				 * might have just cleared PageReclaim, then
@@ -1720,8 +1733,6 @@ retry:
 						goto activate_locked_split;
 				}
 
-				may_enter_fs = true;
-
 				/* Adding to swap updated mapping */
 				mapping = page_mapping(page);
 			}
@@ -1792,7 +1803,7 @@ retry:
 
 			if (references == PAGEREF_RECLAIM_CLEAN)
 				goto keep_locked;
-			if (!may_enter_fs)
+			if (!may_enter_fs(page, sc->gfp_mask))
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

