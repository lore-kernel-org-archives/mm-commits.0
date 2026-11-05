Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793896914;
	b=BF9ovWeQyuCSefH1X/L3wBKSDW5bMLHn8cfv4Z6Dgexe8eRbS/OQuOaeAA47n85Ub3i0
	 qOv9YSZ+iW8a+NgM42ipVzrAA7LEgXuBIvrslRy5ZDJSDPGcoL3OZpxoun+ihduoQbm+3
	 uJl/1p2wsXBaz+xxdl0AIbiAUzuBS6buzlM+FNq9/x9CvUz9Smj6B7hjLYUb++MasfVQE
	 U/3KnfX4w5ViDIOKPWH1O8mZaGyx/9zsAmICcvzC6AWKgKWvtzbG/f18n+TvRytDaE8Xu
	 8arDVorlixKPV7fmVwxcckMYkGtrqEPyBGzIvGV673XAD1sUE72W0aBR4/MiA2nCHKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793896914;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uve9CrjeruoROm0DH7vsX/tvv8UkL4yJLlYEyWJ6ppQ=;
	b=hV26jGTMfT4BueHolNn2WD8V/XzitDgCSAH1zIo5tMeSJKh83kjfJqa5+s3c80EE8gIZ
	 07rCmfuA/cNkZ0hL9ktbqeVLrOv5bWAPrdFvV/e9VyFqSpBtFecyOnhoQkzFcyqwkmnVB
	 1/7GZHJxiuHKgYVfguW+/BA+b/v4i25oiwxNLql6yRqqUaRWhwvOCtqKCRcn7Jr39G2VN
	 ZzK5nBDJT8/HKXokEA2sXEOJZWL17cfNAcjjwj2F0tkawDQLXPZ+3uEwwkPNI/0+2daGf
	 NgxhmFbH0pcnGL04tKj0jwqWSmFv3NVbT4MLT9OjUdoX717yHf39sMYPslt+PKLMTZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u4PPLmNA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B926606A31B
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u4PPLmNA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE8A1F000C1;
	Thu,  5 Nov 2026 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793896913;
	bh=uve9CrjeruoROm0DH7vsX/tvv8UkL4yJLlYEyWJ6ppQ=;
	h=Date:To:From:Subject;
	b=u4PPLmNAmP15aH1bBaExNVDQGXI0I6gMmTJYmOGLTZFoFoLXELEfBeXJvhG19iS20
	 QNJ+5/U1iHbqJAbKydhJ/Pl+xGRUaq07GBV6X38v4YloZ6ARupsQqto1XcN+Lhi2Lz
	 k4mfCPh7jSgx6YpfKz30mOUUMSkNCbqbPD+tFcCM=
Date: Thu, 05 Nov 2026 08:41:53 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,jack@suse.cz,
	brauner@kernel.org,parri.andrea@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] iov_iter-take-an-unsigned-long-segment-count-in-import_iovec.patch removed from -mm tree
Message-Id: <20261105164153.CCE8A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: iov_iter: take an unsigned long segment count in import_iovec()
has been removed from the -mm tree.  Its filename was
     iov_iter-take-an-unsigned-long-segment-count-in-import_iovec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Parri <parri.andrea@gmail.com>
Subject: iov_iter: take an unsigned long segment count in import_iovec()
Date: Mon, 26 Oct 2026 19:06:18 +0100

readv(), writev() and their positional variants, process_vm_readv(),
process_vm_writev(), vmsplice(), process_madvise(), vectored aio and the
btrfs encoded I/O ioctls all take a full-width segment count, and all of
them hand it to import_iovec() or __import_iovec().  Those take an
unsigned int count, so on 64-bit kernels the upper 32 bits are dropped
before iovec_from_user() checks the count against UIO_MAXIOV.

A count of 0x100000001 is therefore imported as one segment: writev() on a
pipe writes a byte and readv() reads it back, instead of both failing with
EINVAL.  A count of 0x100000000 returns 0 as an empty vector.

import_iovec() was added with an unsigned int count, but the helper it
wrapped, rw_copy_check_uvector(), took an unsigned long, as does
iovec_from_user() today.  Until v4.1, readv(), writev(), preadv(),
pwritev(), process_vm_readv(), process_vm_writev() and vectored aio
therefore failed these counts with EINVAL, as did vmsplice() until v4.18.

Widen nr_segs in both import helpers so the UIO_MAXIOV check sees the
count the caller passed.  Callers with 32-bit counts are unaffected.

AI assistance was used to find the bug, develop the fix, and run the
reproducers.

Link: https://lore.kernel.org/20261026180619.4147910-1-parri.andrea@gmail.com
Fixes: bc917be81059 ("saner iov_iter initialization primitives")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
---

 include/linux/uio.h |    8 ++++----
 lib/iov_iter.c      |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/uio.h~iov_iter-take-an-unsigned-long-segment-count-in-import_iovec
+++ a/include/linux/uio.h
@@ -373,11 +373,11 @@ struct iovec *iovec_from_user(const stru
 		unsigned long nr_segs, unsigned long fast_segs,
 		struct iovec *fast_iov, bool compat);
 ssize_t import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i);
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i);
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i, bool compat);
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i, bool compat);
 int import_ubuf(int type, void __user *buf, size_t len, struct iov_iter *i);
 
 static inline void iov_iter_ubuf(struct iov_iter *i, unsigned int direction,
--- a/lib/iov_iter.c~iov_iter-take-an-unsigned-long-segment-count-in-import_iovec
+++ a/lib/iov_iter.c
@@ -1382,8 +1382,8 @@ static ssize_t __import_iovec_ubuf(int t
 }
 
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i, bool compat)
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i, bool compat)
 {
 	ssize_t total_len = 0;
 	unsigned long seg;
@@ -1454,7 +1454,7 @@ ssize_t __import_iovec(int type, const s
  * Return: Negative error code on error, bytes imported on success
  */
 ssize_t import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs,
+		 unsigned long nr_segs, unsigned int fast_segs,
 		 struct iovec **iovp, struct iov_iter *i)
 {
 	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i,
_

Patches currently in -mm which might be from parri.andrea@gmail.com are


