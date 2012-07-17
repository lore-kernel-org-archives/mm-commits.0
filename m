From: akpm@linux-foundation.org
Subject: [merged] hfsplus-make-hfsplus_sync_fs-static.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:44 -0700
Message-ID: <20120717200445.2A0B9200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57501 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2GQUEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:46 -0400
Received: by mail-ee0-f74.google.com with SMTP id b47so48473eek.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: make hfsplus_sync_fs() static
has been removed from the -mm tree.  Its filename was
     hfsplus-make-hfsplus_sync_fs-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfsplus: make hfsplus_sync_fs() static

This patchset makes HFSPLUS file-system stop using the VFS
'->write_supers()' callback and the '->s_dirt' superblock field because I
plan to remove them once all users are gone.

Like the other similar patchsets, we switch to a delayed job for writing
out the superblock instead of using the 's_dirt' flag.  Additionally, this
patch-set includes several clean-ups.

Reminder:

The goal is to get rid of the 'sync_supers()' kernel thread.  This kernel
thread wakes up every 5 seconds (by default) and calls '->write_super()'
for all mounted file-systems.  And the bad thing is that this is done even
if all the superblocks are clean.  Moreover, many file-systems do not even
need this end they do not register the '->write_super()' method at all
(e.g., btrfs).

So 'sync_supers()' most often just generates useless wakeups and wastes
power.  I am trying to make all filesystems independent of
'->write_super()' and plan to remove 'sync_supers()' and '->write_super()'
completely once there are no more users.

Tested using the fsstress test from the LTP project.


This patch:

Make hfsplus_sync_fs() static because it is used only in fs/hfsplus/super.c.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |    1 -
 fs/hfsplus/super.c      |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-make-hfsplus_sync_fs-static fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-make-hfsplus_sync_fs-static
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -428,7 +428,6 @@ int hfsplus_show_options(struct seq_file
 
 /* super.c */
 struct inode *hfsplus_iget(struct super_block *, unsigned long);
-int hfsplus_sync_fs(struct super_block *sb, int wait);
 
 /* tables.c */
 extern u16 hfsplus_case_fold_table[];
diff -puN fs/hfsplus/super.c~hfsplus-make-hfsplus_sync_fs-static fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-make-hfsplus_sync_fs-static
+++ a/fs/hfsplus/super.c
@@ -161,7 +161,7 @@ static void hfsplus_evict_inode(struct i
 	}
 }
 
-int hfsplus_sync_fs(struct super_block *sb, int wait)
+static int hfsplus_sync_fs(struct super_block *sb, int wait)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
 	struct hfsplus_vh *vhdr = sbi->s_vhdr;
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

