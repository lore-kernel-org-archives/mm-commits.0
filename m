From: akpm@linux-foundation.org
Subject: + fat-introduce-mark_fsinfo_dirty-helper.patch added to -mm tree
Date: Wed, 09 May 2012 16:07:25 -0700
Message-ID: <20120509230725.DDC1EA026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62274 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755Ab2EIXH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2012 19:07:27 -0400
Received: by qcsp5 with SMTP id p5so125955qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 09 May 2012 16:07:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk


The patch titled
     Subject: fat: introduce mark_fsinfo_dirty helper
has been added to the -mm tree.  Its filename is
     fat-introduce-mark_fsinfo_dirty-helper.patch

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
Subject: Subject: fat: introduce mark_fsinfo_dirty helper

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
fat-introduce-special-inode-for-managing-the-fsinfo-block.patch
fat-introduce-mark_fsinfo_dirty-helper.patch
fat-mark-superblock-as-dirty-less-often.patch
fat-switch-to-fsinfo_inode.patch

