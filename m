Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7EA1FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186177; cv=none; b=pX0QdT3zsKWvk/NgPhMagu0QGOU7T2aWVHQXTup9AuF7OD4GRXMQso1xTZ4AYuU2ImGfUqi7BJfBKI59O0/dTP2NnLgXaO/4bbJFiQwcvJ+GNonrFl8ROaaUp/7pN0YOn0NooGiDLpzpyi5XNrqF7UcmevUqr25kgl+KGS3T19Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186177; c=relaxed/simple;
	bh=hL3/j4nuOrTFk99LEpvqY7rB9Gs38iAfsdCxRyOEJF0=;
	h=Date:To:From:Subject:Message-Id; b=ebsI8J4mrrQoynUhxc0H0Lr9LH/T9ffxG7IxsdNN42rhevS8dCZV1OY4K1X0GIUE+/9B0+BrBypJMEveObWfpb4jvNxMIHcWGyaK5buuHYEXKxefyzC9KJGELXjYucDVVTLnSAJA7hxOswP0K2V7MwdCTb0S3Pa+M2qWJLpIbCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NEv+du+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NEv+du+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FEDC4CEEB;
	Fri,  6 Jun 2025 05:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186176;
	bh=hL3/j4nuOrTFk99LEpvqY7rB9Gs38iAfsdCxRyOEJF0=;
	h=Date:To:From:Subject:From;
	b=NEv+du+h6qRV8jg+BACc+akMzDNIrJqOrevmcBQWCoC2ErSrg+QdvfE765LF7ndVy
	 h/TGknrmGjXBEDE8tPn06FCsmqntnQcn09YV3Mr6xr9LwXzMz4hqtdz8S6NGadkeb6
	 8Wt3aGeLSVjUYcBbYGlCQUQCi54dGgPlqIDQEDjw=
Date: Thu, 05 Jun 2025 22:02:56 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,kbusch@kernel.org,brauner@kernel.org,axboe@kernel.dk,anuj20.g@samsung.com,nj.shetty@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec.patch removed from -mm tree
Message-Id: <20250606050256.D9FEDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec
has been removed from the -mm tree.  Its filename was
     iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nitesh Shetty <nj.shetty@samsung.com>
Subject: iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec
Date: Mon, 28 Apr 2025 15:28:48 +0530

If iov_offset is non-zero, then we need to consider iov_offset in length
calculation, otherwise we might pass smaller IOs such as 512 bytes, in
below scenario [1].

This issue is reproducible using lib-uring test/fixed-seg.c application
with fixed buffer on a 512 LBA formatted device.

[1]

At present we pass the alignment check, for 512 LBA formatted devices,
len_mask = 511 when IO is smaller, i->count = 512 has an offset,
i->io_offset = 3584 with bvec values, bvec->bv_offset = 256,
bvec->bv_len = 3840.  In short, the first 256 bytes are in the current
page, next 256 bytes are in the another page.  Ideally we expect to
fail the IO.


I can think of 2 userspace scenarios where we experience this.

a: From userspace, we observe a different behaviour when device LBA
   size is 512 vs 4096 bytes.  For 4096 LBA formatted device, I see the
   same liburing test [2] failing, whereas 512 the test passes without
   this.  This is reproducible everytime.

   [2] https://github.com/axboe/liburing/

b: Although I was not able to reproduce the below condition, but I
   suspect below case should be possible from user space for devices
   with 512 LBA formatted device.  Lets say from userspace while
   allocating a virtually single chunk of memory, if we get 2 physical
   chunk of memory, and IO happens to be at the boundary of first
   physical chunk with length crossing first chunk, then we allow IOs
   to proceed and hence we might map wrong physical address length and
   proceed with IO rather than failing.

: --- a/test/fixed-seg.c
: +++ b/test/fixed-seg.c
: @@ -64,7 +64,7 @@ static int test(struct io_uring *ring, int fd, int
: vec_off)
: 		return T_EXIT_FAIL;
: 	}
: 
: -       ret = read_it(ring, fd, 4096, vec_off);
: +       ret = read_it(ring, fd, 4096, 7*512 + 256);
: 	if (ret) {
: 		fprintf(stderr, "4096 0 failed\n");
: 		return T_EXIT_FAIL;

Effectively this is a write crossing the page boundary.

Link: https://lkml.kernel.org/r/20250428095849.11709-1-nj.shetty@samsung.com
Fixes: 2263639f96f2 ("iov_iter: streamline iovec/bvec alignment iteration")
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/iov_iter.c~iov_iter-use-iov_offset-for-length-calculation-in-iov_iter_aligned_bvec
+++ a/lib/iov_iter.c
@@ -817,7 +817,7 @@ static bool iov_iter_aligned_bvec(const
 	size_t size = i->count;
 
 	do {
-		size_t len = bvec->bv_len;
+		size_t len = bvec->bv_len - skip;
 
 		if (len > size)
 			len = size;
_

Patches currently in -mm which might be from nj.shetty@samsung.com are


