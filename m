Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF51C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiEJEVl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635DB2AC6FA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 459796176B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE52C385C2;
        Tue, 10 May 2022 04:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156109;
        bh=HqwnePFAQMX8tW9VpURF6TeCTxRX+6xHH0Wz5KFv52g=;
        h=Date:To:From:Subject:From;
        b=l03VZpAqzTcK7gkG5ED5UVTjXgCOaNwpLLh6I9abVwISo1dwXqmJ2KalBPh1EbeKq
         PiotNVLjmHgH0NGrk2/g60G8qwsye8q03Q7AhrMGIppT6xCOzcUIoytk7Wv1VO7GSY
         meBscs0obfcziDRNwkhvYr02ZAj44YAYWVWB0J5w=
Date:   Mon, 09 May 2022 21:15:09 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-swap_dirty_folio.patch removed from -mm tree
Message-Id: <20220510041509.9EE52C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: drop swap_dirty_folio
has been removed from the -mm tree.  Its filename was
     mm-drop-swap_dirty_folio.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: drop swap_dirty_folio

folios that are written to swap are owned by the MM subsystem - not any
filesystem.

When such a folio is passed to a filesystem to be written out to a
swap-file, the filesystem handles the data, but the folio itself does not
belong to the filesystem.  So calling the filesystem's ->dirty_folio()
address_space operation makes no sense.  This is for folios in the given
address space, and a folio to be written to swap does not exist in the
given address space.

So drop swap_dirty_folio() which calls the address-space's
->dirty_folio(), and always use noop_dirty_folio(), which is appropriate
for folios being swapped out.

Link: https://lkml.kernel.org/r/164859778123.29473.6900942583784889976.stgit@noble.brown
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

 include/linux/swap.h |    1 -
 mm/page_io.c         |   17 -----------------
 mm/swap_state.c      |    2 +-
 3 files changed, 1 insertion(+), 19 deletions(-)

--- a/include/linux/swap.h~mm-drop-swap_dirty_folio
+++ a/include/linux/swap.h
@@ -427,7 +427,6 @@ extern void kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
-bool swap_dirty_folio(struct address_space *mapping, struct folio *folio);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
--- a/mm/page_io.c~mm-drop-swap_dirty_folio
+++ a/mm/page_io.c
@@ -385,20 +385,3 @@ out:
 	delayacct_swapin_end();
 	return ret;
 }
-
-bool swap_dirty_folio(struct address_space *mapping, struct folio *folio)
-{
-	struct swap_info_struct *sis = swp_swap_info(folio_swap_entry(folio));
-
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		const struct address_space_operations *aops;
-
-		mapping = sis->swap_file->f_mapping;
-		aops = mapping->a_ops;
-
-		VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
-		return aops->dirty_folio(mapping, folio);
-	} else {
-		return noop_dirty_folio(mapping, folio);
-	}
-}
--- a/mm/swap_state.c~mm-drop-swap_dirty_folio
+++ a/mm/swap_state.c
@@ -31,7 +31,7 @@
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
-	.dirty_folio	= swap_dirty_folio,
+	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
 #endif
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

