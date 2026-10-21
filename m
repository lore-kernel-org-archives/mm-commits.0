Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560647;
	b=aK3x7Q1pRIVRIxo9hmfuTsNFEx5ivUvzmM9K7j3AD30R0ePsqHZnRXMiqRZ5Up1sb1JN
	 X4UUO2TuXO7KIFRHxj1oKLMIpC6Vb6UOEw7QuqXgAYgFyvgoAWsfvzF4hmTqvdy8iV0s3
	 8nMA5QhtdNVsSI/PdVj4tS2TUxHWI3esjTfE4GNRhaNBSwQGVRpUMXcPqZATMFVfw4/mQ
	 s/czbUUeLuFtUSsUeO1N/q9p1BLi0bgmkgmwMdBJF6NLZH5d1hSb4lPpl7cT6RFdHBSN5
	 02g/JIndkS0x6RV7lNP0ty2KjRcp61NFjfA1DC9XxcmZHVikCYvUxw1lmXLj67ril8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560647;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZE6EPqWN8yPElzxKL0sraq82mWjmev5IkuCCKxJHYfA=;
	b=RKOeHj3DHMpZaDtbFkH6yAOPeOOYB9SKQROml8hF0OonIR0CnMO0rqN6+36Fhd1UCGrC
	 G7jC9a+d5joaHlSz6lSbtGRIJ7V1O3I+l6zItK8+HJhaJndgzWq/6MLIB00p99B2NbZCH
	 kGqQOJPuy/7b6uVZ4smZ+SIhVRp96wZXAKFUaDzqtKudQMwQ+SrcvFkC6Q8Zata6o5MN9
	 iRZcsBY0BxslK+iSqPYytQnVGtd0P3piRKgcAvna9k4ea0ieUF701Pd2L3rZh2/krYL9h
	 yGfjFLqwYgm3Bu5iy4NcCZi2FsA5Zk7jruuL/f6jI4gNW6jcSDo7YfVCk4C1jaDU27g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="ey00qbA/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F1606A31C
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ey00qbA/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259C11F000C9;
	Wed, 21 Oct 2026 05:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560647;
	bh=ZE6EPqWN8yPElzxKL0sraq82mWjmev5IkuCCKxJHYfA=;
	h=Date:To:From:Subject;
	b=ey00qbA/dJ5lIhl7nwpoulk58nADlsEji6hsk/COywiA+UV3Gda/ER2kbIXO8JqZ2
	 +LLUVtBdZmo8Rlpi2/m8Xw2IRyQlwxjKsxNHs/yltYEAiMtS5qeZek2e8grdWGY8jk
	 MtxqSz2/p1X4QpOw4fsrkRat8v10HX+tAvmekN6Y=
Date: Tue, 20 Oct 2026 22:30:46 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-support-adding-multiple-clusters.patch removed from -mm tree
Message-Id: <20261021053047.259C11F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: support adding multiple clusters
has been removed from the -mm tree.  Its filename was
     fat-support-adding-multiple-clusters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


