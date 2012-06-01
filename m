From: akpm@linux-foundation.org
Subject: [merged] fat-introduce-mark_fsinfo_dirty-helper.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:24 -0700
Message-ID: <20120601193324.588B0A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44792 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2FATdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:25 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so245076ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: introduce mark_fsinfo_dirty helper
has been removed from the -mm tree.  Its filename was
     fat-introduce-mark_fsinfo_dirty-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fat: introduce mark_fsinfo_dirty helper

A preparation patch which introduces a 'mark_fsinfo_dirty()' helper
function which just sets the 's_dirt' flag to 1 so far.  I'll add more
code to this helper later, so I do not mark it as 'inline'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/fat/fatent.c~fat-introduce-mark_fsinfo_dirty-helper fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-introduce-mark_fsinfo_dirty-helper
+++ a/fs/fat/fatent.c
@@ -308,6 +308,11 @@ void fat_ent_access_init(struct super_bl
 	}
 }
 
+static void mark_fsinfo_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+
 static inline int fat_ent_update_ptr(struct super_block *sb,
 				     struct fat_entry *fatent,
 				     int offset, sector_t blocknr)
@@ -498,7 +503,7 @@ int fat_alloc_clusters(struct inode *ino
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				sb->s_dirt = 1;
+				mark_fsinfo_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -520,7 +525,7 @@ int fat_alloc_clusters(struct inode *ino
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_fsinfo_dirty(sb);
 	err = -ENOSPC;
 
 out:
@@ -587,7 +592,7 @@ int fat_free_clusters(struct inode *inod
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			sb->s_dirt = 1;
+			mark_fsinfo_dirty(sb);
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -677,7 +682,7 @@ int fat_count_free_clusters(struct super
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_fsinfo_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

origin.patch
linux-next.patch
fat-mark-superblock-as-dirty-less-often.patch
fat-switch-to-fsinfo_inode.patch

