From: akpm@linux-foundation.org
Subject: + reiserfs-use-generic_cont_expand_simple.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:30 -0700
Message-ID: <200705292120.l4TLKUIf011791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXE2VUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vs@namesys.com, npiggin@suse.de


The patch titled
     reiserfs: use generic_cont_expand_simple
has been added to the -mm tree.  Its filename is
     reiserfs-use-generic_cont_expand_simple.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: use generic_cont_expand_simple
From: Vladimir Saveliev <vs@namesys.com>

This patch makes reiserfs to use AOP_FLAG_CONT_EXPAND
in order to get rid of the special generic_cont_expand routine

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-use-generic_cont_expand_simple fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-use-generic_cont_expand_simple
+++ a/fs/reiserfs/inode.c
@@ -2561,13 +2561,20 @@ static int reiserfs_write_begin(struct f
 	int ret;
 	int old_ref = 0;
 
+ 	inode = mapping->host;
+	*fsdata = 0;
+ 	if (flags & AOP_FLAG_CONT_EXPAND &&
+ 	    (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
+ 		pos ++;
+		*fsdata = (void *)(unsigned long)flags;
+	}
+
 	index = pos >> PAGE_CACHE_SHIFT;
 	page = __grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
 
-	inode = mapping->host;
 	reiserfs_wait_on_write_block(inode->i_sb);
 	fix_tail_page_for_writing(page);
 	if (reiserfs_transaction_running(inode->i_sb)) {
@@ -2677,6 +2684,8 @@ static int reiserfs_write_end(struct fil
 	struct reiserfs_transaction_handle *th;
 	unsigned start;
 
+	if ((unsigned long)fsdata & AOP_FLAG_CONT_EXPAND)
+		pos ++;
 
 	reiserfs_wait_on_write_block(inode->i_sb);
 	if (reiserfs_transaction_running(inode->i_sb))
@@ -3065,7 +3074,7 @@ int reiserfs_setattr(struct dentry *dent
 		}
 		/* fill in hole pointers in the expanding truncate case. */
 		if (attr->ia_size > inode->i_size) {
-			error = generic_cont_expand(inode, attr->ia_size);
+			error = generic_cont_expand_simple(inode, attr->ia_size);
 			if (REISERFS_I(inode)->i_prealloc_count > 0) {
 				int err;
 				struct reiserfs_transaction_handle th;
_

Patches currently in -mm which might be from vs@namesys.com are

reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
reiser4.patch
reiser4-use-zero_user_page.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
