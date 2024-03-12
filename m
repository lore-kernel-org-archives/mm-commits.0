Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3E31428EC
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274187; cv=none; b=A8+9KBVMWzW0BQBnGevenRess/RHgGRJXW2xbSfiOTA6JJHXK2M7F1x22TyW+ME455deNVhjeYfqfooyvL17wu/Ci0u2KKF3E0NcgGXFciyX8mfgF+iYcOJ2/vqp4t0J3u+cjxcw3AbcsHBvuVRdUta1ZQu6INXUTWbO5OEYGoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274187; c=relaxed/simple;
	bh=NdT9+xtXVRhjwrNuf9vsQ4y+bAwulGLgGt2mWNDz7Dg=;
	h=Date:To:From:Subject:Message-Id; b=jJb1Gr1xS2NS1zobZp8kfIajl0M/T7p3mZPiDgV6cyzcejIfRtF2f0GsvHDqFEE/90aHjGciX/Lk05+O4dgdG4n/0T36SxcAVKAhzdK+ezuqdi8ie0kA4zniY3iHAwbgR5inmUdb7c6qCLPpEqwrT9njU6d7ipM01A4+qc/gMWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ePjLCyKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ePjLCyKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEECC43390;
	Tue, 12 Mar 2024 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274185;
	bh=NdT9+xtXVRhjwrNuf9vsQ4y+bAwulGLgGt2mWNDz7Dg=;
	h=Date:To:From:Subject:From;
	b=ePjLCyKkHiKNM+bzimOshEPjE8NobHRiMVgGSj7d1kTJ7hosd3Fp4Yb5m4VKrcsgQ
	 t9h5XVyBQBj6JzyhT3A30c8Ihn7u4WXIzMSfEYDd6JjFE89DiinllgSZqxTYSSl/9x
	 GkrywEJoEIu+5wGBUCInGdjSluFzaZcsw//sKe0M=
Date: Tue, 12 Mar 2024 13:09:45 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-use-div64_ul-instead-of-do_div.patch removed from -mm tree
Message-Id: <20240312200945.9CEECC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: use div64_ul() instead of do_div()
has been removed from the -mm tree.  Its filename was
     nilfs2-use-div64_ul-instead-of-do_div.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: nilfs2: use div64_ul() instead of do_div()
Date: Wed, 6 Mar 2024 23:25:47 +0900

Fixes Coccinelle/coccicheck warnings reported by do_div.cocci.

Compared to do_div(), div64_ul() does not implicitly cast the divisor and
does not unnecessarily calculate the remainder.

Link: https://lkml.kernel.org/r/20240229210456.63234-2-thorsten.blum@toblux.com
Link: https://lkml.kernel.org/r/20240306142547.4612-1-konishi.ryusuke@gmail.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c    |    2 +-
 fs/nilfs2/dat.c       |    2 +-
 fs/nilfs2/ioctl.c     |    4 ++--
 fs/nilfs2/sufile.c    |    2 +-
 fs/nilfs2/super.c     |    2 +-
 fs/nilfs2/the_nilfs.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-use-div64_ul-instead-of-do_div
+++ a/fs/nilfs2/cpfile.c
@@ -28,7 +28,7 @@ nilfs_cpfile_get_blkoff(const struct ino
 {
 	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
 
-	do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
+	tcno = div64_ul(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 	return (unsigned long)tcno;
 }
 
--- a/fs/nilfs2/dat.c~nilfs2-use-div64_ul-instead-of-do_div
+++ a/fs/nilfs2/dat.c
@@ -460,7 +460,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 		kaddr = kmap_local_page(entry_bh->b_page);
 		/* last virtual block number in this block */
 		first = vinfo->vi_vblocknr;
-		do_div(first, entries_per_block);
+		first = div64_ul(first, entries_per_block);
 		first *= entries_per_block;
 		last = first + entries_per_block - 1;
 		for (j = i, n = 0;
--- a/fs/nilfs2/ioctl.c~nilfs2-use-div64_ul-instead-of-do_div
+++ a/fs/nilfs2/ioctl.c
@@ -1111,7 +1111,7 @@ static int nilfs_ioctl_set_alloc_range(s
 	segbytes = nilfs->ns_blocks_per_segment * nilfs->ns_blocksize;
 
 	minseg = range[0] + segbytes - 1;
-	do_div(minseg, segbytes);
+	minseg = div64_ul(minseg, segbytes);
 
 	if (range[1] < 4096)
 		goto out;
@@ -1120,7 +1120,7 @@ static int nilfs_ioctl_set_alloc_range(s
 	if (maxseg < segbytes)
 		goto out;
 
-	do_div(maxseg, segbytes);
+	maxseg = div64_ul(maxseg, segbytes);
 	maxseg--;
 
 	ret = nilfs_sufile_set_alloc_range(nilfs->ns_sufile, minseg, maxseg);
--- a/fs/nilfs2/sufile.c~nilfs2-use-div64_ul-instead-of-do_div
+++ a/fs/nilfs2/sufile.c
@@ -48,7 +48,7 @@ nilfs_sufile_get_blkoff(const struct ino
 {
 	__u64 t = segnum + NILFS_MDT(sufile)->mi_first_entry_offset;
 
-	do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
+	t = div64_ul(t, nilfs_sufile_segment_usages_per_block(sufile));
 	return (unsigned long)t;
 }
 
--- a/fs/nilfs2/super.c~nilfs2-use-div64_ul-instead-of-do_div
+++ a/fs/nilfs2/super.c
@@ -448,7 +448,7 @@ int nilfs_resize_fs(struct super_block *
 
 	sb2off = NILFS_SB2_OFFSET_BYTES(newsize);
 	newnsegs = sb2off >> nilfs->ns_blocksize_bits;
-	do_div(newnsegs, nilfs->ns_blocks_per_segment);
+	newnsegs = div64_ul(newnsegs, nilfs->ns_blocks_per_segment);
 
 	ret = nilfs_sufile_resize(nilfs->ns_sufile, newnsegs);
 	up_write(&nilfs->ns_segctor_sem);
--- a/fs/nilfs2/the_nilfs.c~nilfs2-use-div64_ul-instead-of-do_div
+++ a/fs/nilfs2/the_nilfs.c
@@ -413,7 +413,7 @@ static u64 nilfs_max_segment_count(struc
 {
 	u64 max_count = U64_MAX;
 
-	do_div(max_count, nilfs->ns_blocks_per_segment);
+	max_count = div64_ul(max_count, nilfs->ns_blocks_per_segment);
 	return min_t(u64, max_count, ULONG_MAX);
 }
 
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are


