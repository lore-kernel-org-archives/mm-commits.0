Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6205517556C
	for <mm-commits@vger.kernel.org>; Fri, 27 Sep 2024 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727457472; cv=none; b=LjBy7Xf5oUObyr0ontJMAWH4vuvPZmkFfu1DEzieyIEfV4VLlBKj8mlgFNqutFYpe7j8rg7aS9c37Rv62vbmJoDWwl8gxVCzY+BNICCcdCA1Jc1665Xt/a3NEZdPQiLTvC2eb4TmKaJ+ZiQAyBkM39q6m8NdYj0HUUXPYTUzcGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727457472; c=relaxed/simple;
	bh=IF5pfMCX6XvNG+xYnbvjbLFPhJ8Xi8LfoXJxuYILm8E=;
	h=Date:To:From:Subject:Message-Id; b=TV5TJ4qloJsMf486DmG69J0AVUvFWjwC053QInGXJeHINKtJPkFksR6r2A/2d4lgbboUu2NmRfhNW9TnJVxvmor3VOAhD+l9NQYerbNtdKTfa5+oo/b5ADRAOlrHSfyFjhJ4zscO/37YONKm1ICS+i6G0jEclwYvfkbh1/k+9MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfu+QL61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfu+QL61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BD9C4CEC4;
	Fri, 27 Sep 2024 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727457471;
	bh=IF5pfMCX6XvNG+xYnbvjbLFPhJ8Xi8LfoXJxuYILm8E=;
	h=Date:To:From:Subject:From;
	b=nfu+QL61D/RlmzLP94YwPET+6AC+XRTZdcld5l88B0kRSVo/yeSt1B01U7x4Kr4bv
	 exQn1nbisclnjeN7ViII5quiRmTPFEysBRwXXvqGsgzehNHW23PWTU+CvVkqjTCpML
	 N0uUy5hxCyOeSdRjLCDog0eZ9xoewtZnU0v1GBDk=
Date: Fri, 27 Sep 2024 10:17:51 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-instrument-copy_from-to_kernel_nofault.patch added to mm-unstable branch
Message-Id: <20240927171751.D1BD9C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, kasan: instrument copy_from/to_kernel_nofault
has been added to the -mm mm-unstable branch.  Its filename is
     mm-instrument-copy_from-to_kernel_nofault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-instrument-copy_from-to_kernel_nofault.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm, kasan: instrument copy_from/to_kernel_nofault
Date: Fri, 27 Sep 2024 20:14:38 +0500

Instrument copy_from_kernel_nofault(), copy_to_kernel_nofault() with
instrument_memcpy_before() for KASAN, KCSAN checks and
instrument_memcpy_after() for KMSAN.

Tested on x86_64 and arm64 with CONFIG_KASAN_SW_TAGS.  On arm64 with
CONFIG_KASAN_HW_TAGS, kunit test currently fails.  Need more clarification
on it - currently, disabled in kunit test.

Link: https://lkml.kernel.org/r/20240927151438.2143936-1-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reported-by: Andrey Konovalov <andreyknvl@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210505
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |   31 +++++++++++++++++++++++++++++++
 mm/maccess.c          |    8 ++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test.c~mm-instrument-copy_from-to_kernel_nofault
+++ a/mm/kasan/kasan_test.c
@@ -1944,6 +1944,36 @@ static void match_all_mem_tag(struct kun
 	kfree(ptr);
 }
 
+static void copy_from_to_kernel_nofault_oob(struct kunit *test)
+{
+	char *ptr;
+	char buf[128];
+	size_t size = sizeof(buf);
+
+	/* Not detecting fails currently with HW_TAGS */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
+
+	ptr = kmalloc(size - KASAN_GRANULE_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	OPTIMIZER_HIDE_VAR(ptr);
+
+	if (IS_ENABLED(CONFIG_KASAN_SW_TAGS)) {
+		/* Check that the returned pointer is tagged. */
+		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+	}
+
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		copy_from_kernel_nofault(&buf[0], ptr, size));
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		copy_from_kernel_nofault(ptr, &buf[0], size));
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		copy_to_kernel_nofault(&buf[0], ptr, size));
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		copy_to_kernel_nofault(ptr, &buf[0], size));
+	kfree(ptr);
+}
+
 static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
@@ -2017,6 +2047,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(match_all_not_assigned),
 	KUNIT_CASE(match_all_ptr_tag),
 	KUNIT_CASE(match_all_mem_tag),
+	KUNIT_CASE(copy_from_to_kernel_nofault_oob),
 	{}
 };
 
--- a/mm/maccess.c~mm-instrument-copy_from-to_kernel_nofault
+++ a/mm/maccess.c
@@ -15,7 +15,7 @@ bool __weak copy_from_kernel_nofault_all
 
 #define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__get_kernel_nofault(dst, src, type, err_label);		\
+		__get_kernel_nofault(dst, src, type, err_label);	\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -32,6 +32,7 @@ long copy_from_kernel_nofault(void *dst,
 		return -ERANGE;
 
 	pagefault_disable();
+	instrument_memcpy_before(dst, src, size);
 	if (!(align & 7))
 		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
@@ -39,6 +40,7 @@ long copy_from_kernel_nofault(void *dst,
 	if (!(align & 1))
 		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
 	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
+	instrument_memcpy_after(dst, src, size, 0);
 	pagefault_enable();
 	return 0;
 Efault:
@@ -49,7 +51,7 @@ EXPORT_SYMBOL_GPL(copy_from_kernel_nofau
 
 #define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__put_kernel_nofault(dst, src, type, err_label);		\
+		__put_kernel_nofault(dst, src, type, err_label);	\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -63,6 +65,7 @@ long copy_to_kernel_nofault(void *dst, c
 		align = (unsigned long)dst | (unsigned long)src;
 
 	pagefault_disable();
+	instrument_memcpy_before(dst, src, size);
 	if (!(align & 7))
 		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
@@ -70,6 +73,7 @@ long copy_to_kernel_nofault(void *dst, c
 	if (!(align & 1))
 		copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
 	copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
+	instrument_memcpy_after(dst, src, size, 0);
 	pagefault_enable();
 	return 0;
 Efault:
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-instrument-copy_from-to_kernel_nofault.patch

