From: akpm@osdl.org
Subject: + ufs2-write-block-allocation-update.patch added to -mm tree
Date: Mon, 29 Jan 2007 16:56:47 -0800
Message-ID: <200701300056.l0U0ulq9004730@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35865 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965380AbXA3A4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 19:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     ufs2 write: block allocation update
has been added to the -mm tree.  Its filename is
     ufs2-write-block-allocation-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs2 write: block allocation update
From: Evgeniy Dushistov <dushistov@mail.ru>

Patch adds ability to work with 64bit metadata, this made by replacing work
with 32bit pointers by inline functions.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/balloc.c          |  197 +++++++++++++++++++++----------------
 fs/ufs/inode.c           |   82 +++++++++------
 fs/ufs/truncate.c        |  139 ++++++++++++++------------
 fs/ufs/util.h            |   57 ++++++++++
 include/linux/ufs_fs.h   |   33 ++++--
 include/linux/ufs_fs_i.h |    2 
 6 files changed, 320 insertions(+), 190 deletions(-)

diff -puN fs/ufs/balloc.c~ufs2-write-block-allocation-update fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs2-write-block-allocation-update
+++ a/fs/ufs/balloc.c
@@ -4,6 +4,8 @@
  * Copyright (C) 1998
  * Daniel Pirkl <daniel.pirkl@email.cz>
  * Charles University, Faculty of Mathematics and Physics
+ *
+ * UFS2 write support Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
 
 #include <linux/fs.h>
@@ -21,38 +23,42 @@
 #include "swab.h"
 #include "util.h"
 
-static unsigned ufs_add_fragments (struct inode *, unsigned, unsigned, unsigned, int *);
-static unsigned ufs_alloc_fragments (struct inode *, unsigned, unsigned, unsigned, int *);
-static unsigned ufs_alloccg_block (struct inode *, struct ufs_cg_private_info *, unsigned, int *);
-static unsigned ufs_bitmap_search (struct super_block *, struct ufs_cg_private_info *, unsigned, unsigned);
+#define INVBLOCK ((u64)-1L)
+
+static u64 ufs_add_fragments(struct inode *, u64, unsigned, unsigned, int *);
+static u64 ufs_alloc_fragments(struct inode *, unsigned, u64, unsigned, int *);
+static u64 ufs_alloccg_block(struct inode *, struct ufs_cg_private_info *, u64, int *);
+static u64 ufs_bitmap_search (struct super_block *, struct ufs_cg_private_info *, u64, unsigned);
 static unsigned char ufs_fragtable_8fpb[], ufs_fragtable_other[];
 static void ufs_clusteracct(struct super_block *, struct ufs_cg_private_info *, unsigned, int);
 
 /*
  * Free 'count' fragments from fragment number 'fragment'
  */
-void ufs_free_fragments(struct inode *inode, unsigned fragment, unsigned count)
+void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
-	unsigned cgno, bit, end_bit, bbase, blkmap, i, blkno, cylno;
+	unsigned cgno, bit, end_bit, bbase, blkmap, i;
+	u64 blkno;
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 	
-	UFSD("ENTER, fragment %u, count %u\n", fragment, count);
+	UFSD("ENTER, fragment %llu, count %u\n",
+	     (unsigned long long)fragment, count);
 	
 	if (ufs_fragnum(fragment) + count > uspi->s_fpg)
 		ufs_error (sb, "ufs_free_fragments", "internal error");
 	
 	lock_super(sb);
 	
-	cgno = ufs_dtog(fragment);
-	bit = ufs_dtogd(fragment);
+	cgno = ufs_dtog(uspi, fragment);
+	bit = ufs_dtogd(uspi, fragment);
 	if (cgno >= uspi->s_ncg) {
 		ufs_panic (sb, "ufs_free_fragments", "freeing blocks are outside device");
 		goto failed;
@@ -101,9 +107,13 @@ void ufs_free_fragments(struct inode *in
 		fs32_add(sb, &ucg->cg_cs.cs_nbfree, 1);
 		uspi->cs_total.cs_nbfree++;
 		fs32_add(sb, &UFS_SB(sb)->fs_cs(cgno).cs_nbfree, 1);
-		cylno = ufs_cbtocylno (bbase);
-		fs16_add(sb, &ubh_cg_blks(ucpi, cylno, ufs_cbtorpos(bbase)), 1);
-		fs32_add(sb, &ubh_cg_blktot(ucpi, cylno), 1);
+		if (uspi->fs_magic != UFS2_MAGIC) {
+			unsigned cylno = ufs_cbtocylno (bbase);
+
+			fs16_add(sb, &ubh_cg_blks(ucpi, cylno,
+						  ufs_cbtorpos(bbase)), 1);
+			fs32_add(sb, &ubh_cg_blktot(ucpi, cylno), 1);
+		}
 	}
 	
 	ubh_mark_buffer_dirty (USPI_UBH(uspi));
@@ -127,24 +137,27 @@ failed:
 /*
  * Free 'count' fragments from fragment number 'fragment' (free whole blocks)
  */
-void ufs_free_blocks(struct inode *inode, unsigned fragment, unsigned count)
+void ufs_free_blocks(struct inode *inode, u64 fragment, unsigned count)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
-	unsigned overflow, cgno, bit, end_bit, blkno, i, cylno;
+	unsigned overflow, cgno, bit, end_bit, i;
+	u64 blkno;
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 
-	UFSD("ENTER, fragment %u, count %u\n", fragment, count);
+	UFSD("ENTER, fragment %llu, count %u\n",
+	     (unsigned long long)fragment, count);
 	
 	if ((fragment & uspi->s_fpbmask) || (count & uspi->s_fpbmask)) {
 		ufs_error (sb, "ufs_free_blocks", "internal error, "
-			"fragment %u, count %u\n", fragment, count);
+			   "fragment %llu, count %u\n",
+			   (unsigned long long)fragment, count);
 		goto failed;
 	}
 
@@ -152,8 +165,8 @@ void ufs_free_blocks(struct inode *inode
 	
 do_more:
 	overflow = 0;
-	cgno = ufs_dtog (fragment);
-	bit = ufs_dtogd (fragment);
+	cgno = ufs_dtog(uspi, fragment);
+	bit = ufs_dtogd(uspi, fragment);
 	if (cgno >= uspi->s_ncg) {
 		ufs_panic (sb, "ufs_free_blocks", "freeing blocks are outside device");
 		goto failed_unlock;
@@ -187,9 +200,14 @@ do_more:
 		fs32_add(sb, &ucg->cg_cs.cs_nbfree, 1);
 		uspi->cs_total.cs_nbfree++;
 		fs32_add(sb, &UFS_SB(sb)->fs_cs(cgno).cs_nbfree, 1);
-		cylno = ufs_cbtocylno(i);
-		fs16_add(sb, &ubh_cg_blks(ucpi, cylno, ufs_cbtorpos(i)), 1);
-		fs32_add(sb, &ubh_cg_blktot(ucpi, cylno), 1);
+
+		if (uspi->fs_magic != UFS2_MAGIC) {
+			unsigned cylno = ufs_cbtocylno(i);
+
+			fs16_add(sb, &ubh_cg_blks(ucpi, cylno,
+						  ufs_cbtorpos(i)), 1);
+			fs32_add(sb, &ubh_cg_blktot(ucpi, cylno), 1);
+		}
 	}
 
 	ubh_mark_buffer_dirty (USPI_UBH(uspi));
@@ -308,15 +326,19 @@ static void ufs_clear_frags(struct inode
 	}
 }
 
-unsigned ufs_new_fragments(struct inode * inode, __fs32 * p, unsigned fragment,
-			   unsigned goal, unsigned count, int * err, struct page *locked_page)
+u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
+			   u64 goal, unsigned count, int *err,
+			   struct page *locked_page)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
-	unsigned cgno, oldcount, newcount, tmp, request, result;
+	unsigned cgno, oldcount, newcount;
+	u64 tmp, request, result;
 	
-	UFSD("ENTER, ino %lu, fragment %u, goal %u, count %u\n", inode->i_ino, fragment, goal, count);
+	UFSD("ENTER, ino %lu, fragment %llu, goal %llu, count %u\n",
+	     inode->i_ino, (unsigned long long)fragment,
+	     (unsigned long long)goal, count);
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -324,11 +346,12 @@ unsigned ufs_new_fragments(struct inode 
 	*err = -ENOSPC;
 
 	lock_super (sb);
-	
-	tmp = fs32_to_cpu(sb, *p);
+	tmp = ufs_data_ptr_to_cpu(sb, p);
+
 	if (count + ufs_fragnum(fragment) > uspi->s_fpb) {
-		ufs_warning (sb, "ufs_new_fragments", "internal warning"
-			" fragment %u, count %u", fragment, count);
+		ufs_warning(sb, "ufs_new_fragments", "internal warning"
+			    " fragment %llu, count %u",
+			    (unsigned long long)fragment, count);
 		count = uspi->s_fpb - ufs_fragnum(fragment); 
 	}
 	oldcount = ufs_fragnum (fragment);
@@ -339,10 +362,12 @@ unsigned ufs_new_fragments(struct inode 
 	 */
 	if (oldcount) {
 		if (!tmp) {
-			ufs_error (sb, "ufs_new_fragments", "internal error, "
-				"fragment %u, tmp %u\n", fragment, tmp);
-			unlock_super (sb);
-			return (unsigned)-1;
+			ufs_error(sb, "ufs_new_fragments", "internal error, "
+				  "fragment %llu, tmp %llu\n",
+				  (unsigned long long)fragment,
+				  (unsigned long long)tmp);
+			unlock_super(sb);
+			return INVBLOCK;
 		}
 		if (fragment < UFS_I(inode)->i_lastfrag) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
@@ -372,7 +397,7 @@ unsigned ufs_new_fragments(struct inode 
 	if (goal == 0) 
 		cgno = ufs_inotocg (inode->i_ino);
 	else
-		cgno = ufs_dtog (goal);
+		cgno = ufs_dtog(uspi, goal);
 	 
 	/*
 	 * allocate new fragment
@@ -380,14 +405,16 @@ unsigned ufs_new_fragments(struct inode 
 	if (oldcount == 0) {
 		result = ufs_alloc_fragments (inode, cgno, goal, count, err);
 		if (result) {
-			*p = cpu_to_fs32(sb, result);
+			ufs_cpu_to_data_ptr(sb, p, result);
 			*err = 0;
-			UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
-			ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
-					locked_page != NULL);
+			UFS_I(inode)->i_lastfrag =
+				max_t(u32, UFS_I(inode)->i_lastfrag,
+				      fragment + count);
+			ufs_clear_frags(inode, result + oldcount,
+					newcount - oldcount, locked_page != NULL);
 		}
 		unlock_super(sb);
-		UFSD("EXIT, result %u\n", result);
+		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
 
@@ -401,7 +428,7 @@ unsigned ufs_new_fragments(struct inode 
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
 		unlock_super(sb);
-		UFSD("EXIT, result %u\n", result);
+		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
 
@@ -433,15 +460,14 @@ unsigned ufs_new_fragments(struct inode 
 				locked_page != NULL);
 		ufs_change_blocknr(inode, fragment - oldcount, oldcount, tmp,
 				   result, locked_page);
-
-		*p = cpu_to_fs32(sb, result);
+		ufs_cpu_to_data_ptr(sb, p, result);
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
 		unlock_super(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
 		ufs_free_fragments (inode, tmp, oldcount);
-		UFSD("EXIT, result %u\n", result);
+		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
 
@@ -450,9 +476,8 @@ unsigned ufs_new_fragments(struct inode 
 	return 0;
 }		
 
-static unsigned
-ufs_add_fragments (struct inode * inode, unsigned fragment,
-		   unsigned oldcount, unsigned newcount, int * err)
+static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
+			     unsigned oldcount, unsigned newcount, int *err)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
@@ -461,14 +486,15 @@ ufs_add_fragments (struct inode * inode,
 	struct ufs_cylinder_group * ucg;
 	unsigned cgno, fragno, fragoff, count, fragsize, i;
 	
-	UFSD("ENTER, fragment %u, oldcount %u, newcount %u\n", fragment, oldcount, newcount);
+	UFSD("ENTER, fragment %llu, oldcount %u, newcount %u\n",
+	     (unsigned long long)fragment, oldcount, newcount);
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first (uspi);
 	count = newcount - oldcount;
 	
-	cgno = ufs_dtog(fragment);
+	cgno = ufs_dtog(uspi, fragment);
 	if (fs32_to_cpu(sb, UFS_SB(sb)->fs_cs(cgno).cs_nffree) < count)
 		return 0;
 	if ((ufs_fragnum (fragment) + newcount) > uspi->s_fpb)
@@ -483,7 +509,7 @@ ufs_add_fragments (struct inode * inode,
 		return 0;
 	}
 
-	fragno = ufs_dtogd (fragment);
+	fragno = ufs_dtogd(uspi, fragment);
 	fragoff = ufs_fragnum (fragno);
 	for (i = oldcount; i < newcount; i++)
 		if (ubh_isclr (UCPI_UBH(ucpi), ucpi->c_freeoff, fragno + i))
@@ -521,7 +547,7 @@ ufs_add_fragments (struct inode * inode,
 	}
 	sb->s_dirt = 1;
 
-	UFSD("EXIT, fragment %u\n", fragment);
+	UFSD("EXIT, fragment %llu\n", (unsigned long long)fragment);
 	
 	return fragment;
 }
@@ -534,17 +560,19 @@ ufs_add_fragments (struct inode * inode,
 		if (fs32_to_cpu(sb, ucg->cg_frsum[k])) \
 			goto cg_found; 
 
-static unsigned ufs_alloc_fragments (struct inode * inode, unsigned cgno,
-	unsigned goal, unsigned count, int * err)
+static u64 ufs_alloc_fragments(struct inode *inode, unsigned cgno,
+			       u64 goal, unsigned count, int *err)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
-	unsigned oldcg, i, j, k, result, allocsize;
+	unsigned oldcg, i, j, k, allocsize;
+	u64 result;
 	
-	UFSD("ENTER, ino %lu, cgno %u, goal %u, count %u\n", inode->i_ino, cgno, goal, count);
+	UFSD("ENTER, ino %lu, cgno %u, goal %llu, count %u\n",
+	     inode->i_ino, cgno, (unsigned long long)goal, count);
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -593,7 +621,7 @@ cg_found:
 
 	if (count == uspi->s_fpb) {
 		result = ufs_alloccg_block (inode, ucpi, goal, err);
-		if (result == (unsigned)-1)
+		if (result == INVBLOCK)
 			return 0;
 		goto succed;
 	}
@@ -604,9 +632,9 @@ cg_found:
 	
 	if (allocsize == uspi->s_fpb) {
 		result = ufs_alloccg_block (inode, ucpi, goal, err);
-		if (result == (unsigned)-1)
+		if (result == INVBLOCK)
 			return 0;
-		goal = ufs_dtogd (result);
+		goal = ufs_dtogd(uspi, result);
 		for (i = count; i < uspi->s_fpb; i++)
 			ubh_setbit (UCPI_UBH(ucpi), ucpi->c_freeoff, goal + i);
 		i = uspi->s_fpb - count;
@@ -620,7 +648,7 @@ cg_found:
 	}
 
 	result = ufs_bitmap_search (sb, ucpi, goal, allocsize);
-	if (result == (unsigned)-1)
+	if (result == INVBLOCK)
 		return 0;
 	if(DQUOT_ALLOC_BLOCK(inode, count)) {
 		*err = -EDQUOT;
@@ -647,20 +675,21 @@ succed:
 	sb->s_dirt = 1;
 
 	result += cgno * uspi->s_fpg;
-	UFSD("EXIT3, result %u\n", result);
+	UFSD("EXIT3, result %llu\n", (unsigned long long)result);
 	return result;
 }
 
-static unsigned ufs_alloccg_block (struct inode * inode,
-	struct ufs_cg_private_info * ucpi, unsigned goal, int * err)
+static u64 ufs_alloccg_block(struct inode *inode,
+			     struct ufs_cg_private_info *ucpi,
+			     u64 goal, int *err)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct ufs_super_block_first * usb1;
 	struct ufs_cylinder_group * ucg;
-	unsigned result, cylno, blkno;
+	u64 result, blkno;
 
-	UFSD("ENTER, goal %u\n", goal);
+	UFSD("ENTER, goal %llu\n", (unsigned long long)goal);
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -672,7 +701,7 @@ static unsigned ufs_alloccg_block (struc
 		goto norot;
 	}
 	goal = ufs_blknum (goal);
-	goal = ufs_dtogd (goal);
+	goal = ufs_dtogd(uspi, goal);
 	
 	/*
 	 * If the requested block is available, use it.
@@ -684,8 +713,8 @@ static unsigned ufs_alloccg_block (struc
 	
 norot:	
 	result = ufs_bitmap_search (sb, ucpi, goal, uspi->s_fpb);
-	if (result == (unsigned)-1)
-		return (unsigned)-1;
+	if (result == INVBLOCK)
+		return INVBLOCK;
 	ucpi->c_rotor = result;
 gotit:
 	blkno = ufs_fragstoblks(result);
@@ -694,17 +723,22 @@ gotit:
 		ufs_clusteracct (sb, ucpi, blkno, -1);
 	if(DQUOT_ALLOC_BLOCK(inode, uspi->s_fpb)) {
 		*err = -EDQUOT;
-		return (unsigned)-1;
+		return INVBLOCK;
 	}
 
 	fs32_sub(sb, &ucg->cg_cs.cs_nbfree, 1);
 	uspi->cs_total.cs_nbfree--;
 	fs32_sub(sb, &UFS_SB(sb)->fs_cs(ucpi->c_cgx).cs_nbfree, 1);
-	cylno = ufs_cbtocylno(result);
-	fs16_sub(sb, &ubh_cg_blks(ucpi, cylno, ufs_cbtorpos(result)), 1);
-	fs32_sub(sb, &ubh_cg_blktot(ucpi, cylno), 1);
+
+	if (uspi->fs_magic != UFS2_MAGIC) {
+		unsigned cylno = ufs_cbtocylno((unsigned)result);
+
+		fs16_sub(sb, &ubh_cg_blks(ucpi, cylno,
+					  ufs_cbtorpos((unsigned)result)), 1);
+		fs32_sub(sb, &ubh_cg_blktot(ucpi, cylno), 1);
+	}
 	
-	UFSD("EXIT, result %u\n", result);
+	UFSD("EXIT, result %llu\n", (unsigned long long)result);
 
 	return result;
 }
@@ -744,9 +778,9 @@ static unsigned ubh_scanc(struct ufs_sb_
  * @goal: near which block we want find new one
  * @count: specified size
  */
-static unsigned ufs_bitmap_search(struct super_block *sb,
-				  struct ufs_cg_private_info *ucpi,
-				  unsigned goal, unsigned count)
+static u64 ufs_bitmap_search(struct super_block *sb,
+			     struct ufs_cg_private_info *ucpi,
+			     u64 goal, unsigned count)
 {
 	/*
 	 * Bit patterns for identifying fragments in the block map
@@ -761,16 +795,18 @@ static unsigned ufs_bitmap_search(struct
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct ufs_super_block_first *usb1;
 	struct ufs_cylinder_group *ucg;
-	unsigned start, length, loc, result;
+	unsigned start, length, loc;
 	unsigned pos, want, blockmap, mask, end;
+	u64 result;
 
-	UFSD("ENTER, cg %u, goal %u, count %u\n", ucpi->c_cgx, goal, count);
+	UFSD("ENTER, cg %u, goal %llu, count %u\n", ucpi->c_cgx,
+	     (unsigned long long)goal, count);
 
 	usb1 = ubh_get_usb_first (uspi);
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
 
 	if (goal)
-		start = ufs_dtogd(goal) >> 3;
+		start = ufs_dtogd(uspi, goal) >> 3;
 	else
 		start = ucpi->c_frotor >> 3;
 		
@@ -790,7 +826,7 @@ static unsigned ufs_bitmap_search(struct
 				  " length %u, count %u, freeoff %u\n",
 				  ucpi->c_cgx, start, length, count,
 				  ucpi->c_freeoff);
-			return (unsigned)-1;
+			return INVBLOCK;
 		}
 		start = 0;
 	}
@@ -808,7 +844,8 @@ static unsigned ufs_bitmap_search(struct
 		want = want_arr[count];
 		for (pos = 0; pos <= uspi->s_fpb - count; pos++) {
 			if ((blockmap & mask) == want) {
-				UFSD("EXIT, result %u\n", result);
+				UFSD("EXIT, result %llu\n",
+				     (unsigned long long)result);
 				return result + pos;
  			}
 			mask <<= 1;
@@ -819,7 +856,7 @@ static unsigned ufs_bitmap_search(struct
 	ufs_error(sb, "ufs_bitmap_search", "block not in map on cg %u\n",
 		  ucpi->c_cgx);
 	UFSD("EXIT (FAILED)\n");
-	return (unsigned)-1;
+	return INVBLOCK;
 }
 
 static void ufs_clusteracct(struct super_block * sb,
diff -puN fs/ufs/inode.c~ufs2-write-block-allocation-update fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs2-write-block-allocation-update
+++ a/fs/ufs/inode.c
@@ -170,7 +170,7 @@ out:
  * @locked_page - for ufs_new_fragments()
  */
 static struct buffer_head *
-ufs_inode_getfrag(struct inode *inode, unsigned int fragment,
+ufs_inode_getfrag(struct inode *inode, u64 fragment,
 		  sector_t new_fragment, unsigned int required, int *err,
 		  long *phys, int *new, struct page *locked_page)
 {
@@ -178,12 +178,12 @@ ufs_inode_getfrag(struct inode *inode, u
 	struct super_block *sb = inode->i_sb;
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct buffer_head * result;
-	unsigned block, blockoff, lastfrag, lastblock, lastblockoff;
-	unsigned tmp, goal;
-	__fs32 * p, * p2;
+	unsigned blockoff, lastblockoff;
+	u64 tmp, goal, lastfrag, block, lastblock;
+	void *p, *p2;
 
-	UFSD("ENTER, ino %lu, fragment %u, new_fragment %llu, required %u, "
-	     "metadata %d\n", inode->i_ino, fragment,
+	UFSD("ENTER, ino %lu, fragment %llu, new_fragment %llu, required %u, "
+	     "metadata %d\n", inode->i_ino, (unsigned long long)fragment,
 	     (unsigned long long)new_fragment, required, !phys);
 
         /* TODO : to be done for write support
@@ -193,17 +193,20 @@ ufs_inode_getfrag(struct inode *inode, u
 
 	block = ufs_fragstoblks (fragment);
 	blockoff = ufs_fragnum (fragment);
-	p = ufsi->i_u1.i_data + block;
+	p = ufs_get_direct_data_ptr(uspi, ufsi, block);
+
 	goal = 0;
 
 repeat:
-	tmp = fs32_to_cpu(sb, *p);
+	tmp = ufs_data_ptr_to_cpu(sb, p);
+
 	lastfrag = ufsi->i_lastfrag;
 	if (tmp && fragment < lastfrag) {
 		if (!phys) {
 			result = sb_getblk(sb, uspi->s_sbbase + tmp + blockoff);
-			if (tmp == fs32_to_cpu(sb, *p)) {
-				UFSD("EXIT, result %u\n", tmp + blockoff);
+			if (tmp == ufs_data_ptr_to_cpu(sb, p)) {
+				UFSD("EXIT, result %llu\n",
+				     (unsigned long long)tmp + blockoff);
 				return result;
 			}
 			brelse (result);
@@ -224,10 +227,11 @@ repeat:
 		 * We must reallocate last allocated block
 		 */
 		if (lastblockoff) {
-			p2 = ufsi->i_u1.i_data + lastblock;
-			tmp = ufs_new_fragments (inode, p2, lastfrag, 
-						 fs32_to_cpu(sb, *p2), uspi->s_fpb - lastblockoff,
-						 err, locked_page);
+			p2 = ufs_get_direct_data_ptr(uspi, ufsi, lastblock);
+			tmp = ufs_new_fragments(inode, p2, lastfrag,
+						ufs_data_ptr_to_cpu(sb, p2),
+						uspi->s_fpb - lastblockoff,
+						err, locked_page);
 			if (!tmp) {
 				if (lastfrag != ufsi->i_lastfrag)
 					goto repeat;
@@ -237,27 +241,31 @@ repeat:
 			lastfrag = ufsi->i_lastfrag;
 			
 		}
-		tmp = fs32_to_cpu(sb, ufsi->i_u1.i_data[lastblock]);
+		tmp = ufs_data_ptr_to_cpu(sb,
+					 ufs_get_direct_data_ptr(uspi, ufsi,
+								 lastblock));
 		if (tmp)
 			goal = tmp + uspi->s_fpb;
 		tmp = ufs_new_fragments (inode, p, fragment - blockoff, 
 					 goal, required + blockoff,
 					 err,
 					 phys != NULL ? locked_page : NULL);
-	}
+	} else if (lastblock == block) {
 	/*
 	 * We will extend last allocated block
 	 */
-	else if (lastblock == block) {
-		tmp = ufs_new_fragments(inode, p, fragment - (blockoff - lastblockoff),
-					fs32_to_cpu(sb, *p), required +  (blockoff - lastblockoff),
+		tmp = ufs_new_fragments(inode, p, fragment -
+					(blockoff - lastblockoff),
+					ufs_data_ptr_to_cpu(sb, p),
+					required +  (blockoff - lastblockoff),
 					err, phys != NULL ? locked_page : NULL);
 	} else /* (lastblock > block) */ {
 	/*
 	 * We will allocate new block before last allocated block
 	 */
 		if (block) {
-			tmp = fs32_to_cpu(sb, ufsi->i_u1.i_data[block-1]);
+			tmp = ufs_data_ptr_to_cpu(sb,
+						 ufs_get_direct_data_ptr(uspi, ufsi, block - 1));
 			if (tmp)
 				goal = tmp + uspi->s_fpb;
 		}
@@ -266,7 +274,7 @@ repeat:
 					phys != NULL ? locked_page : NULL);
 	}
 	if (!tmp) {
-		if ((!blockoff && *p) || 
+		if ((!blockoff && ufs_data_ptr_to_cpu(sb, p)) ||
 		    (blockoff && lastfrag != ufsi->i_lastfrag))
 			goto repeat;
 		*err = -ENOSPC;
@@ -286,7 +294,7 @@ repeat:
 	if (IS_SYNC(inode))
 		ufs_sync_inode (inode);
 	mark_inode_dirty(inode);
-	UFSD("EXIT, result %u\n", tmp + blockoff);
+	UFSD("EXIT, result %llu\n", (unsigned long long)tmp + blockoff);
 	return result;
 
      /* This part : To be implemented ....
@@ -320,20 +328,22 @@ repeat2:
  */
 static struct buffer_head *
 ufs_inode_getblock(struct inode *inode, struct buffer_head *bh,
-		  unsigned int fragment, sector_t new_fragment, int *err,
+		  u64 fragment, sector_t new_fragment, int *err,
 		  long *phys, int *new, struct page *locked_page)
 {
 	struct super_block *sb = inode->i_sb;
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct buffer_head * result;
-	unsigned tmp, goal, block, blockoff;
-	__fs32 * p;
+	unsigned blockoff;
+	u64 tmp, goal, block;
+	void *p;
 
 	block = ufs_fragstoblks (fragment);
 	blockoff = ufs_fragnum (fragment);
 
-	UFSD("ENTER, ino %lu, fragment %u, new_fragment %llu, metadata %d\n",
-	     inode->i_ino, fragment, (unsigned long long)new_fragment, !phys);
+	UFSD("ENTER, ino %lu, fragment %llu, new_fragment %llu, metadata %d\n",
+	     inode->i_ino, (unsigned long long)fragment,
+	     (unsigned long long)new_fragment, !phys);
 
 	result = NULL;
 	if (!bh)
@@ -344,14 +354,16 @@ ufs_inode_getblock(struct inode *inode, 
 		if (!buffer_uptodate(bh))
 			goto out;
 	}
-
-	p = (__fs32 *) bh->b_data + block;
+	if (uspi->fs_magic == UFS2_MAGIC)
+		p = (__fs64 *)bh->b_data + block;
+	else
+		p = (__fs32 *)bh->b_data + block;
 repeat:
-	tmp = fs32_to_cpu(sb, *p);
+	tmp = ufs_data_ptr_to_cpu(sb, p);
 	if (tmp) {
 		if (!phys) {
 			result = sb_getblk(sb, uspi->s_sbbase + tmp + blockoff);
-			if (tmp == fs32_to_cpu(sb, *p))
+			if (tmp == ufs_data_ptr_to_cpu(sb, p))
 				goto out;
 			brelse (result);
 			goto repeat;
@@ -361,14 +373,16 @@ repeat:
 		}
 	}
 
-	if (block && (tmp = fs32_to_cpu(sb, ((__fs32*)bh->b_data)[block-1])))
+	if (block && (uspi->fs_magic == UFS2_MAGIC ?
+		      (tmp = fs64_to_cpu(sb, ((__fs64 *)bh->b_data)[block-1])) :
+		      (tmp = fs32_to_cpu(sb, ((__fs32 *)bh->b_data)[block-1]))))
 		goal = tmp + uspi->s_fpb;
 	else
 		goal = bh->b_blocknr + uspi->s_fpb;
 	tmp = ufs_new_fragments(inode, p, ufs_blknum(new_fragment), goal,
 				uspi->s_fpb, err, locked_page);
 	if (!tmp) {
-		if (fs32_to_cpu(sb, *p))
+		if (ufs_data_ptr_to_cpu(sb, p))
 			goto repeat;
 		goto out;
 	}		
@@ -386,7 +400,7 @@ repeat:
 		sync_dirty_buffer(bh);
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	UFSD("result %u\n", tmp + blockoff);
+	UFSD("result %llu\n", (unsigned long long)tmp + blockoff);
 out:
 	brelse (bh);
 	UFSD("EXIT\n");
diff -puN fs/ufs/truncate.c~ufs2-write-block-allocation-update fs/ufs/truncate.c
--- a/fs/ufs/truncate.c~ufs2-write-block-allocation-update
+++ a/fs/ufs/truncate.c
@@ -30,8 +30,8 @@
  */
 
 /*
- * Modified to avoid infinite loop on 2006 by
- * Evgeniy Dushistov <dushistov@mail.ru>
+ * Adoptation to use page cache and UFS2 write support by
+ * Evgeniy Dushistov <dushistov@mail.ru>, 2006-2007
  */
 
 #include <linux/errno.h>
@@ -63,13 +63,13 @@
 #define DIRECT_FRAGMENT ((inode->i_size + uspi->s_fsize - 1) >> uspi->s_fshift)
 
 
-static int ufs_trunc_direct (struct inode * inode)
+static int ufs_trunc_direct(struct inode *inode)
 {
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	__fs32 * p;
-	unsigned frag1, frag2, frag3, frag4, block1, block2;
+	void *p;
+	u64 frag1, frag2, frag3, frag4, block1, block2;
 	unsigned frag_to_free, free_count;
 	unsigned i, tmp;
 	int retry;
@@ -91,13 +91,16 @@ static int ufs_trunc_direct (struct inod
 	if (frag2 > frag3) {
 		frag2 = frag4;
 		frag3 = frag4 = 0;
-	}
-	else if (frag2 < frag3) {
+	} else if (frag2 < frag3) {
 		block1 = ufs_fragstoblks (frag2);
 		block2 = ufs_fragstoblks (frag3);
 	}
 
-	UFSD("frag1 %u, frag2 %u, block1 %u, block2 %u, frag3 %u, frag4 %u\n", frag1, frag2, block1, block2, frag3, frag4);
+	UFSD("frag1 %llu, frag2 %llu, block1 %llu, block2 %llu, frag3 %llu,"
+	     " frag4 %llu\n",
+	     (unsigned long long)frag1, (unsigned long long)frag2,
+	     (unsigned long long)block1, (unsigned long long)block2,
+	     (unsigned long long)frag3, (unsigned long long)frag4);
 
 	if (frag1 >= frag2)
 		goto next1;		
@@ -105,8 +108,8 @@ static int ufs_trunc_direct (struct inod
 	/*
 	 * Free first free fragments
 	 */
-	p = ufsi->i_u1.i_data + ufs_fragstoblks (frag1);
-	tmp = fs32_to_cpu(sb, *p);
+	p = ufs_get_direct_data_ptr(uspi, ufsi, ufs_fragstoblks(frag1));
+	tmp = ufs_data_ptr_to_cpu(sb, p);
 	if (!tmp )
 		ufs_panic (sb, "ufs_trunc_direct", "internal error");
 	frag2 -= frag1;
@@ -121,12 +124,11 @@ next1:
 	 * Free whole blocks
 	 */
 	for (i = block1 ; i < block2; i++) {
-		p = ufsi->i_u1.i_data + i;
-		tmp = fs32_to_cpu(sb, *p);
+		p = ufs_get_direct_data_ptr(uspi, ufsi, i);
+		tmp = ufs_data_ptr_to_cpu(sb, p);
 		if (!tmp)
 			continue;
-
-		*p = 0;
+		ufs_data_ptr_clear(uspi, p);
 
 		if (free_count == 0) {
 			frag_to_free = tmp;
@@ -150,13 +152,12 @@ next1:
 	/*
 	 * Free last free fragments
 	 */
-	p = ufsi->i_u1.i_data + ufs_fragstoblks (frag3);
-	tmp = fs32_to_cpu(sb, *p);
+	p = ufs_get_direct_data_ptr(uspi, ufsi, ufs_fragstoblks(frag3));
+	tmp = ufs_data_ptr_to_cpu(sb, p);
 	if (!tmp )
 		ufs_panic(sb, "ufs_truncate_direct", "internal error");
 	frag4 = ufs_fragnum (frag4);
-
-	*p = 0;
+	ufs_data_ptr_clear(uspi, p);
 
 	ufs_free_fragments (inode, tmp, frag4);
 	mark_inode_dirty(inode);
@@ -167,17 +168,20 @@ next1:
 }
 
 
-static int ufs_trunc_indirect (struct inode * inode, unsigned offset, __fs32 *p)
+static int ufs_trunc_indirect(struct inode *inode, u64 offset, void *p)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
 	struct ufs_buffer_head * ind_ubh;
-	__fs32 * ind;
-	unsigned indirect_block, i, tmp;
-	unsigned frag_to_free, free_count;
+	void *ind;
+	u64 tmp, indirect_block, i, frag_to_free;
+	unsigned free_count;
 	int retry;
 
-	UFSD("ENTER\n");
+	UFSD("ENTER: ino %lu, offset %llu, p: %p\n",
+	     inode->i_ino, (unsigned long long)offset, p);
+
+	BUG_ON(!p);
 		
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -186,27 +190,27 @@ static int ufs_trunc_indirect (struct in
 	free_count = 0;
 	retry = 0;
 	
-	tmp = fs32_to_cpu(sb, *p);
+	tmp = ufs_data_ptr_to_cpu(sb, p);
 	if (!tmp)
 		return 0;
 	ind_ubh = ubh_bread(sb, tmp, uspi->s_bsize);
-	if (tmp != fs32_to_cpu(sb, *p)) {
+	if (tmp != ufs_data_ptr_to_cpu(sb, p)) {
 		ubh_brelse (ind_ubh);
 		return 1;
 	}
 	if (!ind_ubh) {
-		*p = 0;
+		ufs_data_ptr_clear(uspi, p);
 		return 0;
 	}
 
 	indirect_block = (DIRECT_BLOCK > offset) ? (DIRECT_BLOCK - offset) : 0;
 	for (i = indirect_block; i < uspi->s_apb; i++) {
-		ind = ubh_get_addr32 (ind_ubh, i);
-		tmp = fs32_to_cpu(sb, *ind);
+		ind = ubh_get_data_ptr(uspi, ind_ubh, i);
+		tmp = ufs_data_ptr_to_cpu(sb, ind);
 		if (!tmp)
 			continue;
 
-		*ind = 0;
+		ufs_data_ptr_clear(uspi, ind);
 		ubh_mark_buffer_dirty(ind_ubh);
 		if (free_count == 0) {
 			frag_to_free = tmp;
@@ -226,11 +230,12 @@ static int ufs_trunc_indirect (struct in
 		ufs_free_blocks (inode, frag_to_free, free_count);
 	}
 	for (i = 0; i < uspi->s_apb; i++)
-		if (*ubh_get_addr32(ind_ubh,i))
+		if (!ufs_is_data_ptr_zero(uspi,
+					  ubh_get_data_ptr(uspi, ind_ubh, i)))
 			break;
 	if (i >= uspi->s_apb) {
-		tmp = fs32_to_cpu(sb, *p);
-		*p = 0;
+		tmp = ufs_data_ptr_to_cpu(sb, p);
+		ufs_data_ptr_clear(uspi, p);
 
 		ufs_free_blocks (inode, tmp, uspi->s_fpb);
 		mark_inode_dirty(inode);
@@ -248,13 +253,13 @@ static int ufs_trunc_indirect (struct in
 	return retry;
 }
 
-static int ufs_trunc_dindirect (struct inode *inode, unsigned offset, __fs32 *p)
+static int ufs_trunc_dindirect(struct inode *inode, u64 offset, void *p)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_buffer_head * dind_bh;
-	unsigned i, tmp, dindirect_block;
-	__fs32 * dind;
+	struct ufs_buffer_head *dind_bh;
+	u64 i, tmp, dindirect_block;
+	void *dind;
 	int retry = 0;
 	
 	UFSD("ENTER\n");
@@ -266,22 +271,22 @@ static int ufs_trunc_dindirect (struct i
 		? ((DIRECT_BLOCK - offset) >> uspi->s_apbshift) : 0;
 	retry = 0;
 	
-	tmp = fs32_to_cpu(sb, *p);
+	tmp = ufs_data_ptr_to_cpu(sb, p);
 	if (!tmp)
 		return 0;
 	dind_bh = ubh_bread(sb, tmp, uspi->s_bsize);
-	if (tmp != fs32_to_cpu(sb, *p)) {
+	if (tmp != ufs_data_ptr_to_cpu(sb, p)) {
 		ubh_brelse (dind_bh);
 		return 1;
 	}
 	if (!dind_bh) {
-		*p = 0;
+		ufs_data_ptr_clear(uspi, p);
 		return 0;
 	}
 
 	for (i = dindirect_block ; i < uspi->s_apb ; i++) {
-		dind = ubh_get_addr32 (dind_bh, i);
-		tmp = fs32_to_cpu(sb, *dind);
+		dind = ubh_get_data_ptr(uspi, dind_bh, i);
+		tmp = ufs_data_ptr_to_cpu(sb, dind);
 		if (!tmp)
 			continue;
 		retry |= ufs_trunc_indirect (inode, offset + (i << uspi->s_apbshift), dind);
@@ -289,11 +294,12 @@ static int ufs_trunc_dindirect (struct i
 	}
 
 	for (i = 0; i < uspi->s_apb; i++)
-		if (*ubh_get_addr32 (dind_bh, i))
+		if (!ufs_is_data_ptr_zero(uspi,
+					  ubh_get_data_ptr(uspi, dind_bh, i)))
 			break;
 	if (i >= uspi->s_apb) {
-		tmp = fs32_to_cpu(sb, *p);
-		*p = 0;
+		tmp = ufs_data_ptr_to_cpu(sb, p);
+		ufs_data_ptr_clear(uspi, p);
 
 		ufs_free_blocks(inode, tmp, uspi->s_fpb);
 		mark_inode_dirty(inode);
@@ -311,34 +317,33 @@ static int ufs_trunc_dindirect (struct i
 	return retry;
 }
 
-static int ufs_trunc_tindirect (struct inode * inode)
+static int ufs_trunc_tindirect(struct inode *inode)
 {
+	struct super_block *sb = inode->i_sb;
+	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct ufs_inode_info *ufsi = UFS_I(inode);
-	struct super_block * sb;
-	struct ufs_sb_private_info * uspi;
 	struct ufs_buffer_head * tind_bh;
-	unsigned tindirect_block, tmp, i;
-	__fs32 * tind, * p;
+	u64 tindirect_block, tmp, i;
+	void *tind, *p;
 	int retry;
 	
 	UFSD("ENTER\n");
 
-	sb = inode->i_sb;
-	uspi = UFS_SB(sb)->s_uspi;
 	retry = 0;
 	
 	tindirect_block = (DIRECT_BLOCK > (UFS_NDADDR + uspi->s_apb + uspi->s_2apb))
 		? ((DIRECT_BLOCK - UFS_NDADDR - uspi->s_apb - uspi->s_2apb) >> uspi->s_2apbshift) : 0;
-	p = ufsi->i_u1.i_data + UFS_TIND_BLOCK;
-	if (!(tmp = fs32_to_cpu(sb, *p)))
+
+	p = ufs_get_direct_data_ptr(uspi, ufsi, UFS_TIND_BLOCK);
+	if (!(tmp = ufs_data_ptr_to_cpu(sb, p)))
 		return 0;
 	tind_bh = ubh_bread (sb, tmp, uspi->s_bsize);
-	if (tmp != fs32_to_cpu(sb, *p)) {
+	if (tmp != ufs_data_ptr_to_cpu(sb, p)) {
 		ubh_brelse (tind_bh);
 		return 1;
 	}
 	if (!tind_bh) {
-		*p = 0;
+		ufs_data_ptr_clear(uspi, p);
 		return 0;
 	}
 
@@ -349,11 +354,12 @@ static int ufs_trunc_tindirect (struct i
 		ubh_mark_buffer_dirty(tind_bh);
 	}
 	for (i = 0; i < uspi->s_apb; i++)
-		if (*ubh_get_addr32 (tind_bh, i))
+		if (!ufs_is_data_ptr_zero(uspi,
+					  ubh_get_data_ptr(uspi, tind_bh, i)))
 			break;
 	if (i >= uspi->s_apb) {
-		tmp = fs32_to_cpu(sb, *p);
-		*p = 0;
+		tmp = ufs_data_ptr_to_cpu(sb, p);
+		ufs_data_ptr_clear(uspi, p);
 
 		ufs_free_blocks(inode, tmp, uspi->s_fpb);
 		mark_inode_dirty(inode);
@@ -375,7 +381,8 @@ static int ufs_alloc_lastblock(struct in
 	int err = 0;
 	struct address_space *mapping = inode->i_mapping;
 	struct ufs_sb_private_info *uspi = UFS_SB(inode->i_sb)->s_uspi;
-	unsigned lastfrag, i, end;
+	unsigned i, end;
+	sector_t lastfrag;
 	struct page *lastpage;
 	struct buffer_head *bh;
 
@@ -430,7 +437,9 @@ int ufs_truncate(struct inode *inode, lo
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	int retry, err = 0;
 	
-	UFSD("ENTER\n");
+	UFSD("ENTER: ino %lu, i_size: %llu, old_i_size: %llu\n",
+	     inode->i_ino, (unsigned long long)i_size_read(inode),
+	     (unsigned long long)old_i_size);
 
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 	      S_ISLNK(inode->i_mode)))
@@ -450,10 +459,12 @@ int ufs_truncate(struct inode *inode, lo
 	lock_kernel();
 	while (1) {
 		retry = ufs_trunc_direct(inode);
-		retry |= ufs_trunc_indirect (inode, UFS_IND_BLOCK,
-			(__fs32 *) &ufsi->i_u1.i_data[UFS_IND_BLOCK]);
-		retry |= ufs_trunc_dindirect (inode, UFS_IND_BLOCK + uspi->s_apb,
-			(__fs32 *) &ufsi->i_u1.i_data[UFS_DIND_BLOCK]);
+		retry |= ufs_trunc_indirect(inode, UFS_IND_BLOCK,
+					    ufs_get_direct_data_ptr(uspi, ufsi,
+								    UFS_IND_BLOCK));
+		retry |= ufs_trunc_dindirect(inode, UFS_IND_BLOCK + uspi->s_apb,
+					     ufs_get_direct_data_ptr(uspi, ufsi,
+								     UFS_DIND_BLOCK));
 		retry |= ufs_trunc_tindirect (inode);
 		if (!retry)
 			break;
diff -puN fs/ufs/util.h~ufs2-write-block-allocation-update fs/ufs/util.h
--- a/fs/ufs/util.h~ufs2-write-block-allocation-update
+++ a/fs/ufs/util.h
@@ -305,8 +305,22 @@ static inline void *get_usb_offset(struc
 	(((__fs32*)((ubh)->bh[(begin) >> (uspi->s_fshift-2)]->b_data)) + \
 	((begin) & ((uspi->s_fsize>>2) - 1)))
 
+#define ubh_get_addr64(ubh,begin) \
+	(((__fs64*)((ubh)->bh[(begin) >> (uspi->s_fshift-3)]->b_data)) + \
+	((begin) & ((uspi->s_fsize>>3) - 1)))
+
 #define ubh_get_addr ubh_get_addr8
 
+static inline void *ubh_get_data_ptr(struct ufs_sb_private_info *uspi,
+				     struct ufs_buffer_head *ubh,
+				     u64 blk)
+{
+	if (uspi->fs_magic == UFS2_MAGIC)
+		return ubh_get_addr64(ubh, blk);
+	else
+		return ubh_get_addr32(ubh, blk);
+}
+
 #define ubh_blkmap(ubh,begin,bit) \
 	((*ubh_get_addr(ubh, (begin) + ((bit) >> 3)) >> ((bit) & 7)) & (0xff >> (UFS_MAXFRAG - uspi->s_fpb)))
 
@@ -507,3 +521,46 @@ static inline void ufs_fragacct (struct 
 	if (fragsize > 0 && fragsize < uspi->s_fpb)
 		fs32_add(sb, &fraglist[fragsize], cnt);
 }
+
+static inline void *ufs_get_direct_data_ptr(struct ufs_sb_private_info *uspi,
+					    struct ufs_inode_info *ufsi,
+					    unsigned blk)
+{
+	BUG_ON(blk > UFS_TIND_BLOCK);
+	return uspi->fs_magic == UFS2_MAGIC ?
+		(void *)&ufsi->i_u1.u2_i_data[blk] :
+		(void *)&ufsi->i_u1.i_data[blk];
+}
+
+static inline u64 ufs_data_ptr_to_cpu(struct super_block *sb, void *p)
+{
+	return UFS_SB(sb)->s_uspi->fs_magic == UFS2_MAGIC ?
+		fs64_to_cpu(sb, *(__fs64 *)p) :
+		fs32_to_cpu(sb, *(__fs32 *)p);
+}
+
+static inline void ufs_cpu_to_data_ptr(struct super_block *sb, void *p, u64 val)
+{
+	if (UFS_SB(sb)->s_uspi->fs_magic == UFS2_MAGIC)
+		*(__fs64 *)p = cpu_to_fs64(sb, val);
+	else
+		*(__fs32 *)p = cpu_to_fs32(sb, val);
+}
+
+static inline void ufs_data_ptr_clear(struct ufs_sb_private_info *uspi,
+				      void *p)
+{
+	if (uspi->fs_magic == UFS2_MAGIC)
+		*(__fs64 *)p = 0;
+	else
+		*(__fs32 *)p = 0;
+}
+
+static inline int ufs_is_data_ptr_zero(struct ufs_sb_private_info *uspi,
+				       void *p)
+{
+	if (uspi->fs_magic == UFS2_MAGIC)
+		return *(__fs64 *)p == 0;
+	else
+		return *(__fs32 *)p == 0;
+}
diff -puN include/linux/ufs_fs.h~ufs2-write-block-allocation-update include/linux/ufs_fs.h
--- a/include/linux/ufs_fs.h~ufs2-write-block-allocation-update
+++ a/include/linux/ufs_fs.h
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/stat.h>
 #include <linux/fs.h>
+#include <asm/div64.h>
 
 #ifndef __KERNEL__
 typedef __u64 __fs64;
@@ -265,13 +266,6 @@ typedef __u16 __bitwise __fs16;
 #define	ufs_inotofsbo(x)	((x) % uspi->s_inopf)
 
 /*
- * Give cylinder group number for a file system block.
- * Give cylinder group block number for a file system block.
- */
-#define	ufs_dtog(d)	((d) / uspi->s_fpg)
-#define	ufs_dtogd(d)	((d) % uspi->s_fpg)
-
-/*
  * Compute the cylinder and rotational position of a cyl block addr.
  */
 #define ufs_cbtocylno(bno) \
@@ -721,6 +715,7 @@ struct ufs_cg_private_info {
 	__u32	c_nclusterblks;	/* number of clusters this cg */
 };	
 
+
 struct ufs_sb_private_info {
 	struct ufs_buffer_head s_ubh; /* buffer containing super block */
 	struct ufs_csum_core cs_total;
@@ -949,10 +944,10 @@ struct ufs_super_block_third {
 #ifdef __KERNEL__
 
 /* balloc.c */
-extern void ufs_free_fragments (struct inode *, unsigned, unsigned);
-extern void ufs_free_blocks (struct inode *, unsigned, unsigned);
-extern unsigned ufs_new_fragments(struct inode *, __fs32 *, unsigned, unsigned,
-				  unsigned, int *, struct page *);
+extern void ufs_free_fragments (struct inode *, u64, unsigned);
+extern void ufs_free_blocks (struct inode *, u64, unsigned);
+extern u64 ufs_new_fragments(struct inode *, void *, u64, u64,
+			     unsigned, int *, struct page *);
 
 /* cylinder.c */
 extern struct ufs_cg_private_info * ufs_load_cylinder (struct super_block *, unsigned);
@@ -1013,6 +1008,22 @@ static inline struct ufs_inode_info *UFS
 	return container_of(inode, struct ufs_inode_info, vfs_inode);
 }
 
+/*
+ * Give cylinder group number for a file system block.
+ * Give cylinder group block number for a file system block.
+ */
+/* #define	ufs_dtog(d)	((d) / uspi->s_fpg) */
+static inline u64 ufs_dtog(struct ufs_sb_private_info * uspi, u64 b)
+{
+	do_div(b, uspi->s_fpg);
+	return b;
+}
+/* #define	ufs_dtogd(d)	((d) % uspi->s_fpg) */
+static inline u32 ufs_dtogd(struct ufs_sb_private_info * uspi, u64 b)
+{
+	return do_div(b, uspi->s_fpg);
+}
+
 #endif	/* __KERNEL__ */
 
 #endif /* __LINUX_UFS_FS_H */
diff -puN include/linux/ufs_fs_i.h~ufs2-write-block-allocation-update include/linux/ufs_fs_i.h
--- a/include/linux/ufs_fs_i.h~ufs2-write-block-allocation-update
+++ a/include/linux/ufs_fs_i.h
@@ -25,7 +25,7 @@ struct ufs_inode_info {
 	__u32	i_unused2;
 	__u32	i_oeftflag;
 	__u16	i_osync;
-	__u32	i_lastfrag;
+	__u64	i_lastfrag;
 	__u32   i_dir_start_lookup;
 	struct inode vfs_inode;
 };
_

Patches currently in -mm which might be from dushistov@mail.ru are

ufs-alloc-metadata-null-page-fix.patch
ufs-truncate-negative-to-unsigned-fix.patch
ufs-rellocation-fix.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch
