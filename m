Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BF1379C57
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 20:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785529945; cv=none; b=qOvh5pTcMG38dSbqzM8JRuLpNARhGZh2YJnxSyhiNdQbZX2aGEc7cdIPZ4SKWVsLmXB7vXehov7KUnuxpOe9rTwpz3Zb0mvYtZcYInF7Gy9gHlQi+yE369P+LkC34PQFqttkeTwNn5WJSdPowU63lGUrRAD5f3SlJ2mwNPgv1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785529945; c=relaxed/simple;
	bh=Mo4dO+bmKouvFU16iqLlU9a5ZMUNCslN9aaubJPWQFs=;
	h=Date:To:From:Subject:Message-Id; b=F30yYHNJ65k1GNhKN58JK6DZ3gHKg7ipbwrtLJ309YDsMfNty8mNsbwwdcxH2t237LwblKlaCEm/7Y3r1nbfYyS9tGtT4ppxJfsLGPM1E17mqi62JPtlC8nY71ubF2Suj75UDqHqvWzlebYaAZgVTMBlQ23k207Qf89GOeYcX/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vLlX2KdL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vLlX2KdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3FB1F00AC4;
	Fri, 31 Jul 2026 20:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785529943;
	bh=eTqFRHD7Px4+ZbttW6sHasq5Tasy9Snr6xZXRSBXw34=;
	h=Date:To:From:Subject;
	b=vLlX2KdLOMOBIYZZSyLCZseaApdWqhPD9vpzmlhg4aHU1eZ8oRrwoS/qtlsCiJ+do
	 bF+jqueRqV5odTiTu2WPYfdyF0OTZeKVRNCV+FrpPXtgu5R2sKFovrTpp/E0vCtpME
	 edBm0XFJM2/rPgHjTzz0qu/P+6bs0dvPFqc8N9oU=
Date: Fri, 31 Jul 2026 13:32:22 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,hughd@google.com,baolin.wang@linux.alibaba.com,zhilinz@nebusec.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-reject-page-aligned-fallocate-end-overflow.patch added to mm-new branch
Message-Id: <20260731203223.1F3FB1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: reject page-aligned fallocate end overflow
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-reject-page-aligned-fallocate-end-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-reject-page-aligned-fallocate-end-overflow.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -3627,6 +3627,7 @@ static long shmem_fallocate(struct file
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_falloc shmem_falloc;
 	pgoff_t start, index, end, undo_fallocend;
+	loff_t aligned_end;
 	int error;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -3683,8 +3684,15 @@ static long shmem_fallocate(struct file
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

mm-page_table_check-skip-special-zero-mappings.patch
mm-shmem-reject-page-aligned-fallocate-end-overflow.patch

