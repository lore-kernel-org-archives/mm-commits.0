Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793042276;
	b=vSjZcCvU1JTAoX4UXsZtzWM+TkOxmdXwhRuTK7YXZx3oFpE7+k+bRBEfo5L9xx771zNh
	 QNSF07TKugg1QaXXt9+6fBkHLtt4IcSBo1IXQ97cHlz8OskfmR3AHO0HOjJXYQoMYwfET
	 YOvOY8X/RQusAWjP7LWOxNj2sI475Psi4EkxyftEccdT2G79BPVKpCim6Jn5I18MFJLrZ
	 +WuvW0nswuz+UKBL3wooqx13PxAg6Gbc5vCZUYekOYvOKN54Hd85X1JWi9tasiGH9trRL
	 m8qcSekuKaBUZ6a1sZBvFZTDFq7IU7lsmsP6ex9hceUZUW+sFq8XLAJsOsWdy/XtvGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793042276;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pRsxTXG+8KZrmLlOADf2tt4AyiIufgQmGCN8aJn6Rs8=;
	b=MR03eSnEZMbBB87NN9imDBZ5CpIJQdIPtotMERzR4ba9oTgEEjdlaTyc8+FSYW+UdzgW
	 uoa1FSKpCtzcI+Zratqrjics9d4JEzKFMnjLQCw+OhvqGtNg3P/qimUJ/a9arUM0CneSr
	 4mHJfhcoqCcQUAGAgu0jj1OmVSDWhP+6i1v8JFkfujV6jO4uRfDsarOkkP+5ZL0xzEUIA
	 YrfebPeI6R5xduyUn8Sda3ar7sHB58FfDRqjGNALHiEfRGJPSzyOkpPZpGWvefzRWIZMR
	 vbiOtRfQ5rF6pAyRmq+y39iS8Lc9T38qWjbdCS92sOTeUoHuarkooHB+zZfJZiM7QuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kthoTBfZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8335606A321
	for <mm-commits@vger.kernel.org>; Mon, 26 Oct 2026 19:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kthoTBfZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1078A1F01825;
	Mon, 26 Oct 2026 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793042275;
	bh=pRsxTXG+8KZrmLlOADf2tt4AyiIufgQmGCN8aJn6Rs8=;
	h=Date:To:From:Subject;
	b=kthoTBfZiASunFoUPdg56l1seXNstPjzmnscZNp1izA4UP1hKvO2rjvSUWUfGlSlc
	 5KKZu579OesbAR9WXCYd2VZsqBeaK0ga5nxce+1IuZ8t1cd6J0ChIBSDtr2Xdkmgby
	 D7X8dM5wwa4rHGYqg+EixLSVaQUcRzvH39z4joS0=
Date: Mon, 26 Oct 2026 12:17:54 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,jack@suse.cz,
	brauner@kernel.org,parri.andrea@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-take-an-unsigned-long-segment-count-in-import_iovec.patch added to mm-nonmm-unstable branch
Message-Id: <20261026191755.1078A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: iov_iter: take an unsigned long segment count in import_iovec()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     iov_iter-take-an-unsigned-long-segment-count-in-import_iovec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-take-an-unsigned-long-segment-count-in-import_iovec.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
---

 include/linux/uio.h |    8 ++++----
 lib/iov_iter.c      |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/uio.h~iov_iter-take-an-unsigned-long-segment-count-in-import_iovec
+++ a/include/linux/uio.h
@@ -362,11 +362,11 @@ struct iovec *iovec_from_user(const stru
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
@@ -1362,8 +1362,8 @@ static ssize_t __import_iovec_ubuf(int t
 }
 
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i, bool compat)
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i, bool compat)
 {
 	ssize_t total_len = 0;
 	unsigned long seg;
@@ -1434,7 +1434,7 @@ ssize_t __import_iovec(int type, const s
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

iov_iter-take-an-unsigned-long-segment-count-in-import_iovec.patch

