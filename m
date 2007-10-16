From: akpm@linux-foundation.org
Subject: - ext2-statfs-improvement-for-block-and-inode-free-count.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:41:24 -0700
Message-ID: <200710162241.l9GMfO41021504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761425AbXJPWmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, adilger@clusterfs.com, mm-commits@vger.kernel.org


The patch titled
     ext2 statfs improvement for block and inode free count
has been removed from the -mm tree.  Its filename was
     ext2-statfs-improvement-for-block-and-inode-free-count.patch

This patch was dropped because it was withdrawn

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
@@ -1150,13 +1150,13 @@ static int ext2_statfs (struct dentry * 
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
aio-account-i-o-wait-time-properly.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
mem-controller-gfp-mask-fix.patch
powerpc-add-scaled-time-accounting-speedup.patch
