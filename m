From: akpm@linux-foundation.org
Subject: + udf-fix-sparse-warnings.patch added to -mm tree
Date: Tue, 02 Dec 2008 12:01:32 -0800
Message-ID: <200812022001.mB2K1WY1020874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbYLBUBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 15:01:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net


The patch titled
     udf: fix sparse warnings
has been added to the -mm tree.  Its filename is
     udf-fix-sparse-warnings.patch

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

linux-next.patch
udf-fix-sparse-warnings.patch
hugetlb-fix-sparse-warnings.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch
pm3fb-fix-sparse-warning.patch
neofb-fix-sparse-warnings.patch
i810-fix-sparse-warnings.patch
intelfb-fix-sparse-warnings.patch

