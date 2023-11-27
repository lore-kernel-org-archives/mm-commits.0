Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FB5C46CA0
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbjK0RJN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbjK0RI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:08:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5003E1A7
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:08:16 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05F6C433C7;
        Mon, 27 Nov 2023 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104896;
        bh=CxeEmnh24kibTts3q+VT0pW2logVwBXNcbRsLp5UO/o=;
        h=Date:To:From:Subject:From;
        b=R1WJGsuyANdp5n7bpaWrHFkF1xa1VjsO55egW/FilwzTmTyhkoo4pW4/gmUIaD7F+
         hSl0B9Pw0DDgBUK3aRsz0MqUM+bc7jkqgrG0QsCwqV0ou/jeZNF6lKJzO6EkVJ6M6a
         OwEZTpjYWkfezUnFrhHFAIvWYeMta+obSX6ypbVg=
Date:   Mon, 27 Nov 2023 09:08:15 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch added to mm-nonmm-unstable branch
Message-Id: <20231127170815.E05F6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_page_bug() to nilfs_folio_bug()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: nilfs2: convert nilfs_page_bug() to nilfs_folio_bug()
Date: Mon, 27 Nov 2023 23:30:36 +0900

All callers have a folio now, so convert it.

Link: https://lkml.kernel.org/r/20231127143036.2425-18-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |    4 ++--
 fs/nilfs2/page.c   |   25 +++++++++++++------------
 fs/nilfs2/page.h   |    6 +++---
 3 files changed, 18 insertions(+), 17 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug
+++ a/fs/nilfs2/btnode.c
@@ -190,7 +190,7 @@ int nilfs_btnode_prepare_change_key(stru
 retry:
 		/* BUG_ON(oldkey != obh->b_folio->index); */
 		if (unlikely(oldkey != ofolio->index))
-			NILFS_PAGE_BUG(&ofolio->page,
+			NILFS_FOLIO_BUG(ofolio,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
@@ -246,7 +246,7 @@ void nilfs_btnode_commit_change_key(stru
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		ofolio = obh->b_folio;
 		if (unlikely(oldkey != ofolio->index))
-			NILFS_PAGE_BUG(&ofolio->page,
+			NILFS_FOLIO_BUG(ofolio,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug
+++ a/fs/nilfs2/page.c
@@ -150,29 +150,30 @@ bool nilfs_folio_buffers_clean(struct fo
 	return true;
 }
 
-void nilfs_page_bug(struct page *page)
+void nilfs_folio_bug(struct folio *folio)
 {
+	struct buffer_head *bh, *head;
 	struct address_space *m;
 	unsigned long ino;
 
-	if (unlikely(!page)) {
-		printk(KERN_CRIT "NILFS_PAGE_BUG(NULL)\n");
+	if (unlikely(!folio)) {
+		printk(KERN_CRIT "NILFS_FOLIO_BUG(NULL)\n");
 		return;
 	}
 
-	m = page->mapping;
+	m = folio->mapping;
 	ino = m ? m->host->i_ino : 0;
 
-	printk(KERN_CRIT "NILFS_PAGE_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
+	printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
 	       "mapping=%p ino=%lu\n",
-	       page, page_ref_count(page),
-	       (unsigned long long)page->index, page->flags, m, ino);
+	       folio, folio_ref_count(folio),
+	       (unsigned long long)folio->index, folio->flags, m, ino);
 
-	if (page_has_buffers(page)) {
-		struct buffer_head *bh, *head;
+	head = folio_buffers(folio);
+	if (head) {
 		int i = 0;
 
-		bh = head = page_buffers(page);
+		bh = head;
 		do {
 			printk(KERN_CRIT
 			       " BH[%d] %p: cnt=%d block#=%llu state=0x%lx\n",
@@ -258,7 +259,7 @@ repeat:
 
 		folio_lock(folio);
 		if (unlikely(!folio_test_dirty(folio)))
-			NILFS_PAGE_BUG(&folio->page, "inconsistent dirty state");
+			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
 		if (unlikely(IS_ERR(dfolio))) {
@@ -268,7 +269,7 @@ repeat:
 			break;
 		}
 		if (unlikely(!folio_buffers(folio)))
-			NILFS_PAGE_BUG(&folio->page,
+			NILFS_FOLIO_BUG(folio,
 				       "found empty page in dat page cache");
 
 		nilfs_copy_folio(dfolio, folio, true);
--- a/fs/nilfs2/page.h~nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug
+++ a/fs/nilfs2/page.h
@@ -37,7 +37,7 @@ struct buffer_head *nilfs_grab_buffer(st
 void nilfs_forget_buffer(struct buffer_head *);
 void nilfs_copy_buffer(struct buffer_head *, struct buffer_head *);
 bool nilfs_folio_buffers_clean(struct folio *);
-void nilfs_page_bug(struct page *);
+void nilfs_folio_bug(struct folio *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
@@ -49,7 +49,7 @@ unsigned long nilfs_find_uncommitted_ext
 					    sector_t start_blk,
 					    sector_t *blkoff);
 
-#define NILFS_PAGE_BUG(page, m, a...) \
-	do { nilfs_page_bug(page); BUG(); } while (0)
+#define NILFS_FOLIO_BUG(folio, m, a...) \
+	do { nilfs_folio_bug(folio); BUG(); } while (0)
 
 #endif /* _NILFS_PAGE_H */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
gfp-include-__gfp_nowarn-in-gfp_nowait.patch
memory-failure-use-a-folio-in-me_pagecache_clean.patch
memory-failure-use-a-folio-in-me_pagecache_dirty.patch
memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch
memory-failure-use-a-folio-in-me_huge_page.patch
memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch
fs-convert-error_remove_page-to-error_remove_folio.patch
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

