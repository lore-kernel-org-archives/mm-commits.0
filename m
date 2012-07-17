From: akpm@linux-foundation.org
Subject: [merged] hfs-introduce-vfs-superblock-object-back-reference.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:32 -0700
Message-ID: <20120717200432.9B8C11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65360 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab2GQUEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:33 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so81417yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: introduce VFS superblock object back-reference
has been removed from the -mm tree.  Its filename was
     hfs-introduce-vfs-superblock-object-back-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
