Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C2F33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810120; cv=none; b=H/JU3h/bBZC54pxY/FLOBsnbvjjleY9urwNItdzA0bfQHaZYSWS7ZTrx+Y4IaW0ERp2CdqqwTte5NwiX1SnNS4onba0ZTiVPyeE7KMbNxY/BMvyVcO0OtwBxxwCLMxtmeAQQ4elT8My1W8oYXyVuVh3d7XfTD9W+lwjcWdQIMXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810120; c=relaxed/simple;
	bh=3hTPOyX1/DXy/BIG8Yff8cnadbIcScmL2woBAHps2wY=;
	h=Date:To:From:Subject:Message-Id; b=Kba+3nnzgSaSTGmavMM7JkelaIhUW7Ti2MfjymiAGNx3lS2RKArxVksRMjlDRXz46RAb7LwBLEH89AZqAGcA6b3uQrXkQOKe4p0UHnJ4vR4Q19B3QdlLKMJm2LR5lHquvuD/txbsRnoecBkEa85lG4NJhpfOwJIXrxHb14/Z+I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BSW3+XKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BSW3+XKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE09C4CEEB;
	Sun, 14 Sep 2025 00:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810120;
	bh=3hTPOyX1/DXy/BIG8Yff8cnadbIcScmL2woBAHps2wY=;
	h=Date:To:From:Subject:From;
	b=BSW3+XKvSQsT4ztcZT+xhlo3MhMmEp50EN7UOqnjDJWq11dh8TTs9c0SO5LCT7hrD
	 V+mS4OcgnYKLhKEyG8pU1vX4QKmy/FQhq0A5xBhURNPtVSjGsjN3zmLVVlq70CMZfA
	 vjGYB4QlwaZgFQudmnNbHMj3l8YP205oF9jKwJmY=
Date: Sat, 13 Sep 2025 17:35:19 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,teczm@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] vfat-remove-unused-variable.patch removed from -mm tree
Message-Id: <20250914003519.EAE09C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vfat: remove unused variable
has been removed from the -mm tree.  Its filename was
     vfat-remove-unused-variable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhoumin <teczm@foxmail.com>
Subject: vfat: remove unused variable
Date: Mon, 18 Aug 2025 22:44:49 +0800

Remove unused variable definition and related function definition and
redundant variable assignments within functions.

Link: https://lkml.kernel.org/r/tencent_9DE7CC9367096503F6ADD2BD960079267406@qq.com
Signed-off-by: zhoumin <teczm@foxmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/fat/dir.c~vfat-remove-unused-variable
+++ a/fs/fat/dir.c
@@ -1209,7 +1209,7 @@ EXPORT_SYMBOL_GPL(fat_alloc_new_dir);
 
 static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
 			       int *nr_cluster, struct msdos_dir_entry **de,
-			       struct buffer_head **bh, loff_t *i_pos)
+			       struct buffer_head **bh)
 {
 	struct super_block *sb = dir->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
@@ -1269,7 +1269,6 @@ static int fat_add_new_entries(struct in
 	get_bh(bhs[n]);
 	*bh = bhs[n];
 	*de = (struct msdos_dir_entry *)((*bh)->b_data + offset);
-	*i_pos = fat_make_i_pos(sb, *bh, *de);
 
 	/* Second stage: clear the rest of cluster, and write outs */
 	err = fat_zeroed_cluster(dir, start_blknr, ++n, bhs, MAX_BUF_PER_PAGE);
@@ -1298,7 +1297,7 @@ int fat_add_entries(struct inode *dir, v
 	struct buffer_head *bh, *prev, *bhs[3]; /* 32*slots (672bytes) */
 	struct msdos_dir_entry *de;
 	int err, free_slots, i, nr_bhs;
-	loff_t pos, i_pos;
+	loff_t pos;
 
 	sinfo->nr_slots = nr_slots;
 
@@ -1386,7 +1385,7 @@ found:
 		 * add the cluster to dir.
 		 */
 		cluster = fat_add_new_entries(dir, slots, nr_slots, &nr_cluster,
-					      &de, &bh, &i_pos);
+					      &de, &bh);
 		if (cluster < 0) {
 			err = cluster;
 			goto error_remove;
_

Patches currently in -mm which might be from teczm@foxmail.com are


