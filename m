From: akpm@linux-foundation.org
Subject: + fs-ufs-remove-extra-superblock-write-on-unmount.patch added to -mm tree
Date: Thu, 12 Jul 2012 15:55:29 -0700
Message-ID: <20120712225529.AF685100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59922 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162218Ab2GLWzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 18:55:31 -0400
Received: by vcqp1 with SMTP id p1so38624vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 15:55:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, dushistov@mail.ru, viro@ZenIV.linux.org.uk


The patch titled
     Subject: fs/ufs: remove extra superblock write on unmount
has been added to the -mm tree.  Its filename is
     fs-ufs-remove-extra-superblock-write-on-unmount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_put_super_internal(sb);
 	
_
Subject: Subject: fs/ufs: remove extra superblock write on unmount

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
hfsplus-make-hfsplus_sync_fs-static.patch
hfsplus-amend-debugging-print.patch
hfsplus-remove-useless-check.patch
hfsplus-get-rid-of-write_super.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
fs-ufs-remove-extra-superblock-write-on-unmount.patch
fs-ufs-re-arrange-the-code-a-bit.patch
fs-ufs-get-rid-of-write_super.patch

