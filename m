Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8056C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjJYXsq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjJYXsU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F2F1A5
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265E5C433C9;
        Wed, 25 Oct 2023 23:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277689;
        bh=gEpEVJ0eN226h3EgZhk/j+jW7ylYxwrTgTfA/hPi+SY=;
        h=Date:To:From:Subject:From;
        b=SUYHa0fzIgX+m0OFiBHnFuTdqHL0vWxPkAFrL9z84lWrVXsXpC6t2CNgWnSF67MXQ
         m6GDIj20KtqYWMT7FHdCfgCmq3DehmqriK1Mg0TEoj7H06lipBTXbmsr+CUyNKXkDU
         H6dX6IWpa/u0LQQjho0qKyv19yWAw5sag0GaOJ4c=
Date:   Wed, 25 Oct 2023 16:48:08 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch removed from -mm tree
Message-Id: <20231025234809.265E5C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ufs: add ufs_get_locked_folio and ufs_put_locked_folio
has been removed from the -mm tree.  Its filename was
     ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ufs: add ufs_get_locked_folio and ufs_put_locked_folio
Date: Mon, 16 Oct 2023 21:11:10 +0100

Convert the _page variants to call them.  Saves a few hidden calls to
compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/util.c |   45 ++++++++++++++++++++++++++-------------------
 fs/ufs/util.h |   13 +++++++++----
 2 files changed, 35 insertions(+), 23 deletions(-)

--- a/fs/ufs/util.c~ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio
+++ a/fs/ufs/util.c
@@ -229,43 +229,50 @@ ufs_set_inode_dev(struct super_block *sb
 		ufsi->i_u1.i_data[0] = cpu_to_fs32(sb, fs32);
 }
 
+struct page *ufs_get_locked_page(struct address_space *mapping, pgoff_t index)
+{
+	struct folio *folio = ufs_get_locked_folio(mapping, index);
+
+	if (folio)
+		return folio_file_page(folio, index);
+	return NULL;
+}
+
 /**
- * ufs_get_locked_page() - locate, pin and lock a pagecache page, if not exist
+ * ufs_get_locked_folio() - locate, pin and lock a pagecache folio, if not exist
  * read it from disk.
  * @mapping: the address_space to search
  * @index: the page index
  *
- * Locates the desired pagecache page, if not exist we'll read it,
+ * Locates the desired pagecache folio, if not exist we'll read it,
  * locks it, increments its reference
  * count and returns its address.
  *
  */
-
-struct page *ufs_get_locked_page(struct address_space *mapping,
+struct folio *ufs_get_locked_folio(struct address_space *mapping,
 				 pgoff_t index)
 {
 	struct inode *inode = mapping->host;
-	struct page *page = find_lock_page(mapping, index);
-	if (!page) {
-		page = read_mapping_page(mapping, index, NULL);
-
-		if (IS_ERR(page)) {
-			printk(KERN_ERR "ufs_change_blocknr: "
-			       "read_mapping_page error: ino %lu, index: %lu\n",
+	struct folio *folio = filemap_lock_folio(mapping, index);
+	if (!folio) {
+		folio = read_mapping_folio(mapping, index, NULL);
+
+		if (IS_ERR(folio)) {
+			printk(KERN_ERR "ufs_change_blocknr: read_mapping_folio error: ino %lu, index: %lu\n",
 			       mapping->host->i_ino, index);
-			return page;
+			return folio;
 		}
 
-		lock_page(page);
+		folio_lock(folio);
 
-		if (unlikely(page->mapping == NULL)) {
+		if (unlikely(folio->mapping == NULL)) {
 			/* Truncate got there first */
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return NULL;
 		}
 	}
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
-	return page;
+	if (!folio_buffers(folio))
+		folio_create_empty_buffers(folio, 1 << inode->i_blkbits, 0);
+	return folio;
 }
--- a/fs/ufs/util.h~ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio
+++ a/fs/ufs/util.h
@@ -273,12 +273,17 @@ extern void _ubh_ubhcpymem_(struct ufs_s
 extern void _ubh_memcpyubh_(struct ufs_sb_private_info *, struct ufs_buffer_head *, unsigned char *, unsigned);
 
 /* This functions works with cache pages*/
-extern struct page *ufs_get_locked_page(struct address_space *mapping,
-					pgoff_t index);
+struct page *ufs_get_locked_page(struct address_space *mapping, pgoff_t index);
+struct folio *ufs_get_locked_folio(struct address_space *mapping, pgoff_t index);
+static inline void ufs_put_locked_folio(struct folio *folio)
+{
+       folio_unlock(folio);
+       folio_put(folio);
+}
+
 static inline void ufs_put_locked_page(struct page *page)
 {
-       unlock_page(page);
-       put_page(page);
+	ufs_put_locked_folio(page_folio(page));
 }
 
 
_

Patches currently in -mm which might be from willy@infradead.org are


