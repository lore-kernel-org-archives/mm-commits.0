Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBFC17B50B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855679; cv=none; b=E1NK/P0woe+4I/Xe9YW5NfuZnYw0Q512QS4pV0eiSNIfMe9ka4UFlNE2bTM5whTYivr6qSq+YpT91a8/Kd8cnSzZf+oGkDnYlASQm+j+NVAU5mJcnga028oUzXAk1gboLSXYD66yOabhS86cNN7YkvBrYwc6FW7eh/LRTSJPB4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855679; c=relaxed/simple;
	bh=PJhgMIy/MbIWTHWPpaWA2X21gLfX2ylo3AJSAz5u0GU=;
	h=Date:To:From:Subject:Message-Id; b=X04yc7BnyTEkDMajzxs7ItgRJTuQVMbEDdbiqXnTgxW6VXCrAGKdnRONIwZtFzXxGDpwc6J+qMer5buXenp1o4rWXIG03m9tBX4l8kckfzSAvsYDJJaX/xMGcAym5VzTHdt9vrNdkyFtmOIcLQnwzYUBkdyVFR/F7YuwE+1A3WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ScVzeglg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ScVzeglg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5448EC4CECF;
	Wed,  6 Nov 2024 01:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855679;
	bh=PJhgMIy/MbIWTHWPpaWA2X21gLfX2ylo3AJSAz5u0GU=;
	h=Date:To:From:Subject:From;
	b=ScVzeglg25UndiG98ALbSXlwp4V7Vt8cHd0hjHclw98Zjdu2hbgJcHrEHp4DfZHyY
	 +z/e59aTYYUFBVx8lLeNfAWAg8ZOXyVzc+hteuOGhIIzo1HzFeB6VS7bdzZu63j6q4
	 m4AFUp9G8OEZ2qqUilJeiw5rkkEQmP9df7pxzSSc=
Date: Tue, 05 Nov 2024 17:14:38 -0800
To: mm-commits@vger.kernel.org,sumit.semwal@linaro.org,christian.koenig@amd.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dma-buf-use-atomic64_inc_return-in-dma_buf_getfile.patch removed from -mm tree
Message-Id: <20241106011439.5448EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dma-buf: use atomic64_inc_return() in dma_buf_getfile()
has been removed from the -mm tree.  Its filename was
     dma-buf-use-atomic64_inc_return-in-dma_buf_getfile.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: dma-buf: use atomic64_inc_return() in dma_buf_getfile()
Date: Mon, 7 Oct 2024 10:37:52 +0200

Use atomic64_inc_return(&ref) instead of atomic64_add_return(1, &ref) to
use optimized implementation and ease register pressure around the
primitive for targets that implement optimized variant.

Link: https://lkml.kernel.org/r/20241007083921.47525-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: "Christian König" <christian.koenig@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/dma-buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-buf.c~dma-buf-use-atomic64_inc_return-in-dma_buf_getfile
+++ a/drivers/dma-buf/dma-buf.c
@@ -558,7 +558,7 @@ static struct file *dma_buf_getfile(size
 	 * Override ->i_ino with the unique and dmabuffs specific
 	 * value.
 	 */
-	inode->i_ino = atomic64_add_return(1, &dmabuf_inode);
+	inode->i_ino = atomic64_inc_return(&dmabuf_inode);
 	flags &= O_ACCMODE | O_NONBLOCK;
 	file = alloc_file_pseudo(inode, dma_buf_mnt, "dmabuf",
 				 flags, &dma_buf_fops);
_

Patches currently in -mm which might be from ubizjak@gmail.com are


