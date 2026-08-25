Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3219349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622887; cv=none; b=QP9pqp+fwU/6O8y4kDks/6iaHZoUH1zJICWmEMAIx+hfYC0/XVP7mXW60ddvcRkw6E6WgGc640YZDTxX5zT/XDAW3wNeDef/RNX2ovN4UjkQrJ6svl2Kmxwetum9rHZgm8sTBLDLZvfXweCDB606tVRqFBpKAkQ9RbI2bO+t5hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622887; c=relaxed/simple;
	bh=8bocF0jEyzlGA33WDtCrfaGXVqHr+D/pQGZkp2refZM=;
	h=Date:To:From:Subject:Message-Id; b=qk/blMpJDvDvASkNjQa2Ij8b2iG6ZE2SS+skH/bEUUczvsuwcRMe543tCz/awPQrFlaqjbyu7YhsEVe8pcSetccqmcmMGoOjnpKf3TjT9lajW81bs9Ld8MXwFEBRwmMhmotUSsDvKJt4jjw/rIJZ8U4Oo6STRdBcpgZXfef/DpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h8HOyNOd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h8HOyNOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CB51F000E9;
	Tue, 25 Aug 2026 01:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622885;
	bh=IUk2Odlmw3ZaCVpYzeTXpn+x0F0UAfYC+CVlrSGPHnQ=;
	h=Date:To:From:Subject;
	b=h8HOyNOdRQPtSOG/yYK84LqKGdQ0LvyuXShgMSGVfSA3+xGuqev59jsP1gQmjyRSU
	 OaC+brp+SV53qt1A53/LGajmwUpVEvYLpvlck1zeZmYBG7ODpfxzLyWKRhs1+wxJgj
	 N1lz3lLLfbeg5nvh0fyx4etjn+oad028YhPLzGFE=
Date: Mon, 24 Aug 2026 18:54:45 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,hughd@google.com,baolin.wang@linux.alibaba.com,zhilinz@nebusec.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-reject-page-aligned-fallocate-end-overflow.patch removed from -mm tree
Message-Id: <20260825015445.A6CB51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: reject page-aligned fallocate end overflow
has been removed from the -mm tree.  Its filename was
     mm-shmem-reject-page-aligned-fallocate-end-overflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiling Zou <zhilinz@nebusec.ai>
Subject: mm: shmem: reject page-aligned fallocate end overflow
Date: Fri, 31 Jul 2026 11:22:51 +0800

shmem_fallocate() validates offset + len with inode_newsize_ok(), but then
rounds that end offset up to a page boundary before entering the
preallocation loop.

For a valid request ending at MAX_LFS_FILESIZE, such as offset = 0 and len
= LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overflow the
signed loff_t used for the rounded end calculation.  If that wrapped value
is then converted into a page index, shmem_fallocate() can enter the folio
allocation loop with an invalid range.

Use check_add_overflow() when calculating the page-aligned end, and fail
before entering the allocation loop if the rounded end cannot be
represented.

Link: https://lore.kernel.org/1929a466735dcbb9438936ff50b7a4fc2332a8a4.1785377919.git.zhilinz@nebusec.ai
Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-reject-page-aligned-fallocate-end-overflow
+++ a/mm/shmem.c
@@ -3617,6 +3617,7 @@ static long shmem_fallocate(struct file
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_falloc shmem_falloc;
 	pgoff_t start, index, end, undo_fallocend;
+	loff_t aligned_end;
 	int error;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -3673,8 +3674,15 @@ static long shmem_fallocate(struct file
 		goto out;
 	}
 
+	/* Check for wraparound */
+	if (check_add_overflow(offset + len, (loff_t)PAGE_SIZE - 1,
+			       &aligned_end)) {
+		error = -EFBIG;
+		goto out;
+	}
+
 	start = offset >> PAGE_SHIFT;
-	end = (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	end = aligned_end >> PAGE_SHIFT;
 	/* Try to avoid a swapstorm if len is impossible to satisfy */
 	if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
 		error = -ENOSPC;
_

Patches currently in -mm which might be from zhilinz@nebusec.ai are


