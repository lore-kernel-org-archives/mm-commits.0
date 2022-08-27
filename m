Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4B8ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345179AbiH0D3J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243634AbiH0D2v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:28:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C99A833D
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 632DAB83387
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074E1C433C1;
        Sat, 27 Aug 2022 03:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661570928;
        bh=8CIB8ilDBPceklfvjLRISgB+zLrY7jH21kQGDIUHwrI=;
        h=Date:To:From:Subject:From;
        b=OJpsuVS068PAO9mB8qA5z7EDDaE0VrbEdUKzzgMeQy9W6UfEjW1bYvubxLvlvNOUq
         +BDZD3UA9p1pfRRe/3T0rUZZr/t+ARi9+vL7inhZj9DomYK3y41tM/SBHhqeQmbWCH
         Wf9RmdC5R6KaUsaMWrn1unnWdNylyVmOz3OoWi/U=
Date:   Fri, 26 Aug 2022 20:28:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch added to mm-unstable branch
Message-Id: <20220827032848.074E1C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_find_uncommited_extent() to use filemap_get_folios_contig()
has been added to the -mm mm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: nilfs2: convert nilfs_find_uncommited_extent() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:21 -0700

Convert function to use folios throughout.  This is in preparation for the
removal of find_get_pages_contig().  Now also supports large folios.

Also clean up an unnecessary if statement - pvec.pages[0]->index > index
will always evaluate to false, and filemap_get_folios_contig() returns 0
if there is no folio found at index.

Link: https://lkml.kernel.org/r/20220824004023.77310-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: David Sterba <dsterb@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   45 ++++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig
+++ a/fs/nilfs2/page.c
@@ -480,41 +480,36 @@ unsigned long nilfs_find_uncommitted_ext
 					    sector_t start_blk,
 					    sector_t *blkoff)
 {
-	unsigned int i;
+	unsigned int i, nr_folios;
 	pgoff_t index;
-	unsigned int nblocks_in_page;
 	unsigned long length = 0;
-	sector_t b;
-	struct pagevec pvec;
-	struct page *page;
+	struct folio_batch fbatch;
+	struct folio *folio;
 
 	if (inode->i_mapping->nrpages == 0)
 		return 0;
 
 	index = start_blk >> (PAGE_SHIFT - inode->i_blkbits);
-	nblocks_in_page = 1U << (PAGE_SHIFT - inode->i_blkbits);
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 repeat:
-	pvec.nr = find_get_pages_contig(inode->i_mapping, index, PAGEVEC_SIZE,
-					pvec.pages);
-	if (pvec.nr == 0)
+	nr_folios = filemap_get_folios_contig(inode->i_mapping, &index, ULONG_MAX,
+			&fbatch);
+	if (nr_folios == 0)
 		return length;
 
-	if (length > 0 && pvec.pages[0]->index > index)
-		goto out;
-
-	b = pvec.pages[0]->index << (PAGE_SHIFT - inode->i_blkbits);
 	i = 0;
 	do {
-		page = pvec.pages[i];
+		folio = fbatch.folios[i];
 
-		lock_page(page);
-		if (page_has_buffers(page)) {
+		folio_lock(folio);
+		if (folio_buffers(folio)) {
 			struct buffer_head *bh, *head;
+			sector_t b;
 
-			bh = head = page_buffers(page);
+			b = folio->index << (PAGE_SHIFT - inode->i_blkbits);
+			bh = head = folio_buffers(folio);
 			do {
 				if (b < start_blk)
 					continue;
@@ -529,21 +524,17 @@ repeat:
 		} else {
 			if (length > 0)
 				goto out_locked;
-
-			b += nblocks_in_page;
 		}
-		unlock_page(page);
+		folio_unlock(folio);
 
-	} while (++i < pagevec_count(&pvec));
+	} while (++i < nr_folios);
 
-	index = page->index + 1;
-	pagevec_release(&pvec);
+	folio_batch_release(&fbatch);
 	cond_resched();
 	goto repeat;
 
 out_locked:
-	unlock_page(page);
-out:
-	pagevec_release(&pvec);
+	folio_unlock(folio);
+	folio_batch_release(&fbatch);
 	return length;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-add-filemap_get_folios_contig.patch
btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig.patch
btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch
btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch
nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch
ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch
filemap-remove-find_get_pages_contig.patch

