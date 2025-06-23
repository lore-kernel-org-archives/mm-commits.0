Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FF4223321
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 22:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718695; cv=none; b=CJYxaz90Xc+bT4rM/D8NDABRAEyyj1Okd5kafT8jy6ufFhNgXTaK1fs/JmiK1EegJ09UdGAmbNY/z75loEYPchKQYkN77cw8/jOmWCXiBXWe5K1ypfmG9xpN1Dwxq4YUH1R09W0b1EBdbbEqgAB5Jqnjy8tv/FsUFLFkx9oisTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718695; c=relaxed/simple;
	bh=HRKkIL6dbpEeyaWQprL4qY0mqNr50f5mEwKdcNfNLQA=;
	h=Date:To:From:Subject:Message-Id; b=TeGeOSpgqQKj7JEWNjp6iQp8r+Wdii1qB8TH9sA0TuaMmplVTyjU+yXoa5u95iiG2eArTZF3gvw937d/E5eE38sZce47qrAcXRBdv1RRaqeikIrA7K2OY/8FVtBYP60mytxLAXPKFf+F2kJ8ifvPS/HkFYb1N5NuLefWAlHZehc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OLYOD2wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OLYOD2wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2F0C4CEED;
	Mon, 23 Jun 2025 22:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750718695;
	bh=HRKkIL6dbpEeyaWQprL4qY0mqNr50f5mEwKdcNfNLQA=;
	h=Date:To:From:Subject:From;
	b=OLYOD2wpDVe/0jS5V/Wojij8zXhraMmu2rqZhVM9oFjKOOz5j1FYIodHScbzAnrfO
	 quGckQOHRTR1E2SbbyYuWsZuhHicPHQ1IED7BYUL2CvwCln0zwwKnENJ6VvGLq3xjc
	 3oaff9dvKd2Bm/vUVUE2TgdXAuPlaNCcoDnXEgmU=
Date: Mon, 23 Jun 2025 15:44:54 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,hch@infradead.org,glider@google.com,elver@google.com,dvyukov@google.com,david@redhat.com,arnd@arndb.de,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unexport-globally-copy_to_kernel_nofault-v2.patch added to mm-new branch
Message-Id: <20250623224455.4B2F0C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-unexport-globally-copy_to_kernel_nofault-v2
has been added to the -mm mm-new branch.  Its filename is
     mm-unexport-globally-copy_to_kernel_nofault-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-unexport-globally-copy_to_kernel_nofault-v2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: mm-unexport-globally-copy_to_kernel_nofault-v2
Date: Sun, 22 Jun 2025 19:11:42 +0500

add a brief comment to `#ifndef MODULE`

Link: https://lkml.kernel.org/r/20250622141142.79332-1-snovitoll@gmail.com
Fixes: ca79a00bb9a8 ("kasan: migrate copy_user_test to kunit")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/kasan/kasan_test_c.c~mm-unexport-globally-copy_to_kernel_nofault-v2
+++ a/mm/kasan/kasan_test_c.c
@@ -1977,6 +1977,10 @@ static void rust_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_test_rust_uaf());
 }
 
+/*
+ * copy_to_kernel_nofault() is an internal helper available when
+ * kasan_test is built-in, so it must not be visible to loadable modules.
+ */
 #ifndef MODULE
 static void copy_to_kernel_nofault_oob(struct kunit *test)
 {
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-unexport-globally-copy_to_kernel_nofault.patch
mm-unexport-globally-copy_to_kernel_nofault-v2.patch

