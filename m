From: akpm@linux-foundation.org
Subject: + fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch added to -mm tree
Date: Tue, 09 Oct 2012 11:59:32 -0700
Message-ID: <20121009185933.527001E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55128 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2JIS7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:59:34 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so670069ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:59:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat (exportfs): rebuild directory-inode if fat_dget() fails
has been added to the -mm tree.  Its filename is
     fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat (exportfs): rebuild directory-inode if fat_dget() fails

This patch enables rebuilding of directory inodes which are not present in
the cache.This is done by traversing the disk clusters to find the
directory entry of the parent directory and using its i_pos to build the
inode.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/nfs.c |  132 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 128 insertions(+), 4 deletions(-)

diff -puN fs/fat/nfs.c~fat-exportfs-rebuild-directory-inode-if-fat_dget-fails fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-exportfs-rebuild-directory-inode-if-fat_dget-fails
+++ a/fs/fat/nfs.c
@@ -166,6 +166,93 @@ struct dentry *fat_fh_to_parent(struct s
 }
 
 /*
+ * Read the directory entries of 'search_clus' and find the entry
+ * which contains 'match_ipos' for the starting cluster.If the entry
+ * is found, rebuild its inode.
+ */
+static struct inode *fat_traverse_cluster(struct super_block *sb,
+				int search_clus, int match_ipos)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct buffer_head *bh;
+	sector_t blknr;
+	int parent_ipos, search_ipos;
+	int i;
+	struct msdos_dir_entry *de;
+	struct inode *inode = NULL;
+	int iterations = sbi->cluster_size >> sb->s_blocksize_bits;
+	blknr = fat_clus_to_blknr(sbi, search_clus);
+
+	do {
+		bh = sb_bread(sb, blknr);
+		if (!bh) {
+			fat_msg(sb, KERN_ERR,
+				"NFS:unable to read block(%llu) while traversing cluster(%d)",
+				(llu)blknr, search_clus);
+			inode = ERR_PTR(-EIO);
+			goto out;
+		}
+		de = (struct msdos_dir_entry *)bh->b_data;
+		for (i = 0; i < sbi->dir_per_block; i++) {
+			if (de[i].name[0] == FAT_ENT_FREE) {
+				/*Reached end of directory*/
+				brelse(bh);
+				inode = ERR_PTR(-ENODATA);
+				goto out;
+			}
+			if (de[i].name[0] == DELETED_FLAG)
+				continue;
+			if (de[i].attr == ATTR_EXT)
+				continue;
+			if (!(de[i].attr & ATTR_DIR))
+				continue;
+			else {
+				search_ipos = fat_get_start(sbi, &de[i]);
+				if (search_ipos == match_ipos) {
+					/*Success.Now build the inode*/
+					parent_ipos = (loff_t)i +
+					 (blknr << sbi->dir_per_block_bits);
+					inode = fat_build_inode(sb, &de[i],
+								parent_ipos);
+					brelse(bh);
+					goto out;
+				}
+			}
+		}
+		brelse(bh);
+		blknr += 1;
+	} while (--iterations > 0);
+out:
+	return inode;
+}
+
+/*
+ * Read the FAT to find the next cluster in the chain
+ * corresponding to 'search_clus'.
+ */
+static int fat_read_next_clus(struct super_block *sb, int search_clus)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	/*bits 31 to 7 give relative sector number*/
+	sector_t blknr = search_clus >> 7;
+	/*bits 6 to 0 give offset*/
+	unsigned int offset = search_clus & 0x7F;
+	__le32 *address;
+	unsigned int next_cluster;
+	struct buffer_head *bh = sb_bread(sb, blknr + sbi->fat_start);
+	if (!bh) {
+		fat_msg(sb, KERN_ERR,
+			"NFS:unable to read block(%llu) for finding the next cluster in FAT chain",
+			(llu)blknr);
+		return -EIO;
+	}
+	address = (__le32 *) bh->b_data;
+	next_cluster = (le32_to_cpu(address[offset])) & 0x0FFFFFFF;
+	brelse(bh);
+	return next_cluster;
+}
+
+/*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
@@ -174,15 +261,52 @@ struct dentry *fat_fh_to_parent(struct s
 struct dentry *fat_get_parent(struct dentry *child_dir)
 {
 	struct super_block *sb = child_dir->d_sb;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *dotdot_bh = NULL, *parent_bh = NULL;
 	struct msdos_dir_entry *de;
 	struct inode *parent_inode = NULL;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int parent_logstart;
+	int search_clus, clus_to_match;
+	sector_t blknr;
 
-	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
-		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
+	if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
+		parent_logstart = fat_get_start(sbi, de);
 		parent_inode = fat_dget(sb, parent_logstart);
+		if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
+			goto out;
+		if (!parent_logstart)
+			/*logstart of dotdot entry is zero if
+			* if the directory's parent is root
+			*/
+			parent_inode = sb->s_root->d_inode;
+		else {
+			blknr = fat_clus_to_blknr(sbi, parent_logstart);
+			parent_bh = sb_bread(sb, blknr);
+			if (!parent_bh) {
+				fat_msg(sb, KERN_ERR,
+					"NFS:unable to read cluster of parent directory");
+				goto out;
+			}
+			de = (struct msdos_dir_entry *) parent_bh->b_data;
+			clus_to_match = fat_get_start(sbi, &de[0]);
+			search_clus = fat_get_start(sbi, &de[1]);
+			if (!search_clus)
+				search_clus = sbi->root_cluster;
+			brelse(parent_bh);
+			do {
+				parent_inode =  fat_traverse_cluster(sb,
+						search_clus, clus_to_match);
+				if (IS_ERR(parent_inode) || parent_inode)
+					break;
+				search_clus = fat_read_next_clus(sb,
+								search_clus);
+				if (search_clus < 0)
+					break;
+			} while (search_clus != FAT_ENT_EOF);
+		}
 	}
-	brelse(bh);
+out:
+	brelse(dotdot_bh);
 
 	return d_obtain_alias(parent_inode);
 }
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-modify-nfs-mount-option.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch

