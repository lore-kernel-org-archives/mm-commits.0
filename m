From: akpm@linux-foundation.org
Subject: + adfs-fix-e-f-dir-size-2048-crashing-kernel.patch added to -mm tree
Date: Wed, 19 Jan 2011 15:28:31 -0800
Message-ID: <201101192328.p0JNSVXm009886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906Ab1ASX3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 18:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stuart.swales.croftnuisk@gmail.com, rmk@arm.linux.org.uk


The patch titled
     adfs: fix E+/F+ dir size > 2048 crashing kernel
has been added to the -mm tree.  Its filename is
     adfs-fix-e-f-dir-size-2048-crashing-kernel.patch

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
Subject: adfs: fix E+/F+ dir size > 2048 crashing kernel
From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>

Kernel crashes in fs/adfs module when accessing directories with a large
number of objects on mounted Acorn ADFS E+/F+ format discs (or images) as
the existing code writes off the end of the fixed array of struct
buffer_head pointers.

Additionally, each directory access that didn't crash would leak a buffer
as nr_buffers was not adjusted correctly for E+/F+ discs (was always left
as one less than required).

The patch fixes this by allocating a dynamically-sized set of struct
buffer_head pointers if necessary for the E+/F+ case (many directories
still do in fact fit in 2048 bytes) and sets the correct nr_buffers so
that all buffers are released.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=26072

Tested by tar'ing the contents of my RISC PC's E+ format 20Gb HDD which
contains a number of large directories that previously crashed the kernel.

Signed-off-by: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h      |    4 +
 fs/adfs/dir_fplus.c |  101 +++++++++++++++++++++++++++++++++---------
 2 files changed, 84 insertions(+), 21 deletions(-)

diff -puN fs/adfs/adfs.h~adfs-fix-e-f-dir-size-2048-crashing-kernel fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~adfs-fix-e-f-dir-size-2048-crashing-kernel
+++ a/fs/adfs/adfs.h
@@ -79,6 +79,10 @@ struct adfs_dir {
 
 	int			nr_buffers;
 	struct buffer_head	*bh[4];
+
+	/* big directories need allocated buffers */
+	struct buffer_head	**bh_fplus;
+
 	unsigned int		pos;
 	unsigned int		parent_id;
 
diff -puN fs/adfs/dir_fplus.c~adfs-fix-e-f-dir-size-2048-crashing-kernel fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~adfs-fix-e-f-dir-size-2048-crashing-kernel
+++ a/fs/adfs/dir_fplus.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 #include "adfs.h"
 #include "dir_fplus.h"
 
@@ -22,30 +23,53 @@ adfs_fplus_read(struct super_block *sb, 
 
 	dir->nr_buffers = 0;
 
+	/* start off using fixed bh set - only alloc for big dirs */
+	dir->bh_fplus = &dir->bh[0];
+
 	block = __adfs_block_map(sb, id, 0);
 	if (!block) {
 		adfs_error(sb, "dir object %X has a hole at offset 0", id);
 		goto out;
 	}
 
-	dir->bh[0] = sb_bread(sb, block);
-	if (!dir->bh[0])
+	dir->bh_fplus[0] = sb_bread(sb, block);
+	if (!dir->bh_fplus[0])
 		goto out;
 	dir->nr_buffers += 1;
 
-	h = (struct adfs_bigdirheader *)dir->bh[0]->b_data;
+	h = (struct adfs_bigdirheader *)dir->bh_fplus[0]->b_data;
 	size = le32_to_cpu(h->bigdirsize);
 	if (size != sz) {
-		printk(KERN_WARNING "adfs: adfs_fplus_read: directory header size\n"
-				" does not match directory size\n");
+		printk(KERN_WARNING "adfs: adfs_fplus_read:"
+					" directory header size %X\n"
+					" does not match directory size %X\n",
+					size, sz);
 	}
 
 	if (h->bigdirversion[0] != 0 || h->bigdirversion[1] != 0 ||
 	    h->bigdirversion[2] != 0 || size & 2047 ||
-	    h->bigdirstartname != cpu_to_le32(BIGDIRSTARTNAME))
+	    h->bigdirstartname != cpu_to_le32(BIGDIRSTARTNAME)) {
+		printk(KERN_WARNING "adfs: dir object %X has"
+					" malformed dir header\n", id);
 		goto out;
+	}
 
 	size >>= sb->s_blocksize_bits;
+	if (size > sizeof(dir->bh)/sizeof(dir->bh[0])) {
+		/* this directory is too big for fixed bh set, must allocate */
+		struct buffer_head **bh_fplus =
+			kzalloc(size * sizeof(struct buffer_head *),
+				GFP_KERNEL);
+		if (!bh_fplus) {
+			adfs_error(sb, "not enough memory for"
+					" dir object %X (%d blocks)", id, size);
+			goto out;
+		}
+		dir->bh_fplus = bh_fplus;
+		/* copy over the pointer to the block that we've already read */
+		dir->bh_fplus[0] = dir->bh[0];
+	}
+
 	for (blk = 1; blk < size; blk++) {
 		block = __adfs_block_map(sb, id, blk);
 		if (!block) {
@@ -53,25 +77,44 @@ adfs_fplus_read(struct super_block *sb, 
 			goto out;
 		}
 
-		dir->bh[blk] = sb_bread(sb, block);
-		if (!dir->bh[blk])
+		dir->bh_fplus[blk] = sb_bread(sb, block);
+		if (!dir->bh_fplus[blk]) {
+			adfs_error(sb,	"dir object %X failed read for"
+					" offset %d, mapped block %X",
+					id, blk, block);
 			goto out;
-		dir->nr_buffers = blk;
+		}
+
+		dir->nr_buffers += 1;
 	}
 
-	t = (struct adfs_bigdirtail *)(dir->bh[size - 1]->b_data + (sb->s_blocksize - 8));
+	t = (struct adfs_bigdirtail *)
+		(dir->bh_fplus[size - 1]->b_data + (sb->s_blocksize - 8));
 
 	if (t->bigdirendname != cpu_to_le32(BIGDIRENDNAME) ||
 	    t->bigdirendmasseq != h->startmasseq ||
-	    t->reserved[0] != 0 || t->reserved[1] != 0)
+	    t->reserved[0] != 0 || t->reserved[1] != 0) {
+		printk(KERN_WARNING "adfs: dir object %X has "
+					"malformed dir end\n", id);
 		goto out;
+	}
 
 	dir->parent_id = le32_to_cpu(h->bigdirparent);
 	dir->sb = sb;
 	return 0;
+
 out:
-	for (i = 0; i < dir->nr_buffers; i++)
-		brelse(dir->bh[i]);
+	if (dir->bh_fplus) {
+		for (i = 0; i < dir->nr_buffers; i++)
+			brelse(dir->bh_fplus[i]);
+
+		if (&dir->bh[0] != dir->bh_fplus)
+			kfree(dir->bh_fplus);
+
+		dir->bh_fplus = NULL;
+	}
+
+	dir->nr_buffers = 0;
 	dir->sb = NULL;
 	return ret;
 }
@@ -79,7 +122,8 @@ out:
 static int
 adfs_fplus_setpos(struct adfs_dir *dir, unsigned int fpos)
 {
-	struct adfs_bigdirheader *h = (struct adfs_bigdirheader *)dir->bh[0]->b_data;
+	struct adfs_bigdirheader *h =
+		(struct adfs_bigdirheader *) dir->bh_fplus[0]->b_data;
 	int ret = -ENOENT;
 
 	if (fpos <= le32_to_cpu(h->bigdirentries)) {
@@ -102,21 +146,27 @@ dir_memcpy(struct adfs_dir *dir, unsigne
 	partial = sb->s_blocksize - offset;
 
 	if (partial >= len)
-		memcpy(to, dir->bh[buffer]->b_data + offset, len);
+		memcpy(to, dir->bh_fplus[buffer]->b_data + offset, len);
 	else {
 		char *c = (char *)to;
 
 		remainder = len - partial;
 
-		memcpy(c, dir->bh[buffer]->b_data + offset, partial);
-		memcpy(c + partial, dir->bh[buffer + 1]->b_data, remainder);
+		memcpy(c,
+			dir->bh_fplus[buffer]->b_data + offset,
+			partial);
+
+		memcpy(c + partial,
+			dir->bh_fplus[buffer + 1]->b_data,
+			remainder);
 	}
 }
 
 static int
 adfs_fplus_getnext(struct adfs_dir *dir, struct object_info *obj)
 {
-	struct adfs_bigdirheader *h = (struct adfs_bigdirheader *)dir->bh[0]->b_data;
+	struct adfs_bigdirheader *h =
+		(struct adfs_bigdirheader *) dir->bh_fplus[0]->b_data;
 	struct adfs_bigdirentry bde;
 	unsigned int offset;
 	int i, ret = -ENOENT;
@@ -160,7 +210,7 @@ adfs_fplus_sync(struct adfs_dir *dir)
 	int i;
 
 	for (i = dir->nr_buffers - 1; i >= 0; i--) {
-		struct buffer_head *bh = dir->bh[i];
+		struct buffer_head *bh = dir->bh_fplus[i];
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh))
 			err = -EIO;
@@ -174,8 +224,17 @@ adfs_fplus_free(struct adfs_dir *dir)
 {
 	int i;
 
-	for (i = 0; i < dir->nr_buffers; i++)
-		brelse(dir->bh[i]);
+	if (dir->bh_fplus) {
+		for (i = 0; i < dir->nr_buffers; i++)
+			brelse(dir->bh_fplus[i]);
+
+		if (&dir->bh[0] != dir->bh_fplus)
+			kfree(dir->bh_fplus);
+
+		dir->bh_fplus = NULL;
+	}
+
+	dir->nr_buffers = 0;
 	dir->sb = NULL;
 }
 
_

Patches currently in -mm which might be from stuart.swales.croftnuisk@gmail.com are

adfs-fix-e-f-dir-size-2048-crashing-kernel.patch

