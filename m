From: akpm@linux-foundation.org
Subject: - ufs-fix-symlink-creation-on-ufs2.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:32 -0800
Message-ID: <200802082016.m18KGDAZ010695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbYBHUuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, stevenaaus@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     ufs: fix symlink creation on ufs2
has been removed from the -mm tree.  Its filename was
     ufs-fix-symlink-creation-on-ufs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: fix symlink creation on ufs2
From: Evgeniy Dushistov <dushistov@mail.ru>

If we create symlink on UFS2 filesystem under Linux, it looks wrong under
other OSes, because of max symlink length field was not initialized
properly, and data blocks were not used to save short symlink names.

[akpm@linux-foundation.org: add missing fs32_to_cpu()]
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
+		       fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen));
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

origin.patch
