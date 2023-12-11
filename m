Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE1A23B5
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zAjz9XwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436BCC433C8;
	Mon, 11 Dec 2023 00:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256052;
	bh=WQjZYCYW/qsoCTLiZ2rSwnmCYR0Gau/g+0rwUsJfAb4=;
	h=Date:To:From:Subject:From;
	b=zAjz9XwCwH8BfuiqLxISwD6WSdYy/mo1GP3sVf6LiCgmJh48r0kI3vXJPZ4nND3bF
	 /AKuGPfLVjjRBpjB0tAUKriHYzTLMZo0Ywfyy/l/1Lpyzk4vlf39yRwGJ+pp6hWC5y
	 q+S2r6bB/FoATJMj9kXXN/hbeDN2Qo36haZ+J2fo=
Date: Sun, 10 Dec 2023 16:54:11 -0800
To: mm-commits@vger.kernel.org,tytso@mit.edu,djwong@kernel.org,agruenba@redhat.com,adilger.kernel@dilger.ca,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_fill_tail-and-use-it-in-iomap.patch removed from -mm tree
Message-Id: <20231211005412.436BCC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add folio_fill_tail() and use it in iomap
has been removed from the -mm tree.  Its filename was
     mm-add-folio_fill_tail-and-use-it-in-iomap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_fill_tail() and use it in iomap
Date: Tue, 7 Nov 2023 21:26:41 +0000

The iomap code was limited to PAGE_SIZE bytes; generalise it to cover
an arbitrary-sized folio, and move it to be a common helper.

[akpm@linux-foundation.org: fix folio_fill_tail(), per Andreas Gruenbacher]
Link: https://lkml.kernel.org/r/20231107212643.3490372-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/buffered-io.c  |   14 ++------------
 include/linux/highmem.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 12 deletions(-)

--- a/fs/iomap/buffered-io.c~mm-add-folio_fill_tail-and-use-it-in-iomap
+++ a/fs/iomap/buffered-io.c
@@ -305,28 +305,18 @@ static int iomap_read_inline_data(const
 {
 	const struct iomap *iomap = iomap_iter_srcmap(iter);
 	size_t size = i_size_read(iter->inode) - iomap->offset;
-	size_t poff = offset_in_page(iomap->offset);
 	size_t offset = offset_in_folio(folio, iomap->offset);
-	void *addr;
 
 	if (folio_test_uptodate(folio))
 		return 0;
 
-	if (WARN_ON_ONCE(size > PAGE_SIZE - poff))
-		return -EIO;
-	if (WARN_ON_ONCE(size > PAGE_SIZE -
-			 offset_in_page(iomap->inline_data)))
-		return -EIO;
 	if (WARN_ON_ONCE(size > iomap->length))
 		return -EIO;
 	if (offset > 0)
 		ifs_alloc(iter->inode, folio, iter->flags);
 
-	addr = kmap_local_folio(folio, offset);
-	memcpy(addr, iomap->inline_data, size);
-	memset(addr + size, 0, PAGE_SIZE - poff - size);
-	kunmap_local(addr);
-	iomap_set_range_uptodate(folio, offset, PAGE_SIZE - poff);
+	folio_fill_tail(folio, offset, iomap->inline_data, size);
+	iomap_set_range_uptodate(folio, offset, folio_size(folio) - offset);
 	return 0;
 }
 
--- a/include/linux/highmem.h~mm-add-folio_fill_tail-and-use-it-in-iomap
+++ a/include/linux/highmem.h
@@ -522,6 +522,44 @@ static inline __must_check void *folio_z
 }
 
 /**
+ * folio_fill_tail - Copy some data to a folio and pad with zeroes.
+ * @folio: The destination folio.
+ * @offset: The offset into @folio at which to start copying.
+ * @from: The data to copy.
+ * @len: How many bytes of data to copy.
+ *
+ * This function is most useful for filesystems which support inline data.
+ * When they want to copy data from the inode into the page cache, this
+ * function does everything for them.  It supports large folios even on
+ * HIGHMEM configurations.
+ */
+static inline void folio_fill_tail(struct folio *folio, size_t offset,
+		const char *from, size_t len)
+{
+	char *to = kmap_local_folio(folio, offset);
+
+	VM_BUG_ON(offset + len > folio_size(folio));
+
+	if (folio_test_highmem(folio)) {
+		size_t max = PAGE_SIZE - offset_in_page(offset);
+
+		while (len > max) {
+			memcpy(to, from, max);
+			kunmap_local(to);
+			len -= max;
+			from += max;
+			offset += max;
+			max = PAGE_SIZE;
+			to = kmap_local_folio(folio, offset);
+		}
+	}
+
+	memcpy(to, from, len);
+	to = folio_zero_tail(folio, offset + len, to + len);
+	kunmap_local(to);
+}
+
+/**
  * memcpy_from_file_folio - Copy some bytes from a file folio.
  * @to: The destination buffer.
  * @folio: The folio to copy from.
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

