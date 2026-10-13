Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F19547F3B1
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 18:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915785; cv=none; b=sjX19zzQQn91vCkPXBM9m0Fb1j6jgizPmoce5r4zm3RcooYbyQNNmCr17afpF7L+3lnVfF8Qdw9AwkBLCyNiwGqCm6sSmolc7vSo/YrkCYkgFGanzlRY2rvpcLX54a42IH6aOaImd4SVgwXD7CYmohgjzM2Vwy6RTL+OF4AN0Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915785; c=relaxed/simple;
	bh=M1qV3cg6jfTjJ8u3QrYLLhzu2/fPzGPOFzzNBufq3xY=;
	h=Date:To:From:Subject:Message-Id; b=Q2S4NScsfZNyjTW7aN77KzAqreSEV3vbIEInJ/Q7WLfTYo2+8NJPLdhBDSSY3VzasCzrX3vA6kIbsW/3O2m5TwxBSiqmWcOZ9O1xOTX9pD4Yd0IJW3y4MekLyLGMygtkwbIjYsHjgI4h8FL7ObbOKFBcQd1FRworil6HR6rvbYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kYyKGzvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kYyKGzvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C13A1F000FF;
	Tue, 13 Oct 2026 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791915783;
	bh=IDf3QWzJsqeBrO/G4v5tNZ+6ZPSwYpAOqcI9SfIZN6M=;
	h=Date:To:From:Subject;
	b=kYyKGzvsPXOyFrRJz8qPinzEc3jg2AGjw4+wGfiEaQBw3qRb9rMZtvJQv8dNPOHpI
	 DrVpcsIOWAGJX23EhCI9qwJm1Hdl7pXZ9fGJ8wwkGoT9Zd73XksJ6faEkW6YhLp7Kx
	 Nb9ER1E6nYYuFP+OEPmowUs+TSZaRvoL4n1crPjw=
Date: Tue, 13 Oct 2026 11:23:03 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-remove-cluster-allocation-size-limit.patch added to mm-nonmm-unstable branch
Message-Id: <20261013182303.9C13A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: remove cluster allocation size limit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-remove-cluster-allocation-size-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-remove-cluster-allocation-size-limit.patch

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
Subject: fat: remove cluster allocation size limit
Date: Mon, 12 Oct 2026 14:11:04 -0300

Patch series "fat: allocate multiple clusters in fallocate", v2.

This series adds support for allocating multiple clusters in a single
fat_add_clusters() call in fat_fallocate().

The multi-cluster TODO in inode.c is not implemented, as doing so would
require speculative preallocation or an iomap conversion.


This patch (of 3):

fat_alloc_clusters() currently BUG()s when asked to allocate more than
MAX_BUF_PER_PAGE / 2 clusters. This limit comes from the buffer_head
array used to defer syncing and mirroring.

Remove the allocation size limit by doing buffer_head batching like
fat_free_clusters() does.

Link: https://lore.kernel.org/20261012171106.146243-1-matheus.aalmeida@inf.ufrgs.br
Link: https://lore.kernel.org/20261012171106.146243-2-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fatent.c |   44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

--- a/fs/fat/fatent.c~fat-remove-cluster-allocation-size-limit
+++ a/fs/fat/fatent.c
@@ -483,6 +483,26 @@ static void fat_collect_bhs(struct buffe
 	}
 }
 
+static int fat_flush_bhs(struct super_block *sb, struct buffer_head **bhs,
+			 int *nr_bhs, bool sync)
+{
+	int err, i;
+
+	if (sync) {
+		err = fat_sync_bhs(bhs, *nr_bhs);
+		if (err)
+			return err;
+	}
+	err = fat_mirror_bhs(sb, bhs, *nr_bhs);
+	if (err)
+		return err;
+	for (i = 0; i < *nr_bhs; i++)
+		brelse(bhs[i]);
+	*nr_bhs = 0;
+
+	return 0;
+}
+
 int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 {
 	struct super_block *sb = inode->i_sb;
@@ -492,8 +512,6 @@ int fat_alloc_clusters(struct inode *ino
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, count, err, nr_bhs, idx_clus;
 
-	BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2));	/* fixed limit */
-
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1 && sbi->free_clus_valid &&
 	    sbi->free_clusters < nr_cluster) {
@@ -524,14 +542,21 @@ int fat_alloc_clusters(struct inode *ino
 				if (prev_ent.nr_bhs)
 					ops->ent_put(&prev_ent, entry);
 
-				fat_collect_bhs(bhs, &nr_bhs, &fatent);
-
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
+
+				if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
+					err = fat_flush_bhs(sb, bhs, &nr_bhs,
+							    inode_needs_sync(inode));
+					if (err)
+						goto out;
+				}
+				fat_collect_bhs(bhs, &nr_bhs, &fatent);
+
 				if (idx_clus == nr_cluster)
 					goto out;
 
@@ -621,17 +646,10 @@ int fat_free_clusters(struct inode *inod
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
-			if (sb->s_flags & SB_SYNCHRONOUS) {
-				err = fat_sync_bhs(bhs, nr_bhs);
-				if (err)
-					goto error;
-			}
-			err = fat_mirror_bhs(sb, bhs, nr_bhs);
+			err = fat_flush_bhs(sb, bhs, &nr_bhs,
+					    sb->s_flags & SB_SYNCHRONOUS);
 			if (err)
 				goto error;
-			for (i = 0; i < nr_bhs; i++)
-				brelse(bhs[i]);
-			nr_bhs = 0;
 		}
 		fat_collect_bhs(bhs, &nr_bhs, &fatent);
 	} while (cluster != FAT_ENT_EOF);
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are

fat-remove-cluster-allocation-size-limit.patch
fat-support-adding-multiple-clusters.patch
fat-allocate-multiple-clusters-in-fallocate.patch

