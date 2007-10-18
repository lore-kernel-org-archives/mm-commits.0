From: akpm@linux-foundation.org
Subject: - fs-isofs-nameic-remove-uninitialized-local-vars-warning.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:49 -0700
Message-ID: <200710180700.l9I70ndP031116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbXJRHP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     fs/isofs/namei.c: Remove uninitialized local vars warning
has been removed from the -mm tree.  Its filename was
     fs-isofs-nameic-remove-uninitialized-local-vars-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/isofs/namei.c: Remove uninitialized local vars warning
From: Borislav Petkov <bbpetkov@yahoo.de>

shut up those:
fs/isofs/namei.c: In function 'isofs_lookup':
fs/isofs/namei.c:161: warning: 'offset' may be used uninitialized in this function
fs/isofs/namei.c:161: warning: 'block' may be used uninitialized in this function

By the way, they get overwritten at the end of isofs_find_entry().

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/isofs/namei.c~fs-isofs-nameic-remove-uninitialized-local-vars-warning fs/isofs/namei.c
--- a/fs/isofs/namei.c~fs-isofs-nameic-remove-uninitialized-local-vars-warning
+++ a/fs/isofs/namei.c
@@ -158,7 +158,8 @@ isofs_find_entry(struct inode *dir, stru
 struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	int found;
-	unsigned long block, offset;
+	unsigned long uninitialized_var(block);
+	unsigned long uninitialized_var(offset);
 	struct inode *inode;
 	struct page *page;
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
unify-dma_bit_mask-definitions-v31.patch
