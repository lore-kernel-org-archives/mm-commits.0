From: akpm@linux-foundation.org
Subject: + fs-fat-add-support-for-dos-1x-formatted-volumes.patch added to
 -mm tree
Date: Mon, 21 Apr 2014 13:26:09 -0700
Message-ID: <53557ee1.bp+jy82Ci9Eb4obF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaDUU0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, cse.cem@gmail.com

Subject: + fs-fat-add-support-for-dos-1x-formatted-volumes.patch added to -mm tree
To: cse.cem@gmail.com,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:26:09 -0700


The patch titled
     Subject: fs/fat/: add support for DOS 1.x formatted volumes
has been added to the -mm tree.  Its filename is
     fs-fat-add-support-for-dos-1x-formatted-volumes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-add-support-for-dos-1x-formatted-volumes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-add-support-for-dos-1x-formatted-volumes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Conrad Meyer <cse.cem@gmail.com>
Subject: fs/fat/: add support for DOS 1.x formatted volumes

Add structure for parsed BPB information, struct fat_bios_param_block, and
move all of the deserialization and validation logic from fat_fill_super()
into fat_read_bpb().

Add a 'dos1xfloppy' mount option to infer DOS 2.x BIOS Parameter Block
defaults from block device geometry for ancient floppies and floppy
images, as a fall-back from the default BPB parsing logic.

When fat_read_bpb() finds an invalid FAT filesystem and dos1xfloppy is
set, fall back to fat_read_static_bpb().  fat_read_static_bpb() validates
that the entire BPB is zero, and that the floppy has a DOS-style 8086 code
bootstrapping header.  Then it fills in default BPB values from media size
and a table.[0]

Media size is assumed to be static for archaic FAT volumes. See also:
[1].

Fixes kernel.org bug #42617.

[0]: https://en.wikipedia.org/wiki/File_Allocation_Table#Exceptions
[1]: http://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |    5 
 fs/fat/fat.h                       |    3 
 fs/fat/inode.c                     |  342 +++++++++++++++++++++------
 3 files changed, 273 insertions(+), 77 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~fs-fat-add-support-for-dos-1x-formatted-volumes Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~fs-fat-add-support-for-dos-1x-formatted-volumes
+++ a/Documentation/filesystems/vfat.txt
@@ -172,6 +172,11 @@ nfs=stale_rw|nostale_ro
 		To maintain backward compatibility, '-o nfs' is also accepted,
 		defaulting to stale_rw
 
+dos1xfloppy  -- If set, use a fallback default BIOS Parameter Block
+		configuration, determined by backing device size. These static
+		parameters match defaults assumed by DOS 1.x for 160 kiB,
+		180 kiB, 320 kiB, and 360 kiB floppies and floppy images.
+
 
 <bool>: 0,1,yes,no,true,false
 
diff -puN fs/fat/fat.h~fs-fat-add-support-for-dos-1x-formatted-volumes fs/fat/fat.h
--- a/fs/fat/fat.h~fs-fat-add-support-for-dos-1x-formatted-volumes
+++ a/fs/fat/fat.h
@@ -52,7 +52,8 @@ struct fat_mount_options {
 		 usefree:1,	   /* Use free_clusters for FAT32 */
 		 tz_set:1,	   /* Filesystem timestamps' offset set */
 		 rodir:1,	   /* allow ATTR_RO for directory */
-		 discard:1;	   /* Issue discard requests on deletions */
+		 discard:1,	   /* Issue discard requests on deletions */
+		 dos1xfloppy:1;	   /* Assume default BPB for DOS 1.x floppies */
 };
 
 #define FAT_HASH_BITS	8
diff -puN fs/fat/inode.c~fs-fat-add-support-for-dos-1x-formatted-volumes fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-add-support-for-dos-1x-formatted-volumes
+++ a/fs/fat/inode.c
@@ -35,9 +35,71 @@
 #define CONFIG_FAT_DEFAULT_IOCHARSET	""
 #endif
 
+#define KB_IN_SECTORS 2
+
+/*
+ * A deserialized copy of the on-disk structure laid out in struct
+ * fat_boot_sector.
+ */
+struct fat_bios_param_block {
+	u16	fat_sector_size;
+	u8	fat_sec_per_clus;
+	u16	fat_reserved;
+	u8	fat_fats;
+	u16	fat_dir_entries;
+	u16	fat_sectors;
+	u16	fat_fat_length;
+	u32	fat_total_sect;
+
+	u8	fat16_state;
+	u32	fat16_vol_id;
+
+	u32	fat32_length;
+	u32	fat32_root_cluster;
+	u16	fat32_info_sector;
+	u8	fat32_state;
+	u32	fat32_vol_id;
+};
+
 static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
 static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
 
+static struct fat_floppy_defaults {
+	unsigned nr_sectors;
+	unsigned sec_per_clus;
+	unsigned dir_entries;
+	unsigned media;
+	unsigned fat_length;
+} floppy_defaults[] = {
+{
+	.nr_sectors = 160 * KB_IN_SECTORS,
+	.sec_per_clus = 1,
+	.dir_entries = 64,
+	.media = 0xFE,
+	.fat_length = 1,
+},
+{
+	.nr_sectors = 180 * KB_IN_SECTORS,
+	.sec_per_clus = 1,
+	.dir_entries = 64,
+	.media = 0xFC,
+	.fat_length = 2,
+},
+{
+	.nr_sectors = 320 * KB_IN_SECTORS,
+	.sec_per_clus = 2,
+	.dir_entries = 112,
+	.media = 0xFF,
+	.fat_length = 1,
+},
+{
+	.nr_sectors = 360 * KB_IN_SECTORS,
+	.sec_per_clus = 2,
+	.dir_entries = 112,
+	.media = 0xFD,
+	.fat_length = 2,
+},
+};
 
 static int fat_add_cluster(struct inode *inode)
 {
@@ -853,6 +915,8 @@ static int fat_show_options(struct seq_f
 		seq_puts(m, ",nfs=stale_rw");
 	if (opts->discard)
 		seq_puts(m, ",discard");
+	if (opts->dos1xfloppy)
+		seq_puts(m, ",dos1xfloppy");
 
 	return 0;
 }
@@ -867,7 +931,7 @@ enum {
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
 	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_time_offset,
-	Opt_nfs_stale_rw, Opt_nfs_nostale_ro, Opt_err,
+	Opt_nfs_stale_rw, Opt_nfs_nostale_ro, Opt_err, Opt_dos1xfloppy,
 };
 
 static const match_table_t fat_tokens = {
@@ -900,6 +964,7 @@ static const match_table_t fat_tokens =
 	{Opt_nfs_stale_rw, "nfs"},
 	{Opt_nfs_stale_rw, "nfs=stale_rw"},
 	{Opt_nfs_nostale_ro, "nfs=nostale_ro"},
+	{Opt_dos1xfloppy, "dos1xfloppy"},
 	{Opt_obsolete, "conv=binary"},
 	{Opt_obsolete, "conv=text"},
 	{Opt_obsolete, "conv=auto"},
@@ -1102,6 +1167,9 @@ static int parse_options(struct super_bl
 		case Opt_nfs_nostale_ro:
 			opts->nfs = FAT_NFS_NOSTALE_RO;
 			break;
+		case Opt_dos1xfloppy:
+			opts->dos1xfloppy = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1247,6 +1315,169 @@ static unsigned long calc_fat_clusters(s
 	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
 }
 
+static bool fat_bpb_is_zero(struct fat_boot_sector *b)
+{
+	if (get_unaligned_le16(&b->sector_size))
+		return false;
+	if (b->sec_per_clus)
+		return false;
+	if (b->reserved)
+		return false;
+	if (b->fats)
+		return false;
+	if (get_unaligned_le16(&b->dir_entries))
+		return false;
+	if (get_unaligned_le16(&b->sectors))
+		return false;
+	if (b->media)
+		return false;
+	if (b->fat_length)
+		return false;
+	if (b->secs_track)
+		return false;
+	if (b->heads)
+		return false;
+	return true;
+}
+
+static int fat_read_bpb(struct super_block *sb, struct fat_boot_sector *b,
+	int silent, struct fat_bios_param_block *bpb)
+{
+	int error = -EINVAL;
+
+	/* Read in BPB ... */
+	memset(bpb, 0, sizeof(*bpb));
+	bpb->fat_sector_size = get_unaligned_le16(&b->sector_size);
+	bpb->fat_sec_per_clus = b->sec_per_clus;
+	bpb->fat_reserved = le16_to_cpu(b->reserved);
+	bpb->fat_fats = b->fats;
+	bpb->fat_dir_entries = get_unaligned_le16(&b->dir_entries);
+	bpb->fat_sectors = get_unaligned_le16(&b->sectors);
+	bpb->fat_fat_length = le16_to_cpu(b->fat_length);
+	bpb->fat_total_sect = le32_to_cpu(b->total_sect);
+
+	bpb->fat16_state = b->fat16.state;
+	bpb->fat16_vol_id = get_unaligned_le32(b->fat16.vol_id);
+
+	bpb->fat32_length = le32_to_cpu(b->fat32.length);
+	bpb->fat32_root_cluster = le32_to_cpu(b->fat32.root_cluster);
+	bpb->fat32_info_sector = le16_to_cpu(b->fat32.info_sector);
+	bpb->fat32_state = b->fat32.state;
+	bpb->fat32_vol_id = get_unaligned_le32(b->fat32.vol_id);
+
+	/* Validate this looks like a FAT filesystem BPB */
+	if (!bpb->fat_reserved) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR,
+				"bogus number of reserved sectors");
+		goto out;
+	}
+	if (!bpb->fat_fats) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "bogus number of FAT structure");
+		goto out;
+	}
+
+	/*
+	 * Earlier we checked here that b->secs_track and b->head are nonzero,
+	 * but it turns out valid FAT filesystems can have zero there.
+	 */
+
+	if (!fat_valid_media(b->media)) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "invalid media value (0x%02x)",
+				(unsigned)b->media);
+		goto out;
+	}
+
+	if (!is_power_of_2(bpb->fat_sector_size)
+	    || (bpb->fat_sector_size < 512)
+	    || (bpb->fat_sector_size > 4096)) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "bogus logical sector size %u",
+			       (unsigned)bpb->fat_sector_size);
+		goto out;
+	}
+
+	if (!is_power_of_2(bpb->fat_sec_per_clus)) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "bogus sectors per cluster %u",
+				(unsigned)bpb->fat_sec_per_clus);
+		goto out;
+	}
+
+	error = 0;
+
+out:
+	return error;
+}
+
+static int fat_read_static_bpb(struct super_block *sb,
+	struct fat_boot_sector *b, int silent,
+	struct fat_bios_param_block *bpb)
+{
+	static const char *notdos1x = "This doesn't look like a DOS 1.x volume";
+
+	struct fat_floppy_defaults *fdefaults = NULL;
+	int error = -EINVAL;
+	sector_t bd_sects;
+	unsigned i;
+
+	bd_sects = i_size_read(sb->s_bdev->bd_inode) / SECTOR_SIZE;
+
+	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
+	if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR,
+				"%s; no bootstrapping code", notdos1x);
+		goto out;
+	}
+
+	/*
+	 * If any value in this region is non-zero, it isn't archaic
+	 * DOS.
+	 */
+	if (!fat_bpb_is_zero(b)) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR,
+				"%s; DOS 2.x BPB is non-zero", notdos1x);
+		goto out;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(floppy_defaults); i++) {
+		if (floppy_defaults[i].nr_sectors == bd_sects) {
+			fdefaults = &floppy_defaults[i];
+			break;
+		}
+	}
+
+	if (fdefaults == NULL) {
+		if (!silent)
+			fat_msg(sb, KERN_WARNING,
+				"This looks like a DOS 1.x volume, but isn't a recognized floppy size (%llu sectors)",
+				(u64)bd_sects);
+		goto out;
+	}
+
+	if (!silent)
+		fat_msg(sb, KERN_INFO,
+			"This looks like a DOS 1.x volume; assuming default BPB values");
+
+	memset(bpb, 0, sizeof(*bpb));
+	bpb->fat_sector_size = SECTOR_SIZE;
+	bpb->fat_sec_per_clus = fdefaults->sec_per_clus;
+	bpb->fat_reserved = 1;
+	bpb->fat_fats = 2;
+	bpb->fat_dir_entries = fdefaults->dir_entries;
+	bpb->fat_sectors = fdefaults->nr_sectors;
+	bpb->fat_fat_length = fdefaults->fat_length;
+
+	error = 0;
+
+out:
+	return error;
+}
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1256,12 +1487,11 @@ int fat_fill_super(struct super_block *s
 	struct inode *root_inode = NULL, *fat_inode = NULL;
 	struct inode *fsinfo_inode = NULL;
 	struct buffer_head *bh;
-	struct fat_boot_sector *b;
+	struct fat_bios_param_block bpb;
 	struct msdos_sb_info *sbi;
 	u16 logical_sector_size;
 	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
 	int debug;
-	unsigned int media;
 	long error;
 	char buf[50];
 
@@ -1298,100 +1528,71 @@ int fat_fill_super(struct super_block *s
 		goto out_fail;
 	}
 
-	b = (struct fat_boot_sector *) bh->b_data;
-	if (!b->reserved) {
-		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus number of reserved sectors");
-		brelse(bh);
-		goto out_invalid;
-	}
-	if (!b->fats) {
-		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus number of FAT structure");
-		brelse(bh);
-		goto out_invalid;
-	}
-
-	/*
-	 * Earlier we checked here that b->secs_track and b->head are nonzero,
-	 * but it turns out valid FAT filesystems can have zero there.
-	 */
+	error = fat_read_bpb(sb, (struct fat_boot_sector *)bh->b_data, silent,
+		&bpb);
+	if (error == -EINVAL && sbi->options.dos1xfloppy)
+		error = fat_read_static_bpb(sb,
+			(struct fat_boot_sector *)bh->b_data, silent, &bpb);
+	brelse(bh);
 
-	media = b->media;
-	if (!fat_valid_media(media)) {
-		if (!silent)
-			fat_msg(sb, KERN_ERR, "invalid media value (0x%02x)",
-			       media);
-		brelse(bh);
-		goto out_invalid;
-	}
-	logical_sector_size = get_unaligned_le16(&b->sector_size);
-	if (!is_power_of_2(logical_sector_size)
-	    || (logical_sector_size < 512)
-	    || (logical_sector_size > 4096)) {
-		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus logical sector size %u",
-			       logical_sector_size);
-		brelse(bh);
+	if (error == -EINVAL)
 		goto out_invalid;
-	}
-	sbi->sec_per_clus = b->sec_per_clus;
-	if (!is_power_of_2(sbi->sec_per_clus)) {
-		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus sectors per cluster %u",
-			       sbi->sec_per_clus);
-		brelse(bh);
-		goto out_invalid;
-	}
+	else if (error)
+		goto out_fail;
+
+	logical_sector_size = bpb.fat_sector_size;
+	sbi->sec_per_clus = bpb.fat_sec_per_clus;
 
 	if (logical_sector_size < sb->s_blocksize) {
 		fat_msg(sb, KERN_ERR, "logical sector size too small for device"
 		       " (logical sector size = %u)", logical_sector_size);
-		brelse(bh);
 		goto out_fail;
 	}
+
 	if (logical_sector_size > sb->s_blocksize) {
-		brelse(bh);
+		struct buffer_head *bh_resize;
 
 		if (!sb_set_blocksize(sb, logical_sector_size)) {
 			fat_msg(sb, KERN_ERR, "unable to set blocksize %u",
 			       logical_sector_size);
 			goto out_fail;
 		}
-		bh = sb_bread(sb, 0);
-		if (bh == NULL) {
+
+		/* Verify that the larger boot sector is fully readable */
+		bh_resize = sb_bread(sb, 0);
+		if (bh_resize == NULL) {
 			fat_msg(sb, KERN_ERR, "unable to read boot sector"
 			       " (logical sector size = %lu)",
 			       sb->s_blocksize);
 			goto out_fail;
 		}
-		b = (struct fat_boot_sector *) bh->b_data;
+		brelse(bh_resize);
 	}
 
 	mutex_init(&sbi->s_lock);
 	sbi->cluster_size = sb->s_blocksize * sbi->sec_per_clus;
 	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
-	sbi->fats = b->fats;
+	sbi->fats = bpb.fat_fats;
 	sbi->fat_bits = 0;		/* Don't know yet */
-	sbi->fat_start = le16_to_cpu(b->reserved);
-	sbi->fat_length = le16_to_cpu(b->fat_length);
+	sbi->fat_start = bpb.fat_reserved;
+	sbi->fat_length = bpb.fat_fat_length;
 	sbi->root_cluster = 0;
 	sbi->free_clusters = -1;	/* Don't know yet */
 	sbi->free_clus_valid = 0;
 	sbi->prev_free = FAT_START_ENT;
 	sb->s_maxbytes = 0xffffffff;
 
-	if (!sbi->fat_length && b->fat32.length) {
+	if (!sbi->fat_length && bpb.fat32_length) {
 		struct fat_boot_fsinfo *fsinfo;
 		struct buffer_head *fsinfo_bh;
 
 		/* Must be FAT32 */
 		sbi->fat_bits = 32;
-		sbi->fat_length = le32_to_cpu(b->fat32.length);
-		sbi->root_cluster = le32_to_cpu(b->fat32.root_cluster);
+		sbi->fat_length = bpb.fat32_length;
+		sbi->root_cluster = bpb.fat32_root_cluster;
 
 		/* MC - if info_sector is 0, don't multiply by 0 */
-		sbi->fsinfo_sector = le16_to_cpu(b->fat32.info_sector);
+		sbi->fsinfo_sector = bpb.fat32_info_sector;
 		if (sbi->fsinfo_sector == 0)
 			sbi->fsinfo_sector = 1;
 
@@ -1399,7 +1600,6 @@ int fat_fill_super(struct super_block *s
 		if (fsinfo_bh == NULL) {
 			fat_msg(sb, KERN_ERR, "bread failed, FSINFO block"
 			       " (sector = %lu)", sbi->fsinfo_sector);
-			brelse(bh);
 			goto out_fail;
 		}
 
@@ -1422,35 +1622,28 @@ int fat_fill_super(struct super_block *s
 
 	/* interpret volume ID as a little endian 32 bit integer */
 	if (sbi->fat_bits == 32)
-		sbi->vol_id = (((u32)b->fat32.vol_id[0]) |
-					((u32)b->fat32.vol_id[1] << 8) |
-					((u32)b->fat32.vol_id[2] << 16) |
-					((u32)b->fat32.vol_id[3] << 24));
+		sbi->vol_id = bpb.fat32_vol_id;
 	else /* fat 16 or 12 */
-		sbi->vol_id = (((u32)b->fat16.vol_id[0]) |
-					((u32)b->fat16.vol_id[1] << 8) |
-					((u32)b->fat16.vol_id[2] << 16) |
-					((u32)b->fat16.vol_id[3] << 24));
+		sbi->vol_id = bpb.fat16_vol_id;
 
 	sbi->dir_per_block = sb->s_blocksize / sizeof(struct msdos_dir_entry);
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
 
 	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
-	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
+	sbi->dir_entries = bpb.fat_dir_entries;
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "bogus directory-entries per block"
 			       " (%u)", sbi->dir_entries);
-		brelse(bh);
 		goto out_invalid;
 	}
 
 	rootdir_sectors = sbi->dir_entries
 		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
 	sbi->data_start = sbi->dir_start + rootdir_sectors;
-	total_sectors = get_unaligned_le16(&b->sectors);
+	total_sectors = bpb.fat_sectors;
 	if (total_sectors == 0)
-		total_sectors = le32_to_cpu(b->total_sect);
+		total_sectors = bpb.fat_total_sect;
 
 	total_clusters = (total_sectors - sbi->data_start) / sbi->sec_per_clus;
 
@@ -1459,9 +1652,9 @@ int fat_fill_super(struct super_block *s
 
 	/* some OSes set FAT_STATE_DIRTY and clean it on unmount. */
 	if (sbi->fat_bits == 32)
-		sbi->dirty = b->fat32.state & FAT_STATE_DIRTY;
+		sbi->dirty = bpb.fat32_state & FAT_STATE_DIRTY;
 	else /* fat 16 or 12 */
-		sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
+		sbi->dirty = bpb.fat16_state & FAT_STATE_DIRTY;
 
 	/* check that FAT table does not overflow */
 	fat_clusters = calc_fat_clusters(sb);
@@ -1470,7 +1663,6 @@ int fat_fill_super(struct super_block *s
 		if (!silent)
 			fat_msg(sb, KERN_ERR, "count of clusters too big (%u)",
 			       total_clusters);
-		brelse(bh);
 		goto out_invalid;
 	}
 
@@ -1483,8 +1675,6 @@ int fat_fill_super(struct super_block *s
 	if (sbi->prev_free < FAT_START_ENT)
 		sbi->prev_free = FAT_START_ENT;
 
-	brelse(bh);
