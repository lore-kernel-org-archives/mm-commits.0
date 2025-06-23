Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D62219E0
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718593; cv=none; b=se3u8VzRoY6GTyoErDm2KhBMgAaqIS2IzqYS2Qk95OJS0iFlpRgY8uuwBTKvwNVE2ke5vCZ9Su/TVY8W+Vpc6k5dt7It9Z5RSfkAv/Pr6ecDhTBdgiqzJh9Z216FcPJdnBoQUUsayxm0p/Z/DE8fIyMkzgfwe0NMfWysnNQDuhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718593; c=relaxed/simple;
	bh=T38UldOF/LTLU5ZNRuJl5hIlP8f6my0IoVZ1Gtw7DNY=;
	h=Date:To:From:Subject:Message-Id; b=uJIxJp405Ig2R6DsL6KNNmNWL2YTEGP0uVJStu+oIM+KlH4XZmW7GG4mtWKpqnT8kQ++n7YmcMbwPh0blnd3NmnxDE8Dr5BPcmtk0aGUA7V/nGY9AfHlniqigrUI/Nvoo2E6qfbvUH9zi9H7aV6OXY1IUVyUAOw9HPCkwVZKMNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yQd80VIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yQd80VIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB20DC4CEEA;
	Mon, 23 Jun 2025 22:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750718592;
	bh=T38UldOF/LTLU5ZNRuJl5hIlP8f6my0IoVZ1Gtw7DNY=;
	h=Date:To:From:Subject:From;
	b=yQd80VIM/KcDAPfaEIOrskhwbwkPkdbxouqrqDQmt3vVYWkv8wFNoJNUBpIdguP4i
	 0QrPlWWnJpQwZWtE7PhxcgkDp7qfdU1Yy50zAgq+FF+NhqPy9GHxHapDYGAQKXE8Gy
	 SSS6G3QwPqWqe/ZpoG+H7tzHzf2SaXD4ZAx7Lj3s=
Date: Mon, 23 Jun 2025 15:43:12 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,hch@infradead.org,glider@google.com,elver@google.com,dvyukov@google.com,david@redhat.com,arnd@arndb.de,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unexport-globally-copy_to_kernel_nofault.patch added to mm-new branch
Message-Id: <20250623224312.DB20DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: unexport globally copy_to_kernel_nofault
has been added to the -mm mm-new branch.  Its filename is
     mm-unexport-globally-copy_to_kernel_nofault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-unexport-globally-copy_to_kernel_nofault.patch

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
Subject: mm: unexport globally copy_to_kernel_nofault
Date: Sun, 22 Jun 2025 10:19:06 +0500

copy_to_kernel_nofault() is an internal helper which should not be visible
to loadable modules – exporting it would give exploit code a cheap
oracle to probe kernel addresses.  Instead, keep the helper un-exported
and compile the kunit case that exercises it only when
mm/kasan/kasan_test.o is linked into vmlinux.

Link: https://lkml.kernel.org/r/20250622051906.67374-1-snovitoll@gmail.com
Fixes: ca79a00bb9a8 ("kasan: migrate copy_user_test to kunit")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    4 ++++
 mm/maccess.c            |    1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~mm-unexport-globally-copy_to_kernel_nofault
+++ a/mm/kasan/kasan_test_c.c
@@ -1977,6 +1977,7 @@ static void rust_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_test_rust_uaf());
 }
 
+#ifndef MODULE
 static void copy_to_kernel_nofault_oob(struct kunit *test)
 {
 	char *ptr;
@@ -2011,6 +2012,7 @@ static void copy_to_kernel_nofault_oob(s
 
 	kfree(ptr);
 }
+#endif /* !MODULE */
 
 static void copy_user_test_oob(struct kunit *test)
 {
@@ -2131,7 +2133,9 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(match_all_not_assigned),
 	KUNIT_CASE(match_all_ptr_tag),
 	KUNIT_CASE(match_all_mem_tag),
+#ifndef MODULE
 	KUNIT_CASE(copy_to_kernel_nofault_oob),
+#endif
 	KUNIT_CASE(rust_uaf),
 	KUNIT_CASE(copy_user_test_oob),
 	{}
--- a/mm/maccess.c~mm-unexport-globally-copy_to_kernel_nofault
+++ a/mm/maccess.c
@@ -82,7 +82,6 @@ Efault:
 	pagefault_enable();
 	return -EFAULT;
 }
-EXPORT_SYMBOL_GPL(copy_to_kernel_nofault);
 
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 {
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-unexport-globally-copy_to_kernel_nofault.patch

