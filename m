From: akpm@linux-foundation.org
Subject: [merged] ext4-fixup-rb_root-initializations-to-use-rb_root.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:59 -0800
Message-ID: <201003091911.o29JBxUG031781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994Ab0CITWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, eparis@redhat.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext4: fix up rb_root initializations to use RB_ROOT
has been removed from the -mm tree.  Its filename was
     ext4-fixup-rb_root-initializations-to-use-rb_root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix up rb_root initializations to use RB_ROOT
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

ext4 uses rb_node = NULL; to zero rb_root at few places.

The problem with this is that 17d9ddc72fb8bba0d4f678 ("rbtree: Add support
for augmented rbtrees") in the linux-next tree adds a new field to that
struct which needs to be NULLas well.  This patch uses RB_ROOT as the
intializer so all of the relevant fields will be NULL'd.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/block_validity.c |    4 ++--
 fs/ext4/dir.c            |    2 +-
 fs/ext4/mballoc.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext4/block_validity.c~ext4-fixup-rb_root-initializations-to-use-rb_root fs/ext4/block_validity.c
--- a/fs/ext4/block_validity.c~ext4-fixup-rb_root-initializations-to-use-rb_root
+++ a/fs/ext4/block_validity.c
@@ -205,14 +205,14 @@ void ext4_release_system_zone(struct sup
 		entry = rb_entry(n, struct ext4_system_zone, node);
 		kmem_cache_free(ext4_system_zone_cachep, entry);
 		if (!parent)
-			EXT4_SB(sb)->system_blks.rb_node = NULL;
+			EXT4_SB(sb)->system_blks = RB_ROOT;
 		else if (parent->rb_left == n)
 			parent->rb_left = NULL;
 		else if (parent->rb_right == n)
 			parent->rb_right = NULL;
 		n = parent;
 	}
-	EXT4_SB(sb)->system_blks.rb_node = NULL;
+	EXT4_SB(sb)->system_blks = RB_ROOT;
 }
 
 /*
diff -puN fs/ext4/dir.c~ext4-fixup-rb_root-initializations-to-use-rb_root fs/ext4/dir.c
--- a/fs/ext4/dir.c~ext4-fixup-rb_root-initializations-to-use-rb_root
+++ a/fs/ext4/dir.c
@@ -303,7 +303,7 @@ static void free_rb_tree_fname(struct rb
 			kfree(old);
 		}
 		if (!parent)
-			root->rb_node = NULL;
+			*root = RB_ROOT;
 		else if (parent->rb_left == n)
 			parent->rb_left = NULL;
 		else if (parent->rb_right == n)
diff -puN fs/ext4/mballoc.c~ext4-fixup-rb_root-initializations-to-use-rb_root fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-fixup-rb_root-initializations-to-use-rb_root
+++ a/fs/ext4/mballoc.c
@@ -2256,7 +2256,7 @@ int ext4_mb_add_groupinfo(struct super_b
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
-	meta_group_info[i]->bb_free_root.rb_node = NULL;
+	meta_group_info[i]->bb_free_root = RB_ROOT;
 
 #ifdef DOUBLE_CHECK
 	{
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

linux-next.patch
arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch
cpufreq-unexport-unlock_policy_rwsem-functions.patch
cpufreq-fix-a-lockdep-warning.patch
jffs2-fixup-rb_root-initializations-to-use-rb_root.patch
ext3-fixup-rb_root-initializations-to-use-rb_root.patch

