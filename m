Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CC923B5
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VI8Zv+tX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF263C433C8;
	Mon, 11 Dec 2023 00:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256050;
	bh=JExE+DXTpyC6sG1uo1H18Qbt1pU1uH7R8nYdh5bK5tw=;
	h=Date:To:From:Subject:From;
	b=VI8Zv+tXPxkaZZLTBdmfPlmwPK+vQTln6ovvHRPE9I0oMMI0uaUE9naPMZjRtpk08
	 5LwGtR+M4aQYGukaj48SmvDVqmLLBMlPTtFWm90qYHEslk0JJIpdIoG0s9QksDu/xu
	 6IP+QLOyTwmLGTb3XXweQp6GgPOna95K9XwrWCEI=
Date: Sun, 10 Dec 2023 16:54:10 -0800
To: mm-commits@vger.kernel.org,tytso@mit.edu,djwong@kernel.org,agruenba@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_zero_tail-and-use-it-in-ext4.patch removed from -mm tree
Message-Id: <20231211005410.BF263C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add folio_zero_tail() and use it in ext4
has been removed from the -mm tree.  Its filename was
     mm-add-folio_zero_tail-and-use-it-in-ext4.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_zero_tail() and use it in ext4
Date: Tue, 7 Nov 2023 21:26:40 +0000

Patch series "Add folio_zero_tail() and folio_fill_tail()".

I'm trying to make it easier for filesystems with tailpacking / stuffing /
inline data to use folios.  The primary function here is
folio_fill_tail().  You give it a pointer to memory where the data
currently is, and it takes care of copying it into the folio at that
offset.  That works for gfs2 & iomap.  Then There's Ext4.  Rather than gin
up some kind of specialist "Here's a two pointers to two blocks of memory"
routine, just let it do its current thing, and let it call
folio_zero_tail(), which is also called by folio_fill_tail().

Other filesystems can be converted later; these ones seemed like good
examples as they're already partly or completely converted to folios.


This patch (of 3):

Instead of unmapping the folio after copying the data to it, then mapping
it again to zero the tail, provide folio_zero_tail() to zero the tail of
an already-mapped folio.

[akpm@linux-foundation.org: fix kerneldoc argument ordering]
Link: https://lkml.kernel.org/r/20231107212643.3490372-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231107212643.3490372-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inline.c        |    3 +--
 include/linux/highmem.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

--- a/fs/ext4/inline.c~mm-add-folio_zero_tail-and-use-it-in-ext4
+++ a/fs/ext4/inline.c
@@ -502,9 +502,8 @@ static int ext4_read_inline_folio(struct
 	BUG_ON(len > PAGE_SIZE);
 	kaddr = kmap_local_folio(folio, 0);
 	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
-	flush_dcache_folio(folio);
+	kaddr = folio_zero_tail(folio, len, kaddr + len);
 	kunmap_local(kaddr);
-	folio_zero_segment(folio, len, folio_size(folio));
 	folio_mark_uptodate(folio);
 	brelse(iloc.bh);
 
--- a/include/linux/highmem.h~mm-add-folio_zero_tail-and-use-it-in-ext4
+++ a/include/linux/highmem.h
@@ -484,6 +484,44 @@ static inline void memcpy_to_folio(struc
 }
 
 /**
+ * folio_zero_tail - Zero the tail of a folio.
+ * @folio: The folio to zero.
+ * @offset: The byte offset in the folio to start zeroing at.
+ * @kaddr: The address the folio is currently mapped to.
+ *
+ * If you have already used kmap_local_folio() to map a folio, written
+ * some data to it and now need to zero the end of the folio (and flush
+ * the dcache), you can use this function.  If you do not have the
+ * folio kmapped (eg the folio has been partially populated by DMA),
+ * use folio_zero_range() or folio_zero_segment() instead.
+ *
+ * Return: An address which can be passed to kunmap_local().
+ */
+static inline __must_check void *folio_zero_tail(struct folio *folio,
+		size_t offset, void *kaddr)
+{
+	size_t len = folio_size(folio) - offset;
+
+	if (folio_test_highmem(folio)) {
+		size_t max = PAGE_SIZE - offset_in_page(offset);
+
+		while (len > max) {
+			memset(kaddr, 0, max);
+			kunmap_local(kaddr);
+			len -= max;
+			offset += max;
+			max = PAGE_SIZE;
+			kaddr = kmap_local_folio(folio, offset);
+		}
+	}
+
+	memset(kaddr, 0, len);
+	flush_dcache_folio(folio);
+
+	return kaddr;
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

