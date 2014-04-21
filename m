From: akpm@linux-foundation.org
Subject: + fs-affs-convert-printk-to-pr_foo.patch added to -mm tree
Date: Mon, 21 Apr 2014 13:36:01 -0700
Message-ID: <53558131.85r1kSN3kQvTh55C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbaDUUgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be

Subject: + fs-affs-convert-printk-to-pr_foo.patch added to -mm tree
To: fabf@skynet.be,joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:36:01 -0700


The patch titled
     Subject: fs/affs: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     fs-affs-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-convert-printk-to-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: convert printk to pr_foo()

-All printk(KERN_foo converted to pr_foo()

-Default printk converted to pr_warn()

-Add pr_fmt to affs.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h     |    6 ++++++
 fs/affs/amigaffs.c |    6 +++---
 fs/affs/bitmap.c   |   13 ++++++-------
 fs/affs/super.c    |   24 +++++++++++-------------
 4 files changed, 26 insertions(+), 23 deletions(-)

diff -puN fs/affs/affs.h~fs-affs-convert-printk-to-pr_foo fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-convert-printk-to-pr_foo
+++ a/fs/affs/affs.h
@@ -1,3 +1,9 @@
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
diff -puN fs/affs/amigaffs.c~fs-affs-convert-printk-to-pr_foo fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-convert-printk-to-pr_foo
+++ a/fs/affs/amigaffs.c
@@ -451,10 +451,10 @@ affs_error(struct super_block *sb, const
 	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
 	va_end(args);
 
-	printk(KERN_CRIT "AFFS error (device %s): %s(): %s\n", sb->s_id,
+	pr_crit("error (device %s): %s(): %s\n", sb->s_id,
 		function,ErrorBuffer);
 	if (!(sb->s_flags & MS_RDONLY))
-		printk(KERN_WARNING "AFFS: Remounting filesystem read-only\n");
+		pr_warn("Remounting filesystem read-only\n");
 	sb->s_flags |= MS_RDONLY;
 }
 
@@ -467,7 +467,7 @@ affs_warning(struct super_block *sb, con
 	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
 	va_end(args);
 
-	printk(KERN_WARNING "AFFS warning (device %s): %s(): %s\n", sb->s_id,
+	pr_warn("(device %s): %s(): %s\n", sb->s_id,
 		function,ErrorBuffer);
 }
 
diff -puN fs/affs/bitmap.c~fs-affs-convert-printk-to-pr_foo fs/affs/bitmap.c
--- a/fs/affs/bitmap.c~fs-affs-convert-printk-to-pr_foo
+++ a/fs/affs/bitmap.c
@@ -254,8 +254,7 @@ int affs_init_bitmap(struct super_block
 		return 0;
 
 	if (!AFFS_ROOT_TAIL(sb, sbi->s_root_bh)->bm_flag) {
-		printk(KERN_NOTICE "AFFS: Bitmap invalid - mounting %s read only\n",
-			sb->s_id);
+		pr_notice("Bitmap invalid - mounting %s read only\n", sb->s_id);
 		*flags |= MS_RDONLY;
 		return 0;
 	}
@@ -268,7 +267,7 @@ int affs_init_bitmap(struct super_block
 	size = sbi->s_bmap_count * sizeof(*bm);
 	bm = sbi->s_bitmap = kzalloc(size, GFP_KERNEL);
 	if (!sbi->s_bitmap) {
-		printk(KERN_ERR "AFFS: Bitmap allocation failed\n");
+		pr_err("Bitmap allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -282,13 +281,13 @@ int affs_init_bitmap(struct super_block
 		bm->bm_key = be32_to_cpu(bmap_blk[blk]);
 		bh = affs_bread(sb, bm->bm_key);
 		if (!bh) {
-			printk(KERN_ERR "AFFS: Cannot read bitmap\n");
+			pr_err("Cannot read bitmap\n");
 			res = -EIO;
 			goto out;
 		}
 		if (affs_checksum_block(sb, bh)) {
-			printk(KERN_WARNING "AFFS: Bitmap %u invalid - mounting %s read only.\n",
-			       bm->bm_key, sb->s_id);
+			pr_warn("Bitmap %u invalid - mounting %s read only.\n",
+				bm->bm_key, sb->s_id);
 			*flags |= MS_RDONLY;
 			goto out;
 		}
@@ -304,7 +303,7 @@ int affs_init_bitmap(struct super_block
 			affs_brelse(bmap_bh);
 		bmap_bh = affs_bread(sb, be32_to_cpu(bmap_blk[blk]));
 		if (!bmap_bh) {
-			printk(KERN_ERR "AFFS: Cannot read bitmap extension\n");
+			pr_err("Cannot read bitmap extension\n");
 			res = -EIO;
 			goto out;
 		}
diff -puN fs/affs/super.c~fs-affs-convert-printk-to-pr_foo fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-convert-printk-to-pr_foo
+++ a/fs/affs/super.c
@@ -220,7 +220,7 @@ parse_options(char *options, kuid_t *uid
 				return 0;
 			if (n != 512 && n != 1024 && n != 2048
 			    && n != 4096) {
-				printk ("AFFS: Invalid blocksize (512, 1024, 2048, 4096 allowed)\n");
+				pr_warn("Invalid blocksize (512, 1024, 2048, 4096 allowed)\n");
 				return 0;
 			}
 			*blocksize = n;
@@ -285,8 +285,8 @@ parse_options(char *options, kuid_t *uid
 		 	/* Silently ignore the quota options */
 			break;
 		default:
-			printk("AFFS: Unrecognized mount option \"%s\" "
-					"or missing value\n", p);
+			pr_warn("Unrecognized mount option \"%s\" or missing value\n",
+				p);
 			return 0;
 		}
 	}
@@ -339,7 +339,7 @@ static int affs_fill_super(struct super_
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
 				&blocksize,&sbi->s_prefix,
 				sbi->s_volume, &mount_flags)) {
-		printk(KERN_ERR "AFFS: Error parsing options\n");
+		pr_err("Error parsing options\n");
 		kfree(sbi->s_prefix);
 		kfree(sbi);
 		return -EINVAL;
@@ -409,8 +409,7 @@ static int affs_fill_super(struct super_
 		}
 	}
 	if (!silent)
-		printk(KERN_ERR "AFFS: No valid root block on device %s\n",
-			sb->s_id);
+		pr_err("No valid root block on device %s\n", sb->s_id);
 	return -EINVAL;
 
 	/* N.B. after this point bh must be released */
@@ -422,7 +421,7 @@ got_root:
 	/* Find out which kind of FS we have */
 	boot_bh = sb_bread(sb, 0);
 	if (!boot_bh) {
-		printk(KERN_ERR "AFFS: Cannot read boot block\n");
+		pr_err("Cannot read boot block\n");
 		return -EINVAL;
 	}
 	memcpy(sig, boot_bh->b_data, 4);
@@ -435,8 +434,7 @@ got_root:
 	 */
 	if ((chksum == FS_DCFFS || chksum == MUFS_DCFFS || chksum == FS_DCOFS
 	     || chksum == MUFS_DCOFS) && !(sb->s_flags & MS_RDONLY)) {
-		printk(KERN_NOTICE "AFFS: Dircache FS - mounting %s read only\n",
-			sb->s_id);
+		pr_notice("Dircache FS - mounting %s read only\n", sb->s_id);
 		sb->s_flags |= MS_RDONLY;
 	}
 	switch (chksum) {
@@ -470,14 +468,14 @@ got_root:
 			sb->s_flags |= MS_NOEXEC;
 			break;
 		default:
-			printk(KERN_ERR "AFFS: Unknown filesystem on device %s: %08X\n",
-				sb->s_id, chksum);
+			pr_err("Unknown filesystem on device %s: %08X\n",
+			       sb->s_id, chksum);
 			return -EINVAL;
 	}
 
 	if (mount_flags & SF_VERBOSE) {
 		u8 len = AFFS_ROOT_TAIL(sb, root_bh)->disk_name[0];
-		printk(KERN_NOTICE "AFFS: Mounting volume \"%.*s\": Type=%.3s\\%c, Blocksize=%d\n",
+		pr_notice("Mounting volume \"%.*s\": Type=%.3s\\%c, Blocksize=%d\n",
 			len > 31 ? 31 : len,
 			AFFS_ROOT_TAIL(sb, root_bh)->disk_name + 1,
 			sig, sig[3] + '0', blocksize);
@@ -508,7 +506,7 @@ got_root:
 
 	sb->s_root = d_make_root(root_inode);
 	if (!sb->s_root) {
-		printk(KERN_ERR "AFFS: Get root inode failed\n");
+		pr_err("AFFS: Get root inode failed\n");
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

