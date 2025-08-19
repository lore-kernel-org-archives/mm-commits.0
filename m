Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E647613FEE
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 02:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755572289; cv=none; b=qqnvuSOsHAg2/G7oym2GpTNoPykGHjc9fXgmawiSM73GjxJxc+QzhIzLvZfQHKKJEIPqwI2gxPvSIPb9O7kFUpnLTbfB19ebL5A8DGclI+LMspKAdgjwnFos+7390nPh81SzCDc71VI2/byh86JWcCKKO7W77wnotTrV3/mBGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755572289; c=relaxed/simple;
	bh=GCWca0C5UHB1UDfxfSn8pnQtEHAmDyU31mUYTsYRcgU=;
	h=Date:To:From:Subject:Message-Id; b=h+yNCxadqsXfAWRkCe4SAkp1+ntH3N9O6gHbb6h9bB3qLnEamT0IwCV0h3PzEu7CIQEOaQnuVatfp8rSUTEzXo2VGtRzC+YL7uTXXbaXQubvhB4HTvhYVgJUvnG7D1NNcI5iekXtk8+R2oDWbgiNVZaSpE8g8EBQGLAKvN9O50k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ka6yJ39i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ka6yJ39i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627AEC4CEEB;
	Tue, 19 Aug 2025 02:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755572288;
	bh=GCWca0C5UHB1UDfxfSn8pnQtEHAmDyU31mUYTsYRcgU=;
	h=Date:To:From:Subject:From;
	b=Ka6yJ39i7wNl44duHrepOz9fgRSERIFIFd2EMI6c9qzD1SaBAi86yg53tNZui/2aH
	 tgBcj4MNtl2k6OVGQSxO4PnOR0wxu8SMRyNBkufCyl/0oTvDQBJSoYwx/OmqX7KRpT
	 Lby8gRUU07K5SnREvF69Bs0bwyAyzHjMymOHaT1w=
Date: Mon, 18 Aug 2025 19:58:07 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,teczm@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vfat-remove-unused-variable.patch added to mm-nonmm-unstable branch
Message-Id: <20250819025808.627AEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vfat: remove unused variable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vfat-remove-unused-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vfat-remove-unused-variable.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

vfat-remove-unused-variable.patch

