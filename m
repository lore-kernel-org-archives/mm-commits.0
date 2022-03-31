Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3EBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiCaEXl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiCaEXc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:23:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C187C1A6E67
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:12:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A11B81E88
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566C3C340EC;
        Thu, 31 Mar 2022 02:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648695371;
        bh=Am0qcGKt0c0mWsn/fjJrzN9jKg9hLxjp1ocoy9nZkeU=;
        h=Date:To:From:Subject:From;
        b=lH9doJHLrHa1z0ktsZagl3n/+D7z5ha8UFwbrwVPciN29cwcU9wYl7iXRE/olTJHI
         fQSpA4G8Mqc9vh+23N8AcNL9v8BoRpPMc7hiC1fJ34hGFPIXoTY22s8lE8FOs3MdW+
         S6bDUDXWZG2QhvGvTTdUyKeXiNS+LzSoXfk2Hk0w=
Date:   Wed, 30 Mar 2022 19:56:10 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, hughd@google.com, hch@lst.de,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-swap_dirty_folio.patch added to -mm tree
Message-Id: <20220331025611.566C3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop swap_dirty_folio
has been added to the -mm tree.  Its filename is
     mm-drop-swap_dirty_folio.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-drop-swap_dirty_folio.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-swap_dirty_folio.patch

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
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/page_io.c         |   17 -----------------
 mm/swap_state.c      |    2 +-
 3 files changed, 1 insertion(+), 19 deletions(-)

--- a/include/linux/swap.h~mm-drop-swap_dirty_folio
+++ a/include/linux/swap.h
@@ -420,7 +420,6 @@ extern void kswapd_stop(int nid);
 
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

