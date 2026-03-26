Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E901E5B88
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 22:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774564805; cv=none; b=fQ0RuuaDl2rqtyAIqyPJdghsauPVFMFQXhR2+/CFPRlf2GwuBMFo1NCNOQEvNvCWLBWCkd4Mnbc/pQ6jpNFonllpNUkZUGRj3L42fBdYyis/9wu55Lj56CCHhJ1mWOc0Mxy1z6vU6sNisyv4wdv2ZxveO5N60i/aRYWZWfYs8/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774564805; c=relaxed/simple;
	bh=N5h+jJdHroLWqFXYRBGh48m5JLJzIMXYvagu1nG5gcA=;
	h=Date:To:From:Subject:Message-Id; b=rCskGFWo1fr4S3SF/6Ho9jyGPnIk4LUSwKlcE3jdbFDKa2JqkdJdvsV6GuotY4WwKFK17QSZobdsy8M9iV7YtWwTEVidC3dCHBI2YLS4Oz+oGVsgtDQX/oB5LJR3gh+2AKTDwu3YGgfV/DwLF3e9XYurSTiameorJn3zrK0qamM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=An0TorNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="An0TorNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B2CC116C6;
	Thu, 26 Mar 2026 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774564805;
	bh=N5h+jJdHroLWqFXYRBGh48m5JLJzIMXYvagu1nG5gcA=;
	h=Date:To:From:Subject:From;
	b=An0TorNemfyE2TzVk0PA10X7tEkIFZ5B5e8GlkLCaKrTsa3YLoUYYiv+xbL1hTlVZ
	 NioG3Cq9JoYzsaGnsJPmkuS/EoUnbBEfA809KjXMrwghiYj9RVZdRInUTzfL+B82Is
	 y/dH5b1w3egVwSQ5p8s3O6Sy3qBR+ClBDyoB0awI=
Date: Thu, 26 Mar 2026 15:40:04 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kunit_iov_iter-fix-memory-leaks.patch added to mm-nonmm-unstable branch
Message-Id: <20260326224005.28B2CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: kunit_iov_iter: fix memory leaks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kunit_iov_iter-fix-memory-leaks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kunit_iov_iter-fix-memory-leaks.patch

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
Subject: lib: kunit_iov_iter: fix memory leaks
Date: Thu, 26 Mar 2026 22:49:03 +0100

Use vfree() instead of vunmap() to free the buffer allocated by
iov_kunit_create_buffer() because vunmap() does not honour
VM_MAP_PUT_PAGES.  In order for this to work the page array itself must
not be managed by kunit.

Remove the folio_put() when destroying a folioq.  This is handled by
vfree(), now.

Pointed out by sashiko.dev on a previous iteration of this series.

Tested by running the kunit test 10000 times in a loop.

Link: https://lkml.kernel.org/r/20260326214905.818170-4-lk@c--e.de
Fixes: 2d71340ff1d4 ("iov_iter: Kunit tests for copying to/from an iterator")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/kunit_iov_iter.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/tests/kunit_iov_iter.c~lib-kunit_iov_iter-fix-memory-leaks
+++ a/lib/tests/kunit_iov_iter.c
@@ -42,7 +42,7 @@ static inline u8 pattern(unsigned long x
 
 static void iov_kunit_unmap(void *data)
 {
-	vunmap(data);
+	vfree(data);
 }
 
 static void *__init iov_kunit_create_buffer(struct kunit *test,
@@ -53,17 +53,22 @@ static void *__init iov_kunit_create_buf
 	unsigned long got;
 	void *buffer;
 
-	pages = kunit_kcalloc(test, npages, sizeof(struct page *), GFP_KERNEL);
-        KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
+	pages = kzalloc_objs(struct page *, npages, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
 	*ppages = pages;
 
 	got = alloc_pages_bulk(GFP_KERNEL, npages, pages);
 	if (got != npages) {
 		release_pages(pages, got);
+		kvfree(pages);
 		KUNIT_ASSERT_EQ(test, got, npages);
 	}
 
 	buffer = vmap(pages, npages, VM_MAP | VM_MAP_PUT_PAGES, PAGE_KERNEL);
+	if (buffer == NULL) {
+		release_pages(pages, got);
+		kvfree(pages);
+	}
         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);
 
 	kunit_add_action_or_reset(test, iov_kunit_unmap, buffer);
@@ -369,9 +374,6 @@ static void iov_kunit_destroy_folioq(voi
 
 	for (folioq = data; folioq; folioq = next) {
 		next = folioq->next;
-		for (int i = 0; i < folioq_nr_slots(folioq); i++)
-			if (folioq_folio(folioq, i))
-				folio_put(folioq_folio(folioq, i));
 		kfree(folioq);
 	}
 }
_

Patches currently in -mm which might be from lk@c--e.de are

lib-scatterlist-fix-length-calculations-in-extract_kvec_to_sg.patch
lib-scatterlist-fix-temp-buffer-in-extract_user_to_sg.patch
lib-kunit_iov_iter-fix-memory-leaks.patch
lib-kunit_iov_iter-improve-error-detection.patch
lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch

