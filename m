Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500669;
	b=jtMCs9QMhsIc+8JssqnETUREyRzg9ElSEByPXadeGRNpWUDqH9yD8oUYlOzp/DAFLNFm
	 2X2Rvd3Rr8YVQoEdElAOJVphvHDvynI78rxEx/j5XulI6rhO2A8G+diqXBCob3xMP9CD5
	 TV6KN8bvbKd5pAnQK4weH+EJjpGUJkHztFjyOVSHojrRsokXBqLgq05MXxzIzhSQm3avQ
	 SJ2GdIH4AiMQegQ7d7nTjujtiToYlWt7BnT750Ss8EZvCt2kEnXs0Yx3jzCk0MtCmj/DO
	 HxwRf07/0Z78w0QKOvUBo2/f672m3PvKvoXCQvwQKwyIB522S5QjCaAqNXqsBpgyVmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500669;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=e9SobyGlrR+cESi5q4h8gNJYYO+xrXR1UXlRrRrvWfQ=;
	b=IImdajPlKvzm2eOueo+GUKbflwRsGozQLPPxzgO/0YED8YJwLpvp2RaAr/No/7sJQxW9
	 7EYF452+elEWIrt0oQWAB4gdotAAADbcoLfzTYPUcXTo2tzfg2EKXnLnoQedrv5BUypxt
	 icXn+mVOGGs4JqjDCROV1dt4ClqIbutHYJDHACuTFcesalqDJiAC0/9SFVGOFZmRYTROZ
	 jbjggvh1/ci31doMSV6MP0YU/VNAoPxpuuN2FEHXGqsoKnVXLNThaWTlTI1eEG06bMb5K
	 ymY/6QQmkDeaIlUzf8Mppj61dmrHVLTLeeFIO+yoW3bDUHNjrFXumldaslR+dQsjfTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rYiwFhaS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0E2606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 06:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rYiwFhaS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246401F000D3;
	Tue, 24 Nov 2026 06:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795500669;
	bh=e9SobyGlrR+cESi5q4h8gNJYYO+xrXR1UXlRrRrvWfQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=rYiwFhaSRHqeRS4RsYrbicRbqo0y7C6iiiIQVqG3NBMl9O7IF462bz+6PGb9cMkLf
	 yoZKlPpSgd2dqRwJ/ILSnTNoDhnN/TBKdZArhH+vgez8ZguO/ZP4KbPgViciswd+s9
	 mi9EN1GyPaegAuiAoHqsqVeghxl58YYVRxCA0dqY=
Date: Mon, 23 Nov 2026 22:11:08 -0800
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,
	matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261026163941.495833-2-matheus.aalmeida@inf.ufrgs.br>
References: <20261026163941.495833-2-matheus.aalmeida@inf.ufrgs.br>
Subject: [merged] fat-batch-synchronous-mirror-writes.patch removed from -mm tree
Message-Id: <20261124061109.246401F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: batch synchronous mirror writes
has been removed from the -mm tree.  Its filename was
     fat-batch-synchronous-mirror-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Subject: fat: batch synchronous mirror writes
Date: Mon, 26 Oct 2026 13:39:40 -0300

Patch series "fat: improve synchronous mount performance", v2.

This series improves performance on synchronous mounts by batching FAT
mirror writes and improving fat_sync_bhs() submission.

The benchmarks were run on top of my other FAT allocation batching changes
currently in linux-next.


This patch (of 2):

fat_mirror_bhs() currently synchronizes buffer-by-buffer on synchronous
mounts, serializing I/O and degrading performance.

Make fat_mirror_bhs() batch dirty buffer heads and use fat_sync_bhs() to
sync several at once.  Add a fat_brelse_array() helper that releases
buffer heads in an array.

Benchmarking was done under QEMU/KVM with a virtio-blk device using
cache=directsync.  Each result is the arithmetic mean of 10 samples.

start = now_ns();
for (unsigned i = 0; i < count; i++) {
	fallocate(fds[i], FALLOC_FL_KEEP_SIZE, 0, bytes);
}
elapsed = now_ns() - start;

Sync-mounted FAT32 using count=16 files:
File size    Cluster size    Before    After    Improvement
256MiB       512B            49.81s    12.26s   4.06x
1MiB         512B            0.198s    0.057s   3.50x
256MiB       4096B           7.060s    1.640s   4.31x
1MiB         4096B           0.073s    0.028s   2.60x

Asynchronous mounts were also benchmarked with no noticeable performance
change.

Link: https://lore.kernel.org/20261026163941.495833-1-matheus.aalmeida@inf.ufrgs.br
Link: https://patch.msgid.link/20261026163941.495833-2-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

 fs/fat/fat.h    |    1 
 fs/fat/fatent.c |   80 ++++++++++++++++++++++++++++++++--------------
 fs/fat/misc.c   |    6 +++
 3 files changed, 64 insertions(+), 23 deletions(-)

--- a/fs/fat/fatent.c~fat-batch-synchronous-mirror-writes
+++ a/fs/fat/fatent.c
@@ -376,42 +376,76 @@ int fat_ent_read(struct inode *inode, st
 	return ops->ent_get(fatent);
 }
 
-/* FIXME: We can write the blocks as more big chunk. */
-static int fat_mirror_bhs(struct super_block *sb, struct buffer_head **bhs,
-			  int nr_bhs)
+static int fat_mirror_one(struct super_block *sb, struct buffer_head **bhs,
+			  int nr_bhs, int target)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t backup_fat = sbi->fat_length * target;
+	/*
+	 * Use the value of MAX_BUF_PER_PAGE for 4K pages. This reduces stack
+	 * usage on large-page architectures as callers may already have a
+	 * MAX_BUF_PER_PAGE-sized array in their stack.
+	 */
+	struct buffer_head *dirty[8];
 	struct buffer_head *c_bh;
-	int err, n, copy;
+	int err, n, nr_dirty;
 
+	nr_dirty = 0;
 	err = 0;
-	for (copy = 1; copy < sbi->fats; copy++) {
-		sector_t backup_fat = sbi->fat_length * copy;
-
-		for (n = 0; n < nr_bhs; n++) {
-			c_bh = sb_getblk(sb, backup_fat + bhs[n]->b_blocknr);
-			if (!c_bh) {
-				err = -ENOMEM;
-				goto error;
+	for (n = 0; n < nr_bhs; n++) {
+		c_bh = sb_getblk(sb, backup_fat + bhs[n]->b_blocknr);
+		if (!c_bh) {
+			err = -ENOMEM;
+			goto error;
+		}
+		/* Avoid race with userspace read via bdev */
+		lock_buffer(c_bh);
+		memcpy(c_bh->b_data, bhs[n]->b_data, sb->s_blocksize);
+		set_buffer_uptodate(c_bh);
+		unlock_buffer(c_bh);
+		mmb_mark_buffer_dirty(c_bh,
+			&MSDOS_I(sbi->fat_inode)->i_metadata_bhs);
+		if (sb->s_flags & SB_SYNCHRONOUS) {
+			dirty[nr_dirty] = c_bh;
+			++nr_dirty;
+			if (nr_dirty == ARRAY_SIZE(dirty)) {
+				err = fat_sync_bhs(dirty, nr_dirty);
+				fat_brelse_array(dirty, nr_dirty);
+				nr_dirty = 0;
+				if (err)
+					goto error;
 			}
-			/* Avoid race with userspace read via bdev */
-			lock_buffer(c_bh);
-			memcpy(c_bh->b_data, bhs[n]->b_data, sb->s_blocksize);
-			set_buffer_uptodate(c_bh);
-			unlock_buffer(c_bh);
-			mmb_mark_buffer_dirty(c_bh,
-				&MSDOS_I(sbi->fat_inode)->i_metadata_bhs);
-			if (sb->s_flags & SB_SYNCHRONOUS)
-				err = sync_dirty_buffer(c_bh);
+		} else {
 			brelse(c_bh);
-			if (err)
-				goto error;
 		}
 	}
+
 error:
+	if (nr_dirty) {
+		int err2 = fat_sync_bhs(dirty, nr_dirty);
+		if (!err)
+			err = err2;
+		fat_brelse_array(dirty, nr_dirty);
+	}
+
 	return err;
 }
 
+static int fat_mirror_bhs(struct super_block *sb, struct buffer_head **bhs,
+			  int nr_bhs)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int copy;
+
+	for (copy = 1; copy < sbi->fats; copy++) {
+		int err = fat_mirror_one(sb, bhs, nr_bhs, copy);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
 		  int new, int old, int wait)
 {
--- a/fs/fat/fat.h~fat-batch-synchronous-mirror-writes
+++ a/fs/fat/fat.h
@@ -480,6 +480,7 @@ void fat_truncate_time(struct inode *ino
 int fat_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
+void fat_brelse_array(struct buffer_head *bhs[], int n);
 
 int fat_cache_init(void);
 void fat_cache_destroy(void);
--- a/fs/fat/misc.c~fat-batch-synchronous-mirror-writes
+++ a/fs/fat/misc.c
@@ -364,3 +364,9 @@ int fat_sync_bhs(struct buffer_head **bh
 	}
 	return err;
 }
+
+void fat_brelse_array(struct buffer_head *bhs[], int n)
+{
+	while (--n >= 0)
+		brelse(bhs[n]);
+}
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are

fat-improve-fat_sync_bhs-write-submission.patch

