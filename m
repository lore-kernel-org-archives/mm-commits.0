From: akpm@osdl.org
Subject: + ufs2-write-mount-as-rw.patch added to -mm tree
Date: Mon, 29 Jan 2007 16:56:43 -0800
Message-ID: <200701300056.l0U0uhcT004724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964860AbXA3A4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 19:56:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     ufs2 write: mount as rw
has been added to the -mm tree.  Its filename is
     ufs2-write-mount-as-rw.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs2 write: mount as rw
From: Evgeniy Dushistov <dushistov@mail.ru>

These series of patches add UFS2 write-support.  UFS2 - is default file system
for recent versions of FreeBSD.

The main differences from UFS1 from write support point of view
are:
1)Not all inodes are allocated during formatation of disk.
2)All meta-data(pointer to data blocks) are 64bit(in UFS1 they
are 32bit).

So patch series consist of
1)make possible mount UFS2 in read-write mode
2)code to write ufs2 inodes and code to initialize inodes chunks.
3)work with 64bit meta-data

I made simple testing like create/deleting/writing/reading/truncating, also I
ran fsx-linux and untar and build kernel on UFS1 and UFS2, after that FreeBSD
fsck do not find any errors in fs.

This patch makes possible to mount ufs2 "rw", and updates UFS2 documentation:
remove note about bug(it fixed by reallocate blocks on the fly patch) and add
me in the list of people who want receive bug reports.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/ufs.txt |    9 ++++-----
 fs/ufs/super.c                    |    9 ++++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/ufs.txt~ufs2-write-mount-as-rw Documentation/filesystems/ufs.txt
--- a/Documentation/filesystems/ufs.txt~ufs2-write-mount-as-rw
+++ a/Documentation/filesystems/ufs.txt
@@ -21,7 +21,7 @@ ufstype=type_of_ufs
 		supported as read-write
 
 	ufs2    used in FreeBSD 5.x
-		supported as read-only
+		supported as read-write
 
 	5xbsd	synonym for ufs2
 
@@ -50,12 +50,11 @@ ufstype=type_of_ufs
 POSSIBLE PROBLEMS
 =================
 
-There is still bug in reallocation of fragment, in file fs/ufs/balloc.c, 
-line 364. But it seems working on current buffer cache configuration.
+See next section, if you have any.
 
 
 BUG REPORTS
 ===========
 
-Any ufs bug report you can send to daniel.pirkl@email.cz (do not send 
-partition tables bug reports.)
+Any ufs bug report you can send to daniel.pirkl@email.cz or
+to dushistov@mail.ru (do not send partition tables bug reports).
diff -puN fs/ufs/super.c~ufs2-write-mount-as-rw fs/ufs/super.c
--- a/fs/ufs/super.c~ufs2-write-mount-as-rw
+++ a/fs/ufs/super.c
@@ -61,6 +61,8 @@
  * UFS2 (of FreeBSD 5.x) support added by
  * Niraj Kumar <niraj17@iitbombay.org>, Jan 2004
  *
+ * UFS2 write support added by
+ * Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
 
 
@@ -674,10 +676,6 @@ static int ufs_fill_super(struct super_b
 		uspi->s_sbsize = super_block_size = 1536;
 		uspi->s_sbbase =  0;
 		flags |= UFS_TYPE_UFS2 | UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;
-		if (!(sb->s_flags & MS_RDONLY)) {
-			printk(KERN_INFO "ufstype=ufs2 is supported read-only\n");
-			sb->s_flags |= MS_RDONLY;
- 		}
 		break;
 		
 	case UFS_MOUNT_UFSTYPE_SUN:
@@ -1153,7 +1151,8 @@ static int ufs_remount (struct super_blo
 #else
 		if (ufstype != UFS_MOUNT_UFSTYPE_SUN && 
 		    ufstype != UFS_MOUNT_UFSTYPE_44BSD &&
-		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86) {
+		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
+		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from dushistov@mail.ru are

ufs-alloc-metadata-null-page-fix.patch
ufs-truncate-negative-to-unsigned-fix.patch
ufs-rellocation-fix.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch
