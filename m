Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AE3C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBCGl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjBCGkK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201838D439
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA68461D9B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE37C433EF;
        Fri,  3 Feb 2023 06:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406247;
        bh=wpAt5ExFKY8v+gVW8ybxyqSlrANLCROMbZgje+KIDVk=;
        h=Date:To:From:Subject:From;
        b=m+MLbnnMYRUuqtnbuCqFaCiA2aq7LUhybWdqxvYLyk4qnI99YmoumqvfdNsWrtglS
         qb+xduXnnVcCzNYzKPSM0sYmME8/ScJ3thmIbxba8mfuEeVdz3zS6qR+jSPrbjfm96
         8nGuCZ5HipIS+CEY+6dnYICqVdkg32l/KAeoiqCs=
Date:   Thu, 02 Feb 2023 22:37:26 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag.patch removed from -mm tree
Message-Id: <20230203063727.0DE37C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_btree_lookup_dirty_buffers() to use filemap_get_folios_tag()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: nilfs2: convert nilfs_btree_lookup_dirty_buffers() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:45 -0800

Convert function to use folios throughout.  This is in preparation for the
removal of find_get_pages_range_tag().  This change removes 1 call to
compound_head().

Link: https://lkml.kernel.org/r/20230104211448.4804-21-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/nilfs2/btree.c~nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag
+++ a/fs/nilfs2/btree.c
@@ -2150,7 +2150,7 @@ static void nilfs_btree_lookup_dirty_buf
 	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
 	struct address_space *btcache = btnc_inode->i_mapping;
 	struct list_head lists[NILFS_BTREE_LEVEL_MAX];
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	struct buffer_head *bh, *head;
 	pgoff_t index = 0;
 	int level, i;
@@ -2160,19 +2160,19 @@ static void nilfs_btree_lookup_dirty_buf
 	     level++)
 		INIT_LIST_HEAD(&lists[level]);
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
-	while (pagevec_lookup_tag(&pvec, btcache, &index,
-					PAGECACHE_TAG_DIRTY)) {
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			bh = head = page_buffers(pvec.pages[i]);
+	while (filemap_get_folios_tag(btcache, &index, (pgoff_t)-1,
+				PAGECACHE_TAG_DIRTY, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			bh = head = folio_buffers(fbatch.folios[i]);
 			do {
 				if (buffer_dirty(bh))
 					nilfs_btree_add_dirty_buffer(btree,
 								     lists, bh);
 			} while ((bh = bh->b_this_page) != head);
 		}
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

