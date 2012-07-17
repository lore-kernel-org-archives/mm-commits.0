From: akpm@linux-foundation.org
Subject: [merged] hfs-remove-extra-mdb-write-on-unmount.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:26 -0700
Message-ID: <20120717200426.C47341E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58151 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab2GQUE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:27 -0400
Received: by ghbz15 with SMTP id z15so81202ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: remove extra mdb write on unmount
has been removed from the -mm tree.  Its filename was
     hfs-remove-extra-mdb-write-on-unmount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

