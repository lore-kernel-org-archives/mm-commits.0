Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFEE285CA6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126377; cv=none; b=aDVFbh81Hamv9gSSRMaPVBqfd75w5obnd3+Dvvk1ss+TTuU42IHVC85h6a5Nv7NsKGxuqPAK4wiFgEa0HwDVhYWinhMC5ALW1IgTEImPJU9i81t9SDpTUaJYLBB5jvdprLeAxIatnHw5eJngAvj4eS13pYkidxZR0IVd1o+iTj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126377; c=relaxed/simple;
	bh=DjDovTgXi4YumyTyyLZ7mmyzkiYi60d7HJ+ktSWWD+A=;
	h=Date:To:From:Subject:Message-Id; b=EebQWmUBHYefEFd3xXbUfFPHXa04Mbfesfqessx8TDr34yIL1FPreXdY2V+GUtZ8DzrJvHhp2s1bdcTWszswLF1chjZDYIAa5exje7+8atDXglvBrXOtSS2ckW0dN70FVX/Izk/TGui8voEUm0FYPrxsqbtlJLJ+kXpdL5G2qzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TSlYID8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TSlYID8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5340FC4CEE3;
	Thu, 10 Jul 2025 05:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126377;
	bh=DjDovTgXi4YumyTyyLZ7mmyzkiYi60d7HJ+ktSWWD+A=;
	h=Date:To:From:Subject:From;
	b=TSlYID8qCJH2+16HUP8w8AQ4zxFLBlZCH3z8inqAK3Q/KhVyRenqF+E4S3bWMIvUF
	 5MFvU6HR9T1dgHfHAEMnQ3GHsqrQbty09o2ICWUpsK2HtP3UUlKdzZDHNDHLO0wbDs
	 V+gWwNc+8f3LAXLMoJUVKtaF+kjfBpqCOdGDsWdk=
Date: Wed, 09 Jul 2025 22:46:15 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,hch@infradead.org,glider@google.com,elver@google.com,dvyukov@google.com,david@redhat.com,arnd@arndb.de,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-unexport-globally-copy_to_kernel_nofault.patch removed from -mm tree
Message-Id: <20250710054617.5340FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: unexport globally copy_to_kernel_nofault
has been removed from the -mm tree.  Its filename was
     mm-unexport-globally-copy_to_kernel_nofault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: mm: unexport globally copy_to_kernel_nofault
Date: Sun, 22 Jun 2025 10:19:06 +0500

copy_to_kernel_nofault() is an internal helper which should not be visible
to loadable modules – exporting it would give exploit code a cheap
oracle to probe kernel addresses.  Instead, keep the helper un-exported
and compile the kunit case that exercises it only when
mm/kasan/kasan_test.o is linked into vmlinux.

[snovitoll@gmail.com: add a brief comment to `#ifndef MODULE`]
  Link: https://lkml.kernel.org/r/20250622141142.79332-1-snovitoll@gmail.com
Link: https://lkml.kernel.org/r/20250622051906.67374-1-snovitoll@gmail.com
Fixes: ca79a00bb9a8 ("kasan: migrate copy_user_test to kunit")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    8 ++++++++
 mm/maccess.c            |    1 -
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~mm-unexport-globally-copy_to_kernel_nofault
+++ a/mm/kasan/kasan_test_c.c
@@ -1977,6 +1977,11 @@ static void rust_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_test_rust_uaf());
 }
 
+/*
+ * copy_to_kernel_nofault() is an internal helper available when
+ * kasan_test is built-in, so it must not be visible to loadable modules.
+ */
+#ifndef MODULE
 static void copy_to_kernel_nofault_oob(struct kunit *test)
 {
 	char *ptr;
@@ -2011,6 +2016,7 @@ static void copy_to_kernel_nofault_oob(s
 
 	kfree(ptr);
 }
+#endif /* !MODULE */
 
 static void copy_user_test_oob(struct kunit *test)
 {
@@ -2131,7 +2137,9 @@ static struct kunit_case kasan_kunit_tes
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


