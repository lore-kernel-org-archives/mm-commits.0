Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791C7264614
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774379910; cv=none; b=XZ7oGhArOAc1WvLi25affDBagt+XLyEY67e5OVW4Y5Lfo4GYfJHgWaPm7kJLPncSXmBZqBP/M6GO812onBNMqzxRmkzihaWKM7D9xKDg4kCGCKCEF9xeqv7rZ3eYqSgu5ZUfy/Lhsn2kLkTrJXMBMmRR5uO/xqCjSDdsSQCUubk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774379910; c=relaxed/simple;
	bh=g8qwRtiDkx0piNaE7lOSLpbKJpT6JHJwEs12mLiNqqI=;
	h=Date:To:From:Subject:Message-Id; b=eT/dN4Eu4B3UJw/3DsjjBSCf4oTJ+uCNWh1dAxWKa26pZPCWaPuDP+0m8k65mudDyo0ofpIBdX+JSXn7W3FfvJuwcuLbKiCGAlhhY3ijvnnAze0NYHT7l1Al/3AcE/WC0Pcu/NInBBfLwm4+XTuD/4O63N0/w9Js2niOKsmnigk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Te+toYbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Te+toYbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073B0C19424;
	Tue, 24 Mar 2026 19:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774379910;
	bh=g8qwRtiDkx0piNaE7lOSLpbKJpT6JHJwEs12mLiNqqI=;
	h=Date:To:From:Subject:From;
	b=Te+toYbmjzVkylwTG40KkfJWP5yseEqEzhDlvzcPawMNczjasdvyzT3qZ/hHJopUN
	 WzUFr8MtPgfsDMCwRfPAjDeGryPlAFhucFcJ606mSri03ZzN3nUMcZOoR0S9r3WjGU
	 4EHod08hLL8Et1noMltYm7sUYFnXpQcBZS8++4EE=
Date: Tue, 24 Mar 2026 12:18:29 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,objecting@objecting.org,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kunit_iov_iter-improve-error-detection.patch added to mm-nonmm-unstable branch
Message-Id: <20260324191830.073B0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: kunit_iov_iter: improve error detection
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kunit_iov_iter-improve-error-detection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kunit_iov_iter-improve-error-detection.patch

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
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib: kunit_iov_iter: improve error detection
Date: Mon, 23 Mar 2026 22:23:48 +0100

Patch series "Fix length calculation bug in extract_kvec_to_sg".

There is a bug in extract_kvec_to_sg() where the length of a scatterlist
segment is miscalculated.  The actual fix is a one-liner and it is quite
obvious from reading the code that this is what was intened.

As this is a core library function this series first adds test cases to
the kunit_iov_iter test that demonstrate that there is a bug before
actually fixing it in the last commit.

The bug was orignally introduced into kernel v6.3 where the function lived
in fs/netfs/iterator.c.  It was later moved to lib/scatterlist.c in v6.5. 
Thus the actual fix is only marked for backports to v6.5+.


This patch (of 3):

In the kunit_iov_iter test prevent the kernel buffer from being a single
physically contiguous region.

Additionally, make sure that the test pattern written to a page in the
buffer depends on the offset of the page within the buffer.

Link: https://lkml.kernel.org/r/20260323212350.807118-1-lk@c--e.de
Link: https://lkml.kernel.org/r/20260323212350.807118-2-lk@c--e.de
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Josh Law <objecting@objecting.org>
Tested-by: Josh Law <objecting@objecting.org>
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
 
 	pages = kunit_kcalloc(test, npages, sizeof(struct page *), GFP_KERNEL);
         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
@@ -62,6 +64,9 @@ static void *__init iov_kunit_create_buf
 		release_pages(pages, got);
 		KUNIT_ASSERT_EQ(test, got, npages);
 	}
+	/* Make sure that we don't get a physically contiguous buffer. */
+	for (i = 0; i < npages / 4; ++i)
+		swap(pages[i], pages[i + npages/2]);
 
 	buffer = vmap(pages, npages, VM_MAP | VM_MAP_PUT_PAGES, PAGE_KERNEL);
         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);
_

Patches currently in -mm which might be from lk@c--e.de are

lib-kunit_iov_iter-improve-error-detection.patch
lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch
lib-fix-length-calculation-in-extract_kvec_to_sg.patch

