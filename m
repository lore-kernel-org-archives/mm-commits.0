Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B852F56;
	Fri, 31 Jan 2025 22:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738362655; cv=none; b=fFiYCLVv6MK84PpiUd3Wrk8KGplH4t43CEo3pcayw1oLAcEUbRLJ9LxSvWEsVMZ4u/MwZBQiEpF9N8ybABx0Yjo2yQ/WS3FdgI1O26iTqJVo/6NRQn85AqfOoHyZuXrKYQFWQRW/mRXMh4r9/L/uUhLbtkyIF2rNlae8p29twNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738362655; c=relaxed/simple;
	bh=QaWa3GJyXQueClS9mTW4gATZ+uT5UhNwhvvBKtBZG24=;
	h=Date:To:From:Subject:Message-Id; b=aSX5mSUSjjKO9kTc3frJEAWX+8Gk+yNUqI5n401pgEqTA1wCu4W4JuIoMdK/c8ePQOy09udnC7XTB5ept2K1EhLIpejSPrtnrdnBFoX5IV2k5sYcnOwGwCZFGBLg/M82Dy3FVKXyZYaYG/arvfUt7RKadHsA2Z600CqXt5W0gAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQyYScF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQyYScF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D139DC4CED1;
	Fri, 31 Jan 2025 22:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738362654;
	bh=QaWa3GJyXQueClS9mTW4gATZ+uT5UhNwhvvBKtBZG24=;
	h=Date:To:From:Subject:From;
	b=CQyYScF9a5CqtKEsmFksQR3Sp1tXTGtIiawQWITK6L3DraT/OCCP4fUI0D5G7M6FM
	 Po9O6IuYiWjMK4TiB/LC3l/yNFclJXmqIiaos+aFLmV4OQKHR/uw9YS75+fo43kCwK
	 7+sfnXFFNwDOvz9R8nb7XzaZgNwzKLCOKSfgn6Tk=
Date: Fri, 31 Jan 2025 14:30:54 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,brauner@kernel.org,axboe@kernel.dk,asml.silence@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-iov_iter-fix-import_iovec_ubuf-iovec-management.patch added to mm-hotfixes-unstable branch
Message-Id: <20250131223054.D139DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/iov_iter: fix import_iovec_ubuf iovec management
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-iov_iter-fix-import_iovec_ubuf-iovec-management.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-iov_iter-fix-import_iovec_ubuf-iovec-management.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: lib/iov_iter: fix import_iovec_ubuf iovec management
Date: Fri, 31 Jan 2025 14:13:15 +0000

import_iovec() says that it should always be fine to kfree the iovec
returned in @iovp regardless of the error code.  __import_iovec_ubuf()
never reallocates it and thus should clear the pointer even in cases when
copy_iovec_*() fail.

Link: https://lkml.kernel.org/r/378ae26923ffc20fd5e41b4360d673bf47b1775b.1738332461.git.asml.silence@gmail.com
Fixes: 3b2deb0e46da9 ("iov_iter: import single vector iovecs as ITER_UBUF")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/iov_iter.c~lib-iov_iter-fix-import_iovec_ubuf-iovec-management
+++ a/lib/iov_iter.c
@@ -1428,6 +1428,8 @@ static ssize_t __import_iovec_ubuf(int t
 	struct iovec *iov = *iovp;
 	ssize_t ret;
 
+	*iovp = NULL;
+
 	if (compat)
 		ret = copy_compat_iovec_from_user(iov, uvec, 1);
 	else
@@ -1438,7 +1440,6 @@ static ssize_t __import_iovec_ubuf(int t
 	ret = import_ubuf(type, iov->iov_base, iov->iov_len, i);
 	if (unlikely(ret))
 		return ret;
-	*iovp = NULL;
 	return i->count;
 }
 
_

Patches currently in -mm which might be from asml.silence@gmail.com are

lib-iov_iter-fix-import_iovec_ubuf-iovec-management.patch

