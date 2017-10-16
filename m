From: akpm@linux-foundation.org
Subject: + hfs-hfsplus-clean-up-unused-variables-in-bnodec.patch added to
 -mm tree
Date: Mon, 16 Oct 2017 15:37:34 -0700
Message-ID: <59e534ae.IhDU/TiThGAVvNYy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdJPWhf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris.gekas@gmail.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs/hfsplus: clean up unused variables in bnode.c
has been added to the -mm tree.  Its filename is
     hfs-hfsplus-clean-up-unused-variables-in-bnodec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfs-hfsplus-clean-up-unused-variables-in-bnodec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfs-hfsplus-clean-up-unused-variables-in-bnodec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -97,13 +97,11 @@ void hfs_bnode_clear(struct hfs_bnode *n
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
@@ -236,7 +234,6 @@ struct hfs_bnode *hfs_bnode_findhash(str
 
 static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 {
-	struct super_block *sb;
 	struct hfs_bnode *node, *node2;
 	struct address_space *mapping;
 	struct page *page;
@@ -248,7 +245,6 @@ static struct hfs_bnode *__hfs_bnode_cre
 		return NULL;
 	}
 
-	sb = tree->inode->i_sb;
 	size = sizeof(struct hfs_bnode) + tree->pages_per_bnode *
 		sizeof(struct page *);
 	node = kzalloc(size, GFP_KERNEL);
diff -puN fs/hfsplus/bnode.c~hfs-hfsplus-clean-up-unused-variables-in-bnodec fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~hfs-hfsplus-clean-up-unused-variables-in-bnodec
+++ a/fs/hfsplus/bnode.c
@@ -126,14 +126,12 @@ void hfs_bnode_clear(struct hfs_bnode *n
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
@@ -400,7 +398,6 @@ struct hfs_bnode *hfs_bnode_findhash(str
 
 static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 {
-	struct super_block *sb;
 	struct hfs_bnode *node, *node2;
 	struct address_space *mapping;
 	struct page *page;
@@ -413,7 +410,6 @@ static struct hfs_bnode *__hfs_bnode_cre
 		return NULL;
 	}
 
-	sb = tree->inode->i_sb;
 	size = sizeof(struct hfs_bnode) + tree->pages_per_bnode *
 		sizeof(struct page *);
 	node = kzalloc(size, GFP_KERNEL);
_

Patches currently in -mm which might be from chris.gekas@gmail.com are

hfs-hfsplus-clean-up-unused-variables-in-bnodec.patch

