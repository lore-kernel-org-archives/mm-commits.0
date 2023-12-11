Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA3BE52
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CV2CmIMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3981C433C7;
	Mon, 11 Dec 2023 01:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257857;
	bh=xPUT508T9hjA6zWFuIYr4109bX3gvh7MTjCOuer5bCw=;
	h=Date:To:From:Subject:From;
	b=CV2CmIMS218pIP6iY9lMll4ILC9vLhB/pK2EUEnJKtb6yZVMMHQnDipkKhuUBn/8W
	 g2rtC0Lgr/0TrW+IIs5N1kaUpiq/jPUV0L44FU/OBYnVGR3JXshqUPRFsZHEwTzqqC
	 I+7KsJn/S1Wh5tNn3bu1R3b2p+6wmA0Xny4cZUPg=
Date: Sun, 10 Dec 2023 17:24:17 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch removed from -mm tree
Message-Id: <20231211012417.A3981C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_page_bug() to nilfs_folio_bug()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

