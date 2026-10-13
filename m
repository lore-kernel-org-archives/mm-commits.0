Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3E52E042
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915787; cv=none; b=C0pjszzLh4roe6y8C2FDVtF4v7u673eoKeD4ndolZqsiJzzjcpdgbU4pXX1GvKUspLXKU/qmL1swS4REAix1igj16XOlV6JL2fSzL6L27kA2ls1mMFAdl2t8cYy8j5cVTQcRpwKqYFX1h/h50yaTzFETHYsT4f/jEPNq/D7z270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915787; c=relaxed/simple;
	bh=4WYgfjq4Ow3J+Xfwvb5GOkVo2YgZ65gccmv+zasDJh8=;
	h=Date:To:From:Subject:Message-Id; b=U825wDiO0iIYyS7LACGJxaAJcEJxzJxY8iYdIdUqJli18V5mhzAQiZypO8CrH2AXD1TLiFgBykXWib4Z9vQRW1JqPQnGctoyCcPs2nO1Z6Q4bccv6fc7ymPrSL3BswrgLF4tSlfMzaZ0wIlI2qzbQoijjql0856GIeBH1qKDmpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MoMC99Ar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MoMC99Ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EA01F00893;
	Tue, 13 Oct 2026 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791915785;
	bh=on0PwG/Sd+ZO5UNjMgl6DCK2+Cbq4I35r7CRLmHUqk8=;
	h=Date:To:From:Subject;
	b=MoMC99Arod4b6Gryi8ICXo0cWySsZSKD4VBttGqGogxOlpgY9sC9slQhugndyXxjh
	 NTevx/hiQpAgikPDsNov3ZwcrJe0UbxXvBnccEeqU+voyhqpT0TS7u1rHv9m6wQwAj
	 2Jmn3IIqPd0YT3IBcR7wWDHmiohjbUS08Tusa72c=
Date: Tue, 13 Oct 2026 11:23:05 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-support-adding-multiple-clusters.patch added to mm-nonmm-unstable branch
Message-Id: <20261013182305.89EA01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: support adding multiple clusters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-support-adding-multiple-clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-support-adding-multiple-clusters.patch

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
Subject: fat: support adding multiple clusters
Date: Mon, 12 Oct 2026 14:11:05 -0300

fat_add_cluster() currently adds only one cluster to a file's chain,
requiring multiple calls when adding more clusters.

Add a fat_alloc_chain() helper that allocates a cluster chain
but only returns the first cluster. Extend fat_add_cluster()
to add multiple clusters in a single call and rename it to
fat_add_clusters() to reflect the new behavior.

Link: https://lore.kernel.org/20261012171106.146243-3-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fat.h    |    3 ++-
 fs/fat/fatent.c |   18 ++++++++++++++++--
 fs/fat/file.c   |    2 +-
 fs/fat/inode.c  |    8 ++++----
 4 files changed, 23 insertions(+), 8 deletions(-)

--- a/fs/fat/fatent.c~fat-support-adding-multiple-clusters
+++ a/fs/fat/fatent.c
@@ -503,7 +503,8 @@ static int fat_flush_bhs(struct super_bl
 	return 0;
 }
 
-int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
+static int __fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster,
+				bool return_all)
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
@@ -546,7 +547,10 @@ int fat_alloc_clusters(struct inode *ino
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
 
-				cluster[idx_clus] = entry;
+				if (return_all)
+					cluster[idx_clus] = entry;
+				else if (!idx_clus)
+					*cluster = entry;
 				idx_clus++;
 
 				if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -596,6 +600,16 @@ out:
 	return err;
 }
 
+int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
+{
+	return __fat_alloc_clusters(inode, cluster, nr_cluster, true);
+}
+
+int fat_alloc_chain(struct inode *inode, int *cluster, int nr_cluster)
+{
+	return __fat_alloc_clusters(inode, cluster, nr_cluster, false);
+}
+
 int fat_free_clusters(struct inode *inode, int cluster)
 {
 	struct super_block *sb = inode->i_sb;
--- a/fs/fat/fat.h~fat-support-adding-multiple-clusters
+++ a/fs/fat/fat.h
@@ -395,6 +395,7 @@ extern int fat_ent_write(struct inode *i
 			 int new, int old, int wait);
 extern int fat_alloc_clusters(struct inode *inode, int *cluster,
 			      int nr_cluster);
+int fat_alloc_chain(struct inode *inode, int *cluster, int nr_cluster);
 extern int fat_free_clusters(struct inode *inode, int cluster);
 extern int fat_count_free_clusters(struct super_block *sb);
 extern int fat_trim_fs(struct inode *inode, struct fstrim_range *range);
@@ -440,7 +441,7 @@ static inline unsigned long fat_dir_hash
 {
 	return hash_32(logstart, FAT_HASH_BITS);
 }
-extern int fat_add_cluster(struct inode *inode);
+extern int fat_add_clusters(struct inode *inode, int nr_cluster);
 
 /* fat/misc.c */
 extern __printf(3, 4) __cold
--- a/fs/fat/file.c~fat-support-adding-multiple-clusters
+++ a/fs/fat/file.c
@@ -292,7 +292,7 @@ static long fat_fallocate(struct file *f
 
 		/* Start the allocation.We are not zeroing out the clusters */
 		while (nr_cluster-- > 0) {
-			err = fat_add_cluster(inode);
+			err = fat_add_clusters(inode, 1);
 			if (err)
 				goto error;
 		}
--- a/fs/fat/inode.c~fat-support-adding-multiple-clusters
+++ a/fs/fat/inode.c
@@ -102,16 +102,16 @@ static struct fat_floppy_defaults {
 },
 };
 
-int fat_add_cluster(struct inode *inode)
+int fat_add_clusters(struct inode *inode, int nr_cluster)
 {
 	int err, cluster;
 
-	err = fat_alloc_clusters(inode, &cluster, 1);
+	err = fat_alloc_chain(inode, &cluster, nr_cluster);
 	if (err)
 		return err;
 	/* FIXME: this cluster should be added after data of this
 	 * cluster is writed */
-	err = fat_chain_add(inode, cluster, 1);
+	err = fat_chain_add(inode, cluster, nr_cluster);
 	if (err)
 		fat_free_clusters(inode, cluster);
 	return err;
@@ -153,7 +153,7 @@ static inline int __fat_get_block(struct
 	 */
 	if (!offset && !(iblock < last_block)) {
 		/* TODO: multiple cluster allocation would be desirable. */
-		err = fat_add_cluster(inode);
+		err = fat_add_clusters(inode, 1);
 		if (err)
 			return err;
 	}
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are

fat-remove-cluster-allocation-size-limit.patch
fat-support-adding-multiple-clusters.patch
fat-allocate-multiple-clusters-in-fallocate.patch

