Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB8BC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbjHKXD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbjHKXCw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2434223
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E919631DF
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E71C433C7;
        Fri, 11 Aug 2023 23:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794866;
        bh=/fYABR0BEwnYp9QqYhXfn5G0y4+oV/vDK7jSA8RUQWY=;
        h=Date:To:From:Subject:From;
        b=Axv7YbOGHnqi+Zpirg5bjb/sYYWzKfo2dJzCFNs5GG7FGJU13uqfPhMa30McSOM5r
         VLb1sKIzQK1hA3X/y5uES+G/j2FYYZm8/0BhqdPKObo6hFNeKjogDN7ab15ycTEV3+
         d+dD/8pAn7rUnJG/Aeqa1DHPJ039VfH+tObTVtfc=
Date:   Fri, 11 Aug 2023 16:01:06 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] affs-convert-data-read-and-write-to-use-folios.patch removed from -mm tree
Message-Id: <20230811230106.B3E71C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: affs: convert data read and write to use folios
has been removed from the -mm tree.  Its filename was
     affs-convert-data-read-and-write-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Sterba <dsterba@suse.com>
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

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

