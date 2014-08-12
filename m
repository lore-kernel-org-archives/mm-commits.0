From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-isofs-logging-clean-up.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 13:34:27 -0700
Message-ID: <53ea7a53.jXgcNijXPXIdZqdw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55071 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaHLUe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:34:29 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1318907vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:34:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, joe@perches.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/isofs: logging clean-up
has been removed from the -mm tree.  Its filename was
     fs-isofs-logging-clean-up.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/isofs: logging clean-up

- All printk(KERN_foo converted to pr_foo()

- Default printk converted to pr_warn()

- Define DEBUG in pr_debug callsites to keep old printk(DEBUG behaviour

- Add DEBUG_FLAGS in Makefile for previous #ifdef DEBUG

- Coalesce format fragments.

- Separate format/arguments on lines > 80 characters.

- Add ISOFS, ISOFS Rock, zisofs pr_fmt

[akpm@linux-foundation.org: 118-column lines make my eyes bleed]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/Makefile   |    2 
 fs/isofs/compress.c |    6 +-
 fs/isofs/export.c   |   11 +----
 fs/isofs/inode.c    |   88 ++++++++++++++++++++----------------------
 fs/isofs/namei.c    |    5 --
 fs/isofs/rock.c     |   44 +++++++++------------
 6 files changed, 73 insertions(+), 83 deletions(-)

diff -puN fs/isofs/Makefile~fs-isofs-logging-clean-up fs/isofs/Makefile
--- a/fs/isofs/Makefile~fs-isofs-logging-clean-up
+++ a/fs/isofs/Makefile
@@ -8,3 +8,5 @@ isofs-objs-y 			:= namei.o inode.o dir.o
 isofs-objs-$(CONFIG_JOLIET)	+= joliet.o
 isofs-objs-$(CONFIG_ZISOFS)	+= compress.o
 isofs-objs			:= $(isofs-objs-y)
+
+# ccflags-y := -DDEBUG_FLAGS=1
diff -puN fs/isofs/compress.c~fs-isofs-logging-clean-up fs/isofs/compress.c
--- a/fs/isofs/compress.c~fs-isofs-logging-clean-up
+++ a/fs/isofs/compress.c
@@ -15,6 +15,8 @@
  *
  * Transparent decompression of files on an iso9660 filesystem
  */
+#define DEBUG
+#define pr_fmt(fmt) "zisofs: " fmt
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -110,7 +112,7 @@ static loff_t zisofs_uncompress_block(st
 			*errp = -ENOMEM;
 		else
 			*errp = -EIO;
-		printk(KERN_DEBUG "zisofs: zisofs_inflateInit returned %d\n",
+		pr_debug("zisofs_inflateInit returned %d\n",
 			       zerr);
 		goto z_eio;
 	}
@@ -154,7 +156,7 @@ static loff_t zisofs_uncompress_block(st
 				if (zerr == Z_MEM_ERROR)
 					*errp = -ENOMEM;
 				else {
-					printk(KERN_DEBUG
+					pr_debug(
 					       "zisofs: zisofs_inflate returned"
 					       " %d, inode = %lu,"
 					       " page idx = %d, bh idx = %d,"
diff -puN fs/isofs/export.c~fs-isofs-logging-clean-up fs/isofs/export.c
--- a/fs/isofs/export.c~fs-isofs-logging-clean-up
+++ a/fs/isofs/export.c
@@ -12,7 +12,7 @@
  *     Documentation/filesystems/nfs/Exporting
  *     fs/exportfs/expfs.c.
  */
-
+#define pr_fmt(fmt) "ISOFS: " fmt
 #include "isofs.h"
 
 static struct dentry *
@@ -52,8 +52,7 @@ static struct dentry *isofs_export_get_p
 
 	/* "child" must always be a directory. */
 	if (!S_ISDIR(child_inode->i_mode)) {
-		printk(KERN_ERR "isofs: isofs_export_get_parent(): "
-		       "child is not a directory!\n");
+		pr_err("%s(): child is not a directory!\n", __func__);
 		rv = ERR_PTR(-EACCES);
 		goto out;
 	}
@@ -62,8 +61,7 @@ static struct dentry *isofs_export_get_p
 	 * it is not zero, it means the directory failed to be
 	 * normalized for some reason. */
 	if (e_child_inode->i_iget5_offset != 0) {
-		printk(KERN_ERR "isofs: isofs_export_get_parent(): "
-		       "child directory not normalized!\n");
+		pr_err("isofs_export_get_parent(): child directory not normalized!\n");
 		rv = ERR_PTR(-EACCES);
 		goto out;
 	}
@@ -89,8 +87,7 @@ static struct dentry *isofs_export_get_p
 
 	/* Verify it is in fact the ".." entry. */
 	if ((isonum_711(de->name_len) != 1) || (de->name[0] != 1)) {
-		printk(KERN_ERR "isofs: Unable to find the \"..\" "
-		       "directory for NFS.\n");
+		pr_err("Unable to find the \"..\" directory for NFS.\n");
 		rv = ERR_PTR(-EACCES);
 		goto out;
 	}
diff -puN fs/isofs/inode.c~fs-isofs-logging-clean-up fs/isofs/inode.c
--- a/fs/isofs/inode.c~fs-isofs-logging-clean-up
+++ a/fs/isofs/inode.c
@@ -10,6 +10,8 @@
  *	2004  Paul Serice - Inode Support pushed out from 4GB to 128GB
  *	2004  Paul Serice - NFS Export Operations
  */
+#define DEBUG
+#define pr_fmt(fmt) "ISOFS: " fmt
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -528,23 +530,25 @@ static unsigned int isofs_get_last_sessi
 		Te.cdte_format=CDROM_LBA;
 		i = ioctl_by_bdev(bdev, CDROMREADTOCENTRY, (unsigned long) &Te);
 		if (!i) {
-			printk(KERN_DEBUG "ISOFS: Session %d start %d type %d\n",
+			pr_debug("Session %d start %d type %d\n",
 				session, Te.cdte_addr.lba,
 				Te.cdte_ctrl&CDROM_DATA_TRACK);
 			if ((Te.cdte_ctrl&CDROM_DATA_TRACK) == 4)
 				return Te.cdte_addr.lba;
 		}
 
-		printk(KERN_ERR "ISOFS: Invalid session number or type of track\n");
+		pr_err("Invalid session number or type of track\n");
 	}
 	i = ioctl_by_bdev(bdev, CDROMMULTISESSION, (unsigned long) &ms_info);
 	if (session > 0)
-		printk(KERN_ERR "ISOFS: Invalid session number\n");
+		pr_err("Invalid session number\n");
 #if 0
-	printk(KERN_DEBUG "isofs.inode: CDROMMULTISESSION: rc=%d\n",i);
+	pr_debug("isofs.inode: CDROMMULTISESSION: rc=%d\n", i);
 	if (i==0) {
-		printk(KERN_DEBUG "isofs.inode: XA disk: %s\n",ms_info.xa_flag?"yes":"no");
-		printk(KERN_DEBUG "isofs.inode: vol_desc_start = %d\n", ms_info.addr.lba);
+		pr_debug("isofs.inode: XA disk: %s\n",
+			 ms_info.xa_flag?"yes":"no");
+		pr_debug("isofs.inode: vol_desc_start = %d\n",
+			 ms_info.addr.lba);
 	}
 #endif
 	if (i==0)
@@ -672,8 +676,7 @@ static int isofs_fill_super(struct super
 						else if (sec->escape[2] == 0x45)
 							joliet_level = 3;
 
-						printk(KERN_DEBUG "ISO 9660 Extensions: "
-							"Microsoft Joliet Level %d\n",
+						pr_debug("ISO 9660 Extensions: Microsoft Joliet Level %d\n",
 							joliet_level);
 					}
 					goto root_found;
@@ -771,11 +774,11 @@ root_found:
 			  isonum_711(rootp->ext_attr_length);
 	sbi->s_firstdatazone = first_data_zone;
 #ifndef BEQUIET
-	printk(KERN_DEBUG "ISOFS: Max size:%ld   Log zone size:%ld\n",
+	pr_debug("Max size:%ld   Log zone size:%ld\n",
 		sbi->s_max_size, 1UL << sbi->s_log_zone_size);
-	printk(KERN_DEBUG "ISOFS: First datazone:%ld\n", sbi->s_firstdatazone);
+	pr_debug("First datazone:%ld\n", sbi->s_firstdatazone);
 	if(sbi->s_high_sierra)
-		printk(KERN_DEBUG "ISOFS: Disc in High Sierra format.\n");
+		pr_debug("Disc in High Sierra format.\n");
 #endif
 
 	/*
@@ -878,9 +881,7 @@ root_found:
 	 */
 	if (sbi->s_rock == 1 && joliet_level &&
 				rootdir_empty(s, sbi->s_firstdatazone)) {
-		printk(KERN_NOTICE
-			"ISOFS: primary root directory is empty. "
-			"Disabling Rock Ridge and switching to Joliet.");
+		pr_notice("primary root directory is empty. Disabling Rock Ridge and switching to Joliet.");
 		sbi->s_rock = 0;
 	}
 
@@ -898,8 +899,7 @@ root_found:
 		sbi->s_rock = 0;
 		if (sbi->s_firstdatazone != first_data_zone) {
 			sbi->s_firstdatazone = first_data_zone;
-			printk(KERN_DEBUG
-				"ISOFS: changing to secondary root\n");
+			pr_debug("changing to secondary root\n");
 			iput(inode);
 			inode = isofs_iget(s, sbi->s_firstdatazone, 0);
 			if (IS_ERR(inode))
@@ -918,9 +918,8 @@ root_found:
 
 	/* Make sure the root inode is a directory */
 	if (!S_ISDIR(inode->i_mode)) {
-		printk(KERN_WARNING
-			"isofs_fill_super: root inode is not a directory. "
-			"Corrupted media?\n");
+		pr_warn("%s: root inode is not a directory. Corrupted media?\n",
+			__func__);
 		goto out_iput;
 	}
 
@@ -952,27 +951,26 @@ out_iput:
 out_no_root:
 	error = PTR_ERR(inode);
 	if (error != -ENOMEM)
-		printk(KERN_WARNING "%s: get root inode failed\n", __func__);
+		pr_warn("%s: get root inode failed\n", __func__);
 out_no_inode:
 #ifdef CONFIG_JOLIET
 	unload_nls(sbi->s_nls_iocharset);
 #endif
 	goto out_freesbi;
 out_no_read:
-	printk(KERN_WARNING "%s: bread failed, dev=%s, iso_blknum=%d, block=%d\n",
+	pr_warn("%s: bread failed, dev=%s, iso_blknum=%d, block=%d\n",
 		__func__, s->s_id, iso_blknum, block);
 	goto out_freebh;
 out_bad_zone_size:
-	printk(KERN_WARNING "ISOFS: Bad logical zone size %ld\n",
-		sbi->s_log_zone_size);
+	pr_warn("Bad logical zone size %ld\n", sbi->s_log_zone_size);
 	goto out_freebh;
 out_bad_size:
-	printk(KERN_WARNING "ISOFS: Logical zone size(%d) < hardware blocksize(%u)\n",
+	pr_warn("Logical zone size(%d) < hardware blocksize(%u)\n",
 		orig_zonesize, opt.blocksize);
 	goto out_freebh;
 out_unknown_format:
 	if (!silent)
-		printk(KERN_WARNING "ISOFS: Unable to identify CD-ROM format.\n");
+		pr_warn("Unable to identify CD-ROM format.\n");
 
 out_freebh:
 	brelse(bh);
@@ -1021,7 +1019,7 @@ int isofs_get_blocks(struct inode *inode
 	error = -EIO;
 	rv = 0;
 	if (iblock != b_off) {
-		printk(KERN_DEBUG "%s: block number too large\n", __func__);
+		pr_debug("%s: block number too large\n", __func__);
 		goto abort;
 	}
 
@@ -1042,7 +1040,7 @@ int isofs_get_blocks(struct inode *inode
 		 * I/O errors.
 		 */
 		if (b_off > ((inode->i_size + PAGE_CACHE_SIZE - 1) >> ISOFS_BUFFER_BITS(inode))) {
-			printk(KERN_DEBUG "%s: block >= EOF (%lu, %llu)\n",
+			pr_debug("%s: block >= EOF (%lu, %llu)\n",
 				__func__, b_off,
 				(unsigned long long)inode->i_size);
 			goto abort;
@@ -1068,12 +1066,11 @@ int isofs_get_blocks(struct inode *inode
 			iput(ninode);
 
 			if (++section > 100) {
-				printk(KERN_DEBUG "%s: More than 100 file sections ?!?"
-					" aborting...\n", __func__);
-				printk(KERN_DEBUG "%s: block=%lu firstext=%u sect_size=%u "
-					"nextblk=%lu nextoff=%lu\n", __func__,
-					b_off, firstext, (unsigned) sect_size,
-					nextblk, nextoff);
+				pr_debug("%s: More than 100 file sections ?!? aborting...\n",
+					 __func__);
+				pr_debug("%s: block=%lu firstext=%u sect_size=%u nextblk=%lu nextoff=%lu\n",
+					__func__, b_off, firstext,
+					(unsigned) sect_size, nextblk, nextoff);
 				goto abort;
 			}
 		}
@@ -1105,7 +1102,7 @@ static int isofs_get_block(struct inode
 	int ret;
 
 	if (create) {
-		printk(KERN_DEBUG "%s: Kernel tries to allocate a block\n", __func__);
+		pr_debug("%s: Kernel tries to allocate a block\n", __func__);
 		return -EROFS;
 	}
 
@@ -1248,13 +1245,12 @@ out_nomem:
 	return -ENOMEM;
 
 out_noread:
-	printk(KERN_INFO "ISOFS: unable to read i-node block %lu\n", block);
+	pr_info("unable to read i-node block %lu\n", block);
 	kfree(tmpde);
 	return -EIO;
 
 out_toomany:
-	printk(KERN_INFO "%s: More than 100 file sections ?!?, aborting...\n"
-		"isofs_read_level3_size: inode=%lu\n",
+	pr_info("%s: More than 100 file sections ?!?, aborting...\n isofs_read_level3_size: inode=%lu\n",
 		__func__, inode->i_ino);
 	goto out;
 }
@@ -1289,7 +1285,7 @@ static int isofs_read_inode(struct inode
 
 		tmpde = kmalloc(de_len, GFP_KERNEL);
 		if (tmpde == NULL) {
-			printk(KERN_INFO "%s: out of memory\n", __func__);
+			pr_info("%s: out of memory\n", __func__);
 			ret = -ENOMEM;
 			goto fail;
 		}
@@ -1364,24 +1360,23 @@ static int isofs_read_inode(struct inode
 		inode->i_size &= 0x00ffffff;
 
 	if (de->interleave[0]) {
-		printk(KERN_DEBUG "ISOFS: Interleaved files not (yet) supported.\n");
+		pr_debug("Interleaved files not (yet) supported.\n");
 		inode->i_size = 0;
 	}
 
 	/* I have no idea what file_unit_size is used for, so
 	   we will flag it for now */
 	if (de->file_unit_size[0] != 0) {
-		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%ld).\n",
-			inode->i_ino);
+		pr_debug("File unit size != 0 for ISO file (%ld).\n",
+			 inode->i_ino);
 	}
 
 	/* I have no idea what other flag bits are used for, so
 	   we will flag it for now */
-#ifdef DEBUG
+#ifdef DEBUG_FLAGS
 	if((de->flags[-high_sierra] & ~2)!= 0){
-		printk(KERN_DEBUG "ISOFS: Unusual flag settings for ISO file "
-				"(%ld %x).\n",
-			inode->i_ino, de->flags[-high_sierra]);
+		pr_debug("Unusual flag settings for ISO file (%ld %x).\n",
+			 inode->i_ino, de->flags[-high_sierra]);
 	}
 #endif
 
@@ -1450,7 +1445,7 @@ out:
 	return ret;
 
 out_badread:
-	printk(KERN_WARNING "ISOFS: unable to read i-node block\n");
+	pr_warn("unable to read i-node block\n");
 fail:
 	goto out;
 }
@@ -1541,6 +1536,7 @@ MODULE_ALIAS("iso9660");
 static int __init init_iso9660_fs(void)
 {
 	int err = init_inodecache();
+
 	if (err)
 		goto out;
 #ifdef CONFIG_ZISOFS
diff -puN fs/isofs/namei.c~fs-isofs-logging-clean-up fs/isofs/namei.c
--- a/fs/isofs/namei.c~fs-isofs-logging-clean-up
+++ a/fs/isofs/namei.c
@@ -113,9 +113,8 @@ isofs_find_entry(struct inode *dir, stru
 		dpnt = de->name;
 		/* Basic sanity check, whether name doesn't exceed dir entry */
 		if (de_len < dlen + sizeof(struct iso_directory_record)) {
-			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
-			       " in block %lu of inode %lu\n", block,
-			       dir->i_ino);
+			pr_notice("Corrupted directory entry in block %lu of inode %lu\n",
+				  block, dir->i_ino);
 			return 0;
 		}
 
diff -puN fs/isofs/rock.c~fs-isofs-logging-clean-up fs/isofs/rock.c
--- a/fs/isofs/rock.c~fs-isofs-logging-clean-up
+++ a/fs/isofs/rock.c
@@ -5,6 +5,8 @@
  *
  *  Rock Ridge Extensions to iso9660
  */
+#define DEBUG
+#define pr_fmt(fmt) "ISOFS: rock: " fmt
 
 #include <linux/slab.h>
 #include <linux/pagemap.h>
@@ -89,9 +91,8 @@ static int rock_continue(struct rock_sta
 	if ((unsigned)rs->cont_offset > blocksize - min_de_size ||
 	    (unsigned)rs->cont_size > blocksize ||
 	    (unsigned)(rs->cont_offset + rs->cont_size) > blocksize) {
-		printk(KERN_NOTICE "rock: corrupted directory entry. "
-			"extent=%d, offset=%d, size=%d\n",
-			rs->cont_extent, rs->cont_offset, rs->cont_size);
+		pr_notice("corrupted directory entry. extent=%d, offset=%d, size=%d\n",
+			  rs->cont_extent, rs->cont_offset, rs->cont_size);
 		ret = -EIO;
 		goto out;
 	}
@@ -117,7 +118,7 @@ static int rock_continue(struct rock_sta
 			rs->cont_offset = 0;
 			return 0;
 		}
-		printk("Unable to read rock-ridge attributes\n");
+		pr_warn("Unable to read rock-ridge attributes\n");
 	}
 out:
 	kfree(rs->buffer);
@@ -176,10 +177,9 @@ static int rock_check_overflow(struct ro
 	}
 	len += offsetof(struct rock_ridge, u);
 	if (len > rs->len) {
-		printk(KERN_NOTICE "rock: directory entry would overflow "
-				"storage\n");
-		printk(KERN_NOTICE "rock: sig=0x%02x, size=%d, remaining=%d\n",
-				sig, len, rs->len);
+		pr_notice("directory entry would overflow storage\n");
+		pr_notice("sig=0x%02x, size=%d, remaining=%d\n",
+			  sig, len, rs->len);
 		return -EIO;
 	}
 	return 0;
@@ -257,7 +257,7 @@ repeat:
 				break;
 
 			if (rr->u.NM.flags & ~1) {
-				printk("Unsupported NM flag settings (%d)\n",
+				pr_warn("Unsupported NM flag settings (%d)\n",
 					rr->u.NM.flags);
 				break;
 			}
@@ -353,13 +353,13 @@ repeat:
 			break;
 		case SIG('E', 'R'):
 			ISOFS_SB(inode->i_sb)->s_rock = 1;
-			printk(KERN_DEBUG "ISO 9660 Extensions: ");
+			pr_debug("ISO 9660 Extensions: ");
 			{
 				int p;
 				for (p = 0; p < rr->u.ER.len_id; p++)
-					printk("%c", rr->u.ER.data[p]);
+					pr_warn("%c", rr->u.ER.data[p]);
 			}
-			printk("\n");
+			pr_warn("\n");
 			break;
 		case SIG('P', 'X'):
 			inode->i_mode = isonum_733(rr->u.PX.mode);
@@ -450,8 +450,7 @@ repeat:
 						inode->i_size += 1;
 						break;
 					default:
-						printk("Symlink component flag "
-							"not implemented\n");
+						pr_warn("Symlink component flag not implemented\n");
 					}
 					slen -= slp->len + 2;
 					oldslp = slp;
@@ -481,8 +480,7 @@ repeat:
 			symlink_len = inode->i_size;
 			break;
 		case SIG('R', 'E'):
-			printk(KERN_WARNING "Attempt to read inode for "
-					"relocated directory\n");
+			pr_warn("Attempt to read inode for relocated directory\n");
 			goto out;
 		case SIG('C', 'L'):
 			ISOFS_I(inode)->i_first_extent =
@@ -518,9 +516,7 @@ repeat:
 				int block_shift =
 					isonum_711(&rr->u.ZF.parms[1]);
 				if (block_shift > 17) {
-					printk(KERN_WARNING "isofs: "
-						"Can't handle ZF block "
-						"size of 2^%d\n",
+					pr_warn("Can't handle ZF block size of 2^%d\n",
 						block_shift);
 				} else {
 					/*
@@ -543,9 +539,7 @@ repeat:
 						       real_size);
 				}
 			} else {
-				printk(KERN_WARNING
-				       "isofs: Unknown ZF compression "
-						"algorithm: %c%c\n",
+				pr_warn("Unknown ZF compression algorithm: %c%c\n",
 				       rr->u.ZF.algorithm[0],
 				       rr->u.ZF.algorithm[1]);
 			}
@@ -604,7 +598,7 @@ static char *get_symlink_chunk(char *rpn
 			*rpnt++ = '/';
 			break;
 		default:
-			printk("Symlink component flag not implemented (%d)\n",
+			pr_warn("Symlink component flag not implemented (%d)\n",
 			       slp->flags);
 		}
 		slen -= slp->len + 2;
@@ -757,10 +751,10 @@ out:
 	kfree(rs.buffer);
 	goto fail;
 out_noread:
-	printk("unable to read i-node block");
+	pr_warn("unable to read i-node block");
 	goto fail;
 out_bad_span:
-	printk("symlink spans iso9660 blocks\n");
+	pr_warn("symlink spans iso9660 blocks\n");
 fail:
 	brelse(bh);
 error:
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

