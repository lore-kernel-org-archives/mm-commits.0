Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C223A1
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zoXHdu74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE60BC433C8;
	Mon, 11 Dec 2023 00:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256055;
	bh=qd/E/G958crxWoU8QEWnR/oFEHClqH3G8P+Ese5d2ng=;
	h=Date:To:From:Subject:From;
	b=zoXHdu746uPoNE6BG7XT5ZaRaATY35ge2R3EsJjtE6K5eQFC+tY4WCvilQM4J/1dB
	 5iR94yQVJj3SadqhRnETRsrHmU3JCNQDs5hDpZIdO4SWXsQJAHd1OQrEIaRtizKTMj
	 T8b2ZCmmvVHUWvsIdO4vPNuzXdmRFJIrXeW1N3kg=
Date: Sun, 10 Dec 2023 16:54:15 -0800
To: mm-commits@vger.kernel.org,sfrench@samba.org,dhowells@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] afs-do-not-test-the-return-value-of-folio_start_writeback.patch removed from -mm tree
Message-Id: <20231211005415.BE60BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: afs: do not test the return value of folio_start_writeback()
has been removed from the -mm tree.  Its filename was
     afs-do-not-test-the-return-value-of-folio_start_writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: afs: do not test the return value of folio_start_writeback()
Date: Wed, 8 Nov 2023 20:46:03 +0000

In preparation for removing the return value entirely, stop testing it
in afs.

Link: https://lkml.kernel.org/r/20231108204605.745109-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/afs/write.c~afs-do-not-test-the-return-value-of-folio_start_writeback
+++ a/fs/afs/write.c
@@ -559,8 +559,7 @@ static void afs_extend_writeback(struct
 
 			if (!folio_clear_dirty_for_io(folio))
 				BUG();
-			if (folio_start_writeback(folio))
-				BUG();
+			folio_start_writeback(folio);
 			afs_folio_start_fscache(caching, folio);
 
 			*_count -= folio_nr_pages(folio);
@@ -595,8 +594,7 @@ static ssize_t afs_write_back_from_locke
 
 	_enter(",%lx,%llx-%llx", folio_index(folio), start, end);
 
-	if (folio_start_writeback(folio))
-		BUG();
+	folio_start_writeback(folio);
 	afs_folio_start_fscache(caching, folio);
 
 	count -= folio_nr_pages(folio);
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

