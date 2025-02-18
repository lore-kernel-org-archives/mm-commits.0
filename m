Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC4D1B218A;
	Tue, 18 Feb 2025 06:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860845; cv=none; b=I2XA6+65yw9LUmXTGx78o4YZGkdpeZGKALjGKosXq6Xyx8Yfuhynu1HhMvuCu/z8WcLev91n0BvwZRZ1tf5AvEf6pOwI6l6Cp5xFx+zJ6IAUo4EYRefDMDyM6TJzxfmfRKgBoUyknKL0Ah3NGMyfegz9LAXRYYVEMju763nWz6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860845; c=relaxed/simple;
	bh=UX6HP+cKTZ77dTbXSCoUxS1rcVlZqV8HlfcZ7I1nyeE=;
	h=Date:To:From:Subject:Message-Id; b=eufmQGH4cCak1J659JIRdZoHylZtGhG12IDlXc5cf69rRRI2Jg2ml57B0p7MNEvtwIXdyafVS/8wykLJOJRzDCapESIXN41a+5ykv63S4+05qXSuECZ87h9XBfxngtJeArFswm7w8LzfH8HYtzk0jeR6Zb3/v+yMPJEe/jPBBWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1TJCbHcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1TJCbHcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6459FC4CEE2;
	Tue, 18 Feb 2025 06:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860844;
	bh=UX6HP+cKTZ77dTbXSCoUxS1rcVlZqV8HlfcZ7I1nyeE=;
	h=Date:To:From:Subject:From;
	b=1TJCbHcSUYsJbJWvefKhAW4W5qRSCfsl/KHg7nwd8tU+VcuK3BdOylkkMeVhUoibo
	 bQIGNhLn+jXj6ppLKzmj8TiYCwvD6YZ20MC9Ew2Hy05NZg/mn2EX2ZHmJGQRm4rntS
	 aGKEN6ghTrDjHzAQHMMEpUu2qUq8L3hsrKL5D+K8=
Date: Mon, 17 Feb 2025 22:40:43 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,brauner@kernel.org,axboe@kernel.dk,asml.silence@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-iov_iter-fix-import_iovec_ubuf-iovec-management.patch removed from -mm tree
Message-Id: <20250218064044.6459FC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/iov_iter: fix import_iovec_ubuf iovec management
has been removed from the -mm tree.  Its filename was
     lib-iov_iter-fix-import_iovec_ubuf-iovec-management.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: lib/iov_iter: fix import_iovec_ubuf iovec management
Date: Fri, 31 Jan 2025 14:13:15 +0000

import_iovec() says that it should always be fine to kfree the iovec
returned in @iovp regardless of the error code.  __import_iovec_ubuf()
never reallocates it and thus should clear the pointer even in cases when
copy_iovec_*() fail.

Link: https://lkml.kernel.org/r/378ae26923ffc20fd5e41b4360d673bf47b1775b.1738332461.git.asml.silence@gmail.com
Fixes: 3b2deb0e46da ("iov_iter: import single vector iovecs as ITER_UBUF")
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


