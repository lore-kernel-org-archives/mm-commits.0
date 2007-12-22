From: akpm@linux-foundation.org
Subject: - udf-improve-readability-of-do_udf_readdir.patch removed from -mm tree
Date: Fri, 21 Dec 2007 16:21:39 -0800
Message-ID: <200712220021.lBM0Ld2r006373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbXLVAVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: improve readability of do_udf_readdir
has been removed from the -mm tree.  Its filename was
     udf-improve-readability-of-do_udf_readdir.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: udf: improve readability of do_udf_readdir
From: Marcin Slusarz <marcin.slusarz@gmail.com>

make reading do_udf_readdir easier by adding new variable

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/dir.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/udf/dir.c~udf-improve-readability-of-do_udf_readdir fs/udf/dir.c
--- a/fs/udf/dir.c~udf-improve-readability-of-do_udf_readdir
+++ a/fs/udf/dir.c
@@ -57,6 +57,7 @@ static int do_udf_readdir(struct inode *
 	int i, num;
 	unsigned int dt_type;
 	struct extent_position epos = { NULL, 0, {0, 0} };
+	unsigned char bits;
 
 	if (nf_pos >= size)
 		return 0;
@@ -65,12 +66,14 @@ static int do_udf_readdir(struct inode *
 		nf_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	bits = dir->i_sb->s_blocksize_bits;
+
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	} else if (inode_bmap(dir, nf_pos >> (bits - 2),
 			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
+		if ((++offset << bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
@@ -84,10 +87,10 @@ static int do_udf_readdir(struct inode *
 			return -EIO;
 		}
 
-		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
-			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i + offset > (elen >> dir->i_sb->s_blocksize_bits))
-				i = (elen >> dir->i_sb->s_blocksize_bits) - offset;
+		if (!(offset & ((16 >> (bits - 9)) - 1))) {
+			i = 16 >> (bits - 9);
+			if (i + offset > (elen >> bits))
+				i = (elen >> bits) - offset;
 			for (num = 0; i > 0; i--) {
 				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

git-alsa.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
udf-improve-readability-of-do_udf_readdir.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
