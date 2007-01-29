From: akpm@osdl.org
Subject: + ext-jbd-layer-function-called-instead-of-fs-specific-one.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:15:56 -0800
Message-ID: <200701290015.l0T0FumU006819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995AbXA2AP6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:15:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org


The patch titled
     jbd layer function called instead of fs specific one
has been added to the -mm tree.  Its filename is
     ext-jbd-layer-function-called-instead-of-fs-specific-one.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jbd layer function called instead of fs specific one
From: Dmitriy Monakhov <dmonakhov@openvz.org>

jbd function called instead of fs specific one.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/inode.c |    4 ++--
 fs/ext4/inode.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext3/inode.c~ext-jbd-layer-function-called-instead-of-fs-specific-one fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext-jbd-layer-function-called-instead-of-fs-specific-one
+++ a/fs/ext3/inode.c
@@ -947,7 +947,7 @@ out:
 static int ext3_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
-	handle_t *handle = journal_current_handle();
+	handle_t *handle = ext3_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
@@ -1717,7 +1717,7 @@ static ssize_t ext3_direct_IO(int rw, st
 	/*
 	 * Reacquire the handle: ext3_get_block() can restart the transaction
 	 */
-	handle = journal_current_handle();
+	handle = ext3_journal_current_handle();
 
 out_stop:
 	if (handle) {
diff -puN fs/ext4/inode.c~ext-jbd-layer-function-called-instead-of-fs-specific-one fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext-jbd-layer-function-called-instead-of-fs-specific-one
+++ a/fs/ext4/inode.c
@@ -946,7 +946,7 @@ out:
 static int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
-	handle_t *handle = journal_current_handle();
+	handle_t *handle = ext4_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
@@ -1716,7 +1716,7 @@ static ssize_t ext4_direct_IO(int rw, st
 	/*
 	 * Reacquire the handle: ext4_get_block() can restart the transaction
 	 */
-	handle = journal_current_handle();
+	handle = ext4_journal_current_handle();
 
 out_stop:
 	if (handle) {
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

broadcom-4400-resume-small-fix-v2.patch
mm-search_binary_handler-mem-limit-fix.patch
ext-jbd-layer-function-called-instead-of-fs-specific-one.patch
