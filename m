Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792882426;
	b=lXO23AY9i3OYwj+3VFslh2I9FcLXif/0gpQ8xbMK53rfVf86nTgJJHFDk57snxDTZMW2
	 9KklXopREMpjeO+vm4MXqVosX2Rb0hL4S9aqnyKVMgLcb42mmlTBiYEMj5ogE021HWPWk
	 cj9+Zs2k9DqoZo4ifYtiyxcCHJ6aOLDJyYkwBt3VQs18u1KlGznZg1zTLSoosBswH8N8D
	 EsIlPLC0sTcH8RpaUKIDQwJi4PnWUP5lwh9hZs7WuDQd0Vw0J9S2ReLIPVTpP8xBlWQis
	 l+1KG+AX14wB4/xRLC+9saZZl66Un5B8ukKvI3/F2ZdtPUun3RyzghQwwv7NaGoE6Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792882426;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nmEAOrWtK875aBUH6tImcULc18kWaxqr9EmzqP3lUi8=;
	b=x2Ojhb3nBrM/4MLlPAkoFPSPuKbD1049+/NuuDUIl88IN+jn9l+gjTvu7n41jmObVxf0
	 BLsM50TgFeGpMkNx1nacj9bbcAoMzFEVwY86R4E/+SMF4ASRaVn6Ftbb+1VxQ2sa0WHMr
	 pgIRB9/gEbaqVbpUW9X5w3jMs4hax8aPJzEYoVO4dvKqhzSdsL1YuT5H4ogUs+IID/gWt
	 pvZp6w4Vchw2/83Jo1mtXlSFT/6W7ystkaFMIRloBe7dgVChFmqfZeevfhLCcVjIN0avC
	 pEVJtRMrQyFzSkL6nC8mbQxKREWs4MuPL7/7tPcH3SKU+QUcJQyd+i4Vl8rzeyuDr0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gWN7uRKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD2606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 22:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gWN7uRKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C521F01825;
	Sat, 24 Oct 2026 22:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792882424;
	bh=nmEAOrWtK875aBUH6tImcULc18kWaxqr9EmzqP3lUi8=;
	h=Date:To:From:Subject;
	b=gWN7uRKN9+D5PrPIUb/tupdzRcFgQ3K3QzYleu3ecFyV7PoeLD6AQmV9IUIn34ljB
	 ebX0ztWGnHeRJ+2sNS/51yy+OAprLnsZyWSwFeMsITkSLpZ185IOtFV7CE4j2+EfYO
	 0jlO/BdB27Pp4AYJ4MY09iA5IGugRzFotnKW6l0w=
Date: Sat, 24 Oct 2026 15:53:44 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,
	matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-preallocate-space-before-expanding-in-fat_cont_expand.patch added to mm-nonmm-unstable branch
Message-Id: <20261024225344.C8C521F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fat: preallocate space before expanding in fat_cont_expand()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-preallocate-space-before-expanding-in-fat_cont_expand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-preallocate-space-before-expanding-in-fat_cont_expand.patch

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
Subject: fat: preallocate space before expanding in fat_cont_expand()
Date: Fri, 23 Oct 2026 22:30:20 -0300

The fat_cont_expand() implementation leaves allocation of new clusters
to generic_cont_expand_simple(). This path does many small cluster
allocations, harming performance.

Preallocate cluster space in fat_cont_expand(). Move preallocation to
a new fat_preallocate() helper used by both fat_cont_expand() and
fat_fallocate(FALLOC_FL_KEEP_SIZE). Use a FAT-specific
fat_cont_expand_simple() instead of generic_cont_expand_simple() to
avoid rechecking the new size after clusters have been allocated.

Benchmarking was done under QEMU/KVM with a virtio-blk device using
cache=none. Each result is the arithmetic mean of the listed samples.

start = now_ns();
for (unsigned i = 0; i < count; i++) {
    if (truncate_mode)
        ftruncate(fds[i], bytes);
    else
        fallocate(fds[i], 0, 0, bytes);
}
elapsed = now_ns() - start;

16 files, 512-byte clusters:
length    mode      sync?    before    after    improvement    samples
256MiB    ftruncate no       9.576s    5.345s   1.79x          10
256MiB    fallocate no       9.634s    5.640s   1.71x          10
1MiB      ftruncate yes      58.66s    0.362s   162.15x        5
1MiB      fallocate yes      61.36s    0.390s   157.15x        5

128 files, 512-byte clusters:
length    mode      sync?    before    after    improvement    samples
512KiB    ftruncate no       0.433s    0.352s   1.23x          10
512KiB    fallocate no       0.446s    0.393s   1.13x          10
64KiB     ftruncate yes      31.32s    0.429s   73.00x         10
64KiB     fallocate yes      29.59s    0.410s   72.42x         10

16 files, 4096-byte clusters:
length    mode      sync?    before    after    improvement    samples
256MiB    ftruncate no       5.181s    4.417s   1.17x          10
256MiB    fallocate no       5.166s    4.442s   1.16x          10
1MiB      ftruncate yes      9.294s    0.111s   84.06x         10
1MiB      fallocate yes      8.710s    0.110s   79.36x         10

The biggest improvement is on filesystems with a small cluster size and
on synchronous mounts.

Link: https://lore.kernel.org/20261024013021.251898-1-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/file.c |   70 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 19 deletions(-)

--- a/fs/fat/file.c~fat-preallocate-space-before-expanding-in-fat_cont_expand
+++ a/fs/fat/file.c
@@ -217,13 +217,62 @@ const struct file_operations fat_file_op
 	.setlease	= generic_setlease,
 };
 
+static int fat_preallocate(struct inode *inode, loff_t new_size)
+{
+	int nr_cluster; /* Number of clusters to be allocated */
+	loff_t mm_bytes; /* Number of bytes to be allocated for file */
+	loff_t ondisksize; /* block aligned on-disk size in bytes*/
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	ondisksize = inode->i_blocks << 9;
+	if (new_size <= ondisksize)
+		return 0;
+
+	/* First compute the number of clusters to be allocated */
+	mm_bytes = new_size - ondisksize;
+	nr_cluster = (mm_bytes + (sbi->cluster_size - 1)) >>
+		     sbi->cluster_bits;
+
+	/* Allocate the clusters. We are not zeroing them out */
+	return fat_add_clusters(inode, nr_cluster);
+}
+
+static int fat_cont_expand_simple(struct inode *inode, loff_t size)
+{
+	struct address_space *mapping = inode->i_mapping;
+	const struct address_space_operations *aops = mapping->a_ops;
+	struct folio *folio;
+	void *fsdata = NULL;
+	int err;
+
+	err = aops->write_begin(NULL, mapping, size, 0, &folio, &fsdata);
+	if (err)
+		goto out;
+
+	err = aops->write_end(NULL, mapping, size, 0, 0, folio, fsdata);
+
+out:
+	return err;
+}
+
 static int fat_cont_expand(struct inode *inode, loff_t size)
 {
 	struct address_space *mapping = inode->i_mapping;
 	loff_t start = inode->i_size, count = size - inode->i_size;
 	int err;
 
-	err = generic_cont_expand_simple(inode, size);
+	/*
+	 * Preallocating space here is more efficient than during
+	 * fat_cont_expand_simple() because of batching.
+	 */
+	err = inode_newsize_ok(inode, size);
+	if (err)
+		goto out;
+	err = fat_preallocate(inode, size);
+	if (err)
+		goto out;
+	err = fat_cont_expand_simple(inode, size);
 	if (err)
 		goto out;
 
@@ -263,12 +312,7 @@ out:
 static long fat_fallocate(struct file *file, int mode,
 			  loff_t offset, loff_t len)
 {
-	int nr_cluster; /* Number of clusters to be allocated */
-	loff_t mm_bytes; /* Number of bytes to be allocated for file */
-	loff_t ondisksize; /* block aligned on-disk size in bytes*/
 	struct inode *inode = file->f_mapping->host;
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	int err = 0;
 
 	/* No support for hole punch or other fallocate flags. */
@@ -281,19 +325,7 @@ static long fat_fallocate(struct file *f
 
 	inode_lock(inode);
 	if (mode & FALLOC_FL_KEEP_SIZE) {
-		ondisksize = inode->i_blocks << 9;
-		if ((offset + len) <= ondisksize)
-			goto error;
-
-		/* First compute the number of clusters to be allocated */
-		mm_bytes = offset + len - ondisksize;
-		nr_cluster = (mm_bytes + (sbi->cluster_size - 1)) >>
-			sbi->cluster_bits;
-
-		/* Allocate the clusters. We are not zeroing them out */
-		err = fat_add_clusters(inode, nr_cluster);
-		if (err)
-			goto error;
+		err = fat_preallocate(inode, offset + len);
 	} else {
 		if ((offset + len) <= i_size_read(inode))
 			goto error;
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are

fat-preallocate-space-before-expanding-in-fat_cont_expand.patch
fat-hold-truncate_lock-in-fat_write_failed.patch

