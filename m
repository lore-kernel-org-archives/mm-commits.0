From: akpm@linux-foundation.org
Subject: + isofs-fix-isofs_get_blocks-for-8tb-files.patch added to -mm tree
Date: Mon, 04 Oct 2010 12:50:21 -0700
Message-ID: <201010041950.o94JoMWY010763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926Ab0JDTu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 15:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     isofs: fix isofs_get_blocks for 8TB files
has been added to the -mm tree.  Its filename is
     isofs-fix-isofs_get_blocks-for-8tb-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isofs: fix isofs_get_blocks for 8TB files
From: Jan Kara <jack@suse.cz>

Currently isofs_get_blocks() was limited to handle only 4TB files on
32-bit architectures because of unnecessary use of iblock variable which
was signed long.  Just remove the variable.  The error messages that were
using this variable should have rather used b_off anyway because that is
the block we are currently mapping.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/isofs/inode.c~isofs-fix-isofs_get_blocks-for-8tb-files fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-fix-isofs_get_blocks-for-8tb-files
+++ a/fs/isofs/inode.c
@@ -1002,26 +1002,23 @@ static int isofs_statfs (struct dentry *
  * or getblk() if they are not.  Returns the number of blocks inserted
  * (-ve == error.)
  */
-int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
+int isofs_get_blocks(struct inode *inode, sector_t iblock,
 		     struct buffer_head **bh, unsigned long nblocks)
 {
-	unsigned long b_off;
+	unsigned long b_off = iblock;
 	unsigned offset, sect_size;
 	unsigned int firstext;
 	unsigned long nextblk, nextoff;
-	long iblock = (long)iblock_s;
 	int section, rv, error;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
 	error = -EIO;
 	rv = 0;
-	if (iblock < 0 || iblock != iblock_s) {
+	if (iblock != b_off) {
 		printk(KERN_DEBUG "%s: block number too large\n", __func__);
 		goto abort;
 	}
 
-	b_off = iblock;
-
 	offset = 0;
 	firstext = ei->i_first_extent;
 	sect_size = ei->i_section_size >> ISOFS_BUFFER_BITS(inode);
@@ -1038,8 +1035,9 @@ int isofs_get_blocks(struct inode *inode
 		 * I/O errors.
 		 */
 		if (b_off > ((inode->i_size + PAGE_CACHE_SIZE - 1) >> ISOFS_BUFFER_BITS(inode))) {
-			printk(KERN_DEBUG "%s: block >= EOF (%ld, %ld)\n",
-				__func__, iblock, (unsigned long) inode->i_size);
+			printk(KERN_DEBUG "%s: block >= EOF (%lu, %llu)\n",
+				__func__, b_off,
+				(unsigned long long)inode->i_size);
 			goto abort;
 		}
 
@@ -1065,9 +1063,9 @@ int isofs_get_blocks(struct inode *inode
 			if (++section > 100) {
 				printk(KERN_DEBUG "%s: More than 100 file sections ?!?"
 					" aborting...\n", __func__);
-				printk(KERN_DEBUG "%s: block=%ld firstext=%u sect_size=%u "
+				printk(KERN_DEBUG "%s: block=%lu firstext=%u sect_size=%u "
 					"nextblk=%lu nextoff=%lu\n", __func__,
-					iblock, firstext, (unsigned) sect_size,
+					b_off, firstext, (unsigned) sect_size,
 					nextblk, nextoff);
 				goto abort;
 			}
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch
isofs-fix-isofs_get_blocks-for-8tb-files.patch

