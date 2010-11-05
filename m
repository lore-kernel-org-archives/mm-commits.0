From: akpm@linux-foundation.org
Subject: [merged] fs-btrfs-use-err_cast.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:29:12 -0700
Message-ID: <201011051830.oA5IUsOX025680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab0KESbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/btrfs: use ERR_CAST
has been removed from the -mm tree.  Its filename was
     fs-btrfs-use-err_cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/btrfs: use ERR_CAST
From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_map.c |    4 ++--
 fs/btrfs/super.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/btrfs/extent_map.c~fs-btrfs-use-err_cast fs/btrfs/extent_map.c
--- a/fs/btrfs/extent_map.c~fs-btrfs-use-err_cast
+++ a/fs/btrfs/extent_map.c
@@ -335,7 +335,7 @@ struct extent_map *lookup_extent_mapping
 		goto out;
 	}
 	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
+		em = ERR_CAST(rb_node);
 		goto out;
 	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
@@ -384,7 +384,7 @@ struct extent_map *search_extent_mapping
 		goto out;
 	}
 	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
+		em = ERR_CAST(rb_node);
 		goto out;
 	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
diff -puN fs/btrfs/super.c~fs-btrfs-use-err_cast fs/btrfs/super.c
--- a/fs/btrfs/super.c~fs-btrfs-use-err_cast
+++ a/fs/btrfs/super.c
@@ -381,7 +381,7 @@ static struct dentry *get_default_root(s
 find_root:
 	new_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
 	if (IS_ERR(new_root))
-		return ERR_PTR(PTR_ERR(new_root));
+		return ERR_CAST(new_root);
 
 	if (btrfs_root_refs(&new_root->root_item) == 0)
 		return ERR_PTR(-ENOENT);
_

Patches currently in -mm which might be from julia@diku.dk are

fs-btrfs-inodec-eliminate-memory-leak.patch

