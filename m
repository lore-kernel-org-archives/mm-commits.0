From: akpm@linux-foundation.org
Subject: - ufs-fix-sun-state.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:42:36 -0700
Message-ID: <200709270142.l8R1gamO013887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbXI0Bml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: fix sun state
has been removed from the -mm tree.  Its filename was
     ufs-fix-sun-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: fix sun state
From: Evgeniy Dushistov <dushistov@mail.ru>

Different types of ufs hold state in different places, to hide complexity
of this, there is ufs_get_fs_state, it returns state according to
"UFS_SB(sb)->s_flags", but during mount ufs_get_fs_state is called, before
setting s_flags, this cause message for ufs types like sun ufs: "fs need
fsck", and remount in readonly state.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ufs/super.c~ufs-fix-sun-state fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-fix-sun-state
+++ a/fs/ufs/super.c
@@ -894,7 +894,7 @@ magic_found:
 		goto again;
 	}
 
-
+	sbi->s_flags = flags;/*after that line some functions use s_flags*/
 	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
 	/*
@@ -1025,8 +1025,6 @@ magic_found:
 	    UFS_MOUNT_UFSTYPE_44BSD)
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
-	
-	sbi->s_flags = flags;
 
 	inode = iget(sb, UFS_ROOTINO);
 	if (!inode || is_bad_inode(inode))
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
ufs-convert-to-new-aops.patch
add-in-sunos-41x-compatible-mode-for-ufs.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix-2.patch
ufs-implement-show_options.patch
ufs-move-non-layout-parts-of-ufs_fsh-to-fs-ufs.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
