Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEFBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiCaESx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiCaESk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:18:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F95855BC8
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C1660C49
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D6C3410F;
        Thu, 31 Mar 2022 02:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648695376;
        bh=UG6W9yXCrgqcCz37P8sYG+nyiTsfs8aEZTRv0buzai4=;
        h=Date:To:From:Subject:From;
        b=zQXV8fLKhpaQMK1+V5sV42GiDqB9TGNCMGf5TGQ1r4GrjC1QdcpHb+Y5gNCQbQAfV
         MPIyg23ftaUGkZRYBVcs9xsWMye3qNGw+zDiXSY3+O03MHYE3+wEv6RrZpQP/d3f/C
         zNQPJwUf0e5FRyqf7GtUeFY8dpNoczgNg7CQXPXU=
Date:   Wed, 30 Mar 2022 19:56:15 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, hughd@google.com, hch@lst.de,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch added to -mm tree
Message-Id: <20220331025616.573D6C3410F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reclaim mustn't enter FS for SWP_FS_OPS swap-space
has been added to the -mm tree.  Its filename is
     mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
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

mm-create-new-mm-swaph-header-file.patch
mm-drop-swap_dirty_folio.patch
mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch
doc-update-documentation-for-swap_activate-and-swap_rw.patch
mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch
vfs-add-fmode_can_odirect-file-flag.patch
mm-discard-__gfp_atomic.patch

