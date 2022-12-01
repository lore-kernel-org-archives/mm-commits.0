Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14807C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiLAAIi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiLAAGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0ED1027
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E71D614D0
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79031C433D7;
        Thu,  1 Dec 2022 00:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852956;
        bh=4zqd0AESSqCbYSPmPhhvlgPFRHGuEjwVTNcr+RuF4+k=;
        h=Date:To:From:Subject:From;
        b=eZDH/3klTjrzwE6toHtC8KsZlfZUZOK909Gg9WbDyw/9A2V64miV+N4Olwz+QPMiB
         BnmpBqJigS6AvIaT8lVP9iRsFxQAiniK0tYY2W0tpKKwO0dRpKR1y3ldzFNmYZBAnD
         yeQer/GiT0XaqbkpCj0mayFpdH7xO4VBQrP414O4=
Date:   Wed, 30 Nov 2022 16:02:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        naoya.horiguchi@nec.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ext4-convert-move_extent_per_page-to-use-folios.patch removed from -mm tree
Message-Id: <20221201000236.79031C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext4: convert move_extent_per_page() to use folios
has been removed from the -mm tree.  Its filename was
     ext4-convert-move_extent_per_page-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: ext4: convert move_extent_per_page() to use folios
Date: Thu, 17 Nov 2022 23:30:52 -0800

Patch series "Removing the try_to_release_page() wrapper", v3.

This patchset replaces the remaining calls of try_to_release_page() with
the folio equivalent: filemap_release_folio().  This allows us to remove
the wrapper.


This patch (of 4):

Convert move_extent_per_page() to use folios.  This change removes 5 calls
to compound_head() and is in preparation for the removal of the
try_to_release_page() wrapper.

Link: https://lkml.kernel.org/r/20221118073055.55694-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20221118073055.55694-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/move_extent.c |   52 +++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

--- a/fs/ext4/move_extent.c~ext4-convert-move_extent_per_page-to-use-folios
+++ a/fs/ext4/move_extent.c
@@ -253,6 +253,7 @@ move_extent_per_page(struct file *o_filp
 {
 	struct inode *orig_inode = file_inode(o_filp);
 	struct page *pagep[2] = {NULL, NULL};
+	struct folio *folio[2] = {NULL, NULL};
 	handle_t *handle;
 	ext4_lblk_t orig_blk_offset, donor_blk_offset;
 	unsigned long blocksize = orig_inode->i_sb->s_blocksize;
@@ -313,6 +314,13 @@ again:
 	 * hold page's lock, if it is still the case data copy is not
 	 * necessary, just swap data blocks between orig and donor.
 	 */
+	folio[0] = page_folio(pagep[0]);
+	folio[1] = page_folio(pagep[1]);
+
+	VM_BUG_ON_FOLIO(folio_test_large(folio[0]), folio[0]);
+	VM_BUG_ON_FOLIO(folio_test_large(folio[1]), folio[1]);
+	VM_BUG_ON_FOLIO(folio_nr_pages(folio[0]) != folio_nr_pages(folio[1]), folio[1]);
+
 	if (unwritten) {
 		ext4_double_down_write_data_sem(orig_inode, donor_inode);
 		/* If any of extents in range became initialized we have to
@@ -331,10 +339,10 @@ again:
 			ext4_double_up_write_data_sem(orig_inode, donor_inode);
 			goto data_copy;
 		}
-		if ((page_has_private(pagep[0]) &&
-		     !try_to_release_page(pagep[0], 0)) ||
-		    (page_has_private(pagep[1]) &&
-		     !try_to_release_page(pagep[1], 0))) {
+		if ((folio_has_private(folio[0]) &&
+		     !filemap_release_folio(folio[0], 0)) ||
+		    (folio_has_private(folio[1]) &&
+		     !filemap_release_folio(folio[1], 0))) {
 			*err = -EBUSY;
 			goto drop_data_sem;
 		}
@@ -344,19 +352,21 @@ again:
 						   block_len_in_page, 1, err);
 	drop_data_sem:
 		ext4_double_up_write_data_sem(orig_inode, donor_inode);
-		goto unlock_pages;
+		goto unlock_folios;
 	}
 data_copy:
-	*err = mext_page_mkuptodate(pagep[0], from, from + replaced_size);
+	*err = mext_page_mkuptodate(&folio[0]->page, from, from + replaced_size);
 	if (*err)
-		goto unlock_pages;
+		goto unlock_folios;
 
 	/* At this point all buffers in range are uptodate, old mapping layout
 	 * is no longer required, try to drop it now. */
-	if ((page_has_private(pagep[0]) && !try_to_release_page(pagep[0], 0)) ||
-	    (page_has_private(pagep[1]) && !try_to_release_page(pagep[1], 0))) {
+	if ((folio_has_private(folio[0]) &&
+		!filemap_release_folio(folio[0], 0)) ||
+	    (folio_has_private(folio[1]) &&
+		!filemap_release_folio(folio[1], 0))) {
 		*err = -EBUSY;
-		goto unlock_pages;
+		goto unlock_folios;
 	}
 	ext4_double_down_write_data_sem(orig_inode, donor_inode);
 	replaced_count = ext4_swap_extents(handle, orig_inode, donor_inode,
@@ -369,13 +379,13 @@ data_copy:
 			replaced_size =
 				block_len_in_page << orig_inode->i_blkbits;
 		} else
-			goto unlock_pages;
+			goto unlock_folios;
 	}
 	/* Perform all necessary steps similar write_begin()/write_end()
 	 * but keeping in mind that i_size will not change */
-	if (!page_has_buffers(pagep[0]))
-		create_empty_buffers(pagep[0], 1 << orig_inode->i_blkbits, 0);
-	bh = page_buffers(pagep[0]);
+	if (!folio_buffers(folio[0]))
+		create_empty_buffers(&folio[0]->page, 1 << orig_inode->i_blkbits, 0);
+	bh = folio_buffers(folio[0]);
 	for (i = 0; i < data_offset_in_page; i++)
 		bh = bh->b_this_page;
 	for (i = 0; i < block_len_in_page; i++) {
@@ -385,7 +395,7 @@ data_copy:
 		bh = bh->b_this_page;
 	}
 	if (!*err)
-		*err = block_commit_write(pagep[0], from, from + replaced_size);
+		*err = block_commit_write(&folio[0]->page, from, from + replaced_size);
 
 	if (unlikely(*err < 0))
 		goto repair_branches;
@@ -395,11 +405,11 @@ data_copy:
 	*err = ext4_jbd2_inode_add_write(handle, orig_inode,
 			(loff_t)orig_page_offset << PAGE_SHIFT, replaced_size);
 
-unlock_pages:
-	unlock_page(pagep[0]);
-	put_page(pagep[0]);
-	unlock_page(pagep[1]);
-	put_page(pagep[1]);
+unlock_folios:
+	folio_unlock(folio[0]);
+	folio_put(folio[0]);
+	folio_unlock(folio[1]);
+	folio_put(folio[1]);
 stop_journal:
 	ext4_journal_stop(handle);
 	if (*err == -ENOSPC &&
@@ -430,7 +440,7 @@ repair_branches:
 		*err = -EIO;
 	}
 	replaced_count = 0;
-	goto unlock_pages;
+	goto unlock_folios;
 }
 
 /**
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch
fuse-convert-fuse_try_move_page-to-use-folios.patch
userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch
khugepage-replace-lru_cache_add-with-folio_add_lru.patch
folio-compat-remove-lru_cache_add.patch

