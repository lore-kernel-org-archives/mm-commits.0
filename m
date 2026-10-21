Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560648;
	b=RGtMwV2wfCFLqqI0jOdFxzOlhFJzqFENOXmaq/vrGgMyGJgFAaMq1f3+LNMj72NDMTzQ
	 H6BkbO8F2s9gqt/N1bxlQvFaB1kWYt8Tq0qJlCBagUqhaChPqZtDOMOuvx7h3gd+QZCSS
	 iV6xwPSe+QH9sj3Xh0sS4slKWfJ0qFydqrA4t9Uc29b/yGEx9/afUdcBsxzOinxC7606W
	 CM3tr+ewvsZt9rOf3HOYqvg69VO/XS+QnUossAK+sB5RUfE5XgDfmmHLJ85zGG0QP/7Y3
	 pIGXi7fmiBNkRr785+DXMMf5WMHbKAcczk+Aiw3v03PuiLBg6MdD8BYnd1Yth/EjJ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560648;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nfABYnLV1WwHDXoFZLn1oJ3Pd6ulEsK5scDmtfLLjCs=;
	b=uLM3Uj88Nqmiz/NgmzA2o+mXA4YzbRltOAmezReUceE87eyVL/mmr3xu+Eap06pg8E7B
	 MmaW4nbQ05MM/PKCJsssB6QfAN7tXaDE1c4FpPgikrysmXi6r3+tL1YzFcjnxtn00nz9r
	 4QwqynjT/Koq5/KB72r8v+qZ5MKt4pOmtpKJlBazC+sW4PpBVrSoTQChdPDmaH8dD8dg2
	 9ND/HJNixzjuCibM74RW8On8AnHrmcM/oNo8tQIAQOjuwBqjxXDz+HRnQmZasiD4L+usf
	 FwAw8tVlOZovKOmZr7u943PMGfUB0Bq2c1NsQAyJqQIRzDjCSBUNTzgfkTpJnv+BC0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aZotDZpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899F9606A31C
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aZotDZpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1FA1F000C9;
	Wed, 21 Oct 2026 05:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560648;
	bh=nfABYnLV1WwHDXoFZLn1oJ3Pd6ulEsK5scDmtfLLjCs=;
	h=Date:To:From:Subject;
	b=aZotDZppNEd6t3/2pWCc+Wr4AECS2/1HbrPjlpKYozbuQDS5SfWIsW1vg12l7KKn2
	 cnEwFgChggVaaI+TBkgn36HGjXfuBBlABrKB93XtmFxmxdCVph9IEOsiNe/pkfFvTO
	 ZoZb3P8GNv2T2zeANcuCZtf6z0zPVkcX5+AUAN6o=
Date: Tue, 20 Oct 2026 22:30:47 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-allocate-multiple-clusters-in-fallocate.patch removed from -mm tree
Message-Id: <20261021053048.2E1FA1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: allocate multiple clusters in fallocate
has been removed from the -mm tree.  Its filename was
     fat-allocate-multiple-clusters-in-fallocate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Subject: fat: allocate multiple clusters in fallocate
Date: Mon, 12 Oct 2026 14:11:06 -0300

The fat_fallocate() code currently does many 1-cluster allocations when
growing a file in the FALLOC_FL_KEEP_SIZE path. Make it allocate
everything with one call instead.

Benchmarking was done under QEMU/KVM with a virtio-blk device using
cache=none. Each result is the arithmetic mean of the listed samples.

start = now_ns();
for (unsigned int i = 0; i < count; i++)
     fallocate(fds[i], FALLOC_FL_KEEP_SIZE, 0, bytes);
elapsed = now_ns() - start;

FAT32 with 512-byte clusters using count=16 files:
length    mounted sync?    before    after    improvement    samples
256MiB    no               2.328s    0.175s   13.2x          10
16MiB     no               149.659ms 14.036ms 10.7x          10
16MiB     yes              747.993s  3.445s   217.1x         3
1MiB      yes              46.63s    0.333s   140.1x         10

FAT32 with 512-byte clusters using count=128 files:
length    mounted sync?    before    after    improvement    samples
1MiB      no               90.873ms  4.686ms  19.4x          10
16KiB     no               1.287ms   0.241ms  5.3x           10
128KiB    yes              47.284s   0.350s   135x           10
4KiB      yes              1.98s     0.144s   13.7x          10

FAT32 with 4096-byte clusters using count=16 files:
length    mounted sync?    before    after    improvement    samples
256MiB    no               295.392ms 24.733ms 11.9x          10
16MiB     no               20.509ms  1.404ms  14.6x          10
16MiB     yes              92.489s   0.348s   265.4x         10
1MiB      yes              5.837s    0.048s   121.3x         10

The improvement is especially large on synchronous mounts, where the
new code can batch FAT updates instead of synchronously handling each
cluster allocation separately.

Link: https://lore.kernel.org/20261012171106.146243-4-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/file.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/fat/file.c~fat-allocate-multiple-clusters-in-fallocate
+++ a/fs/fat/file.c
@@ -290,12 +290,10 @@ static long fat_fallocate(struct file *f
 		nr_cluster = (mm_bytes + (sbi->cluster_size - 1)) >>
 			sbi->cluster_bits;
 
-		/* Start the allocation.We are not zeroing out the clusters */
-		while (nr_cluster-- > 0) {
-			err = fat_add_clusters(inode, 1);
-			if (err)
-				goto error;
-		}
+		/* Allocate the clusters. We are not zeroing them out */
+		err = fat_add_clusters(inode, nr_cluster);
+		if (err)
+			goto error;
 	} else {
 		if ((offset + len) <= i_size_read(inode))
 			goto error;
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are


