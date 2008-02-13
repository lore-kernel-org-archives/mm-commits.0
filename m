From: akpm@linux-foundation.org
Subject: + udf-fix-directory-offset-handling.patch added to -mm tree
Date: Tue, 12 Feb 2008 23:00:48 -0800
Message-ID: <200802130702.m1D72CfY013050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbYBMHC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 02:02:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, marcin.slusarz@gmail.com


The patch titled
     udf: fix directory offset handling
has been added to the -mm tree.  Its filename is
     udf-fix-directory-offset-handling.patch

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
Subject: udf: fix directory offset handling
From: Jan Kara <jack@suse.cz>

Patch cleaning up UDF directory offset handling missed modifications in dir.c
(because I've submitted an old version :(). Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/dir.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/udf/dir.c~udf-fix-directory-offset-handling fs/udf/dir.c
--- a/fs/udf/dir.c~udf-fix-directory-offset-handling
+++ a/fs/udf/dir.c
@@ -43,13 +43,13 @@ static int do_udf_readdir(struct inode *
 	struct fileIdentDesc *fi = NULL;
 	struct fileIdentDesc cfi;
 	int block, iblock;
-	loff_t nf_pos = filp->f_pos - 1;
+	loff_t nf_pos = (filp->f_pos - 1) << 2;
 	int flen;
 	char fname[UDF_NAME_LEN];
 	char *nameptr;
 	uint16_t liu;
 	uint8_t lfi;
-	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
+	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	struct buffer_head *tmp, *bha[16];
 	kernel_lb_addr eloc;
 	uint32_t elen;
@@ -63,13 +63,13 @@ static int do_udf_readdir(struct inode *
 		return 0;
 
 	if (nf_pos == 0)
-		nf_pos = (udf_ext0_offset(dir) >> 2);
+		nf_pos = udf_ext0_offset(dir);
 
-	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset = nf_pos & (dir->i_sb->s_blocksize - 1);
 	iinfo = UDF_I(dir);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	} else if (inode_bmap(dir, nf_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
@@ -111,7 +111,7 @@ static int do_udf_readdir(struct inode *
 	}
 
 	while (nf_pos < size) {
-		filp->f_pos = nf_pos + 1;
+		filp->f_pos = (nf_pos >> 2) + 1;
 
 		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
@@ -178,7 +178,7 @@ static int do_udf_readdir(struct inode *
 		}
 	} /* end while */
 
-	filp->f_pos = nf_pos + 1;
+	filp->f_pos = (nf_pos >> 2) + 1;
 
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
udf-fix-directory-offset-handling.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
