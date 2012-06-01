From: akpm@linux-foundation.org
Subject: [merged] fat-mark-superblock-as-dirty-less-often.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:26 -0700
Message-ID: <20120601193326.657D2A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56227 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2FATd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:27 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so246756qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: mark superblock as dirty less often
has been removed from the -mm tree.  Its filename was
     fat-mark-superblock-as-dirty-less-often.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fat: mark superblock as dirty less often

Preparation for further changes.  It touches few functions in fatent.c and
prevents them from marking the superblock as dirty unnecessarily often. 
Namely, instead of marking it as dirty in the internal tight loops - do it
only once at the end of the functions.  And instead of marking it as dirty
while holding the FAT table lock, do it outside the lock.

The reason for this patch is that marking the superblock as dirty will
soon become a little bit heavier operation, so it is cleaner to do this
only when it is necessary.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/fat/fatent.c~fat-mark-superblock-as-dirty-less-often fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-mark-superblock-as-dirty-less-often
+++ a/fs/fat/fatent.c
@@ -503,7 +503,6 @@ int fat_alloc_clusters(struct inode *ino
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				mark_fsinfo_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -525,11 +524,11 @@ int fat_alloc_clusters(struct inode *ino
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	mark_fsinfo_dirty(sb);
 	err = -ENOSPC;
 
 out:
 	unlock_fat(sbi);
+	mark_fsinfo_dirty(sb);
 	fatent_brelse(&fatent);
 	if (!err) {
 		if (inode_needs_sync(inode))
@@ -554,7 +553,7 @@ int fat_free_clusters(struct inode *inod
 	struct fat_entry fatent;
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, err, nr_bhs;
-	int first_cl = cluster;
+	int first_cl = cluster, dirty_fsinfo = 0;
 
 	nr_bhs = 0;
 	fatent_init(&fatent);
@@ -592,7 +591,7 @@ int fat_free_clusters(struct inode *inod
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			mark_fsinfo_dirty(sb);
+			dirty_fsinfo = 1;
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -622,6 +621,8 @@ error:
 	for (i = 0; i < nr_bhs; i++)
 		brelse(bhs[i]);
 	unlock_fat(sbi);
+	if (dirty_fsinfo)
+		mark_fsinfo_dirty(sb);
 
 	return err;
 }
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

origin.patch
linux-next.patch
fat-switch-to-fsinfo_inode.patch

