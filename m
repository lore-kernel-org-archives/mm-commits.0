From: akpm@linux-foundation.org
Subject: [merged] befs-dont-pass-huge-structs-by-value.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:15 -0800
Message-ID: <201101132010.p0DKAuTg030107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703Ab1AMUR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:17:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, geert@linux-m68k.org, will_dyson@pobox.com, mm-commits@vger.kernel.org


The patch titled
     befs: don't pass huge structs by value
has been removed from the -mm tree.  Its filename was
     befs-dont-pass-huge-structs-by-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: befs: don't pass huge structs by value
From: Jesper Juhl <jj@chaosbits.net>

'struct befs_disk_data_stream' is huge (~144 bytes) and it's being passed
by value in fs/befs/endian.h::cpu_to_fsrun().

It would be better to pass a pointer.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Will Dyson <will_dyson@pobox.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/endian.h   |   16 ++++++++--------
 fs/befs/linuxvfs.c |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/befs/endian.h~befs-dont-pass-huge-structs-by-value fs/befs/endian.h
--- a/fs/befs/endian.h~befs-dont-pass-huge-structs-by-value
+++ a/fs/befs/endian.h
@@ -102,22 +102,22 @@ cpu_to_fsrun(const struct super_block *s
 }
 
 static inline befs_data_stream
-fsds_to_cpu(const struct super_block *sb, befs_disk_data_stream n)
+fsds_to_cpu(const struct super_block *sb, const befs_disk_data_stream *n)
 {
 	befs_data_stream data;
 	int i;
 
 	for (i = 0; i < BEFS_NUM_DIRECT_BLOCKS; ++i)
-		data.direct[i] = fsrun_to_cpu(sb, n.direct[i]);
+		data.direct[i] = fsrun_to_cpu(sb, n->direct[i]);
 
-	data.max_direct_range = fs64_to_cpu(sb, n.max_direct_range);
-	data.indirect = fsrun_to_cpu(sb, n.indirect);
-	data.max_indirect_range = fs64_to_cpu(sb, n.max_indirect_range);
-	data.double_indirect = fsrun_to_cpu(sb, n.double_indirect);
+	data.max_direct_range = fs64_to_cpu(sb, n->max_direct_range);
+	data.indirect = fsrun_to_cpu(sb, n->indirect);
+	data.max_indirect_range = fs64_to_cpu(sb, n->max_indirect_range);
+	data.double_indirect = fsrun_to_cpu(sb, n->double_indirect);
 	data.max_double_indirect_range = fs64_to_cpu(sb,
-						     n.
+						     n->
 						     max_double_indirect_range);
-	data.size = fs64_to_cpu(sb, n.size);
+	data.size = fs64_to_cpu(sb, n->size);
 
 	return data;
 }
diff -puN fs/befs/linuxvfs.c~befs-dont-pass-huge-structs-by-value fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-dont-pass-huge-structs-by-value
+++ a/fs/befs/linuxvfs.c
@@ -390,7 +390,7 @@ static struct inode *befs_iget(struct su
 		int num_blks;
 
 		befs_ino->i_data.ds =
-		    fsds_to_cpu(sb, raw_inode->data.datastream);
+		    fsds_to_cpu(sb, &raw_inode->data.datastream);
 
 		num_blks = befs_count_blocks(sb, &befs_ino->i_data.ds);
 		inode->i_blocks =
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch
audit-always-follow-va_copy-with-va_end.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

