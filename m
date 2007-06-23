From: akpm@linux-foundation.org
Subject: + ext4-zero_user_page-conversion.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:54:26 -0700
Message-ID: <200706231654.l5NGsN2a019749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759057AbXFWQy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, tytso@mit.edu


The patch titled
     ext4: zero_user_page() conversions
has been added to the -mm tree.  Its filename is
     ext4-zero_user_page-conversion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: zero_user_page() conversions
From: Eric Sandeen <sandeen@redhat.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN fs/ext4/inode.c~ext4-zero_user_page-conversion fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-zero_user_page-conversion
+++ a/fs/ext4/inode.c
@@ -1830,7 +1830,6 @@ int ext4_block_truncate_page(handle_t *h
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 			test_opt(inode->i_sb, EXTENTS) &&
@@ -1847,10 +1846,7 @@ int ext4_block_truncate_page(handle_t *h
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext4_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, length, KM_USER0);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1903,10 +1899,7 @@ int ext4_block_truncate_page(handle_t *h
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length, KM_USER0);
 
 	BUFFER_TRACE(bh, "zeroed end of block");
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

cifs-zero_user_page-conversion.patch
gfs2-zero_user_page-conversion.patch
ocfs2-zero_user_page-conversion.patch
ext4-zero_user_page-conversion.patch
