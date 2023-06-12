Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05ED0C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbjFLVun (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbjFLVuj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F52CE9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1B6D62F75
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FC1C433EF;
        Mon, 12 Jun 2023 21:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606637;
        bh=HNDNEx63hFCdpgEj6C9auqM/pyr8yjKAim+gNocgd6E=;
        h=Date:To:From:Subject:From;
        b=DKp59HonNcogMyeBSQCFzciZL3tlmkXXXhdVNSyqcBvmYbld3dIThrzgp4zcmbGGU
         /eGC82LfgZbQfp7I94LUl4R3H8PN0R8M/0d7uKXcl5XtX3HTyFekF9X2d342ukfoxb
         pBFeQVNg1Gy4HQaReyc892FVRBf3WpcpCnrYaCvA=
Date:   Mon, 12 Jun 2023 14:50:36 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch added to mm-unstable branch
Message-Id: <20230612215037.44FC1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert page_zero_new_buffers() to folio_zero_new_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: convert page_zero_new_buffers() to folio_zero_new_buffers()
Date: Mon, 12 Jun 2023 22:01:36 +0100

Most of the callers already have a folio; convert reiserfs_write_end() to
have a folio.  Removes a couple of hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20230612210141.730128-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   27 ++++++++++++++-------------
 fs/ext4/inode.c             |    4 ++--
 fs/reiserfs/inode.c         |    7 ++++---
 include/linux/buffer_head.h |    2 +-
 4 files changed, 21 insertions(+), 19 deletions(-)

--- a/fs/buffer.c~buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers
+++ a/fs/buffer.c
@@ -1927,33 +1927,34 @@ recover:
 EXPORT_SYMBOL(__block_write_full_folio);
 
 /*
- * If a page has any new buffers, zero them out here, and mark them uptodate
+ * If a folio has any new buffers, zero them out here, and mark them uptodate
  * and dirty so they'll be written out (in order to prevent uninitialised
  * block data from leaking). And clear the new bit.
  */
-void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
+void folio_zero_new_buffers(struct folio *folio, size_t from, size_t to)
 {
-	unsigned int block_start, block_end;
+	size_t block_start, block_end;
 	struct buffer_head *head, *bh;
 
-	BUG_ON(!PageLocked(page));
-	if (!page_has_buffers(page))
+	BUG_ON(!folio_test_locked(folio));
+	head = folio_buffers(folio);
+	if (!head)
 		return;
 
-	bh = head = page_buffers(page);
+	bh = head;
 	block_start = 0;
 	do {
 		block_end = block_start + bh->b_size;
 
 		if (buffer_new(bh)) {
 			if (block_end > from && block_start < to) {
-				if (!PageUptodate(page)) {
-					unsigned start, size;
+				if (!folio_test_uptodate(folio)) {
+					size_t start, xend;
 
 					start = max(from, block_start);
-					size = min(to, block_end) - start;
+					xend = min(to, block_end);
 
-					zero_user(page, start, size);
+					folio_zero_segment(folio, start, xend);
 					set_buffer_uptodate(bh);
 				}
 
@@ -1966,7 +1967,7 @@ void page_zero_new_buffers(struct page *
 		bh = bh->b_this_page;
 	} while (bh != head);
 }
-EXPORT_SYMBOL(page_zero_new_buffers);
+EXPORT_SYMBOL(folio_zero_new_buffers);
 
 static void
 iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
@@ -2104,7 +2105,7 @@ int __block_write_begin_int(struct folio
 			err = -EIO;
 	}
 	if (unlikely(err))
-		page_zero_new_buffers(&folio->page, from, to);
+		folio_zero_new_buffers(folio, from, to);
 	return err;
 }
 
@@ -2208,7 +2209,7 @@ int block_write_end(struct file *file, s
 		if (!folio_test_uptodate(folio))
 			copied = 0;
 
-		page_zero_new_buffers(&folio->page, start+copied, start+len);
+		folio_zero_new_buffers(folio, start+copied, start+len);
 	}
 	flush_dcache_folio(folio);
 
--- a/fs/ext4/inode.c~buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers
+++ a/fs/ext4/inode.c
@@ -1093,7 +1093,7 @@ static int ext4_block_write_begin(struct
 			err = -EIO;
 	}
 	if (unlikely(err)) {
-		page_zero_new_buffers(&folio->page, from, to);
+		folio_zero_new_buffers(folio, from, to);
 	} else if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
 		for (i = 0; i < nr_wait; i++) {
 			int err2;
@@ -1339,7 +1339,7 @@ static int ext4_write_end(struct file *f
 }
 
 /*
- * This is a private version of page_zero_new_buffers() which doesn't
+ * This is a private version of folio_zero_new_buffers() which doesn't
  * set the buffer to be dirty, since in data=journalled mode we need
  * to call ext4_dirty_journalled_data() instead.
  */
--- a/fs/reiserfs/inode.c~buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers
+++ a/fs/reiserfs/inode.c
@@ -2872,6 +2872,7 @@ static int reiserfs_write_end(struct fil
 			      loff_t pos, unsigned len, unsigned copied,
 			      struct page *page, void *fsdata)
 {
+	struct folio *folio = page_folio(page);
 	struct inode *inode = page->mapping->host;
 	int ret = 0;
 	int update_sd = 0;
@@ -2887,12 +2888,12 @@ static int reiserfs_write_end(struct fil
 
 	start = pos & (PAGE_SIZE - 1);
 	if (unlikely(copied < len)) {
-		if (!PageUptodate(page))
+		if (!folio_test_uptodate(folio))
 			copied = 0;
 
-		page_zero_new_buffers(page, start + copied, start + len);
+		folio_zero_new_buffers(folio, start + copied, start + len);
 	}
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 
 	reiserfs_commit_page(inode, page, start, start + copied);
 
--- a/include/linux/buffer_head.h~buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers
+++ a/include/linux/buffer_head.h
@@ -278,7 +278,7 @@ int block_write_end(struct file *, struc
 int generic_write_end(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page *, void *);
-void page_zero_new_buffers(struct page *page, unsigned from, unsigned to);
+void folio_zero_new_buffers(struct folio *folio, size_t from, size_t to);
 void clean_page_buffers(struct page *page);
 int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, struct page **, void **,
_

Patches currently in -mm which might be from willy@infradead.org are

gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch
gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch
gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch
buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch
gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch
buffer-make-block_write_full_page-handle-large-folios-correctly.patch
buffer-convert-block_page_mkwrite-to-use-a-folio.patch
buffer-convert-__block_commit_write-to-take-a-folio.patch
buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch
buffer-convert-grow_dev_page-to-use-a-folio.patch
buffer-convert-init_page_buffers-to-folio_init_buffers.patch
buffer-convert-link_dev_buffers-to-take-a-folio.patch
buffer-use-a-folio-in-__find_get_block_slow.patch
buffer-convert-block_truncate_page-to-use-a-folio.patch

