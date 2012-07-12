From: akpm@linux-foundation.org
Subject: + hfs-get-rid-of-hfs_sync_super-v2.patch added to -mm tree
Date: Thu, 12 Jul 2012 16:15:40 -0700
Message-ID: <20120712231541.1D8C2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49987 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162656Ab2GLXPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 19:15:44 -0400
Received: by eaao13 with SMTP id o13so150535eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 16:15:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfs: get rid of hfs_sync_super
has been added to the -mm tree.  Its filename is
     hfs-get-rid-of-hfs_sync_super-v2.patch

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
Subject: hfs: get rid of hfs_sync_super

Remove enough to just cancel the job, we need to set the work_queued flag
to zero as well.  I could do this, but it is simpler to just remove this
tiny optimization - we do not gain much with it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/mdb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hfs/mdb.c~hfs-get-rid-of-hfs_sync_super-v2 fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-get-rid-of-hfs_sync_super-v2
+++ a/fs/hfs/mdb.c
@@ -263,8 +263,6 @@ void hfs_mdb_commit(struct super_block *
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
-	cancel_delayed_work(&HFS_SB(sb)->mdb_work);
-
 	lock_buffer(HFS_SB(sb)->mdb_bh);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
_
Subject: Subject: hfs: get rid of hfs_sync_super

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
hfs-get-rid-of-hfs_sync_super-v2.patch
hfsplus-make-hfsplus_sync_fs-static.patch
hfsplus-amend-debugging-print.patch
hfsplus-remove-useless-check.patch
hfsplus-get-rid-of-write_super.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
fs-ufs-remove-extra-superblock-write-on-unmount.patch
fs-ufs-re-arrange-the-code-a-bit.patch
fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch
fs-ufs-get-rid-of-write_super.patch

