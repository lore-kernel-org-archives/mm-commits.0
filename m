Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6569152F27F
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915790; cv=none; b=GmtUO0arYHKHHiEoX5AWXgMWhSEIbhqLz6D/N1Aj9VumZAqwoR71ojeTgptP7OD2fawxCz1/bP8Rr+yaKG+bvoCVRgzeYwRd1PNznf03g4xBkhLzkvxUY4KjQ6hOk2zGq2Ur+N9Km+dSXe2kwmm7tr1Vs4bW2wOa70nJPomf37U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915790; c=relaxed/simple;
	bh=j82rZcOehlmmwffgpfYLs6NCdm3rsPnM3KEHIVIQZKk=;
	h=Date:To:From:Subject:Message-Id; b=E9nkyIiXX4baIvwhS6nQOuzjmJxdXFHF05bhoB8bT/u/tDI1yidapqXI+ECMToY5VmMxtqsIsMYjRG2KbcQWLEHMUTqLS2Lh4txmCDko/qmfqC30amvNRgFOonnlEiMpgiN9kUWbzQeqkdnTJm+pctLYU5+CS0ir29fFnsAqy4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wiO642fM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wiO642fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07C01F000FF;
	Tue, 13 Oct 2026 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791915788;
	bh=IpHNyvUBVW6mLZhEebxbSzb4N0hNlC+n7KuXu7mLMFs=;
	h=Date:To:From:Subject;
	b=wiO642fMqgyXxk2mqIlJGMtOuZrsOb78gnFFN42GsOyPiO/vPOcfLCzWwPK9t7x/Y
	 9PES/QB3Vo2U07P7215keHGQCuamHYjtz70UZpsEo5KUq/I7oroGpGK0zPdd91AjGh
	 ADxp0zb3Lf2UYgIfm6eXm6d3tIs+gsND4c1EYAao=
Date: Tue, 13 Oct 2026 11:23:08 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-allocate-multiple-clusters-in-fallocate.patch added to mm-nonmm-unstable branch
Message-Id: <20261013182308.D07C01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: allocate multiple clusters in fallocate
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-allocate-multiple-clusters-in-fallocate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-allocate-multiple-clusters-in-fallocate.patch

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

fat-remove-cluster-allocation-size-limit.patch
fat-support-adding-multiple-clusters.patch
fat-allocate-multiple-clusters-in-fallocate.patch

