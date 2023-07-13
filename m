Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EE9C001DD
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjGMR1Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjGMR1V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85C1272B
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845FC61ADB
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45B3C433C8;
        Thu, 13 Jul 2023 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689269208;
        bh=8Btm4MDYjnmjQ4ndV8hv8VTtoeS3VtK3Dm5YzMKmqbQ=;
        h=Date:To:From:Subject:From;
        b=RLl+j4z7+841egeWXH1/j0FXdrttXRYGV8FJUrSaqOQwxlyN+i+W7mt/xPprFRrUX
         7YUZ9+hzfaa2ZsCT3uyaROTCiw94oK/ztfGy4Kitl8LLpYFuwPUm7+As3X8BK6zAQV
         Avs0FBO+smTbWtHmk1AOSjwe9hf/pw7Mvpjz0C+o=
Date:   Thu, 13 Jul 2023 10:26:48 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + affs-convert-data-read-and-write-to-use-folios.patch added to mm-unstable branch
Message-Id: <20230713172648.D45B3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: affs: convert data read and write to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     affs-convert-data-read-and-write-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/affs-convert-data-read-and-write-to-use-folios.patch

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
Subject: affs: convert data read and write to use folios
Date: Thu, 13 Jul 2023 04:55:08 +0100

We still need to convert to/from folios in write_begin & write_end to fit
the API, but this removes a lot of calls to old page-based functions,
removing many hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20230713035512.4139457-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   77 +++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

--- a/fs/affs/file.c~affs-convert-data-read-and-write-to-use-folios
+++ a/fs/affs/file.c
@@ -520,21 +520,20 @@ affs_getemptyblk_ino(struct inode *inode
 	return ERR_PTR(err);
 }
 
-static int
-affs_do_readpage_ofs(struct page *page, unsigned to, int create)
+static int affs_do_read_folio_ofs(struct folio *folio, size_t to, int create)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh;
-	unsigned pos = 0;
-	u32 bidx, boff, bsize;
+	size_t pos = 0;
+	size_t bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%lu, %ld, 0, %d)\n", __func__, inode->i_ino,
-		 page->index, to);
-	BUG_ON(to > PAGE_SIZE);
+	pr_debug("%s(%lu, %ld, 0, %zu)\n", __func__, inode->i_ino,
+		 folio->index, to);
+	BUG_ON(to > folio_size(folio));
 	bsize = AFFS_SB(sb)->s_data_blksize;
-	tmp = page->index << PAGE_SHIFT;
+	tmp = folio_pos(folio);
 	bidx = tmp / bsize;
 	boff = tmp % bsize;
 
@@ -544,7 +543,7 @@ affs_do_readpage_ofs(struct page *page,
 			return PTR_ERR(bh);
 		tmp = min(bsize - boff, to - pos);
 		BUG_ON(pos + tmp > to || tmp > bsize);
-		memcpy_to_page(page, pos, AFFS_DATA(bh) + boff, tmp);
+		memcpy_to_folio(folio, pos, AFFS_DATA(bh) + boff, tmp);
 		affs_brelse(bh);
 		bidx++;
 		pos += tmp;
@@ -624,25 +623,23 @@ out:
 	return PTR_ERR(bh);
 }
 
-static int
-affs_read_folio_ofs(struct file *file, struct folio *folio)
+static int affs_read_folio_ofs(struct file *file, struct folio *folio)
 {
-	struct page *page = &folio->page;
-	struct inode *inode = page->mapping->host;
-	u32 to;
+	struct inode *inode = folio->mapping->host;
+	size_t to;
 	int err;
 
-	pr_debug("%s(%lu, %ld)\n", __func__, inode->i_ino, page->index);
-	to = PAGE_SIZE;
-	if (((page->index + 1) << PAGE_SHIFT) > inode->i_size) {
-		to = inode->i_size & ~PAGE_MASK;
-		memset(page_address(page) + to, 0, PAGE_SIZE - to);
+	pr_debug("%s(%lu, %ld)\n", __func__, inode->i_ino, folio->index);
+	to = folio_size(folio);
+	if (folio_pos(folio) + to > inode->i_size) {
+		to = inode->i_size - folio_pos(folio);
+		folio_zero_segment(folio, to, folio_size(folio));
 	}
 
-	err = affs_do_readpage_ofs(page, to, 0);
+	err = affs_do_read_folio_ofs(folio, to, 0);
 	if (!err)
-		SetPageUptodate(page);
-	unlock_page(page);
+		folio_mark_uptodate(folio);
+	folio_unlock(folio);
 	return err;
 }
 
@@ -651,7 +648,7 @@ static int affs_write_begin_ofs(struct f
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	struct page *page;
+	struct folio *folio;
 	pgoff_t index;
 	int err = 0;
 
@@ -667,19 +664,20 @@ static int affs_write_begin_ofs(struct f
 	}
 
 	index = pos >> PAGE_SHIFT;
-	page = grab_cache_page_write_begin(mapping, index);
-	if (!page)
-		return -ENOMEM;
-	*pagep = page;
+	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
+			mapping_gfp_mask(mapping));
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+	*pagep = &folio->page;
 
-	if (PageUptodate(page))
+	if (folio_test_uptodate(folio))
 		return 0;
 
 	/* XXX: inefficient but safe in the face of short writes */
-	err = affs_do_readpage_ofs(page, PAGE_SIZE, 1);
+	err = affs_do_read_folio_ofs(folio, folio_size(folio), 1);
 	if (err) {
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 	return err;
 }
@@ -688,6 +686,7 @@ static int affs_write_end_ofs(struct fil
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata)
 {
+	struct folio *folio = page_folio(page);
 	struct inode *inode = mapping->host;
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh, *prev_bh;
@@ -701,18 +700,18 @@ static int affs_write_end_ofs(struct fil
 	to = from + len;
 	/*
 	 * XXX: not sure if this can handle short copies (len < copied), but
-	 * we don't have to, because the page should always be uptodate here,
+	 * we don't have to, because the folio should always be uptodate here,
 	 * due to write_begin.
 	 */
 
 	pr_debug("%s(%lu, %llu, %llu)\n", __func__, inode->i_ino, pos,
 		 pos + len);
 	bsize = AFFS_SB(sb)->s_data_blksize;
-	data = page_address(page);
+	data = folio_address(folio);
 
 	bh = NULL;
 	written = 0;
-	tmp = (page->index << PAGE_SHIFT) + from;
+	tmp = (folio->index << PAGE_SHIFT) + from;
 	bidx = tmp / bsize;
 	boff = tmp % bsize;
 	if (boff) {
@@ -804,11 +803,11 @@ static int affs_write_end_ofs(struct fil
 		from += tmp;
 		bidx++;
 	}
-	SetPageUptodate(page);
+	folio_mark_uptodate(folio);
 
 done:
 	affs_brelse(bh);
-	tmp = (page->index << PAGE_SHIFT) + from;
+	tmp = (folio->index << PAGE_SHIFT) + from;
 	if (tmp > inode->i_size)
 		inode->i_size = AFFS_I(inode)->mmu_private = tmp;
 
@@ -819,8 +818,8 @@ done:
 	}
 
 err_first_bh:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return written;
 
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch

