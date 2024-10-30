Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1F480C0C
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 01:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730252011; cv=none; b=TJR35e5gwjaNOX6mOdnxFt6PLhXF/urYRWtswzTi30w3dbucUx2LFPswE/w9wMpqQrACuBlnOhUj7KRzQ0mSKubIsgovDCnmdqa3D+jgwNW5INxiezJgHWQ1kCQcDWJ77vRshlQycsEuhzlJrCSxTlFEh6I52WnaVKKc332sEL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730252011; c=relaxed/simple;
	bh=97H/oJTWV0MCvhoiwwBNnTMtfi+K06Pu6/H8pKa5GLI=;
	h=Date:To:From:Subject:Message-Id; b=FvZ4538dxS7ZeZg/2BxdVPbabuGZh2w4yJ7Lm1/tVTh29MoOFSeFxM8YDVpKI/HIzgpa0Avkh5xBg6mUfiTHPk5hBYOWKrl3oE9694GChDg+q4jAF1jTOB9Jo8KhcACtHZWxTy9QUzglwTXmDphQNxTIU43NF9PioObwyNP8sVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K/DKvOpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K/DKvOpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F693C4CECD;
	Wed, 30 Oct 2024 01:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730252010;
	bh=97H/oJTWV0MCvhoiwwBNnTMtfi+K06Pu6/H8pKa5GLI=;
	h=Date:To:From:Subject:From;
	b=K/DKvOpBsCtgBfAz2SB67j4b1nsQMP2JFgjvj3pgPsR6cEbr69GUDVQInhNo85wHb
	 OBfjsFgDiUUWHwTgj116nmT2EIrSTvybQ1+gLSu5Y9tJn1TMQy5SYgt9XmOdFEjIGH
	 ZUuBzl9fR42WecYRzVPsUBsCa4WTzJ2+Cx9/AhRc=
Date: Tue, 29 Oct 2024 18:33:29 -0700
To: mm-commits@vger.kernel.org,sumit.semwal@linaro.org,christian.koenig@amd.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-buf-use-atomic64_inc_return-in-dma_buf_getfile.patch added to mm-nonmm-unstable branch
Message-Id: <20241030013330.7F693C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dma-buf: use atomic64_inc_return() in dma_buf_getfile()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dma-buf-use-atomic64_inc_return-in-dma_buf_getfile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-buf-use-atomic64_inc_return-in-dma_buf_getfile.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch
percpu-merge-verify_percpu_ptr-into-its-only-user.patch
percpu-introduce-percpu_ptr-macro.patch
percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch
dma-buf-use-atomic64_inc_return-in-dma_buf_getfile.patch

