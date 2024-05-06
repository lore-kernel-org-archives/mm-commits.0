Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DE63B79F
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958112; cv=none; b=BC6uXk7mWofV6ReIPNQm1tdAcUWbRorWybKOTEVf4aMASatepoilJxRGIq3KQjplr7KiB807164gehjQ4DiBfEOxwP5l8bR6Qb4+8Chz3rsA9smMZ/cCv/k+iKkRDjzbqW+usle8cchLSC0vVLkM22cpHaylCOBkoTwfVlvEK58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958112; c=relaxed/simple;
	bh=B7bvLj7bCZZdDSlklcGrDuHEbES+z9NPpZQUekEdcbE=;
	h=Date:To:From:Subject:Message-Id; b=A5YBaJWT9LSsdkJHEwJY9SqNunevIItDhVacp/Wc/q6t2rjKQXvJ4QONJ3sR3DKqhdGmgL0fLOfwXELJeL0Noqe7ZeifDqqKtsJa4XWXMABymYa0JJbq/+MseyuIJ9h4VR1IloYmnUtivOrlSAKoPtUeNcTad0SnmsaT6xt+MNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vxE/Z/Qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vxE/Z/Qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00CBC113CC;
	Mon,  6 May 2024 01:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958111;
	bh=B7bvLj7bCZZdDSlklcGrDuHEbES+z9NPpZQUekEdcbE=;
	h=Date:To:From:Subject:From;
	b=vxE/Z/Qq0dVY8vVOxzApxEhrvaYOlV+S50Hk1c0CLG8arcTPzK3lZKZL3tned/hu7
	 uSAzgd+1F0Q+7b77sOQJEpv9sZoGfXxcchVGc2oydyI8/ooRvdKlWElazv2IirwCQZ
	 8rIyhrUvx6JnmHWLHy/SmfQ4gBk8iY9fQz3Z+4d4=
Date: Sun, 05 May 2024 18:15:11 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,bvanassche@acm.org,axboe@kernel.dk,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-make-superblock-data-array-index-computation-sparse-friendly.patch removed from -mm tree
Message-Id: <20240506011511.C00CBC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: make superblock data array index computation sparse friendly
has been removed from the -mm tree.  Its filename was
     nilfs2-make-superblock-data-array-index-computation-sparse-friendly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: make superblock data array index computation sparse friendly
Date: Tue, 30 Apr 2024 17:00:19 +0900

Upon running sparse, "warning: dubious: x & !y" is output at an array
index calculation within nilfs_load_super_block().

The calculation is not wrong, but to eliminate the sparse warning, replace
it with an equivalent calculation.

Also, add a comment to make it easier to understand what the unintuitive
array index calculation is doing and whether it's correct.

Link: https://lkml.kernel.org/r/20240430080019.4242-3-konishi.ryusuke@gmail.com
Fixes: e339ad31f599 ("nilfs2: introduce secondary super block")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/the_nilfs.c~nilfs2-make-superblock-data-array-index-computation-sparse-friendly
+++ a/fs/nilfs2/the_nilfs.c
@@ -592,7 +592,7 @@ static int nilfs_load_super_block(struct
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
 	u64 sb2off, devsize = bdev_nr_bytes(nilfs->ns_bdev);
-	int valid[2], swp = 0;
+	int valid[2], swp = 0, older;
 
 	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
 		nilfs_err(sb, "device size too small");
@@ -648,9 +648,25 @@ static int nilfs_load_super_block(struct
 	if (swp)
 		nilfs_swap_super_block(nilfs);
 
+	/*
+	 * Calculate the array index of the older superblock data.
+	 * If one has been dropped, set index 0 pointing to the remaining one,
+	 * otherwise set index 1 pointing to the old one (including if both
+	 * are the same).
+	 *
+	 *  Divided case             valid[0]  valid[1]  swp  ->  older
+	 *  -------------------------------------------------------------
+	 *  Both SBs are invalid        0         0       N/A (Error)
+	 *  SB1 is invalid              0         1       1         0
+	 *  SB2 is invalid              1         0       0         0
+	 *  SB2 is newer                1         1       1         0
+	 *  SB2 is older or the same    1         1       0         1
+	 */
+	older = valid[1] ^ swp;
+
 	nilfs->ns_sbwcount = 0;
 	nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
-	nilfs->ns_prot_seq = le64_to_cpu(sbp[valid[1] & !swp]->s_last_seq);
+	nilfs->ns_prot_seq = le64_to_cpu(sbp[older]->s_last_seq);
 	*sbpp = sbp[0];
 	return 0;
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


