Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CFB23A1
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l2SMsT6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50BFC433C9;
	Mon, 11 Dec 2023 00:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256053;
	bh=wAPnl0np9z7rRGQj5VDRU4UD56BZ7swdDWCgfbJEQxg=;
	h=Date:To:From:Subject:From;
	b=l2SMsT6qyIKHUXMR4+Y3XyhjGCyGN99mT1rxxqeq6AnxjhpcwjyFu3ehX1gcrT0y/
	 10gLnwuJ/GOBhORNo05UxSlNCM1G8NuFy7b0432NFxtIWuyRu6I9PH+l22w3H2T1IU
	 yjoLEoUl0ovAYFOs8DEX4vzDjbWkZ4JEWyJgtZ3A=
Date: Sun, 10 Dec 2023 16:54:13 -0800
To: mm-commits@vger.kernel.org,tytso@mit.edu,djwong@kernel.org,agruenba@redhat.com,adilger.kernel@dilger.ca,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch removed from -mm tree
Message-Id: <20231211005413.C50BFC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gfs2: convert stuffed_readpage() to stuffed_read_folio()
has been removed from the -mm tree.  Its filename was
     gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: convert stuffed_readpage() to stuffed_read_folio()
Date: Tue, 7 Nov 2023 21:26:42 +0000

Use folio_fill_tail() to implement the unstuffing and folio_end_read() to
simultaneously mark the folio uptodate and unlock it.  Unifies a couple of
code paths.

Link: https://lkml.kernel.org/r/20231107212643.3490372-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/fs/gfs2/aops.c~gfs2-convert-stuffed_readpage-to-stuffed_read_folio
+++ a/fs/gfs2/aops.c
@@ -403,18 +403,18 @@ static int gfs2_jdata_writepages(struct
 }
 
 /**
- * stuffed_readpage - Fill in a Linux folio with stuffed file data
+ * stuffed_read_folio - Fill in a Linux folio with stuffed file data
  * @ip: the inode
  * @folio: the folio
  *
  * Returns: errno
  */
-static int stuffed_readpage(struct gfs2_inode *ip, struct folio *folio)
+static int stuffed_read_folio(struct gfs2_inode *ip, struct folio *folio)
 {
-	struct buffer_head *dibh;
-	size_t i_size = i_size_read(&ip->i_inode);
-	void *data;
-	int error;
+	struct buffer_head *dibh = NULL;
+	size_t dsize = i_size_read(&ip->i_inode);
+	void *from = NULL;
+	int error = 0;
 
 	/*
 	 * Due to the order of unstuffing files and ->fault(), we can be
@@ -422,22 +422,20 @@ static int stuffed_readpage(struct gfs2_
 	 * so we need to supply one here. It doesn't happen often.
 	 */
 	if (unlikely(folio->index)) {
-		folio_zero_range(folio, 0, folio_size(folio));
-		folio_mark_uptodate(folio);
-		return 0;
+		dsize = 0;
+	} else {
+		error = gfs2_meta_inode_buffer(ip, &dibh);
+		if (error)
+			goto out;
+		from = dibh->b_data + sizeof(struct gfs2_dinode);
 	}
 
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		return error;
-
-	data = dibh->b_data + sizeof(struct gfs2_dinode);
-	memcpy_to_folio(folio, 0, data, i_size);
-	folio_zero_range(folio, i_size, folio_size(folio) - i_size);
+	folio_fill_tail(folio, 0, from, dsize);
 	brelse(dibh);
-	folio_mark_uptodate(folio);
+out:
+	folio_end_read(folio, error == 0);
 
-	return 0;
+	return error;
 }
 
 /**
@@ -456,8 +454,7 @@ static int gfs2_read_folio(struct file *
 	    (i_blocksize(inode) == PAGE_SIZE && !folio_buffers(folio))) {
 		error = iomap_read_folio(folio, &gfs2_iomap_ops);
 	} else if (gfs2_is_stuffed(ip)) {
-		error = stuffed_readpage(ip, folio);
-		folio_unlock(folio);
+		error = stuffed_read_folio(ip, folio);
 	} else {
 		error = mpage_read_folio(folio, gfs2_block_map);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
nilfs2-add-nilfs_end_folio_io.patch
nilfs2-convert-nilfs_abort_logs-to-use-folios.patch
nilfs2-convert-nilfs_segctor_complete_write-to-use-folios.patch
nilfs2-convert-nilfs_forget_buffer-to-use-a-folio.patch
nilfs2-convert-to-nilfs_folio_buffers_clean.patch
nilfs2-convert-nilfs_writepage-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio.patch
nilfs2-convert-to-nilfs_clear_folio_dirty.patch
nilfs2-convert-to-__nilfs_clear_folio_dirty.patch
nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios.patch
nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_gccache_submit_read_data-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_delete-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio.patch
nilfs2-remove-page_address-from-nilfs_set_link.patch
nilfs2-remove-page_address-from-nilfs_add_link.patch
nilfs2-remove-page_address-from-nilfs_delete_entry.patch
nilfs2-return-the-mapped-address-from-nilfs_get_page.patch
nilfs2-pass-the-mapped-address-to-nilfs_check_page.patch
nilfs2-switch-to-kmap_local-for-directory-handling.patch
nilfs2-add-nilfs_get_folio.patch
nilfs2-convert-nilfs_readdir-to-use-a-folio.patch
nilfs2-convert-nilfs_find_entry-to-use-a-folio.patch
nilfs2-convert-nilfs_rename-to-use-folios.patch
nilfs2-convert-nilfs_add_link-to-use-a-folio.patch
nilfs2-convert-nilfs_empty_dir-to-use-a-folio.patch
nilfs2-convert-nilfs_make_empty-to-use-a-folio.patch
nilfs2-convert-nilfs_prepare_chunk-and-nilfs_commit_chunk-to-folios.patch
nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch

