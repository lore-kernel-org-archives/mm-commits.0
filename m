From: akpm@linux-foundation.org
Subject: [folded] nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:32:40 -0700
Message-ID: <200904062232.n36MWeNJ016965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131AbZDFWe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:34:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: remove nilfs bmap wrapper macros
has been removed from the -mm tree.  Its filename was
     nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch

This patch was dropped because it was folded into nilfs2-integrated-block-mapping.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: remove nilfs bmap wrapper macros
From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes bunch of bmap wrapper macros from fs/nilfs/bmap.h.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |   16 ++++++++--------
 fs/nilfs2/bmap.h |    7 -------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff -puN fs/nilfs2/bmap.c~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros
+++ a/fs/nilfs2/bmap.c
@@ -100,7 +100,7 @@ static int nilfs_bmap_do_insert(struct n
 				bmap, keys, ptrs, NILFS_BMAP_SMALL_HIGH + 1);
 			if (n < 0)
 				return n;
-			ret = (*nilfs_bmap_large_convert_and_insert)(
+			ret = nilfs_btree_convert_and_insert(
 				bmap, key, ptr, keys, ptrs, n,
 				NILFS_BMAP_LARGE_LOW, NILFS_BMAP_LARGE_HIGH);
 			if (ret == 0)
@@ -157,7 +157,7 @@ static int nilfs_bmap_do_delete(struct n
 				bmap, keys, ptrs, NILFS_BMAP_LARGE_LOW + 1);
 			if (n < 0)
 				return n;
-			ret = (*nilfs_bmap_small_delete_and_convert)(
+			ret = nilfs_direct_delete_and_convert(
 				bmap, key, keys, ptrs, n,
 				NILFS_BMAP_SMALL_LOW, NILFS_BMAP_SMALL_HIGH);
 			if (ret == 0)
@@ -730,12 +730,12 @@ int nilfs_bmap_read(struct nilfs_bmap *b
 	}
 
 	return (bmap->b_u.u_flags & NILFS_BMAP_LARGE) ?
-		nilfs_bmap_large_init(bmap,
-				      NILFS_BMAP_LARGE_LOW,
-				      NILFS_BMAP_LARGE_HIGH) :
-		nilfs_bmap_small_init(bmap,
-				      NILFS_BMAP_SMALL_LOW,
-				      NILFS_BMAP_SMALL_HIGH);
+		nilfs_btree_init(bmap,
+				 NILFS_BMAP_LARGE_LOW,
+				 NILFS_BMAP_LARGE_HIGH) :
+		nilfs_direct_init(bmap,
+			   	  NILFS_BMAP_SMALL_LOW,
+				  NILFS_BMAP_SMALL_HIGH);
 }
 
 /**
diff -puN fs/nilfs2/bmap.h~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros
+++ a/fs/nilfs2/bmap.h
@@ -241,11 +241,4 @@ static inline void nilfs_bmap_clear_dirt
 #define NILFS_BMAP_LARGE_LOW	NILFS_BTREE_ROOT_NCHILDREN_MAX
 #define NILFS_BMAP_LARGE_HIGH	NILFS_BTREE_KEY_MAX
 
-#define nilfs_bmap_small_init			nilfs_direct_init
-#define nilfs_bmap_small_convert_and_insert	NULL
-#define nilfs_bmap_small_delete_and_convert	nilfs_direct_delete_and_convert
-#define nilfs_bmap_large_init			nilfs_btree_init
-#define nilfs_bmap_large_convert_and_insert	nilfs_btree_convert_and_insert
-#define nilfs_bmap_large_delete_and_convert	NULL
