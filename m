From: akpm@linux-foundation.org
Subject: + ufs-fix-symlink-creation-on-ufs2.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:53:21 -0800
Message-ID: <200801100753.m0A7r1PA011663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbYAJHxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:53:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru, stevenaaus@yahoo.com


The patch titled
     ufs: fix symlink creation on ufs2
has been added to the -mm tree.  Its filename is
     ufs-fix-symlink-creation-on-ufs2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: fix symlink creation on ufs2
From: Evgeniy Dushistov <dushistov@mail.ru>

If we create symlink on UFS2 filesystem under Linux, it looks wrong under
other OSes, because of max symlink length field was not initialized
properly, and data blocks were not used to save short symlink names.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Steven <stevenaaus@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ufs/super.c~ufs-fix-symlink-creation-on-ufs2 fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-fix-symlink-creation-on-ufs2
+++ a/fs/ufs/super.c
@@ -131,6 +131,8 @@ static void ufs_print_super_stuff(struct
 		printk(KERN_INFO"  cs_nffree(Num of free frags): %llu\n",
 		       (unsigned long long)
 		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
+		printk(KERN_INFO"  fs_maxsymlinklen: %u\n",
+		       usb3->fs_un2.fs_44.fs_maxsymlinklen);
 	} else {
 		printk(" sblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_sblkno));
 		printk(" cblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_cblkno));
@@ -1061,8 +1063,8 @@ magic_found:
 	uspi->s_bpf = uspi->s_fsize << 3;
 	uspi->s_bpfshift = uspi->s_fshift + 3;
 	uspi->s_bpfmask = uspi->s_bpf - 1;
-	if ((sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) ==
-	    UFS_MOUNT_UFSTYPE_44BSD)
+	if ((sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) == UFS_MOUNT_UFSTYPE_44BSD ||
+	    (sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) == UFS_MOUNT_UFSTYPE_UFS2)
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
 
_

Patches currently in -mm which might be from dushistov@mail.ru are

iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
ufs-fix-symlink-creation-on-ufs2.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
