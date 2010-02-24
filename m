From: akpm@linux-foundation.org
Subject: + ext4-fixup-rb_root-initializations-to-use-rb_root.patch added to -mm tree
Date: Wed, 24 Feb 2010 15:07:20 -0800
Message-ID: <201002242307.o1ON7KxD025799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181Ab0BXXHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 18:07:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, eparis@redhat.com, tytso@mit.edu


The patch titled
     ext4: fix up rb_root initializations to use RB_ROOT
has been added to the -mm tree.  Its filename is
     ext4-fixup-rb_root-initializations-to-use-rb_root.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
arch-x86-kernel-hpetc-fix-bug-in-rtc-emulation.patch
ext4-fixup-rb_root-initializations-to-use-rb_root.patch
ext3-fixup-rb_root-initializations-to-use-rb_root.patch
jffs2-fixup-rb_root-initializations-to-use-rb_root.patch

