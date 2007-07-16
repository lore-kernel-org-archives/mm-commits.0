From: akpm@linux-foundation.org
Subject: - fix-up-codingstyle-in-isofs.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:11 -0700
Message-ID: <200707162054.l6GKsB3H001784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761276AbXGPV2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     isofs: fix up CodingStyle
has been removed from the -mm tree.  Its filename was
     fix-up-codingstyle-in-isofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isofs: fix up CodingStyle
From: Dave Jones <davej@redhat.com>

fs/isofs/* had a bunch of CodingStyle issues.
* Indentation was a mix of spaces and tabs
* "int * foo" instead of "int *foo"
* "while ( foo )" instead of "while (foo)"
* if (foo) blah; on one line instead of two
* Missing printk KERN_ levels
* lots of trailing whitespace
* lines >80 columns changed to wrap.
* Unnecessary prototype removed by shuffling code order in C file.

Should be no functional changes other than slight size increase due to
printk changes.  Further improvement possible, but this is a start..

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/dir.c    |   87 ++++-----
 fs/isofs/inode.c  |  415 ++++++++++++++++++++++----------------------
 fs/isofs/joliet.c |   10 -
 fs/isofs/namei.c  |   26 +-
 4 files changed, 277 insertions(+), 261 deletions(-)

diff -puN fs/isofs/dir.c~fix-up-codingstyle-in-isofs fs/isofs/dir.c
--- a/fs/isofs/dir.c~fix-up-codingstyle-in-isofs
+++ a/fs/isofs/dir.c
@@ -7,34 +7,18 @@
  *
  *  Steve Beynon		       : Missing last directory entries fixed
  *  (stephen@askone.demon.co.uk)      : 21st June 1996
- * 
+ *
  *  isofs directory handling functions
  */
 #include <linux/smp_lock.h>
 #include "isofs.h"
 
-static int isofs_readdir(struct file *, void *, filldir_t);
-
-const struct file_operations isofs_dir_operations =
-{
-	.read		= generic_read_dir,
-	.readdir	= isofs_readdir,
-};
-
-/*
- * directories can handle most operations...
- */
-const struct inode_operations isofs_dir_inode_operations =
-{
-	.lookup		= isofs_lookup,
-};
-
 int isofs_name_translate(struct iso_directory_record *de, char *new, struct inode *inode)
 {
 	char * old = de->name;
 	int len = de->name_len[0];
 	int i;
-			
+
 	for (i = 0; i < len; i++) {
 		unsigned char c = old[i];
 		if (!c)
@@ -62,22 +46,27 @@ int isofs_name_translate(struct iso_dire
 }
 
 /* Acorn extensions written by Matthew Wilcox <willy@bofh.ai> 1998 */
-int get_acorn_filename(struct iso_directory_record * de,
-			    char * retname, struct inode * inode)
+int get_acorn_filename(struct iso_directory_record *de,
+			    char *retname, struct inode *inode)
 {
 	int std;
-	unsigned char * chr;
+	unsigned char *chr;
 	int retnamlen = isofs_name_translate(de, retname, inode);
-	if (retnamlen == 0) return 0;
+
+	if (retnamlen == 0)
+		return 0;
 	std = sizeof(struct iso_directory_record) + de->name_len[0];
-	if (std & 1) std++;
-	if ((*((unsigned char *) de) - std) != 32) return retnamlen;
+	if (std & 1)
+		std++;
+	if ((*((unsigned char *) de) - std) != 32)
+		return retnamlen;
 	chr = ((unsigned char *) de) + std;
-	if (strncmp(chr, "ARCHIMEDES", 10)) return retnamlen;
-	if ((*retname == '_') && ((chr[19] & 1) == 1)) *retname = '!';
+	if (strncmp(chr, "ARCHIMEDES", 10))
+		return retnamlen;
+	if ((*retname == '_') && ((chr[19] & 1) == 1))
+		*retname = '!';
 	if (((de->flags[0] & 2) == 0) && (chr[13] == 0xff)
-		&& ((chr[12] & 0xf0) == 0xf0))
-	{
+		&& ((chr[12] & 0xf0) == 0xf0)) {
 		retname[retnamlen] = ',';
 		sprintf(retname+retnamlen+1, "%3.3x",
 			((chr[12] & 0xf) << 8) | chr[11]);
@@ -91,7 +80,7 @@ int get_acorn_filename(struct iso_direct
  */
 static int do_isofs_readdir(struct inode *inode, struct file *filp,
 		void *dirent, filldir_t filldir,
-		char * tmpname, struct iso_directory_record * tmpde)
+		char *tmpname, struct iso_directory_record *tmpde)
 {
 	unsigned long bufsize = ISOFS_BUFFER_SIZE(inode);
 	unsigned char bufbits = ISOFS_BUFFER_BITS(inode);
@@ -121,9 +110,11 @@ static int do_isofs_readdir(struct inode
 
 		de_len = *(unsigned char *) de;
 
-		/* If the length byte is zero, we should move on to the next
-		   CDROM sector.  If we are at the end of the directory, we
-		   kick out of the while loop. */
+		/*
+		 * If the length byte is zero, we should move on to the next
+		 * CDROM sector.  If we are at the end of the directory, we
+		 * kick out of the while loop.
+		 */
 
 		if (de_len == 0) {
 			brelse(bh);
@@ -157,11 +148,10 @@ static int do_isofs_readdir(struct inode
 
 		if (first_de) {
 			isofs_normalize_block_and_offset(de,
-							 &block_saved,
-							 &offset_saved);
+							&block_saved,
+							&offset_saved);
 			inode_number = isofs_get_ino(block_saved,
-						     offset_saved,
-						     bufbits);
+							offset_saved, bufbits);
 		}
 
 		if (de->flags[-sbi->s_high_sierra] & 0x80) {
@@ -199,7 +189,7 @@ static int do_isofs_readdir(struct inode
 		 */
 		if ((sbi->s_hide == 'y' &&
 				(de->flags[-sbi->s_high_sierra] & 1)) ||
-		      (sbi->s_showassoc =='n' &&
+				(sbi->s_showassoc =='n' &&
 				(de->flags[-sbi->s_high_sierra] & 4))) {
 			filp->f_pos += de_len;
 			continue;
@@ -240,7 +230,8 @@ static int do_isofs_readdir(struct inode
 
 		continue;
 	}
-	if (bh) brelse(bh);
+	if (bh)
+		brelse(bh);
 	return 0;
 }
 
@@ -253,8 +244,8 @@ static int isofs_readdir(struct file *fi
 		void *dirent, filldir_t filldir)
 {
 	int result;
-	char * tmpname;
-	struct iso_directory_record * tmpde;
+	char *tmpname;
+	struct iso_directory_record *tmpde;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	tmpname = (char *)__get_free_page(GFP_KERNEL);
@@ -270,3 +261,19 @@ static int isofs_readdir(struct file *fi
 	unlock_kernel();
 	return result;
 }
+
+const struct file_operations isofs_dir_operations =
+{
+	.read = generic_read_dir,
+	.readdir = isofs_readdir,
+};
+
+/*
+ * directories can handle most operations...
+ */
+const struct inode_operations isofs_dir_inode_operations =
+{
+	.lookup = isofs_lookup,
+};
+
+
diff -puN fs/isofs/inode.c~fix-up-codingstyle-in-isofs fs/isofs/inode.c
--- a/fs/isofs/inode.c~fix-up-codingstyle-in-isofs
+++ a/fs/isofs/inode.c
@@ -73,20 +73,20 @@ static void isofs_destroy_inode(struct i
 	kmem_cache_free(isofs_inode_cachep, ISOFS_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct iso_inode_info *ei = foo;
 
 	inode_init_once(&ei->vfs_inode);
 }
- 
+
 static int init_inodecache(void)
 {
 	isofs_inode_cachep = kmem_cache_create("isofs_inode_cache",
-					     sizeof(struct iso_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
-					     init_once, NULL);
+					sizeof(struct iso_inode_info),
+					0, (SLAB_RECLAIM_ACCOUNT|
+					SLAB_MEM_SPREAD),
+					init_once, NULL);
 	if (isofs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
@@ -150,9 +150,9 @@ struct iso9660_options{
 	uid_t uid;
 	char *iocharset;
 	unsigned char utf8;
-        /* LVE */
-        s32 session;
-        s32 sbsector;
+	/* LVE */
+	s32 session;
+	s32 sbsector;
 };
 
 /*
@@ -360,10 +360,12 @@ static int parse_options(char *options, 
 	popt->check = 'u';		/* unset */
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
-	popt->mode = S_IRUGO | S_IXUGO; /* r-x for all.  The disc could
-					   be shared with DOS machines so
-					   virtually anything could be
-					   a valid executable. */
+	popt->mode = S_IRUGO | S_IXUGO; /*
+					 * r-x for all.  The disc could
+					 * be shared with DOS machines so
+					 * virtually anything could be
+					 * a valid executable.
+					 */
 	popt->gid = 0;
 	popt->uid = 0;
 	popt->iocharset = NULL;
@@ -503,30 +505,30 @@ static unsigned int isofs_get_last_sessi
 		Te.cdte_format=CDROM_LBA;
 		i = ioctl_by_bdev(bdev, CDROMREADTOCENTRY, (unsigned long) &Te);
 		if (!i) {
-			printk(KERN_DEBUG "Session %d start %d type %d\n",
-			       session, Te.cdte_addr.lba,
-			       Te.cdte_ctrl&CDROM_DATA_TRACK);
+			printk(KERN_DEBUG "ISOFS: Session %d start %d type %d\n",
+				session, Te.cdte_addr.lba,
+				Te.cdte_ctrl&CDROM_DATA_TRACK);
 			if ((Te.cdte_ctrl&CDROM_DATA_TRACK) == 4)
 				return Te.cdte_addr.lba;
 		}
-			
-		printk(KERN_ERR "Invalid session number or type of track\n");
+
+		printk(KERN_ERR "ISOFS: Invalid session number or type of track\n");
 	}
 	i = ioctl_by_bdev(bdev, CDROMMULTISESSION, (unsigned long) &ms_info);
 	if (session > 0)
-		printk(KERN_ERR "Invalid session number\n");
+		printk(KERN_ERR "ISOFS: Invalid session number\n");
 #if 0
-	printk("isofs.inode: CDROMMULTISESSION: rc=%d\n",i);
+	printk(KERN_DEBUG "isofs.inode: CDROMMULTISESSION: rc=%d\n",i);
 	if (i==0) {
-		printk("isofs.inode: XA disk: %s\n",ms_info.xa_flag?"yes":"no");
-		printk("isofs.inode: vol_desc_start = %d\n", ms_info.addr.lba);
+		printk(KERN_DEBUG "isofs.inode: XA disk: %s\n",ms_info.xa_flag?"yes":"no");
+		printk(KERN_DEBUG "isofs.inode: vol_desc_start = %d\n", ms_info.addr.lba);
 	}
 #endif
 	if (i==0)
 #if WE_OBEY_THE_WRITTEN_STANDARDS
-        if (ms_info.xa_flag) /* necessary for a valid ms_info.addr */
+		if (ms_info.xa_flag) /* necessary for a valid ms_info.addr */
 #endif
-		vol_desc_start=ms_info.addr.lba;
+			vol_desc_start=ms_info.addr.lba;
 	return vol_desc_start;
 }
 
@@ -538,20 +540,20 @@ static unsigned int isofs_get_last_sessi
  */
 static int isofs_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct buffer_head	      * bh = NULL, *pri_bh = NULL;
-	struct hs_primary_descriptor  * h_pri = NULL;
-	struct iso_primary_descriptor * pri = NULL;
+	struct buffer_head *bh = NULL, *pri_bh = NULL;
+	struct hs_primary_descriptor *h_pri = NULL;
+	struct iso_primary_descriptor *pri = NULL;
 	struct iso_supplementary_descriptor *sec = NULL;
-	struct iso_directory_record   * rootp;
-	int				joliet_level = 0;
-	int				iso_blknum, block;
-	int				orig_zonesize;
-	int				table;
-	unsigned int			vol_desc_start;
-	unsigned long			first_data_zone;
-	struct inode		      * inode;
-	struct iso9660_options		opt;
-	struct isofs_sb_info	      * sbi;
+	struct iso_directory_record *rootp;
+	struct inode *inode;
+	struct iso9660_options opt;
+	struct isofs_sb_info *sbi;
+	unsigned long first_data_zone;
+	int joliet_level = 0;
+	int iso_blknum, block;
+	int orig_zonesize;
+	int table;
+	unsigned int vol_desc_start;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -577,72 +579,73 @@ static int isofs_fill_super(struct super
 	vol_desc_start = (opt.sbsector != -1) ?
 		opt.sbsector : isofs_get_last_session(s,opt.session);
 
-  	for (iso_blknum = vol_desc_start+16;
-             iso_blknum < vol_desc_start+100; iso_blknum++)
-	{
-	    struct hs_volume_descriptor   * hdp;
-	    struct iso_volume_descriptor  * vdp;
-
-	    block = iso_blknum << (ISOFS_BLOCK_BITS - s->s_blocksize_bits);
-	    if (!(bh = sb_bread(s, block)))
-		goto out_no_read;
-
-	    vdp = (struct iso_volume_descriptor *)bh->b_data;
-	    hdp = (struct hs_volume_descriptor *)bh->b_data;
-	    
-	    /* Due to the overlapping physical location of the descriptors, 
-	     * ISO CDs can match hdp->id==HS_STANDARD_ID as well. To ensure 
-	     * proper identification in this case, we first check for ISO.
-	     */
-	    if (strncmp (vdp->id, ISO_STANDARD_ID, sizeof vdp->id) == 0) {
-		if (isonum_711 (vdp->type) == ISO_VD_END)
-		    break;
-		if (isonum_711 (vdp->type) == ISO_VD_PRIMARY) {
-		    if (pri == NULL) {
-			pri = (struct iso_primary_descriptor *)vdp;
-			/* Save the buffer in case we need it ... */
-			pri_bh = bh;
-			bh = NULL;
-		    }
-		}
+	for (iso_blknum = vol_desc_start+16;
+		iso_blknum < vol_desc_start+100; iso_blknum++) {
+		struct hs_volume_descriptor *hdp;
+		struct iso_volume_descriptor  *vdp;
+
+		block = iso_blknum << (ISOFS_BLOCK_BITS - s->s_blocksize_bits);
+		if (!(bh = sb_bread(s, block)))
+			goto out_no_read;
+
+		vdp = (struct iso_volume_descriptor *)bh->b_data;
+		hdp = (struct hs_volume_descriptor *)bh->b_data;
+
+		/*
+		 * Due to the overlapping physical location of the descriptors,
+		 * ISO CDs can match hdp->id==HS_STANDARD_ID as well. To ensure
+		 * proper identification in this case, we first check for ISO.
+		 */
+		if (strncmp (vdp->id, ISO_STANDARD_ID, sizeof vdp->id) == 0) {
+			if (isonum_711(vdp->type) == ISO_VD_END)
+				break;
+			if (isonum_711(vdp->type) == ISO_VD_PRIMARY) {
+				if (pri == NULL) {
+					pri = (struct iso_primary_descriptor *)vdp;
+					/* Save the buffer in case we need it ... */
+					pri_bh = bh;
+					bh = NULL;
+				}
+			}
 #ifdef CONFIG_JOLIET
-		else if (isonum_711 (vdp->type) == ISO_VD_SUPPLEMENTARY) {
-		    sec = (struct iso_supplementary_descriptor *)vdp;
-		    if (sec->escape[0] == 0x25 && sec->escape[1] == 0x2f) {
-			if (opt.joliet == 'y') {
-			    if (sec->escape[2] == 0x40) {
-				joliet_level = 1;
-			    } else if (sec->escape[2] == 0x43) {
-				joliet_level = 2;
-			    } else if (sec->escape[2] == 0x45) {
-				joliet_level = 3;
-			    }
-			    printk(KERN_DEBUG"ISO 9660 Extensions: Microsoft Joliet Level %d\n",
-				   joliet_level);
+			else if (isonum_711(vdp->type) == ISO_VD_SUPPLEMENTARY) {
+				sec = (struct iso_supplementary_descriptor *)vdp;
+				if (sec->escape[0] == 0x25 && sec->escape[1] == 0x2f) {
+					if (opt.joliet == 'y') {
+						if (sec->escape[2] == 0x40)
+							joliet_level = 1;
+						else if (sec->escape[2] == 0x43)
+							joliet_level = 2;
+						else if (sec->escape[2] == 0x45)
+							joliet_level = 3;
+
+						printk(KERN_DEBUG "ISO 9660 Extensions: "
+							"Microsoft Joliet Level %d\n",
+							joliet_level);
+					}
+					goto root_found;
+				} else {
+				/* Unknown supplementary volume descriptor */
+				sec = NULL;
+				}
 			}
-			goto root_found;
-		    } else {
-			/* Unknown supplementary volume descriptor */
-			sec = NULL;
-		    }
-		}
 #endif
-	    } else {
-	        if (strncmp (hdp->id, HS_STANDARD_ID, sizeof hdp->id) == 0) {
-		    if (isonum_711 (hdp->type) != ISO_VD_PRIMARY)
-		        goto out_freebh;
-		
-		    sbi->s_high_sierra = 1;
-		    opt.rock = 'n';
-		    h_pri = (struct hs_primary_descriptor *)vdp;
-		    goto root_found;
+		} else {
+			if (strncmp (hdp->id, HS_STANDARD_ID, sizeof hdp->id) == 0) {
+				if (isonum_711(hdp->type) != ISO_VD_PRIMARY)
+					goto out_freebh;
+
+				sbi->s_high_sierra = 1;
+				opt.rock = 'n';
+				h_pri = (struct hs_primary_descriptor *)vdp;
+				goto root_found;
+			}
 		}
-	    }
 
-            /* Just skip any volume descriptors we don't recognize */
+		/* Just skip any volume descriptors we don't recognize */
 
-	    brelse(bh);
-	    bh = NULL;
+		brelse(bh);
+		bh = NULL;
 	}
 	/*
 	 * If we fall through, either no volume descriptor was found,
@@ -657,24 +660,24 @@ static int isofs_fill_super(struct super
 root_found:
 
 	if (joliet_level && (pri == NULL || opt.rock == 'n')) {
-	    /* This is the case of Joliet with the norock mount flag.
-	     * A disc with both Joliet and Rock Ridge is handled later
-	     */
-	    pri = (struct iso_primary_descriptor *) sec;
+		/* This is the case of Joliet with the norock mount flag.
+		 * A disc with both Joliet and Rock Ridge is handled later
+		 */
+		pri = (struct iso_primary_descriptor *) sec;
 	}
 
 	if(sbi->s_high_sierra){
-	  rootp = (struct iso_directory_record *) h_pri->root_directory_record;
-	  sbi->s_nzones = isonum_733 (h_pri->volume_space_size);
-	  sbi->s_log_zone_size = isonum_723 (h_pri->logical_block_size);
-	  sbi->s_max_size = isonum_733(h_pri->volume_space_size);
+		rootp = (struct iso_directory_record *) h_pri->root_directory_record;
+		sbi->s_nzones = isonum_733(h_pri->volume_space_size);
+		sbi->s_log_zone_size = isonum_723(h_pri->logical_block_size);
+		sbi->s_max_size = isonum_733(h_pri->volume_space_size);
 	} else {
-	  if (!pri)
-	    goto out_freebh;
-	  rootp = (struct iso_directory_record *) pri->root_directory_record;
-	  sbi->s_nzones = isonum_733 (pri->volume_space_size);
-	  sbi->s_log_zone_size = isonum_723 (pri->logical_block_size);
-	  sbi->s_max_size = isonum_733(pri->volume_space_size);
+		if (!pri)
+			goto out_freebh;
+		rootp = (struct iso_directory_record *) pri->root_directory_record;
+		sbi->s_nzones = isonum_733(pri->volume_space_size);
+		sbi->s_log_zone_size = isonum_723(pri->logical_block_size);
+		sbi->s_max_size = isonum_733(pri->volume_space_size);
 	}
 
 	sbi->s_ninodes = 0; /* No way to figure this out easily */
@@ -687,42 +690,43 @@ root_found:
 	 * blocks that were 512 bytes (which should only very rarely
 	 * happen.)
 	 */
-	if(orig_zonesize < opt.blocksize)
+	if (orig_zonesize < opt.blocksize)
 		goto out_bad_size;
 
 	/* RDE: convert log zone size to bit shift */
-	switch (sbi->s_log_zone_size)
-	  { case  512: sbi->s_log_zone_size =  9; break;
-	    case 1024: sbi->s_log_zone_size = 10; break;
-	    case 2048: sbi->s_log_zone_size = 11; break;
+	switch (sbi->s_log_zone_size) {
+	case  512: sbi->s_log_zone_size =  9; break;
+	case 1024: sbi->s_log_zone_size = 10; break;
+	case 2048: sbi->s_log_zone_size = 11; break;
 
-	    default:
+	default:
 		goto out_bad_zone_size;
-	  }
+	}
 
 	s->s_magic = ISOFS_SUPER_MAGIC;
 	s->s_maxbytes = 0xffffffff; /* We can handle files up to 4 GB */
 
-	/* The CDROM is read-only, has no nodes (devices) on it, and since
-	   all of the files appear to be owned by root, we really do not want
-	   to allow suid.  (suid or devices will not show up unless we have
-	   Rock Ridge extensions) */
+	/*
+	 * The CDROM is read-only, has no nodes (devices) on it, and since
+	 * all of the files appear to be owned by root, we really do not want
+	 * to allow suid.  (suid or devices will not show up unless we have
+	 * Rock Ridge extensions)
+	 */
 
 	s->s_flags |= MS_RDONLY /* | MS_NODEV | MS_NOSUID */;
 
 	/* Set this for reference. Its not currently used except on write
 	   which we don't have .. */
-	   
-	first_data_zone = isonum_733 (rootp->extent) +
-			  isonum_711 (rootp->ext_attr_length);
+
+	first_data_zone = isonum_733(rootp->extent) +
+			  isonum_711(rootp->ext_attr_length);
 	sbi->s_firstdatazone = first_data_zone;
 #ifndef BEQUIET
-	printk(KERN_DEBUG "Max size:%ld   Log zone size:%ld\n",
-	       sbi->s_max_size,
-	       1UL << sbi->s_log_zone_size);
-	printk(KERN_DEBUG "First datazone:%ld\n", sbi->s_firstdatazone);
+	printk(KERN_DEBUG "ISOFS: Max size:%ld   Log zone size:%ld\n",
+		sbi->s_max_size, 1UL << sbi->s_log_zone_size);
+	printk(KERN_DEBUG "ISOFS: First datazone:%ld\n", sbi->s_firstdatazone);
 	if(sbi->s_high_sierra)
-		printk(KERN_DEBUG "Disc in High Sierra format.\n");
+		printk(KERN_DEBUG "ISOFS: Disc in High Sierra format.\n");
 #endif
 
 	/*
@@ -737,8 +741,8 @@ root_found:
 		pri = (struct iso_primary_descriptor *) sec;
 		rootp = (struct iso_directory_record *)
 			pri->root_directory_record;
-		first_data_zone = isonum_733 (rootp->extent) +
-			  	isonum_711 (rootp->ext_attr_length);
+		first_data_zone = isonum_733(rootp->extent) +
+				isonum_711(rootp->ext_attr_length);
 	}
 
 	/*
@@ -771,7 +775,7 @@ root_found:
 
 #ifdef CONFIG_JOLIET
 	if (joliet_level && opt.utf8 == 0) {
-		char * p = opt.iocharset ? opt.iocharset : CONFIG_NLS_DEFAULT;
+		char *p = opt.iocharset ? opt.iocharset : CONFIG_NLS_DEFAULT;
 		sbi->s_nls_iocharset = load_nls(p);
 		if (! sbi->s_nls_iocharset) {
 			/* Fail only if explicit charset specified */
@@ -821,7 +825,7 @@ root_found:
 		sbi->s_rock = 0;
 		if (sbi->s_firstdatazone != first_data_zone) {
 			sbi->s_firstdatazone = first_data_zone;
-			printk(KERN_DEBUG 
+			printk(KERN_DEBUG
 				"ISOFS: changing to secondary root\n");
 			iput(inode);
 			inode = isofs_iget(s, sbi->s_firstdatazone, 0);
@@ -830,8 +834,10 @@ root_found:
 
 	if (opt.check == 'u') {
 		/* Only Joliet is case insensitive by default */
-		if (joliet_level) opt.check = 'r';
-		else opt.check = 's';
+		if (joliet_level)
+			opt.check = 'r';
+		else
+			opt.check = 's';
 	}
 	sbi->s_joliet_level = joliet_level;
 
@@ -846,8 +852,10 @@ root_found:
 		goto out_no_root;
 
 	table = 0;
-	if (joliet_level) table += 2;
-	if (opt.check == 'r') table++;
+	if (joliet_level)
+		table += 2;
+	if (opt.check == 'r')
+		table++;
 	s->s_root->d_op = &isofs_dentry_ops[table];
 
 	kfree(opt.iocharset);
@@ -858,10 +866,10 @@ root_found:
 	 * Display error messages and free resources.
 	 */
 out_bad_root:
-	printk(KERN_WARNING "isofs_fill_super: root inode not initialized\n");
+	printk(KERN_WARNING "%s: root inode not initialized\n", __func__);
 	goto out_iput;
 out_no_root:
-	printk(KERN_WARNING "isofs_fill_super: get root inode failed\n");
+	printk(KERN_WARNING "%s: get root inode failed\n", __func__);
 out_iput:
 	iput(inode);
 #ifdef CONFIG_JOLIET
@@ -870,21 +878,20 @@ out_iput:
 #endif
 	goto out_freesbi;
 out_no_read:
-	printk(KERN_WARNING "isofs_fill_super: "
-		"bread failed, dev=%s, iso_blknum=%d, block=%d\n",
-		s->s_id, iso_blknum, block);
+	printk(KERN_WARNING "%s: bread failed, dev=%s, iso_blknum=%d, block=%d\n",
+		__func__, s->s_id, iso_blknum, block);
 	goto out_freesbi;
 out_bad_zone_size:
-	printk(KERN_WARNING "Bad logical zone size %ld\n",
+	printk(KERN_WARNING "ISOFS: Bad logical zone size %ld\n",
 		sbi->s_log_zone_size);
 	goto out_freebh;
 out_bad_size:
-	printk(KERN_WARNING "Logical zone size(%d) < hardware blocksize(%u)\n",
+	printk(KERN_WARNING "ISOFS: Logical zone size(%d) < hardware blocksize(%u)\n",
 		orig_zonesize, opt.blocksize);
 	goto out_freebh;
 out_unknown_format:
 	if (!silent)
-		printk(KERN_WARNING "Unable to identify CD-ROM format.\n");
+		printk(KERN_WARNING "ISOFS: Unable to identify CD-ROM format.\n");
 
 out_freebh:
 	brelse(bh);
@@ -902,7 +909,7 @@ static int isofs_statfs (struct dentry *
 	buf->f_type = ISOFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = (ISOFS_SB(sb)->s_nzones
-                  << (ISOFS_SB(sb)->s_log_zone_size - sb->s_blocksize_bits));
+		<< (ISOFS_SB(sb)->s_log_zone_size - sb->s_blocksize_bits));
 	buf->f_bfree = 0;
 	buf->f_bavail = 0;
 	buf->f_files = ISOFS_SB(sb)->s_ninodes;
@@ -931,20 +938,20 @@ int isofs_get_blocks(struct inode *inode
 
 	rv = 0;
 	if (iblock < 0 || iblock != iblock_s) {
-		printk("isofs_get_blocks: block number too large\n");
+		printk(KERN_DEBUG "%s: block number too large\n", __func__);
 		goto abort;
 	}
 
 	b_off = iblock;
-	
-	offset    = 0;
-	firstext  = ei->i_first_extent;
+
+	offset = 0;
+	firstext = ei->i_first_extent;
 	sect_size = ei->i_section_size >> ISOFS_BUFFER_BITS(inode);
-	nextblk   = ei->i_next_section_block;
-	nextoff   = ei->i_next_section_offset;
-	section   = 0;
+	nextblk = ei->i_next_section_block;
+	nextoff = ei->i_next_section_offset;
+	section = 0;
 
-	while ( nblocks ) {
+	while (nblocks) {
 		/* If we are *way* beyond the end of the file, print a message.
 		 * Access beyond the end of the file up to the next page boundary
 		 * is normal, however because of the way the page cache works.
@@ -953,11 +960,11 @@ int isofs_get_blocks(struct inode *inode
 		 * I/O errors.
 		 */
 		if (b_off > ((inode->i_size + PAGE_CACHE_SIZE - 1) >> ISOFS_BUFFER_BITS(inode))) {
-			printk("isofs_get_blocks: block >= EOF (%ld, %ld)\n",
-			       iblock, (unsigned long) inode->i_size);
+			printk(KERN_DEBUG "%s: block >= EOF (%ld, %ld)\n",
+				__func__, iblock, (unsigned long) inode->i_size);
 			goto abort;
 		}
-		
+
 		/* On the last section, nextblk == 0, section size is likely to
 		 * exceed sect_size by a partial block, and access beyond the
 		 * end of the file will reach beyond the section size, too.
@@ -976,20 +983,21 @@ int isofs_get_blocks(struct inode *inode
 			iput(ninode);
 
 			if (++section > 100) {
-				printk("isofs_get_blocks: More than 100 file sections ?!?, aborting...\n");
-				printk("isofs_get_blocks: block=%ld firstext=%u sect_size=%u "
-				       "nextblk=%lu nextoff=%lu\n",
-				       iblock, firstext, (unsigned) sect_size,
-				       nextblk, nextoff);
+				printk(KERN_DEBUG "%s: More than 100 file sections ?!?"
+					" aborting...\n", __func__);
+				printk(KERN_DEBUG "%s: block=%ld firstext=%u sect_size=%u "
+					"nextblk=%lu nextoff=%lu\n", __func__,
+					iblock, firstext, (unsigned) sect_size,
+					nextblk, nextoff);
 				goto abort;
 			}
 		}
-		
-		if ( *bh ) {
+
+		if (*bh) {
 			map_bh(*bh, inode->i_sb, firstext + b_off - offset);
 		} else {
 			*bh = sb_getblk(inode->i_sb, firstext+b_off-offset);
-			if ( !*bh )
+			if (!*bh)
 				goto abort;
 		}
 		bh++;	/* Next buffer head */
@@ -1010,7 +1018,7 @@ static int isofs_get_block(struct inode 
 		    struct buffer_head *bh_result, int create)
 {
 	if (create) {
-		printk("isofs_get_block: Kernel tries to allocate a block\n");
+		printk(KERN_DEBUG "%s: Kernel tries to allocate a block\n", __func__);
 		return -EROFS;
 	}
 
@@ -1070,11 +1078,11 @@ static int isofs_read_level3_size(struct
 {
 	unsigned long bufsize = ISOFS_BUFFER_SIZE(inode);
 	int high_sierra = ISOFS_SB(inode->i_sb)->s_high_sierra;
-	struct buffer_head * bh = NULL;
+	struct buffer_head *bh = NULL;
 	unsigned long block, offset, block_saved, offset_saved;
 	int i = 0;
 	int more_entries = 0;
-	struct iso_directory_record * tmpde = NULL;
+	struct iso_directory_record *tmpde = NULL;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
 	inode->i_size = 0;
@@ -1089,7 +1097,7 @@ static int isofs_read_level3_size(struct
 	offset = ei->i_iget5_offset;
 
 	do {
-		struct iso_directory_record * de;
+		struct iso_directory_record *de;
 		unsigned int de_len;
 
 		if (!bh) {
@@ -1163,10 +1171,9 @@ out_noread:
 	return -EIO;
 
 out_toomany:
-	printk(KERN_INFO "isofs_read_level3_size: "
-		"More than 100 file sections ?!?, aborting...\n"
-	  	"isofs_read_level3_size: inode=%lu\n",
-		inode->i_ino);
+	printk(KERN_INFO "%s: More than 100 file sections ?!?, aborting...\n"
+		"isofs_read_level3_size: inode=%lu\n",
+		__func__, inode->i_ino);
 	goto out;
 }
 
@@ -1177,9 +1184,9 @@ static void isofs_read_inode(struct inod
 	unsigned long bufsize = ISOFS_BUFFER_SIZE(inode);
 	unsigned long block;
 	int high_sierra = sbi->s_high_sierra;
-	struct buffer_head * bh = NULL;
-	struct iso_directory_record * de;
-	struct iso_directory_record * tmpde = NULL;
+	struct buffer_head *bh = NULL;
+	struct iso_directory_record *de;
+	struct iso_directory_record *tmpde = NULL;
 	unsigned int de_len;
 	unsigned long offset;
 	struct iso_inode_info *ei = ISOFS_I(inode);
@@ -1199,7 +1206,7 @@ static void isofs_read_inode(struct inod
 
 		tmpde = kmalloc(de_len, GFP_KERNEL);
 		if (tmpde == NULL) {
-			printk(KERN_INFO "isofs_read_inode: out of memory\n");
+			printk(KERN_INFO "%s: out of memory\n", __func__);
 			goto fail;
 		}
 		memcpy(tmpde, bh->b_data + offset, frag1);
@@ -1212,24 +1219,26 @@ static void isofs_read_inode(struct inod
 	}
 
 	inode->i_ino = isofs_get_ino(ei->i_iget5_block,
-				     ei->i_iget5_offset,
-				     ISOFS_BUFFER_BITS(inode));
+					ei->i_iget5_offset,
+					ISOFS_BUFFER_BITS(inode));
 
 	/* Assume it is a normal-format file unless told otherwise */
 	ei->i_file_format = isofs_file_normal;
 
 	if (de->flags[-high_sierra] & 2) {
 		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
-		inode->i_nlink = 1; /* Set to 1.  We know there are 2, but
-				       the find utility tries to optimize
-				       if it is 2, and it screws up.  It is
-				       easier to give 1 which tells find to
-				       do it the hard way. */
+		inode->i_nlink = 1;	/*
+					 * Set to 1.  We know there are 2, but
+					 * the find utility tries to optimize
+					 * if it is 2, and it screws up.  It is
+					 * easier to give 1 which tells find to
+					 * do it the hard way.
+					 */
 	} else {
- 		/* Everybody gets to read the file. */
+		/* Everybody gets to read the file. */
 		inode->i_mode = sbi->s_mode;
 		inode->i_nlink = 1;
-	        inode->i_mode |= S_IFREG;
+		inode->i_mode |= S_IFREG;
 	}
 	inode->i_uid = sbi->s_uid;
 	inode->i_gid = sbi->s_gid;
@@ -1239,13 +1248,14 @@ static void isofs_read_inode(struct inod
 	ei->i_format_parm[1] = 0;
 	ei->i_format_parm[2] = 0;
 
-	ei->i_section_size = isonum_733 (de->size);
+	ei->i_section_size = isonum_733(de->size);
 	if (de->flags[-high_sierra] & 0x80) {
-		if(isofs_read_level3_size(inode)) goto fail;
+		if(isofs_read_level3_size(inode))
+			goto fail;
 	} else {
 		ei->i_next_section_block = 0;
 		ei->i_next_section_offset = 0;
-		inode->i_size = isonum_733 (de->size);
+		inode->i_size = isonum_733(de->size);
 	}
 
 	/*
@@ -1258,23 +1268,24 @@ static void isofs_read_inode(struct inod
 		inode->i_size &= 0x00ffffff;
 
 	if (de->interleave[0]) {
-		printk("Interleaved files not (yet) supported.\n");
+		printk(KERN_DEBUG "ISOFS: Interleaved files not (yet) supported.\n");
 		inode->i_size = 0;
 	}
 
 	/* I have no idea what file_unit_size is used for, so
 	   we will flag it for now */
 	if (de->file_unit_size[0] != 0) {
-		printk("File unit size != 0 for ISO file (%ld).\n",
-		       inode->i_ino);
+		printk(KERN_DEBUG "ISOFS: File unit size != 0 for ISO file (%ld).\n",
+			inode->i_ino);
 	}
 
 	/* I have no idea what other flag bits are used for, so
 	   we will flag it for now */
 #ifdef DEBUG
 	if((de->flags[-high_sierra] & ~2)!= 0){
-		printk("Unusual flag settings for ISO file (%ld %x).\n",
-		       inode->i_ino, de->flags[-high_sierra]);
+		printk(KERN_DEBUG "ISOFS: Unusual flag settings for ISO file "
+				"(%ld %x).\n",
+			inode->i_ino, de->flags[-high_sierra]);
 	}
 #endif
 
@@ -1285,11 +1296,11 @@ static void isofs_read_inode(struct inod
 	inode->i_atime.tv_nsec =
 	inode->i_ctime.tv_nsec = 0;
 
-	ei->i_first_extent = (isonum_733 (de->extent) +
-			      isonum_711 (de->ext_attr_length));
+	ei->i_first_extent = (isonum_733(de->extent) +
+			isonum_711(de->ext_attr_length));
 
 	/* Set the number of blocks for stat() - should be done before RR */
-	inode->i_blocks  = (inode->i_size + 511) >> 9;
+	inode->i_blocks = (inode->i_size + 511) >> 9;
 
 	/*
 	 * Now test for possible Rock Ridge extensions which will override
@@ -1306,7 +1317,7 @@ static void isofs_read_inode(struct inod
 	/* Install the inode operations vector */
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_fop = &generic_ro_fops;
-		switch ( ei->i_file_format ) {
+		switch (ei->i_file_format) {
 #ifdef CONFIG_ZISOFS
 		case isofs_file_compressed:
 			inode->i_data.a_ops = &zisofs_aops;
@@ -1350,7 +1361,7 @@ static int isofs_iget5_test(struct inode
 	struct isofs_iget5_callback_data *d =
 		(struct isofs_iget5_callback_data*)data;
 	return (i->i_iget5_block == d->block)
-	       && (i->i_iget5_offset == d->offset);
+		&& (i->i_iget5_offset == d->offset);
 }
 
 static int isofs_iget5_set(struct inode *ino, void *data)
@@ -1384,7 +1395,7 @@ struct inode *isofs_iget(struct super_bl
 	hashval = (block << sb->s_blocksize_bits) | offset;
 
 	inode = iget5_locked(sb, hashval, &isofs_iget5_test,
-			     &isofs_iget5_set, &data);
+				&isofs_iget5_set, &data);
 
 	if (inode && (inode->i_state & I_NEW)) {
 		sb->s_op->read_inode(inode);
@@ -1398,7 +1409,7 @@ static int isofs_get_sb(struct file_syst
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	return get_sb_bdev(fs_type, flags, dev_name, data, isofs_fill_super,
-			   mnt);
+				mnt);
 }
 
 static struct file_system_type iso9660_fs_type = {
diff -puN fs/isofs/joliet.c~fix-up-codingstyle-in-isofs fs/isofs/joliet.c
--- a/fs/isofs/joliet.c~fix-up-codingstyle-in-isofs
+++ a/fs/isofs/joliet.c
@@ -80,22 +80,20 @@ get_joliet_filename(struct iso_directory
 
 	if (utf8) {
 		len = wcsntombs_be(outname, de->name,
-				   de->name_len[0] >> 1, PAGE_SIZE);
+				de->name_len[0] >> 1, PAGE_SIZE);
 	} else {
 		len = uni16_to_x8(outname, (__be16 *) de->name,
-				  de->name_len[0] >> 1, nls);
+				de->name_len[0] >> 1, nls);
 	}
-	if ((len > 2) && (outname[len-2] == ';') && (outname[len-1] == '1')) {
+	if ((len > 2) && (outname[len-2] == ';') && (outname[len-1] == '1'))
 		len -= 2;
-	}
 
 	/*
 	 * Windows doesn't like periods at the end of a name,
 	 * so neither do we
 	 */
-	while (len >= 2 && (outname[len-1] == '.')) {
+	while (len >= 2 && (outname[len-1] == '.'))
 		len--;
-	}
 
 	return len;
 }
diff -puN fs/isofs/namei.c~fix-up-codingstyle-in-isofs fs/isofs/namei.c
--- a/fs/isofs/namei.c~fix-up-codingstyle-in-isofs
+++ a/fs/isofs/namei.c
@@ -15,7 +15,7 @@
  * some sanity tests.
  */
 static int
-isofs_cmp(struct dentry * dentry, const char * compare, int dlen)
+isofs_cmp(struct dentry *dentry, const char *compare, int dlen)
 {
 	struct qstr qstr;
 
@@ -48,24 +48,24 @@ isofs_cmp(struct dentry * dentry, const 
  */
 static unsigned long
 isofs_find_entry(struct inode *dir, struct dentry *dentry,
-	unsigned long *block_rv, unsigned long* offset_rv,
-	char * tmpname, struct iso_directory_record * tmpde)
+	unsigned long *block_rv, unsigned long *offset_rv,
+	char *tmpname, struct iso_directory_record *tmpde)
 {
 	unsigned long bufsize = ISOFS_BUFFER_SIZE(dir);
 	unsigned char bufbits = ISOFS_BUFFER_BITS(dir);
 	unsigned long block, f_pos, offset, block_saved, offset_saved;
-	struct buffer_head * bh = NULL;
+	struct buffer_head *bh = NULL;
 	struct isofs_sb_info *sbi = ISOFS_SB(dir->i_sb);
 
 	if (!ISOFS_I(dir)->i_first_extent)
 		return 0;
-  
+
 	f_pos = 0;
 	offset = 0;
 	block = 0;
 
 	while (f_pos < dir->i_size) {
-		struct iso_directory_record * de;
+		struct iso_directory_record *de;
 		int de_len, match, i, dlen;
 		char *dpnt;
 
@@ -114,7 +114,7 @@ isofs_find_entry(struct inode *dir, stru
 
 		if (sbi->s_rock &&
 		    ((i = get_rock_ridge_filename(de, tmpname, dir)))) {
-			dlen = i; 	/* possibly -1 */
+			dlen = i;	/* possibly -1 */
 			dpnt = tmpname;
 #ifdef CONFIG_JOLIET
 		} else if (sbi->s_joliet_level) {
@@ -145,8 +145,8 @@ isofs_find_entry(struct inode *dir, stru
 			isofs_normalize_block_and_offset(de,
 							 &block_saved,
 							 &offset_saved);
-                        *block_rv = block_saved;
-                        *offset_rv = offset_saved;
+			*block_rv = block_saved;
+			*offset_rv = offset_saved;
 			brelse(bh);
 			return 1;
 		}
@@ -155,7 +155,7 @@ isofs_find_entry(struct inode *dir, stru
 	return 0;
 }
 
-struct dentry *isofs_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	int found;
 	unsigned long block, offset;
@@ -170,9 +170,9 @@ struct dentry *isofs_lookup(struct inode
 
 	lock_kernel();
 	found = isofs_find_entry(dir, dentry,
-				 &block, &offset,
-				 page_address(page),
-				 1024 + page_address(page));
+				&block, &offset,
+				page_address(page),
+				1024 + page_address(page));
 	__free_page(page);
 
 	inode = NULL;
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
fix-empty-macros-in-acpi.patch
git-alsa.patch
i386-remove-support-for-the-rise-cpu.patch
slow-down-printk-during-boot.patch
