From: akpm@linux-foundation.org
Subject: + fs-hpfs-convert-printk-to-pr_foo.patch added to -mm tree
Date: Thu, 15 May 2014 12:56:08 -0700
Message-ID: <53751bd8.V0IVWr0/wIV8Ev8B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaEOT4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 15:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mikulas@artax.karlin.mff.cuni.cz, fabf@skynet.be

Subject: + fs-hpfs-convert-printk-to-pr_foo.patch added to -mm tree
To: fabf@skynet.be,mikulas@artax.karlin.mff.cuni.cz
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 12:56:08 -0700


The patch titled
     Subject: fs/hpfs: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     fs-hpfs-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hpfs-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hpfs-convert-printk-to-pr_foo.patch

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
Subject: fs/hpfs: convert printk to pr_foo()

No level printk in hptfs_error converted to pr_err (others to pr_warn or
pr_info)

This patch also fixes if/then/else checkpatch warnings

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/alloc.c  |    2 -
 fs/hpfs/buffer.c |   12 ++++-----
 fs/hpfs/dir.c    |    6 ++--
 fs/hpfs/dnode.c  |   42 ++++++++++++++++++++--------------
 fs/hpfs/ea.c     |    6 ++--
 fs/hpfs/inode.c  |    3 +-
 fs/hpfs/map.c    |   17 ++++++++-----
 fs/hpfs/name.c   |   11 ++++-----
 fs/hpfs/namei.c  |    2 -
 fs/hpfs/super.c  |   55 ++++++++++++++++++++++++++-------------------
 10 files changed, 89 insertions(+), 67 deletions(-)

diff -puN fs/hpfs/alloc.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/alloc.c
--- a/fs/hpfs/alloc.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/alloc.c
@@ -316,7 +316,7 @@ void hpfs_free_sectors(struct super_bloc
 	struct quad_buffer_head qbh;
 	__le32 *bmp;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
-	/*printk("2 - ");*/
+	/*pr_info("2 - ");*/
 	if (!n) return;
 	if (sec < 0x12) {
 		hpfs_error(s, "Trying to free reserved sector %08x", sec);
diff -puN fs/hpfs/buffer.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/buffer.c
--- a/fs/hpfs/buffer.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/buffer.c
@@ -55,7 +55,7 @@ void *hpfs_map_sector(struct super_block
 	if (bh != NULL)
 		return bh->b_data;
 	else {
-		printk("HPFS: hpfs_map_sector: read error\n");
+		pr_warn("HPFS: hpfs_map_sector: read error\n");
 		return NULL;
 	}
 }
@@ -76,7 +76,7 @@ void *hpfs_get_sector(struct super_block
 		set_buffer_uptodate(bh);
 		return bh->b_data;
 	} else {
-		printk("HPFS: hpfs_get_sector: getblk failed\n");
+		pr_warn("HPFS: hpfs_get_sector: getblk failed\n");
 		return NULL;
 	}
 }
@@ -93,7 +93,7 @@ void *hpfs_map_4sectors(struct super_blo
 	cond_resched();
 
 	if (secno & 3) {
-		printk("HPFS: hpfs_map_4sectors: unaligned read\n");
+		pr_warn("HPFS: hpfs_map_4sectors: unaligned read\n");
 		return NULL;
 	}
 
@@ -112,7 +112,7 @@ void *hpfs_map_4sectors(struct super_blo
 
 	qbh->data = data = kmalloc(2048, GFP_NOFS);
 	if (!data) {
-		printk("HPFS: hpfs_map_4sectors: out of memory\n");
+		pr_warn("HPFS: hpfs_map_4sectors: out of memory\n");
 		goto bail4;
 	}
 
@@ -145,7 +145,7 @@ void *hpfs_get_4sectors(struct super_blo
 	hpfs_lock_assert(s);
 
 	if (secno & 3) {
-		printk("HPFS: hpfs_get_4sectors: unaligned read\n");
+		pr_warn("HPFS: hpfs_get_4sectors: unaligned read\n");
 		return NULL;
 	}
 
@@ -161,7 +161,7 @@ void *hpfs_get_4sectors(struct super_blo
 	}
 
 	if (!(qbh->data = kmalloc(2048, GFP_NOFS))) {
-		printk("HPFS: hpfs_get_4sectors: out of memory\n");
+		pr_warn("HPFS: hpfs_get_4sectors: out of memory\n");
 		goto bail4;
 	}
 	return qbh->data;
diff -puN fs/hpfs/dir.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/dir.c
--- a/fs/hpfs/dir.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/dir.c
@@ -36,7 +36,7 @@ static loff_t hpfs_dir_lseek(struct file
 	mutex_lock(&i->i_mutex);
 	hpfs_lock(s);
 
-	/*printk("dir lseek\n");*/
+	/*pr_info("dir lseek\n");*/
 	if (new_off == 0 || new_off == 1 || new_off == 11 || new_off == 12 || new_off == 13) goto ok;
 	pos = ((loff_t) hpfs_de_as_down_as_possible(s, hpfs_inode->i_dno) << 4) + 1;
 	while (pos != new_off) {
@@ -51,7 +51,7 @@ ok:
 	mutex_unlock(&i->i_mutex);
 	return new_off;
 fail:
-	/*printk("illegal lseek: %016llx\n", new_off);*/
+	/*pr_warn("illegal lseek: %016llx\n", new_off);*/
 	hpfs_unlock(s);
 	mutex_unlock(&i->i_mutex);
 	return -ESPIPE;
@@ -127,7 +127,7 @@ static int hpfs_readdir(struct file *fil
 		if (ctx->pos == 12)
 			goto out;
 		if (ctx->pos == 3 || ctx->pos == 4 || ctx->pos == 5) {
-			printk("HPFS: warning: pos==%d\n",(int)ctx->pos);
+			pr_warn("HPFS: warning: pos==%d\n", (int)ctx->pos);
 			goto out;
 		}
 		if (ctx->pos == 0) {
diff -puN fs/hpfs/dnode.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/dnode.c
--- a/fs/hpfs/dnode.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/dnode.c
@@ -17,7 +17,7 @@ static loff_t get_pos(struct dnode *d, s
 		if (de == fde) return ((loff_t) le32_to_cpu(d->self) << 4) | (loff_t)i;
 		i++;
 	}
-	printk("HPFS: get_pos: not_found\n");
+	pr_info("HPFS: get_pos: not_found\n");
 	return ((loff_t)le32_to_cpu(d->self) << 4) | (loff_t)1;
 }
 
@@ -32,7 +32,7 @@ void hpfs_add_pos(struct inode *inode, l
 			if (hpfs_inode->i_rddir_off[i] == pos) return;
 	if (!(i&0x0f)) {
 		if (!(ppos = kmalloc((i+0x11) * sizeof(loff_t*), GFP_NOFS))) {
-			printk("HPFS: out of memory for position list\n");
+			pr_warn("HPFS: out of memory for position list\n");
 			return;
 		}
 		if (hpfs_inode->i_rddir_off) {
@@ -63,7 +63,8 @@ void hpfs_del_pos(struct inode *inode, l
 	}
 	return;
 	not_f:
-	/*printk("HPFS: warning: position pointer %p->%08x not found\n", pos, (int)*pos);*/
+	/*pr_info("HPFS: warning: position pointer %p->%08x not found\n",
+		  pos, (int)*pos);*/
 	return;
 }
 
@@ -92,8 +93,11 @@ static void hpfs_pos_ins(loff_t *p, loff
 {
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) + c;
-		if (n > 0x3f) printk("HPFS: hpfs_pos_ins: %08x + %d\n", (int)*p, (int)c >> 8);
-		else *p = (*p & ~0x3f) | n;
+		if (n > 0x3f)
+			pr_warn("HPFS: hpfs_pos_ins: %08x + %d\n",
+				(int)*p, (int)c >> 8);
+		else
+			*p = (*p & ~0x3f) | n;
 	}
 }
 
@@ -101,8 +105,11 @@ static void hpfs_pos_del(loff_t *p, loff
 {
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) - c;
-		if (n < 1) printk("HPFS: hpfs_pos_ins: %08x - %d\n", (int)*p, (int)c >> 8);
-		else *p = (*p & ~0x3f) | n;
+		if (n < 1)
+			pr_warn("HPFS: hpfs_pos_ins: %08x - %d\n",
+				(int)*p, (int)c >> 8);
+		else
+			*p = (*p & ~0x3f) | n;
 	}
 }
 
@@ -239,7 +246,7 @@ static int hpfs_add_to_dnode(struct inod
 	struct fnode *fnode;
 	int c1, c2 = 0;
 	if (!(nname = kmalloc(256, GFP_NOFS))) {
-		printk("HPFS: out of memory, can't add to dnode\n");
+		pr_warn("HPFS: out of memory, can't add to dnode\n");
 		return 1;
 	}
 	go_up:
@@ -281,7 +288,7 @@ static int hpfs_add_to_dnode(struct inod
 		   not be any error while splitting dnodes, otherwise the
 		   whole directory, not only file we're adding, would
 		   be lost. */
-		printk("HPFS: out of memory for dnode splitting\n");
+		pr_warn("HPFS: out of memory for dnode splitting\n");
 		hpfs_brelse4(&qbh);
 		kfree(nname);
 		return 1;
@@ -597,7 +604,7 @@ static void delete_empty_dnode(struct in
 		if (!de_next->down) goto endm;
 		ndown = de_down_pointer(de_next);
 		if (!(de_cp = kmalloc(le16_to_cpu(de->length), GFP_NOFS))) {
-			printk("HPFS: out of memory for dtree balancing\n");
+			pr_warn("HPFS: out of memory for dtree balancing\n");
 			goto endm;
 		}
 		memcpy(de_cp, de, le16_to_cpu(de->length));
@@ -612,7 +619,8 @@ static void delete_empty_dnode(struct in
 			hpfs_brelse4(&qbh1);
 		}
 		hpfs_add_to_dnode(i, ndown, de_cp->name, de_cp->namelen, de_cp, de_cp->down ? de_down_pointer(de_cp) : 0);
-		/*printk("UP-TO-DNODE: %08x (ndown = %08x, down = %08x, dno = %08x)\n", up, ndown, down, dno);*/
+		/*pr_info("UP-TO-DNODE: %08x (ndown = %08x, down = %08x, dno = %08x)\n",
+		  up, ndown, down, dno);*/
 		dno = up;
 		kfree(de_cp);
 		goto try_it_again;
@@ -637,15 +645,15 @@ static void delete_empty_dnode(struct in
 			if (!dlp && down) {
 				if (le32_to_cpu(d1->first_free) > 2044) {
 					if (hpfs_sb(i->i_sb)->sb_chk >= 2) {
-						printk("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
-						printk("HPFS: warning: terminating balancing operation\n");
+						pr_warn("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
+						pr_warn("HPFS: warning: terminating balancing operation\n");
 					}
 					hpfs_brelse4(&qbh1);
 					goto endm;
 				}
 				if (hpfs_sb(i->i_sb)->sb_chk >= 2) {
-					printk("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
-					printk("HPFS: warning: goin'on\n");
+					pr_warn("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
+					pr_warn("HPFS: warning: goin'on\n");
 				}
 				le16_add_cpu(&del->length, 4);
 				del->down = 1;
@@ -659,7 +667,7 @@ static void delete_empty_dnode(struct in
 				*(__le32 *) ((void *) del + le16_to_cpu(del->length) - 4) = cpu_to_le32(down);
 		} else goto endm;
 		if (!(de_cp = kmalloc(le16_to_cpu(de_prev->length), GFP_NOFS))) {
-			printk("HPFS: out of memory for dtree balancing\n");
+			pr_warn("HPFS: out of memory for dtree balancing\n");
 			hpfs_brelse4(&qbh1);
 			goto endm;
 		}
@@ -1000,7 +1008,7 @@ struct hpfs_dirent *map_fnode_dirent(str
 	int d1, d2 = 0;
 	name1 = f->name;
 	if (!(name2 = kmalloc(256, GFP_NOFS))) {
-		printk("HPFS: out of memory, can't map dirent\n");
+		pr_warn("HPFS: out of memory, can't map dirent\n");
 		return NULL;
 	}
 	if (f->len <= 15)
diff -puN fs/hpfs/ea.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/ea.c
--- a/fs/hpfs/ea.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/ea.c
@@ -51,7 +51,7 @@ static char *get_indirect_ea(struct supe
 {
 	char *ret;
 	if (!(ret = kmalloc(size + 1, GFP_NOFS))) {
-		printk("HPFS: out of memory for EA\n");
+		pr_warn("HPFS: out of memory for EA\n");
 		return NULL;
 	}
 	if (hpfs_ea_read(s, a, ano, 0, size, ret)) {
@@ -139,7 +139,7 @@ char *hpfs_get_ea(struct super_block *s,
 			if (ea_indirect(ea))
 				return get_indirect_ea(s, ea_in_anode(ea), ea_sec(ea), *size = ea_len(ea));
 			if (!(ret = kmalloc((*size = ea_valuelen(ea)) + 1, GFP_NOFS))) {
-				printk("HPFS: out of memory for EA\n");
+				pr_warn("HPFS: out of memory for EA\n");
 				return NULL;
 			}
 			memcpy(ret, ea_data(ea), ea_valuelen(ea));
@@ -165,7 +165,7 @@ char *hpfs_get_ea(struct super_block *s,
 			if (ea_indirect(ea))
 				return get_indirect_ea(s, ea_in_anode(ea), ea_sec(ea), *size = ea_len(ea));
 			if (!(ret = kmalloc((*size = ea_valuelen(ea)) + 1, GFP_NOFS))) {
-				printk("HPFS: out of memory for EA\n");
+				pr_warn("HPFS: out of memory for EA\n");
 				return NULL;
 			}
 			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, ea_valuelen(ea), ret)) {
diff -puN fs/hpfs/inode.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/inode.c
--- a/fs/hpfs/inode.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/inode.c
@@ -183,7 +183,8 @@ void hpfs_write_inode(struct inode *i)
 	struct inode *parent;
 	if (i->i_ino == hpfs_sb(i->i_sb)->sb_root) return;
 	if (hpfs_inode->i_rddir_off && !atomic_read(&i->i_count)) {
-		if (*hpfs_inode->i_rddir_off) printk("HPFS: write_inode: some position still there\n");
+		if (*hpfs_inode->i_rddir_off)
+			pr_warn("HPFS: write_inode: some position still there\n");
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
 	}
diff -puN fs/hpfs/map.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/map.c
--- a/fs/hpfs/map.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/map.c
@@ -65,12 +65,13 @@ unsigned char *hpfs_load_code_page(struc
 	struct code_page_directory *cp = hpfs_map_sector(s, cps, &bh, 0);
 	if (!cp) return NULL;
 	if (le32_to_cpu(cp->magic) != CP_DIR_MAGIC) {
-		printk("HPFS: Code page directory magic doesn't match (magic = %08x)\n", le32_to_cpu(cp->magic));
+		pr_warn("HPFS: Code page directory magic doesn't match (magic = %08x)\n",
+			le32_to_cpu(cp->magic));
 		brelse(bh);
 		return NULL;
 	}
 	if (!le32_to_cpu(cp->n_code_pages)) {
-		printk("HPFS: n_code_pages == 0\n");
+		pr_warn("HPFS: n_code_pages == 0\n");
 		brelse(bh);
 		return NULL;
 	}
@@ -79,19 +80,19 @@ unsigned char *hpfs_load_code_page(struc
 	brelse(bh);
 
 	if (cpi >= 3) {
-		printk("HPFS: Code page index out of array\n");
+		pr_warn("HPFS: Code page index out of array\n");
 		return NULL;
 	}
 	
 	if (!(cpd = hpfs_map_sector(s, cpds, &bh, 0))) return NULL;
 	if (le16_to_cpu(cpd->offs[cpi]) > 0x178) {
-		printk("HPFS: Code page index out of sector\n");
+		pr_warn("HPFS: Code page index out of sector\n");
 		brelse(bh);
 		return NULL;
 	}
 	ptr = (unsigned char *)cpd + le16_to_cpu(cpd->offs[cpi]) + 6;
 	if (!(cp_table = kmalloc(256, GFP_KERNEL))) {
-		printk("HPFS: out of memory for code page table\n");
+		pr_warn("HPFS: out of memory for code page table\n");
 		brelse(bh);
 		return NULL;
 	}
@@ -114,7 +115,7 @@ __le32 *hpfs_load_bitmap_directory(struc
 	int i;
 	__le32 *b;
 	if (!(b = kmalloc(n * 512, GFP_KERNEL))) {
-		printk("HPFS: can't allocate memory for bitmap directory\n");
+		pr_warn("HPFS: can't allocate memory for bitmap directory\n");
 		return NULL;
 	}	
 	for (i=0;i<n;i++) {
@@ -281,7 +282,9 @@ struct dnode *hpfs_map_dnode(struct supe
 				hpfs_error(s, "dnode %08x does not end with \\377 entry", secno);
 				goto bail;
 			}
-			if (b == 3) printk("HPFS: warning: unbalanced dnode tree, dnode %08x; see hpfs.txt 4 more info\n", secno);
+			if (b == 3)
+				pr_warn("HPFS: warning: unbalanced dnode tree, dnode %08x; see hpfs.txt 4 more info\n",
+					secno);
 		}
 	return dnode;
 	bail:
diff -puN fs/hpfs/name.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/name.c
--- a/fs/hpfs/name.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/name.c
@@ -56,14 +56,15 @@ unsigned char *hpfs_translate_name(struc
 	unsigned char *to;
 	int i;
 	if (hpfs_sb(s)->sb_chk >= 2) if (hpfs_is_name_long(from, len) != lng) {
-		printk("HPFS: Long name flag mismatch - name ");
-		for (i=0; i<len; i++) printk("%c", from[i]);
-		printk(" misidentified as %s.\n", lng ? "short" : "long");
-		printk("HPFS: It's nothing serious. It could happen because of bug in OS/2.\nHPFS: Set checks=normal to disable this message.\n");
+		pr_warn("HPFS: Long name flag mismatch - name ");
+		for (i = 0; i < len; i++)
+			pr_cont("%c", from[i]);
+		pr_cont(" misidentified as %s.\n", lng ? "short" : "long");
+		pr_warn("HPFS: It's nothing serious. It could happen because of bug in OS/2.\nHPFS: Set checks=normal to disable this message.\n");
 	}
 	if (!lc) return from;
 	if (!(to = kmalloc(len, GFP_KERNEL))) {
-		printk("HPFS: can't allocate memory for name conversion buffer\n");
+		pr_warn("HPFS: can't allocate memory for name conversion buffer\n");
 		return from;
 	}
 	for (i = 0; i < len; i++) to[i] = locase(hpfs_sb(s)->sb_cp_table,from[i]);
diff -puN fs/hpfs/namei.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/namei.c
@@ -404,7 +404,7 @@ again:
 			d_rehash(dentry);
 		} else {
 			struct iattr newattrs;
-			/*printk("HPFS: truncating file before delete.\n");*/
+			/*pr_info("HPFS: truncating file before delete.\n");*/
 			newattrs.ia_size = 0;
 			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 			err = notify_change(dentry, &newattrs, NULL);
diff -puN fs/hpfs/super.c~fs-hpfs-convert-printk-to-pr_foo fs/hpfs/super.c
--- a/fs/hpfs/super.c~fs-hpfs-convert-printk-to-pr_foo
+++ a/fs/hpfs/super.c
@@ -62,22 +62,26 @@ void hpfs_error(struct super_block *s, c
 	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
 	va_end(args);
 
-	printk("HPFS: filesystem error: %s", err_buf);
+	pr_err("HPFS: filesystem error: %s", err_buf);
 	if (!hpfs_sb(s)->sb_was_error) {
 		if (hpfs_sb(s)->sb_err == 2) {
-			printk("; crashing the system because you wanted it\n");
+			pr_cont("; crashing the system because you wanted it\n");
 			mark_dirty(s, 0);
 			panic("HPFS panic");
 		} else if (hpfs_sb(s)->sb_err == 1) {
-			if (s->s_flags & MS_RDONLY) printk("; already mounted read-only\n");
+			if (s->s_flags & MS_RDONLY)
+				pr_cont("; already mounted read-only\n");
 			else {
-				printk("; remounting read-only\n");
+				pr_cont("; remounting read-only\n");
 				mark_dirty(s, 0);
 				s->s_flags |= MS_RDONLY;
 			}
-		} else if (s->s_flags & MS_RDONLY) printk("; going on - but anything won't be destroyed because it's read-only\n");
-		else printk("; corrupted filesystem mounted read/write - your computer will explode within 20 seconds ... but you wanted it so!\n");
-	} else printk("\n");
+		} else if (s->s_flags & MS_RDONLY)
+				pr_cont("; going on - but anything won't be destroyed because it's read-only\n");
+		else
+			pr_cont("; corrupted filesystem mounted read/write - your computer will explode within 20 seconds ... but you wanted it so!\n");
+	} else
+		pr_cont("\n");
 	hpfs_sb(s)->sb_was_error = 1;
 }
 
@@ -292,7 +296,7 @@ static int parse_opts(char *opts, kuid_t
 	if (!opts)
 		return 1;
 
-	/*printk("Parsing opts: '%s'\n",opts);*/
+	/*pr_info("Parsing opts: '%s'\n",opts);*/
 
 	while ((p = strsep(&opts, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -387,7 +391,7 @@ static int parse_opts(char *opts, kuid_t
 
 static inline void hpfs_help(void)
 {
-	printk("\n\
+	pr_info("\n\
 HPFS filesystem options:\n\
       help              do not mount and display this text\n\
       uid=xxx           set uid of files that don't have uid specified in eas\n\
@@ -434,7 +438,7 @@ static int hpfs_remount_fs(struct super_
 
 	if (!(o = parse_opts(data, &uid, &gid, &umask, &lowercase,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
-		printk("HPFS: bad mount options.\n");
+		pr_warn("HPFS: bad mount options.\n");
 		goto out_err;
 	}
 	if (o == 2) {
@@ -442,7 +446,7 @@ static int hpfs_remount_fs(struct super_
 		goto out_err;
 	}
 	if (timeshift != sbi->sb_timeshift) {
-		printk("HPFS: timeshift can't be changed using remount.\n");
+		pr_warn("HPFS: timeshift can't be changed using remount.\n");
 		goto out_err;
 	}
 
@@ -523,7 +527,7 @@ static int hpfs_fill_super(struct super_
 
 	if (!(o = parse_opts(options, &uid, &gid, &umask, &lowercase,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
-		printk("HPFS: bad mount options.\n");
+		pr_warn("HPFS: bad mount options.\n");
 		goto bail0;
 	}
 	if (o==2) {
@@ -542,16 +546,17 @@ static int hpfs_fill_super(struct super_
 	if (/*le16_to_cpu(bootblock->magic) != BB_MAGIC
 	    ||*/ le32_to_cpu(superblock->magic) != SB_MAGIC
 	    || le32_to_cpu(spareblock->magic) != SP_MAGIC) {
-		if (!silent) printk("HPFS: Bad magic ... probably not HPFS\n");
+		if (!silent)
+			pr_warn("HPFS: Bad magic ... probably not HPFS\n");
 		goto bail4;
 	}
 
 	/* Check version */
 	if (!(s->s_flags & MS_RDONLY) &&
 	      superblock->funcversion != 2 && superblock->funcversion != 3) {
-		printk("HPFS: Bad version %d,%d. Mount readonly to go around\n",
+		pr_warn("HPFS: Bad version %d,%d. Mount readonly to go around\n",
 			(int)superblock->version, (int)superblock->funcversion);
-		printk("HPFS: please try recent version of HPFS driver at http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi and if it still can't understand this format, contact author - mikulas@artax.karlin.mff.cuni.cz\n");
+		pr_warn("HPFS: please try recent version of HPFS driver at http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi and if it still can't understand this format, contact author - mikulas@artax.karlin.mff.cuni.cz\n");
 		goto bail4;
 	}
 
@@ -597,7 +602,7 @@ static int hpfs_fill_super(struct super_
 	/* Check for general fs errors*/
 	if (spareblock->dirty && !spareblock->old_wrote) {
 		if (errs == 2) {
-			printk("HPFS: Improperly stopped, not mounted\n");
+			pr_warn("HPFS: Improperly stopped, not mounted\n");
 			goto bail4;
 		}
 		hpfs_error(s, "improperly stopped");
@@ -611,22 +616,25 @@ static int hpfs_fill_super(struct super_
 
 	if (spareblock->hotfixes_used || spareblock->n_spares_used) {
 		if (errs >= 2) {
-			printk("HPFS: Hotfixes not supported here, try chkdsk\n");
+			pr_warn("HPFS: Hotfixes not supported here, try chkdsk\n");
 			mark_dirty(s, 0);
 			goto bail4;
 		}
 		hpfs_error(s, "hotfixes not supported here, try chkdsk");
-		if (errs == 0) printk("HPFS: Proceeding, but your filesystem will be probably corrupted by this driver...\n");
-		else printk("HPFS: This driver may read bad files or crash when operating on disk with hotfixes.\n");
+		if (errs == 0)
+			pr_warn("HPFS: Proceeding, but your filesystem will be probably corrupted by this driver...\n");
+		else
+			pr_warn("HPFS: This driver may read bad files or crash when operating on disk with hotfixes.\n");
 	}
 	if (le32_to_cpu(spareblock->n_dnode_spares) != le32_to_cpu(spareblock->n_dnode_spares_free)) {
 		if (errs >= 2) {
-			printk("HPFS: Spare dnodes used, try chkdsk\n");
+			pr_warn("HPFS: Spare dnodes used, try chkdsk\n");
 			mark_dirty(s, 0);
 			goto bail4;
 		}
 		hpfs_error(s, "warning: spare dnodes used, try chkdsk");
-		if (errs == 0) printk("HPFS: Proceeding, but your filesystem could be corrupted if you delete files or directories\n");
+		if (errs == 0)
+			pr_warn("HPFS: Proceeding, but your filesystem could be corrupted if you delete files or directories\n");
 	}
 	if (chk) {
 		unsigned a;
@@ -645,12 +653,13 @@ static int hpfs_fill_super(struct super_
 			goto bail4;
 		}
 		sbi->sb_dirband_size = a;
-	} else printk("HPFS: You really don't want any checks? You are crazy...\n");
+	} else
+		pr_warn("HPFS: You really don't want any checks? You are crazy...\n");
 
 	/* Load code page table */
 	if (le32_to_cpu(spareblock->n_code_pages))
 		if (!(sbi->sb_cp_table = hpfs_load_code_page(s, le32_to_cpu(spareblock->code_page_dir))))
-			printk("HPFS: Warning: code page support is disabled\n");
+			pr_warn("HPFS: Warning: code page support is disabled\n");
 
 	brelse(bh2);
 	brelse(bh1);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
fs-gfs2-bmapc-kernel-doc-warning-fixes.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-time-ntpc-convert-simple_strtol-to-kstrtol.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
fs-configfs-convert-printk-to-pr_foo.patch
fs-configfs-use-pr_fmt.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
fs-add-generic-data-flush-to-fsync.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-efivarfs-superc-use-static-const-for-dentry_operations.patch
fs-exportfs-expfsc-kernel-doc-warning-fixes.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
kernel-utsname_sysctlc-replace-obsolete-__initcall-by-device_initcall.patch
kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
documentation-expand-clarify-debug-documentation.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-efs-convert-printk-to-pr_foo.patch
fs-efs-add-pr_fmt-use-__func__.patch
fs-efs-convert-printkkern_debug-to-pr_debug.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch

