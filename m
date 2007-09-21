From: akpm@linux-foundation.org
Subject: + fs-isofs-nameic-remove-uninitialized-local-vars-warning.patch added to -mm tree
Date: Thu, 20 Sep 2007 22:03:29 -0700
Message-ID: <200709210503.l8L53T3t019734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbXIUFDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 01:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de


The patch titled
     fs/isofs/namei.c: Remove uninitialized local vars warning
has been added to the -mm tree.  Its filename is
     fs-isofs-nameic-remove-uninitialized-local-vars-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

unify-dma_bit_mask-definitions-v31.patch
fs-isofs-nameic-remove-uninitialized-local-vars-warning.patch
