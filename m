From: akpm@linux-foundation.org
Subject: + ext3-speed-up-file-creates-by-optimizing-rec_len-functions.patch added to -mm tree
Date: Tue, 07 Dec 2010 13:07:22 -0800
Message-ID: <201012072107.oB7L7MkE008162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab0LGVHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 16:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, jack@suse.cz


The patch titled
     ext3: speed up file creates by optimizing rec_len functions
has been added to the -mm tree.  Its filename is
     ext3-speed-up-file-creates-by-optimizing-rec_len-functions.patch

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
Subject: ext3: speed up file creates by optimizing rec_len functions
From: Eric Sandeen <sandeen@redhat.com>

The addition of 64k block capability in the rec_len_from_disk and
rec_len_to_disk functions added a bit of math overhead which slows down
file create workloads needlessly when the architecture cannot even support
64k blocks, thanks to page size limits.

Similar changes already exist in the ext4 codebase.

The directory entry checking can also be optimized a bit by sprinkling in
some unlikely() conditions to move the error handling out of line.

bonnie++ sequential file creates on a 512MB ramdisk speeds up from about
77,000/s to about 82,000/s, about a 6% improvement.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc:  Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c           |   15 ++++++++-------
 include/linux/ext3_fs.h |    9 +++++++++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff -puN fs/ext3/dir.c~ext3-speed-up-file-creates-by-optimizing-rec_len-functions fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-speed-up-file-creates-by-optimizing-rec_len-functions
+++ a/fs/ext3/dir.c
@@ -69,25 +69,26 @@ int ext3_check_dir_entry (const char * f
 	const char * error_msg = NULL;
 	const int rlen = ext3_rec_len_from_disk(de->rec_len);
 
-	if (rlen < EXT3_DIR_REC_LEN(1))
+	if (unlikely(rlen < EXT3_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
-	else if (rlen % 4 != 0)
+	else if (unlikely(rlen % 4 != 0))
 		error_msg = "rec_len % 4 != 0";
-	else if (rlen < EXT3_DIR_REC_LEN(de->name_len))
+	else if (unlikely(rlen < EXT3_DIR_REC_LEN(de->name_len)))
 		error_msg = "rec_len is too small for name_len";
-	else if (((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)
+	else if (unlikely((((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)))
 		error_msg = "directory entry across blocks";
-	else if (le32_to_cpu(de->inode) >
-			le32_to_cpu(EXT3_SB(dir->i_sb)->s_es->s_inodes_count))
+	else if (unlikely(le32_to_cpu(de->inode) >
+			le32_to_cpu(EXT3_SB(dir->i_sb)->s_es->s_inodes_count)))
 		error_msg = "inode out of bounds";
 
-	if (error_msg != NULL)
+	if (unlikely(error_msg != NULL))
 		ext3_error (dir->i_sb, function,
 			"bad entry in directory #%lu: %s - "
 			"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
 			dir->i_ino, error_msg, offset,
 			(unsigned long) le32_to_cpu(de->inode),
 			rlen, de->name_len);
+
 	return error_msg == NULL ? 1 : 0;
 }
 
diff -puN include/linux/ext3_fs.h~ext3-speed-up-file-creates-by-optimizing-rec_len-functions include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-speed-up-file-creates-by-optimizing-rec_len-functions
+++ a/include/linux/ext3_fs.h
@@ -724,21 +724,30 @@ struct ext3_dir_entry_2 {
 					 ~EXT3_DIR_ROUND)
 #define EXT3_MAX_REC_LEN		((1<<16)-1)
 
+/*
+ * Tests against MAX_REC_LEN etc were put in place for 64k block
+ * sizes; if that is not possible on this arch, we can skip
+ * those tests and speed things up.
+ */
 static inline unsigned ext3_rec_len_from_disk(__le16 dlen)
 {
 	unsigned len = le16_to_cpu(dlen);
 
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == EXT3_MAX_REC_LEN)
 		return 1 << 16;
+#endif
 	return len;
 }
 
 static inline __le16 ext3_rec_len_to_disk(unsigned len)
 {
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == (1 << 16))
 		return cpu_to_le16(EXT3_MAX_REC_LEN);
 	else if (len > (1 << 16))
 		BUG();
+#endif
 	return cpu_to_le16(len);
 }
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

linux-next.patch
ext2-speed-up-file-creates-by-optimizing-rec_len-functions.patch
ext3-speed-up-file-creates-by-optimizing-rec_len-functions.patch

