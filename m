From: akpm@linux-foundation.org
Subject: - udf-fix-coding-style-of-dirc.patch removed from -mm tree
Date: Fri, 21 Dec 2007 16:21:41 -0800
Message-ID: <200712220021.lBM0Lfaj006376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966AbXLVAV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix coding style of dir.c
has been removed from the -mm tree.  Its filename was
     udf-fix-coding-style-of-dirc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: udf: fix coding style of dir.c
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/dir.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff -puN fs/udf/dir.c~udf-fix-coding-style-of-dirc fs/udf/dir.c
--- a/fs/udf/dir.c~udf-fix-coding-style-of-dirc
+++ a/fs/udf/dir.c
@@ -65,24 +65,26 @@ static int do_udf_readdir(struct inode *
 	if (nf_pos == 0)
 		nf_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset =
+		(nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 	bits = dir->i_sb->s_blocksize_bits;
 
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, nf_pos >> (bits - 2),
-			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	else if (inode_bmap(dir, nf_pos >> (bits - 2),
+			    &epos, &eloc, &elen, &offset) ==
+			(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else {
+		} else
 			offset = 0;
-		}
 
-		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
+		fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block);
+		if (!fibh.sbh) {
 			brelse(epos.bh);
 			return -EIO;
 		}
@@ -92,9 +94,11 @@ static int do_udf_readdir(struct inode *
 			if (i + offset > (elen >> bits))
 				i = (elen >> bits) - offset;
 			for (num = 0; i > 0; i--) {
-				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
+				block = udf_get_lb_pblock(dir->i_sb, eloc,
+							  offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
-				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
+				if (tmp && !buffer_uptodate(tmp) &&
+					!buffer_locked(tmp))
 					bha[num++] = tmp;
 				else
 					brelse(tmp);
@@ -126,16 +130,18 @@ static int do_udf_readdir(struct inode *
 		liu = le16_to_cpu(cfi.lengthOfImpUse);
 		lfi = cfi.lengthFileIdent;
 
-		if (fibh.sbh == fibh.ebh) {
+		if (fibh.sbh == fibh.ebh)
 			nameptr = fi->fileIdent + liu;
-		} else {
+		else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset = fibh.soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+			poffset = fibh.soffset + sizeof(struct fileIdentDesc) +
+					liu + lfi;
 
-			if (poffset >= lfi) {
-				nameptr = (char *)(fibh.ebh->b_data + poffset - lfi);
-			} else {
+			if (poffset >= lfi)
+				nameptr = (char *)(fibh.ebh->b_data +
+						   poffset - lfi);
+			else {
 				nameptr = fname;
 				memcpy(nameptr, fi->fileIdent + liu,
 				       lfi - poffset);
@@ -168,12 +174,13 @@ static int do_udf_readdir(struct inode *
 		}
 
 		if (flen) {
-			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0) {
+			if (filldir(dirent, fname, flen, filp->f_pos, iblock,
+				    dt_type) < 0) {
 				if (fibh.sbh != fibh.ebh)
 					brelse(fibh.ebh);
 				brelse(fibh.sbh);
 				brelse(epos.bh);
-	 			return 0;
+				return 0;
 			}
 		}
 	} /* end while */
@@ -222,7 +229,8 @@ static int udf_readdir(struct file *filp
 	lock_kernel();
 
 	if (filp->f_pos == 0) {
-		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
+		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino,
+			    DT_DIR) < 0) {
 			unlock_kernel();
 			return 0;
 		}
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

git-alsa.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
