Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793072505;
	b=t6yUhoPMIcBGUNXvXgkZZ5hno4WwOx0j5HmF+CFl/e/8Hg7mWuPM46wy6JnkohKcYPlh
	 4jkgnlJPm4avkmxYJrW1fYkJbf9Gd15/xNuj0LHRcDni4e1RuG39/R9zkgBZoOr4cHC6n
	 0GHmLdZ8rOArLv4SyrZDxerkvBZgX5in38+ywLVhguQ881wgettqXBj1pmRAiHvusfcTv
	 wAHPwHqXuJpOdMT1FuEth2rCfuxomLDqxG6EJdxdjbL+iyMRAs1xuirsZUhOtl9vtBbhN
	 gwEszp15h8Yca+AgkMilCJkwF2JDQiCugKMjjcJipI+xxV9rE3Dl2JStjot2H+g51ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793072505;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BS5spvRNFnV3RUcnWcXUntXLpnlVo9fisLdbQdT+nRg=;
	b=DyS4hIOf04uI7nrUDlIZnbRUX/KDKXMufPhlHyLyQAMiddhgLE2Qoy9aTgcadzgYSIhb
	 DmFrDadLvQM4jbDgh/sB2IVOVH+Mzuansmko+VbY9PFNB4Su4XZ7JnGWy4VpoxS1gigfs
	 JrAGImpY2RdOm7ICdEek6vGq06QKonOyz79ZxcDiR4fa//+7KjxmU3rC5ZGpnkH8G480S
	 KWrgq4mN3F9OQE1K9uL0h7EWoGecraDZXUaEmZS1FwUChcXiZfXAo5FEJ0wtKowztrchl
	 vQwHvPCDN4QU25bBt6m7PcD+TZFM0zYFzzJlbfyur/dzzvPGboxruEXuEt39Yu9q+vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="SYQDVKB/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A0606A31A
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 03:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SYQDVKB/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAE71F01825;
	Tue, 27 Oct 2026 03:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793072504;
	bh=BS5spvRNFnV3RUcnWcXUntXLpnlVo9fisLdbQdT+nRg=;
	h=Date:To:From:Subject;
	b=SYQDVKB/btfNFx1uC/FgHIDX0blm1+jmlMnnaD1w47CS2NVhv/3r0VbN/YA7Z7BGw
	 8giuNpru5/nYWLPeDIeEalHEA9r2VoTX8fjA5ckMtV8iV1yaFrxnNQ88zvaVWjxpo7
	 T3u5tmLRvhIX6bi2X2EW31ej8rBdN6fJEcxIZDjY=
Date: Mon, 26 Oct 2026 20:41:43 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,
	matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-batch-synchronous-mirror-writes.patch added to mm-nonmm-unstable branch
Message-Id: <20261027034144.2CAE71F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fat: batch synchronous mirror writes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-batch-synchronous-mirror-writes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-batch-synchronous-mirror-writes.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Link: https://lore.kernel.org/20261026163941.495833-2-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

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
@@ -479,6 +479,7 @@ void fat_truncate_time(struct inode *ino
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

fat-preallocate-space-before-expanding-in-fat_cont_expand.patch
fat-hold-truncate_lock-in-fat_write_failed.patch
fat-batch-synchronous-mirror-writes.patch
fat-improve-fat_sync_bhs-write-submission.patch

