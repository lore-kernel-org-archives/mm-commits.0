Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5680C54EBD
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjAIXiK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjAIXhm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:37:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6474FE72
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:37:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D15CB81094
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868D8C433D2;
        Mon,  9 Jan 2023 23:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307458;
        bh=Hj0oFLJQOkux/ZIlYAoxaTV2le0ENYNEHEmxrxUG9pg=;
        h=Date:To:From:Subject:From;
        b=MNjr/GCsk6bkJ8mVlysopXmbwkVSnt3Jhl7xUojwk9o636gvU7Vis3wesoUG7bJRK
         0MEYopJgjceIfZMwjzYI7wdWLIx0jjrXtadVrOYnP1cXXbIAutU9IPok+t2weashnw
         jwNT73h/0eu8GxumbhTE69k3ZO7WnTr/OLdAj/Bg=
Date:   Mon, 09 Jan 2023 15:37:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch added to mm-unstable branch
Message-Id: <20230109233738.868D8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: convert mext_page_double_lock() to mext_folio_double_lock()
has been added to the -mm mm-unstable branch.  Its filename is
     ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch

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
Subject: ext4: convert mext_page_double_lock() to mext_folio_double_lock()
Date: Wed, 7 Dec 2022 10:10:09 -0800

Convert mext_page_double_lock() to use folios.  This change saves 146
bytes of kernel text.  It also removes 6 calls to compound_head() and 2
calls to folio_file_page().

Link: https://lkml.kernel.org/r/20221207181009.4016-1-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/move_extent.c |   46 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/fs/ext4/move_extent.c~ext4-convert-mext_page_double_lock-to-mext_folio_double_lock
+++ a/fs/ext4/move_extent.c
@@ -110,22 +110,23 @@ out:
 }
 
 /**
- * mext_page_double_lock - Grab and lock pages on both @inode1 and @inode2
+ * mext_folio_double_lock - Grab and lock folio on both @inode1 and @inode2
  *
  * @inode1:	the inode structure
  * @inode2:	the inode structure
- * @index1:	page index
- * @index2:	page index
- * @page:	result page vector
+ * @index1:	folio index
+ * @index2:	folio index
+ * @folio:	result folio vector
  *
- * Grab two locked pages for inode's by inode order
+ * Grab two locked folio for inode's by inode order
  */
 static int
-mext_page_double_lock(struct inode *inode1, struct inode *inode2,
-		      pgoff_t index1, pgoff_t index2, struct page *page[2])
+mext_folio_double_lock(struct inode *inode1, struct inode *inode2,
+		      pgoff_t index1, pgoff_t index2, struct folio *folio[2])
 {
 	struct address_space *mapping[2];
 	unsigned int flags;
+	unsigned fgp_flags = FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE;
 
 	BUG_ON(!inode1 || !inode2);
 	if (inode1 < inode2) {
@@ -138,28 +139,30 @@ mext_page_double_lock(struct inode *inod
 	}
 
 	flags = memalloc_nofs_save();
-	page[0] = grab_cache_page_write_begin(mapping[0], index1);
-	if (!page[0]) {
+	folio[0] = __filemap_get_folio(mapping[0], index1, fgp_flags,
+			mapping_gfp_mask(mapping[0]));
+	if (!folio[0]) {
 		memalloc_nofs_restore(flags);
 		return -ENOMEM;
 	}
 
-	page[1] = grab_cache_page_write_begin(mapping[1], index2);
+	folio[1] = __filemap_get_folio(mapping[1], index2, fgp_flags,
+			mapping_gfp_mask(mapping[1]));
 	memalloc_nofs_restore(flags);
-	if (!page[1]) {
-		unlock_page(page[0]);
-		put_page(page[0]);
+	if (!folio[1]) {
+		folio_unlock(folio[0]);
+		folio_put(folio[0]);
 		return -ENOMEM;
 	}
 	/*
-	 * grab_cache_page_write_begin() may not wait on page's writeback if
+	 * __filemap_get_folio() may not wait on folio's writeback if
 	 * BDI not demand that. But it is reasonable to be very conservative
-	 * here and explicitly wait on page's writeback
+	 * here and explicitly wait on folio's writeback
 	 */
-	wait_on_page_writeback(page[0]);
-	wait_on_page_writeback(page[1]);
+	folio_wait_writeback(folio[0]);
+	folio_wait_writeback(folio[1]);
 	if (inode1 > inode2)
-		swap(page[0], page[1]);
+		swap(folio[0], folio[1]);
 
 	return 0;
 }
@@ -252,7 +255,6 @@ move_extent_per_page(struct file *o_filp
 		     int block_len_in_page, int unwritten, int *err)
 {
 	struct inode *orig_inode = file_inode(o_filp);
-	struct page *pagep[2] = {NULL, NULL};
 	struct folio *folio[2] = {NULL, NULL};
 	handle_t *handle;
 	ext4_lblk_t orig_blk_offset, donor_blk_offset;
@@ -303,8 +305,8 @@ again:
 
 	replaced_size = data_size;
 
-	*err = mext_page_double_lock(orig_inode, donor_inode, orig_page_offset,
-				     donor_page_offset, pagep);
+	*err = mext_folio_double_lock(orig_inode, donor_inode, orig_page_offset,
+				     donor_page_offset, folio);
 	if (unlikely(*err < 0))
 		goto stop_journal;
 	/*
@@ -314,8 +316,6 @@ again:
 	 * hold page's lock, if it is still the case data copy is not
 	 * necessary, just swap data blocks between orig and donor.
 	 */
-	folio[0] = page_folio(pagep[0]);
-	folio[1] = page_folio(pagep[1]);
 
 	VM_BUG_ON_FOLIO(folio_test_large(folio[0]), folio[0]);
 	VM_BUG_ON_FOLIO(folio_test_large(folio[1]), folio[1]);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch
ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch

