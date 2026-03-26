Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE88921C160
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774564806; cv=none; b=p4LD5FvTvKgPHci1762NoYa+Ic304fw+zzAmh7ZUijPbnoxOPQ/9QNHVt3P0zBJBkbT2KY+JXHqPuFrNFwtrtqGcWejARkjWdMXgVgiKXi5x4nNjF0cQ9avAEk1xzrtOoXaWes5BTcqFxSMlHdt4Fi+5RRKJ1leBxnKjUmhHJ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774564806; c=relaxed/simple;
	bh=nWhtwrEszTFAFXhfbQPRC5WxJv1WAFHwSI5z9MbTFrI=;
	h=Date:To:From:Subject:Message-Id; b=VkvxJYfsujKX0HfNRw5jv/p+/Pp+v3jOH7MLaiZtzFeVqlfunZsGXAvm50Ag1hTic3bi3S7kC/8J/NS5TX+m/ta1kxtz4HU45SG/U2IhhPNZqaHCup5du7eLJaA+C9tn8k+NxqR9LHEEw8Z3O+4dhBig94AaQT2j4cTMQTGc+Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HXH5A0iM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HXH5A0iM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605CCC116C6;
	Thu, 26 Mar 2026 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774564806;
	bh=nWhtwrEszTFAFXhfbQPRC5WxJv1WAFHwSI5z9MbTFrI=;
	h=Date:To:From:Subject:From;
	b=HXH5A0iMUFUFSwLTy8k0SMtyNv4CfHK0WZ16BhGu2Cg5KME+wdYw+Woa3Q4ETnFpV
	 iAmRygWP03WfBewbyT1iwOB/rU3JfH0tTG7BuTafSS0ElMHbpJbW4ELYWgdbBmNwCM
	 8uqmgml5Xfwu62fg4qLWvmRXXyc9HyUc6ggAU0Wc=
Date: Thu, 26 Mar 2026 15:40:05 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kunit_iov_iter-improve-error-detection.patch added to mm-nonmm-unstable branch
Message-Id: <20260326224006.605CCC116C6@smtp.kernel.org>
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

lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg.patch
lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch
lib-kunit_iov_iter-fix-memory-leaks.patch
lib-kunit_iov_iter-improve-error-detection.patch
lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch

