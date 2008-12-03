From: akpm@linux-foundation.org
Subject: - udf-fix-sparse-warnings.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:29:03 -0800
Message-ID: <200812032029.mB3KT3V8028305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762949AbYLCUiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:38:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, mm-commits@vger.kernel.org


The patch titled
     udf: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     udf-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>

Fix these sparse warnings:

  fs/udf/balloc.c:843:3: warning: returning void-valued expression
  fs/udf/balloc.c:847:3: warning: returning void-valued expression
  fs/udf/balloc.c:851:3: warning: returning void-valued expression
  fs/udf/balloc.c:855:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/udf/balloc.c~udf-fix-sparse-warnings fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-fix-sparse-warnings
+++ a/fs/udf/balloc.c
@@ -840,21 +840,21 @@ void udf_free_blocks(struct super_block 
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
 	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
-		return udf_bitmap_free_blocks(sb, inode,
-					      map->s_uspace.s_bitmap,
-					      bloc, offset, count);
+		udf_bitmap_free_blocks(sb, inode, map->s_uspace.s_bitmap,
+				       bloc, offset, count);
+		return;
 	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
-		return udf_table_free_blocks(sb, inode,
-					     map->s_uspace.s_table,
-					     bloc, offset, count);
+		udf_table_free_blocks(sb, inode, map->s_uspace.s_table,
+				      bloc, offset, count);
+		return;
 	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
-		return udf_bitmap_free_blocks(sb, inode,
-					      map->s_fspace.s_bitmap,
-					      bloc, offset, count);
+		udf_bitmap_free_blocks(sb, inode, map->s_fspace.s_bitmap,
+				       bloc, offset, count);
+		return;
 	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
-		return udf_table_free_blocks(sb, inode,
-					     map->s_fspace.s_table,
-					     bloc, offset, count);
+		udf_table_free_blocks(sb, inode, map->s_fspace.s_table,
+				      bloc, offset, count);
+		return;
 	} else {
 		return;
 	}
_

Patches currently in -mm which might be from hannes@hanneseder.net are

origin.patch
linux-next.patch
hugetlb-fix-sparse-warnings.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch
pm3fb-fix-sparse-warning.patch
neofb-fix-sparse-warnings.patch
i810-fix-sparse-warnings.patch
intelfb-fix-sparse-warnings.patch

