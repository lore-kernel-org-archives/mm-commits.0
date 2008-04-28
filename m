From: akpm@linux-foundation.org
Subject: - reiserfs-le_add_cpu-conversion.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:14 -0700
Message-ID: <200804282201.m3SM1EAG018832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965684AbYD1WB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, chris.mason@oracle.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: le*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     reiserfs-le_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/objectid.c |    5 ++---
 fs/reiserfs/stree.c    |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/reiserfs/objectid.c~reiserfs-le_add_cpu-conversion fs/reiserfs/objectid.c
--- a/fs/reiserfs/objectid.c~reiserfs-le_add_cpu-conversion
+++ a/fs/reiserfs/objectid.c
@@ -114,7 +114,7 @@ void reiserfs_release_objectid(struct re
 		if (objectid_to_release == le32_to_cpu(map[i])) {
 			/* This incrementation unallocates the objectid. */
 			//map[i]++;
-			map[i] = cpu_to_le32(le32_to_cpu(map[i]) + 1);
+			le32_add_cpu(&map[i], 1);
 
 			/* Did we unallocate the last member of an odd sequence, and can shrink oids? */
 			if (map[i] == map[i + 1]) {
@@ -138,8 +138,7 @@ void reiserfs_release_objectid(struct re
 			/* size of objectid map is not changed */
 			if (objectid_to_release + 1 == le32_to_cpu(map[i + 1])) {
 				//objectid_map[i+1]--;
-				map[i + 1] =
-				    cpu_to_le32(le32_to_cpu(map[i + 1]) - 1);
+				le32_add_cpu(&map[i + 1], -1);
 				return;
 			}
 
diff -puN fs/reiserfs/stree.c~reiserfs-le_add_cpu-conversion fs/reiserfs/stree.c
--- a/fs/reiserfs/stree.c~reiserfs-le_add_cpu-conversion
+++ a/fs/reiserfs/stree.c
@@ -1419,8 +1419,7 @@ int reiserfs_delete_object(struct reiser
 
 		inode_generation =
 		    &REISERFS_SB(th->t_super)->s_rs->s_inode_generation;
-		*inode_generation =
-		    cpu_to_le32(le32_to_cpu(*inode_generation) + 1);
+		le32_add_cpu(inode_generation, 1);
 	}
 /* USE_INODE_GENERATION_COUNTER */
 #endif
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
ntfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

