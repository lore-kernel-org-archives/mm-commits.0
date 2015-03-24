From: akpm@linux-foundation.org
Subject: + adfs-returning-correct-return-values.patch added to -mm tree
Date: Tue, 24 Mar 2015 13:31:45 -0700
Message-ID: <5511c9b1.S43B3JKvpxWJ5TRP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbCXUbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 16:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanidhya.gatech@gmail.com, fabf@skynet.be, joe@perches.com, taesoo@gatech.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: adfs: return correct return values
has been added to the -mm tree.  Its filename is
     adfs-returning-correct-return-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/adfs-returning-correct-return-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/adfs-returning-correct-return-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Subject: adfs: return correct return values

Fix the wrong values returned by various functions such as EIO and ENOMEM.

Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: Taesoo kim <taesoo@gatech.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_fplus.c |    1 +
 fs/adfs/super.c     |   20 +++++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN fs/adfs/dir_fplus.c~adfs-returning-correct-return-values fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~adfs-returning-correct-return-values
+++ a/fs/adfs/dir_fplus.c
@@ -61,6 +61,7 @@ adfs_fplus_read(struct super_block *sb,
 			kcalloc(size, sizeof(struct buffer_head *),
 				GFP_KERNEL);
 		if (!bh_fplus) {
+			ret = -ENOMEM;
 			adfs_error(sb, "not enough memory for"
 					" dir object %X (%d blocks)", id, size);
 			goto out;
diff -puN fs/adfs/super.c~adfs-returning-correct-return-values fs/adfs/super.c
--- a/fs/adfs/super.c~adfs-returning-correct-return-values
+++ a/fs/adfs/super.c
@@ -316,7 +316,7 @@ static struct adfs_discmap *adfs_read_ma
 	dm = kmalloc(nzones * sizeof(*dm), GFP_KERNEL);
 	if (dm == NULL) {
 		adfs_error(sb, "not enough memory");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	for (zone = 0; zone < nzones; zone++, map_addr++) {
@@ -349,7 +349,7 @@ error_free:
 		brelse(dm[zone].dm_bh);
 
 	kfree(dm);
-	return NULL;
+	return ERR_PTR(-EIO);
 }
 
 static inline unsigned long adfs_discsize(struct adfs_discrecord *dr, int block_bits)
@@ -370,6 +370,7 @@ static int adfs_fill_super(struct super_
 	unsigned char *b_data;
 	struct adfs_sb_info *asb;
 	struct inode *root;
+	int ret = -EINVAL;
 
 	sb->s_flags |= MS_NODIRATIME;
 
@@ -391,6 +392,7 @@ static int adfs_fill_super(struct super_
 	sb_set_blocksize(sb, BLOCK_SIZE);
 	if (!(bh = sb_bread(sb, ADFS_DISCRECORD / BLOCK_SIZE))) {
 		adfs_error(sb, "unable to read superblock");
+		ret = -EIO;
 		goto error;
 	}
 
@@ -400,6 +402,7 @@ static int adfs_fill_super(struct super_
 		if (!silent)
 			printk("VFS: Can't find an adfs filesystem on dev "
 				"%s.\n", sb->s_id);
+		ret = -EINVAL;
 		goto error_free_bh;
 	}
 
@@ -412,6 +415,7 @@ static int adfs_fill_super(struct super_
 		if (!silent)
 			printk("VPS: Can't find an adfs filesystem on dev "
 				"%s.\n", sb->s_id);
+		ret = -EINVAL;
 		goto error_free_bh;
 	}
 
@@ -421,11 +425,13 @@ static int adfs_fill_super(struct super_
 		if (!bh) {
 			adfs_error(sb, "couldn't read superblock on "
 				"2nd try.");
+			ret = -EIO;
 			goto error;
 		}
 		b_data = bh->b_data + (ADFS_DISCRECORD % sb->s_blocksize);
 		if (adfs_checkbblk(b_data)) {
 			adfs_error(sb, "disc record mismatch, very weird!");
+			ret = -EINVAL;
 			goto error_free_bh;
 		}
 		dr = (struct adfs_discrecord *)(b_data + ADFS_DR_OFFSET);
@@ -433,6 +439,7 @@ static int adfs_fill_super(struct super_
 		if (!silent)
 			printk(KERN_ERR "VFS: Unsupported blocksize on dev "
 				"%s.\n", sb->s_id);
+		ret = -EINVAL;
 		goto error;
 	}
 
@@ -447,10 +454,12 @@ static int adfs_fill_super(struct super_
 	asb->s_size    		= adfs_discsize(dr, sb->s_blocksize_bits);
 	asb->s_version 		= dr->format_version;
 	asb->s_log2sharesize	= dr->log2sharesize;
-	
+
 	asb->s_map = adfs_read_map(sb, dr);
-	if (!asb->s_map)
+	if (IS_ERR(asb->s_map)) {
+		ret =  PTR_ERR(asb->s_map);
 		goto error_free_bh;
+	}
 
 	brelse(bh);
 
@@ -499,6 +508,7 @@ static int adfs_fill_super(struct super_
 			brelse(asb->s_map[i].dm_bh);
 		kfree(asb->s_map);
 		adfs_error(sb, "get root inode failed\n");
+		ret = -EIO;
 		goto error;
 	}
 	return 0;
@@ -508,7 +518,7 @@ error_free_bh:
 error:
 	sb->s_fs_info = NULL;
 	kfree(asb);
-	return -EINVAL;
+	return ret;
 }
 
 static struct dentry *adfs_mount(struct file_system_type *fs_type,
_

Patches currently in -mm which might be from sanidhya.gatech@gmail.com are

adfs-returning-correct-return-values.patch
affs-kstrdup-memory-handling.patch
affs-kstrdup-memory-handling-fix.patch

