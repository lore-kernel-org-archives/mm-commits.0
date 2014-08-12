From: akpm@linux-foundation.org
Subject: [merged] fs-cramfs-convert-printk-to-pr_foo.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:41:02 -0700
Message-ID: <53ea6dce.YTuSFHZezHtDFVvT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:55010 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbaHLTlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:03 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so1312706vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sasha.levin@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cramfs: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-cramfs-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cramfs: convert printk to pr_foo()

Use current logging functions.  No level printk converted to pr_err

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c      |   14 +++++++-------
 fs/cramfs/uncompress.c |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-convert-printk-to-pr_foo fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-convert-printk-to-pr_foo
+++ a/fs/cramfs/inode.c
@@ -277,7 +277,7 @@ static int cramfs_fill_super(struct supe
 		/* check for wrong endianness */
 		if (super.magic == CRAMFS_MAGIC_WEND) {
 			if (!silent)
-				printk(KERN_ERR "cramfs: wrong endianness\n");
+				pr_err("cramfs: wrong endianness\n");
 			return -EINVAL;
 		}
 
@@ -287,22 +287,22 @@ static int cramfs_fill_super(struct supe
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
-				printk(KERN_ERR "cramfs: wrong endianness\n");
+				pr_err("cramfs: wrong endianness\n");
 			else if (!silent)
-				printk(KERN_ERR "cramfs: wrong magic\n");
+				pr_err("cramfs: wrong magic\n");
 			return -EINVAL;
 		}
 	}
 
 	/* get feature flags first */
 	if (super.flags & ~CRAMFS_SUPPORTED_FLAGS) {
-		printk(KERN_ERR "cramfs: unsupported filesystem features\n");
+		pr_err("cramfs: unsupported filesystem features\n");
 		return -EINVAL;
 	}
 
 	/* Check that the root inode is in a sane state */
 	if (!S_ISDIR(super.root.mode)) {
-		printk(KERN_ERR "cramfs: root is not a directory\n");
+		pr_err("cramfs: root is not a directory\n");
 		return -EINVAL;
 	}
 	/* correct strange, hard-coded permissions of mkcramfs */
@@ -321,12 +321,12 @@ static int cramfs_fill_super(struct supe
 	sbi->magic=super.magic;
 	sbi->flags=super.flags;
 	if (root_offset == 0)
-		printk(KERN_INFO "cramfs: empty filesystem");
+		pr_info("cramfs: empty filesystem");
 	else if (!(super.flags & CRAMFS_FLAG_SHIFTED_ROOT_OFFSET) &&
 		 ((root_offset != sizeof(struct cramfs_super)) &&
 		  (root_offset != 512 + sizeof(struct cramfs_super))))
 	{
-		printk(KERN_ERR "cramfs: bad root offset %lu\n", root_offset);
+		pr_err("cramfs: bad root offset %lu\n", root_offset);
 		return -EINVAL;
 	}
 
diff -puN fs/cramfs/uncompress.c~fs-cramfs-convert-printk-to-pr_foo fs/cramfs/uncompress.c
--- a/fs/cramfs/uncompress.c~fs-cramfs-convert-printk-to-pr_foo
+++ a/fs/cramfs/uncompress.c
@@ -37,7 +37,7 @@ int cramfs_uncompress_block(void *dst, i
 
 	err = zlib_inflateReset(&stream);
 	if (err != Z_OK) {
-		printk("zlib_inflateReset error %d\n", err);
+		pr_err("zlib_inflateReset error %d\n", err);
 		zlib_inflateEnd(&stream);
 		zlib_inflateInit(&stream);
 	}
@@ -48,8 +48,8 @@ int cramfs_uncompress_block(void *dst, i
 	return stream.total_out;
 
 err:
-	printk("Error %d while decompressing!\n", err);
-	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
+	pr_err("Error %d while decompressing!\n", err);
+	pr_err("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
 	return -EIO;
 }
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

