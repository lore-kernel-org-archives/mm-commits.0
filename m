Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1CF3921E7
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298484; cv=none; b=EUMCRs9dGbGnOLwr0sHinNLDs9pHnp8Ck9IEs0YIdjZ6wjwvl/u/cB4UYD72o71oA6qC01jYP7rxF8XzgemTIBHwQTZciQlog5M77KAfbkr88BwaVRhffo+1TN5f+CtT4bubaJIULjGBSBwcH0NNi52nHdpsyiNkhWghaLAvKAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298484; c=relaxed/simple;
	bh=CpVX9W4fqNhksLWnCWZ7H56itQP44IvGXY4v7lo4Nx8=;
	h=Date:To:From:Subject:Message-Id; b=PV8+4WLldYVlmL1jDtKAz+a8nZzAue9bPoxJOSyvRF6qoToGRGxA8Tc6BDuA0iwLhzw79Tk22tGu8dDdRaPQerfBiRIuSvazTUICM8//+hk4RZjCtvEWM8SR1w35nu3q0SyF6W+rLYNEaAshngxh0RJYSPf2GYht3KeU77xFD74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HW1GoySD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HW1GoySD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D307C1F000E9;
	Wed, 29 Jul 2026 04:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298482;
	bh=XHzr2ZgI1BVlqNkbs3LbaWj2XtdqKZ7r0Ss5zT9p2pI=;
	h=Date:To:From:Subject;
	b=HW1GoySDJRyZeiNL0SyKsaNyHIHU7wPzPqYSb4s5tjo6prahF3GuClz/8vNh+XYbI
	 1iNC7ISa5jCJAdIpwydkC/nA8YTCSc2/wjOKTrW5sHvnqh9BqlkZufamFrWSbbpwN4
	 mJKBwlYVaGnR/aKrDiZCNNpKpYFJxexNLcACr8dg=
Date: Tue, 28 Jul 2026 21:14:42 -0700
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,alhouseenyousef@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tmpfs-zero-unused-folio-tail-for-long-symlinks.patch removed from -mm tree
Message-Id: <20260729041442.D307C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tmpfs: zero unused folio tail for long symlinks
has been removed from the -mm tree.  Its filename was
     tmpfs-zero-unused-folio-tail-for-long-symlinks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: tmpfs: zero unused folio tail for long symlinks
Date: Sun, 28 Jun 2026 02:43:14 +0200

shmem_symlink() marks the entire folio uptodate after copying only the
NUL-terminated link target.  The remainder of the freshly allocated folio
is left uninitialized.

Reclaim may pass the whole folio to a swap compressor.  KMSAN observed
sw842_compress() computing a checksum over the uninitialized tail.  If the
folio is written to a swap device, those bytes can also leave the kernel.

Zero the remainder of the folio before marking it uptodate and dirty.

Link: https://lore.kernel.org/20260628004314.27370-1-alhouseenyousef@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bf5586280a66e9ccdfa9
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c~tmpfs-zero-unused-folio-tail-for-long-symlinks
+++ a/mm/shmem.c
@@ -4067,6 +4067,7 @@ static int shmem_symlink(struct mnt_idma
 			goto out_remove_offset;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
+		folio_zero_range(folio, len, folio_size(folio) - len);
 		folio_mark_uptodate(folio);
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
_

Patches currently in -mm which might be from alhouseenyousef@gmail.com are


