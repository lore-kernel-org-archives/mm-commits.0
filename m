From: akpm@linux-foundation.org
Subject: + udf-fix-sparse-warning-in-nameic.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:17:05 -0800
Message-ID: <200802181018.m1IAI3MY019867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757533AbYBRKSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jack@ucw.cz


The patch titled
     udf: fix sparse warning in namei.c
has been added to the -mm tree.  Its filename is
     udf-fix-sparse-warning-in-nameic.patch

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
Subject: udf: fix sparse warning in namei.c
From: Harvey Harrison <harvey.harrison@gmail.com>

Let's use bsize instead.
fs/udf/namei.c:960:12: warning: symbol 'elen' shadows an earlier one
fs/udf/namei.c:937:15: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/udf/namei.c~udf-fix-sparse-warning-in-nameic fs/udf/namei.c
--- a/fs/udf/namei.c~udf-fix-sparse-warning-in-nameic
+++ a/fs/udf/namei.c
@@ -957,7 +957,7 @@ static int udf_symlink(struct inode *dir
 
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 		kernel_lb_addr eloc;
-		uint32_t elen;
+		uint32_t bsize;
 
 		block = udf_new_block(inode->i_sb, inode,
 				iinfo->i_location.partitionReferenceNum,
@@ -970,9 +970,9 @@ static int udf_symlink(struct inode *dir
 		eloc.logicalBlockNum = block;
 		eloc.partitionReferenceNum =
 				iinfo->i_location.partitionReferenceNum;
-		elen = inode->i_sb->s_blocksize;
-		iinfo->i_lenExtents = elen;
-		udf_add_aext(inode, &epos, eloc, elen, 0);
+		bsize = inode->i_sb->s_blocksize;
+		iinfo->i_lenExtents = bsize;
+		udf_add_aext(inode, &epos, eloc, bsize, 0);
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
cifs-remove-global_extern-macro.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-replace-macro-with-static-inline-in-libatah.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
