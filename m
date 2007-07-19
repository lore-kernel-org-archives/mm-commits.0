From: akpm@linux-foundation.org
Subject: + ext2-statfs-improvement-for-block-and-inode-free-count.patch added to -mm tree
Date: Wed, 18 Jul 2007 20:18:14 -0700
Message-ID: <200707190318.l6J3IEdX011198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756945AbXGSDSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 23:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, adilger@clusterfs.com


The patch titled
     ext2 statfs improvement for block and inode free count
has been added to the -mm tree.  Its filename is
     ext2-statfs-improvement-for-block-and-inode-free-count.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2 statfs improvement for block and inode free count
From: Badari Pulavarty <pbadari@us.ibm.com>

More statfs() improvements for ext2.  ext2 already maintains percpu
counters for free blocks and inodes.  Derive free block count and inode
count by summing up percpu counters, instead of counting up all the groups
in the filesystem each time.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext2/super.c~ext2-statfs-improvement-for-block-and-inode-free-count fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-statfs-improvement-for-block-and-inode-free-count
+++ a/fs/ext2/super.c
@@ -1141,13 +1141,13 @@ static int ext2_statfs (struct dentry * 
 	buf->f_type = EXT2_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
-	buf->f_bfree = ext2_count_free_blocks(sb);
+	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
 	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
-	buf->f_ffree = ext2_count_free_inodes(sb);
+	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
 	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT2_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
fix-for-ext2-reservation.patch
