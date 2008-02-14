From: akpm@linux-foundation.org
Subject: + jfs-le_add_cpu-conversion.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:24:43 -0800
Message-ID: <200802140024.m1E0OhNe021983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935030AbYBNAa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:30:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, shaggy@austin.ibm.com


The patch titled
     jfs: le*_add_cpu conversion
has been added to the -mm tree.  Its filename is
     jfs-le_add_cpu-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jfs: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_dmap.c  |   11 +++++------
 fs/jfs/jfs_imap.c  |   15 ++++++---------
 fs/jfs/jfs_xtree.c |   26 ++++++++------------------
 3 files changed, 19 insertions(+), 33 deletions(-)

diff -puN fs/jfs/jfs_dmap.c~jfs-le_add_cpu-conversion fs/jfs/jfs_dmap.c
--- a/fs/jfs/jfs_dmap.c~jfs-le_add_cpu-conversion
+++ a/fs/jfs/jfs_dmap.c
@@ -2172,7 +2172,7 @@ static void dbAllocBits(struct bmap * bm
 	}
 
 	/* update the free count for this dmap */
-	dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) - nblocks);
+	le32_add_cpu(&dp->nfree, -nblocks);
 
 	BMAP_LOCK(bmp);
 
@@ -2316,7 +2316,7 @@ static int dbFreeBits(struct bmap * bmp,
 
 	/* update the free count for this dmap.
 	 */
-	dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) + nblocks);
+	le32_add_cpu(&dp->nfree, nblocks);
 
 	BMAP_LOCK(bmp);
 
@@ -3226,7 +3226,7 @@ static int dbAllocDmapBU(struct bmap * b
 	}
 
 	/* update the free count for this dmap */
-	dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) - nblocks);
+	le32_add_cpu(&dp->nfree, -nblocks);
 
 	/* reconstruct summary tree */
 	dbInitDmapTree(dp);
@@ -3660,9 +3660,8 @@ static int dbInitDmap(struct dmap * dp, 
 			goto initTree;
 		}
 	} else {
-		dp->nblocks =
-		    cpu_to_le32(le32_to_cpu(dp->nblocks) + nblocks);
-		dp->nfree = cpu_to_le32(le32_to_cpu(dp->nfree) + nblocks);
+		le32_add_cpu(&dp->nblocks, nblocks);
+		le32_add_cpu(&dp->nfree, nblocks);
 	}
 
 	/* word number containing start block number */
diff -puN fs/jfs/jfs_imap.c~jfs-le_add_cpu-conversion fs/jfs/jfs_imap.c
--- a/fs/jfs/jfs_imap.c~jfs-le_add_cpu-conversion
+++ a/fs/jfs/jfs_imap.c
@@ -1019,8 +1019,7 @@ int diFree(struct inode *ip)
 		/* update the free inode counts at the iag, ag and
 		 * map level.
 		 */
-		iagp->nfreeinos =
-		    cpu_to_le32(le32_to_cpu(iagp->nfreeinos) + 1);
+		le32_add_cpu(&iagp->nfreeinos, 1);
 		imap->im_agctl[agno].numfree += 1;
 		atomic_inc(&imap->im_numfree);
 
@@ -1219,9 +1218,8 @@ int diFree(struct inode *ip)
 	/* update the number of free inodes and number of free extents
 	 * for the iag.
 	 */
-	iagp->nfreeinos = cpu_to_le32(le32_to_cpu(iagp->nfreeinos) -
-				      (INOSPEREXT - 1));
-	iagp->nfreeexts = cpu_to_le32(le32_to_cpu(iagp->nfreeexts) + 1);
+	le32_add_cpu(&iagp->nfreeinos, -(INOSPEREXT - 1));
+	le32_add_cpu(&iagp->nfreeexts, 1);
 
 	/* update the number of free inodes and backed inodes
 	 * at the ag and inode map level.
@@ -2124,7 +2122,7 @@ static int diAllocBit(struct inomap * im
 	/* update the free inode count at the iag, ag, inode
 	 * map levels.
 	 */
-	iagp->nfreeinos = cpu_to_le32(le32_to_cpu(iagp->nfreeinos) - 1);
+	le32_add_cpu(&iagp->nfreeinos, -1);
 	imap->im_agctl[agno].numfree -= 1;
 	atomic_dec(&imap->im_numfree);
 
@@ -2378,9 +2376,8 @@ static int diNewExt(struct inomap * imap
 	/* update the free inode and free extent counts for the
 	 * iag.
 	 */
-	iagp->nfreeinos = cpu_to_le32(le32_to_cpu(iagp->nfreeinos) +
-				      (INOSPEREXT - 1));
-	iagp->nfreeexts = cpu_to_le32(le32_to_cpu(iagp->nfreeexts) - 1);
+	le32_add_cpu(&iagp->nfreeinos, (INOSPEREXT - 1));
+	le32_add_cpu(&iagp->nfreeexts, -1);
 
 	/* update the free and backed inode counts for the ag.
 	 */
diff -puN fs/jfs/jfs_xtree.c~jfs-le_add_cpu-conversion fs/jfs/jfs_xtree.c
--- a/fs/jfs/jfs_xtree.c~jfs-le_add_cpu-conversion
+++ a/fs/jfs/jfs_xtree.c
@@ -905,8 +905,7 @@ int xtInsert(tid_t tid,		/* transaction 
 	XT_PUTENTRY(xad, xflag, xoff, xlen, xaddr);
 
 	/* advance next available entry index */
-	p->header.nextindex =
-	    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+	le16_add_cpu(&p->header.nextindex, 1);
 
 	/* Don't log it if there are no links to the file */
 	if (!test_cflag(COMMIT_Nolink, ip)) {
@@ -997,8 +996,7 @@ xtSplitUp(tid_t tid,
 			    split->addr);
 
 		/* advance next available entry index */
-		sp->header.nextindex =
-		    cpu_to_le16(le16_to_cpu(sp->header.nextindex) + 1);
+		le16_add_cpu(&sp->header.nextindex, 1);
 
 		/* Don't log it if there are no links to the file */
 		if (!test_cflag(COMMIT_Nolink, ip)) {
@@ -1167,9 +1165,7 @@ xtSplitUp(tid_t tid,
 				    JFS_SBI(ip->i_sb)->nbperpage, rcbn);
 
 			/* advance next available entry index. */
-			sp->header.nextindex =
-			    cpu_to_le16(le16_to_cpu(sp->header.nextindex) +
-					1);
+			le16_add_cpu(&sp->header.nextindex, 1);
 
 			/* Don't log it if there are no links to the file */
 			if (!test_cflag(COMMIT_Nolink, ip)) {
@@ -1738,8 +1734,7 @@ int xtExtend(tid_t tid,		/* transaction 
 		XT_PUTENTRY(xad, XAD_NEW, xoff, len, xaddr);
 
 		/* advance next available entry index */
-		p->header.nextindex =
-		    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+		le16_add_cpu(&p->header.nextindex, 1);
 	}
 
 	/* get back old entry */
@@ -1905,8 +1900,7 @@ printf("xtTailgate: xoff:0x%lx xlen:0x%x
 		XT_PUTENTRY(xad, XAD_NEW, xoff, xlen, xaddr);
 
 		/* advance next available entry index */
-		p->header.nextindex =
-		    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+		le16_add_cpu(&p->header.nextindex, 1);
 	}
 
 	/* get back old XAD */
@@ -2567,8 +2561,7 @@ int xtAppend(tid_t tid,		/* transaction 
 	XT_PUTENTRY(xad, xflag, xoff, xlen, xaddr);
 
 	/* advance next available entry index */
-	p->header.nextindex =
-	    cpu_to_le16(le16_to_cpu(p->header.nextindex) + 1);
+	le16_add_cpu(&p->header.nextindex, 1);
 
 	xtlck->lwm.offset =
 	    (xtlck->lwm.offset) ? min(index,(int) xtlck->lwm.offset) : index;
@@ -2631,8 +2624,7 @@ int xtDelete(tid_t tid, struct inode *ip
 	 * delete the entry from the leaf page
 	 */
 	nextindex = le16_to_cpu(p->header.nextindex);
-	p->header.nextindex =
-	    cpu_to_le16(le16_to_cpu(p->header.nextindex) - 1);
+	le16_add_cpu(&p->header.nextindex, -1);
 
 	/*
 	 * if the leaf page bocome empty, free the page
@@ -2795,9 +2787,7 @@ xtDeleteUp(tid_t tid, struct inode *ip,
 					(nextindex - index -
 					 1) << L2XTSLOTSIZE);
 
-			p->header.nextindex =
-			    cpu_to_le16(le16_to_cpu(p->header.nextindex) -
-					1);
+			le16_add_cpu(&p->header.nextindex, -1);
 			jfs_info("xtDeleteUp(entry): 0x%lx[%d]",
 				 (ulong) parent->bn, index);
 		}
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
jfs-le_add_cpu-conversion.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
