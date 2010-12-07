From: akpm@linux-foundation.org
Subject: + ext2-speed-up-file-creates-by-optimizing-rec_len-functions.patch added to -mm tree
Date: Tue, 07 Dec 2010 13:07:19 -0800
Message-ID: <201012072107.oB7L7L3O008159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab0LGVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 16:07:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, jack@suse.cz


The patch titled
     ext2: speed up file creates by optimizing rec_len functions
has been added to the -mm tree.  Its filename is
     ext2-speed-up-file-creates-by-optimizing-rec_len-functions.patch

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
Subject: ext2: speed up file creates by optimizing rec_len functions
From: Eric Sandeen <sandeen@redhat.com>

The addition of 64k block capability in the rec_len_from_disk and
rec_len_to_disk functions added a bit of math overhead which slows down
file create workloads needlessly when the architecture cannot even support
64k blocks, thanks to page size limits.

The directory entry checking can also be optimized a bit by sprinkling in
some unlikely() conditions to move the error handling out of line.

bonnie++ sequential file creates on a 512MB ramdisk speeds up
from about 2200/s to about 2500/s, about a 14% improvement.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/ext2/dir.c~ext2-speed-up-file-creates-by-optimizing-rec_len-functions fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-speed-up-file-creates-by-optimizing-rec_len-functions
+++ a/fs/ext2/dir.c
@@ -28,21 +28,30 @@
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
+/*
+ * Tests against MAX_REC_LEN etc were put in place for 64k block
+ * sizes; if that is not possible on this arch, we can skip
+ * those tests and speed things up.
+ */
 static inline unsigned ext2_rec_len_from_disk(__le16 dlen)
 {
 	unsigned len = le16_to_cpu(dlen);
 
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == EXT2_MAX_REC_LEN)
 		return 1 << 16;
+#endif
 	return len;
 }
 
 static inline __le16 ext2_rec_len_to_disk(unsigned len)
 {
+#if (PAGE_CACHE_SIZE >= 65536)
 	if (len == (1 << 16))
 		return cpu_to_le16(EXT2_MAX_REC_LEN);
 	else
 		BUG_ON(len > (1 << 16));
+#endif
 	return cpu_to_le16(len);
 }
 
@@ -129,15 +138,15 @@ static void ext2_check_page(struct page 
 		p = (ext2_dirent *)(kaddr + offs);
 		rec_len = ext2_rec_len_from_disk(p->rec_len);
 
-		if (rec_len < EXT2_DIR_REC_LEN(1))
+		if (unlikely(rec_len < EXT2_DIR_REC_LEN(1)))
 			goto Eshort;
-		if (rec_len & 3)
+		if (unlikely(rec_len & 3))
 			goto Ealign;
-		if (rec_len < EXT2_DIR_REC_LEN(p->name_len))
+		if (unlikely(rec_len < EXT2_DIR_REC_LEN(p->name_len)))
 			goto Enamelen;
-		if (((offs + rec_len - 1) ^ offs) & ~(chunk_size-1))
+		if (unlikely(((offs + rec_len - 1) ^ offs) & ~(chunk_size-1)))
 			goto Espan;
-		if (le32_to_cpu(p->inode) > max_inumber)
+		if (unlikely(le32_to_cpu(p->inode) > max_inumber))
 			goto Einumber;
 	}
 	if (offs != limit)
_

Patches currently in -mm which might be from sandeen@redhat.com are

linux-next.patch
ext2-speed-up-file-creates-by-optimizing-rec_len-functions.patch
ext3-speed-up-file-creates-by-optimizing-rec_len-functions.patch

