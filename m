From: akpm@linux-foundation.org
Subject: + hfs-introduce-vfs-superblock-object-back-reference.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:36:09 -0700
Message-ID: <20120613223609.ECC7AA0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52268 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FMWgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 18:36:11 -0400
Received: by eeit10 with SMTP id t10so57747eei.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:36:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfs: introduce VFS superblock object back-reference
has been added to the -mm tree.  Its filename is
     hfs-introduce-vfs-superblock-object-back-reference.patch

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
Subject: hfs: introduce VFS superblock object back-reference

Add an 'sb' VFS superblock back-reference to the 'struct hfs_sb_info' data
structure - we will need to find the VFS superblock from a 'struct
hfs_sb_info' object in the next patch, so this change is jut a
preparation.

Remove few useless newlines while on it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/hfs_fs.h |    6 +-----
 fs/hfs/super.c  |    1 +
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/hfs/hfs_fs.h~hfs-introduce-vfs-superblock-object-back-reference fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~hfs-introduce-vfs-superblock-object-back-reference
+++ a/fs/hfs/hfs_fs.h
@@ -137,16 +137,12 @@ struct hfs_sb_info {
 	gid_t s_gid;				/* The gid of all files */
 
 	int session, part;
-
 	struct nls_table *nls_io, *nls_disk;
-
 	struct mutex bitmap_lock;
-
 	unsigned long flags;
-
 	u16 blockoffset;
-
 	int fs_div;
+	struct super_block *sb;
 };
 
 #define HFS_FLG_BITMAP_DIRTY	0
diff -puN fs/hfs/super.c~hfs-introduce-vfs-superblock-object-back-reference fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-introduce-vfs-superblock-object-back-reference
+++ a/fs/hfs/super.c
@@ -380,6 +380,7 @@ static int hfs_fill_super(struct super_b
 	if (!sbi)
 		return -ENOMEM;
 
+	sbi->sb = sb;
 	sb->s_fs_info = sbi;
 
 	res = -EINVAL;
_
Subject: Subject: hfs: introduce VFS superblock object back-reference

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch

