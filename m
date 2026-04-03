Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9045369208
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198551; cv=none; b=GvfTO0xpWGL6Sw7o9yEr4UVcTwfdG92y3rybLosMZTqtKp5BZ/stNfJvqvqEG6I/aVTKnaLg7Ss673w7y3/xfDFGiS/ylLLMwq3DZVSzJofAcUXn0+Uj/sTmHjoy6mDksq26qzYyerMfT+96M/EiAvrHnkk/O2uSI+q6FIxVQGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198551; c=relaxed/simple;
	bh=Dgk24iBHXGzdZ737iaM9BBQHl/ZQZsVnpxPgamC2WE0=;
	h=Date:To:From:Subject:Message-Id; b=cvWnVuJoVBsQv4lFjp9nZg8R1qcULBOhV41Steg5HyGrmuZ8l++AmEeNRUiUGRyfZDIhJZs4qaCOOspP9VgUDXX91wRWanl0DLMXbHXanVZBDyzvUliHY50EqvTmWDvOhTOX4FRJp5A/HW6Bd4yBvUQPnzEurto3+MJLN0Ddw4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M8CQAgCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M8CQAgCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A143BC4CEF7;
	Fri,  3 Apr 2026 06:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198551;
	bh=Dgk24iBHXGzdZ737iaM9BBQHl/ZQZsVnpxPgamC2WE0=;
	h=Date:To:From:Subject:From;
	b=M8CQAgCz4XpLdHlsyfNBz41geXwj5OKUFM8HlO5xlnTlcScBqhX6X0SLiyZ9XY1Z4
	 g+9Tmgarn5Lm5zD/I7XkgjvaZr/tcTsDL11gY1qJF5YKQ0E1BUIJrEtKX5eccrTAJ9
	 fRau6tLEVMTdZTCiMdMAS9/cliAkBwY13Av3uN8o=
Date: Thu, 02 Apr 2026 23:42:31 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kunit_iov_iter-improve-error-detection.patch removed from -mm tree
Message-Id: <20260403064231.A143BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: kunit_iov_iter: improve error detection
has been removed from the -mm tree.  Its filename was
     lib-kunit_iov_iter-improve-error-detection.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib: kunit_iov_iter: improve error detection
Date: Thu, 26 Mar 2026 22:49:04 +0100

In the kunit_iov_iter test prevent the kernel buffer from being a single
physically contiguous region.

Additionally, make sure that the test pattern written to a page in the
buffer depends on the offset of the page within the buffer.

Link: https://lkml.kernel.org/r/20260326214905.818170-5-lk@c--e.de
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/kunit_iov_iter.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/tests/kunit_iov_iter.c~lib-kunit_iov_iter-improve-error-detection
+++ a/lib/tests/kunit_iov_iter.c
@@ -13,6 +13,7 @@
 #include <linux/uio.h>
 #include <linux/bvec.h>
 #include <linux/folio_queue.h>
+#include <linux/minmax.h>
 #include <kunit/test.h>
 
 MODULE_DESCRIPTION("iov_iter testing");
@@ -37,7 +38,7 @@ static const struct kvec_test_range kvec
 
 static inline u8 pattern(unsigned long x)
 {
-	return x & 0xff;
+	return (u8)x + (u8)(x >> 8) + (u8)(x >> 16);
 }
 
 static void iov_kunit_unmap(void *data)
@@ -52,6 +53,7 @@ static void *__init iov_kunit_create_buf
 	struct page **pages;
 	unsigned long got;
 	void *buffer;
+	unsigned int i;
 
 	pages = kzalloc_objs(struct page *, npages, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
@@ -63,6 +65,9 @@ static void *__init iov_kunit_create_buf
 		kvfree(pages);
 		KUNIT_ASSERT_EQ(test, got, npages);
 	}
+	/* Make sure that we don't get a physically contiguous buffer. */
+	for (i = 0; i < npages / 4; ++i)
+		swap(pages[i], pages[i + npages / 2]);
 
 	buffer = vmap(pages, npages, VM_MAP | VM_MAP_PUT_PAGES, PAGE_KERNEL);
 	if (buffer == NULL) {
_

Patches currently in -mm which might be from lk@c--e.de are


