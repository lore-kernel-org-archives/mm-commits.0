From: akpm@linux-foundation.org
Subject: [patch 62/94] hfs/hfsplus: clean up unused variables in
 bnode.c
Date: Fri, 17 Nov 2017 15:29:54 -0800
Message-ID: <20171117232954.3JPs_uWZ-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966947AbdKQX3z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris.gekas@gmail.com, hch@infradead.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Christos Gkekas <chris.gekas@gmail.com>
Subject: hfs/hfsplus: clean up unused variables in bnode.c

Delete variables 'tree' and 'sb', which are set but never used.

Link: http://lkml.kernel.org/r/1507977146-15875-1-git-send-email-chris.gekas@gmail.com
Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bnode.c     |    4 ----
 fs/hfsplus/bnode.c |    4 ----
 2 files changed, 8 deletions(-)

diff -puN fs/hfs/bnode.c~hfs-hfsplus-clean-up-unused-variables-in-bnodec fs/hfs/bnode.c
--- a/fs/hfs/bnode.c~hfs-hfsplus-clean-up-unused-variables-in-bnodec
+++ a/fs/hfs/bnode.c
@@ -98,13 +98,11 @@ void hfs_bnode_clear(struct hfs_bnode *n
 void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
 		struct hfs_bnode *src_node, int src, int len)
 {
-	struct hfs_btree *tree;
 	struct page *src_page, *dst_page;
 
 	hfs_dbg(BNODE_MOD, "copybytes: %u,%u,%u\n", dst, src, len);
 	if (!len)
 		return;
-	tree = src_node->tree;
 	src += src_node->page_offset;
 	dst += dst_node->page_offset;
 	src_page = src_node->page[0];
@@ -237,7 +235,6 @@ struct hfs_bnode *hfs_bnode_findhash(str
 
 static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 {
-	struct super_block *sb;
 	struct hfs_bnode *node, *node2;
 	struct address_space *mapping;
 	struct page *page;
@@ -249,7 +246,6 @@ static struct hfs_bnode *__hfs_bnode_cre
 		return NULL;
 	}
 
-	sb = tree->inode->i_sb;
 	size = sizeof(struct hfs_bnode) + tree->pages_per_bnode *
 		sizeof(struct page *);
 	node = kzalloc(size, GFP_KERNEL);
diff -puN fs/hfsplus/bnode.c~hfs-hfsplus-clean-up-unused-variables-in-bnodec fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~hfs-hfsplus-clean-up-unused-variables-in-bnodec
+++ a/fs/hfsplus/bnode.c
@@ -127,14 +127,12 @@ void hfs_bnode_clear(struct hfs_bnode *n
 void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
 		    struct hfs_bnode *src_node, int src, int len)
 {
-	struct hfs_btree *tree;
 	struct page **src_page, **dst_page;
 	int l;
 
 	hfs_dbg(BNODE_MOD, "copybytes: %u,%u,%u\n", dst, src, len);
 	if (!len)
 		return;
-	tree = src_node->tree;
 	src += src_node->page_offset;
 	dst += dst_node->page_offset;
 	src_page = src_node->page + (src >> PAGE_SHIFT);
@@ -401,7 +399,6 @@ struct hfs_bnode *hfs_bnode_findhash(str
 
 static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 {
-	struct super_block *sb;
 	struct hfs_bnode *node, *node2;
 	struct address_space *mapping;
 	struct page *page;
@@ -414,7 +411,6 @@ static struct hfs_bnode *__hfs_bnode_cre
 		return NULL;
 	}
 
-	sb = tree->inode->i_sb;
 	size = sizeof(struct hfs_bnode) + tree->pages_per_bnode *
 		sizeof(struct page *);
 	node = kzalloc(size, GFP_KERNEL);
_
