From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-remove-extra-superblock-write-on-unmount.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:04 -0700
Message-ID: <20120717200504.A36231E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35601 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2GQUFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:05 -0400
Received: by qcqs25 with SMTP id s25so81857qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, dushistov@mail.ru, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: remove extra superblock write on unmount
has been removed from the -mm tree.  Its filename was
     fs-ufs-remove-extra-superblock-write-on-unmount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fs/ufs: remove extra superblock write on unmount

This patchset makes UFS file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove
them once all users are gone.

Like some other similar patch-sets (affs, hfs, hfsplus, reiserfs), we
switch to a delayed job for writing out the superblock instead of using
the 's_dirt' flag.  Additionally, this patch-set includes several
clean-ups.

Tested using the fsstress test from the LTP project.


This patch: remove extra superblock write on unmount

UFS calls 'ufs_write_super()' from 'ufs_put_super()' in order to write the
superblocks to the media.  However, it is not needed because VFS calls
'->sync_fs()' before calling '->put_super()' - so by the time we are in
'ufs_write_super()', the superblocks are already synchronized.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-remove-extra-superblock-write-on-unmount fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-remove-extra-superblock-write-on-unmount
+++ a/fs/ufs/super.c
@@ -1238,9 +1238,6 @@ static void ufs_put_super(struct super_b
 		
 	UFSD("ENTER\n");
 
-	if (sb->s_dirt)
-		ufs_write_super(sb);
