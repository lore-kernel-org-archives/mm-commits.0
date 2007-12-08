From: akpm@linux-foundation.org
Subject: - ufs-fix-nexstep-dir-block-size.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:40 -0800
Message-ID: <200712080128.lB81SeDA013347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbXLHB3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, dsbailey@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     ufs: fix nexstep dir block size
has been removed from the -mm tree.  Its filename was
     ufs-fix-nexstep-dir-block-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: fix nexstep dir block size
From: Evgeniy Dushistov <dushistov@mail.ru>

This patch fixes regression, introduced since 2.6.16.  NextStep variant of
UFS as OpenStep uses directory block size equals to 1024.  Without this
change, ufs_check_page fails in many cases.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Dave Bailey <dsbailey@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c   |    2 +-
 fs/ufs/super.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ufs/dir.c~ufs-fix-nexstep-dir-block-size fs/ufs/dir.c
--- a/fs/ufs/dir.c~ufs-fix-nexstep-dir-block-size
+++ a/fs/ufs/dir.c
@@ -179,7 +179,7 @@ bad_entry:
 	goto fail;
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
-	ufs_error (sb, "ext2_check_page",
+	ufs_error(sb, __FUNCTION__,
 		   "entry in directory #%lu spans the page boundary"
 		   "offset=%lu",
 		   dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs);
diff -puN fs/ufs/super.c~ufs-fix-nexstep-dir-block-size fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-fix-nexstep-dir-block-size
+++ a/fs/ufs/super.c
@@ -755,13 +755,13 @@ static int ufs_fill_super(struct super_b
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP:
-		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep\n");
 		uspi->s_fsize = block_size = 1024;
 		uspi->s_fmask = ~(1024 - 1);
 		uspi->s_fshift = 10;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
+		uspi->s_dirblksize = 1024;
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
@@ -771,13 +771,13 @@ static int ufs_fill_super(struct super_b
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP_CD:
-		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep-cd\n");
 		uspi->s_fsize = block_size = 2048;
 		uspi->s_fmask = ~(2048 - 1);
 		uspi->s_fshift = 11;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
+		uspi->s_dirblksize = 1024;
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
