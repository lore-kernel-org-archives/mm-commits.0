From: akpm@linux-foundation.org
Subject: + hfs-remove-extra-mdb-write-on-unmount.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:36:05 -0700
Message-ID: <20120613223605.DCAA4A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44572 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2FMWgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 18:36:08 -0400
Received: by bkty5 with SMTP id y5so57318bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:36:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfs: remove extra mdb write on unmount
has been added to the -mm tree.  Its filename is
     hfs-remove-extra-mdb-write-on-unmount.patch

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
Subject: hfs: remove extra mdb write on unmount

HFS calls 'hfs_write_super()' from 'hfs_put_super()' in order to write the
MDB to the media.  However, it is not needed because VFS calls
'->sync_fs()' before calling '->put_super()' - so by the time we are in
'hfs_write_super()', the MDB is already synchronized.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/super.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hfs/super.c~hfs-remove-extra-mdb-write-on-unmount fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-remove-extra-mdb-write-on-unmount
+++ a/fs/hfs/super.c
@@ -74,8 +74,6 @@ static int hfs_sync_fs(struct super_bloc
  */
 static void hfs_put_super(struct super_block *sb)
 {
-	if (sb->s_dirt)
-		hfs_write_super(sb);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
 	hfs_mdb_put(sb);
_
Subject: Subject: hfs: remove extra mdb write on unmount

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch

