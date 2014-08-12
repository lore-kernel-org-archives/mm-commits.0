From: akpm@linux-foundation.org
Subject: [merged] fs-cramfs-use-pr_fmt.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:04 -0700
Message-ID: <53ea6dd0.sneciMFssUJEef/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:39082 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbaHLTlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:05 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1069076igi.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sasha.levin@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cramfs: use pr_fmt
has been removed from the -mm tree.  Its filename was
     fs-cramfs-use-pr_fmt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cramfs: use pr_fmt

Use module name for "cramfs: " prefix.  (note that uncompress.c printk had
no prefix).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c      |   18 ++++++++++--------
 fs/cramfs/uncompress.c |    2 ++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-use-pr_fmt fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-use-pr_fmt
+++ a/fs/cramfs/inode.c
@@ -11,6 +11,8 @@
  * The actual compression is based on zlib, see the other files.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
@@ -277,7 +279,7 @@ static int cramfs_fill_super(struct supe
 		/* check for wrong endianness */
 		if (super.magic == CRAMFS_MAGIC_WEND) {
 			if (!silent)
-				pr_err("cramfs: wrong endianness\n");
+				pr_err("wrong endianness\n");
 			return -EINVAL;
 		}
 
@@ -287,22 +289,22 @@ static int cramfs_fill_super(struct supe
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
-				pr_err("cramfs: wrong endianness\n");
+				pr_err("wrong endianness\n");
 			else if (!silent)
-				pr_err("cramfs: wrong magic\n");
+				pr_err("wrong magic\n");
 			return -EINVAL;
 		}
 	}
 
 	/* get feature flags first */
 	if (super.flags & ~CRAMFS_SUPPORTED_FLAGS) {
-		pr_err("cramfs: unsupported filesystem features\n");
+		pr_err("unsupported filesystem features\n");
 		return -EINVAL;
 	}
 
 	/* Check that the root inode is in a sane state */
 	if (!S_ISDIR(super.root.mode)) {
-		pr_err("cramfs: root is not a directory\n");
+		pr_err("root is not a directory\n");
 		return -EINVAL;
 	}
 	/* correct strange, hard-coded permissions of mkcramfs */
@@ -321,12 +323,12 @@ static int cramfs_fill_super(struct supe
 	sbi->magic=super.magic;
 	sbi->flags=super.flags;
 	if (root_offset == 0)
-		pr_info("cramfs: empty filesystem");
+		pr_info("empty filesystem");
 	else if (!(super.flags & CRAMFS_FLAG_SHIFTED_ROOT_OFFSET) &&
 		 ((root_offset != sizeof(struct cramfs_super)) &&
 		  (root_offset != 512 + sizeof(struct cramfs_super))))
 	{
-		pr_err("cramfs: bad root offset %lu\n", root_offset);
+		pr_err("bad root offset %lu\n", root_offset);
 		return -EINVAL;
 	}
 
@@ -511,7 +513,7 @@ static int cramfs_readpage(struct file *
 		if (compr_len == 0)
 			; /* hole */
 		else if (unlikely(compr_len > (PAGE_CACHE_SIZE << 1))) {
-			pr_err("cramfs: bad compressed blocksize %u\n",
+			pr_err("bad compressed blocksize %u\n",
 				compr_len);
 			goto err;
 		} else {
diff -puN fs/cramfs/uncompress.c~fs-cramfs-use-pr_fmt fs/cramfs/uncompress.c
--- a/fs/cramfs/uncompress.c~fs-cramfs-use-pr_fmt
+++ a/fs/cramfs/uncompress.c
@@ -15,6 +15,8 @@
  * then is used by multiple filesystems.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/vmalloc.h>
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

