From: akpm@linux-foundation.org
Subject: - fs-cramfs-inodec-remove-unused-variable.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:31 -0700
Message-ID: <200710190345.l9J3jVJJ013230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757604AbXJSDzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists-receive@programmierforen.de, mm-commits@vger.kernel.org


The patch titled
     fs/cramfs/inode.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     fs-cramfs-inodec-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/cramfs/inode.c: remove unused variable
From: Andi Drebes <lists-receive@programmierforen.de>

Remove a variable that is never read.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-inodec-remove-unused-variable fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-inodec-remove-unused-variable
+++ a/fs/cramfs/inode.c
@@ -148,7 +148,7 @@ static void *cramfs_read(struct super_bl
 {
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 	struct page *pages[BLKS_PER_BUF];
-	unsigned i, blocknr, buffer, unread;
+	unsigned i, blocknr, buffer;
 	unsigned long devsize;
 	char *data;
 
@@ -175,7 +175,6 @@ static void *cramfs_read(struct super_bl
 	devsize = mapping->host->i_size >> PAGE_CACHE_SHIFT;
 
 	/* Ok, read in BLKS_PER_BUF pages completely first. */
-	unread = 0;
 	for (i = 0; i < BLKS_PER_BUF; i++) {
 		struct page *page = NULL;
 
_

Patches currently in -mm which might be from lists-receive@programmierforen.de are

origin.patch
