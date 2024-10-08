Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190E017588
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352821; cv=none; b=hjY5OVglzJxRuhZaxAzD2s3XPYnSM7TP0RkGjeA5NXagL1ylkcUjl3hFEB08wBxBVhk0fO/YRjf7uQlYSrHVD1kGIIVowysZ7+BNghBU+5zCIsYf+a92gVzYOfCd1GqgLvy6UnDpM39dwHTGNmV/yry1LH2L0m5kpEu0tWSl76Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352821; c=relaxed/simple;
	bh=7oz7RIF3BKe8RhLVYPj6FGFUOq3j87Ej9EoYXASWTX0=;
	h=Date:To:From:Subject:Message-Id; b=WaufkPlQlDn2MWgeGI4I0PK/FJ1yQ8Vg9A9DdxdK8zmbBrQ2UvW5lcTfZDmPAzC0OrFroIzhmwleboJlZmU96J2eL74ey29kj9viYNeFtVmQdgXFLr3k756DLZ1ez21cSjKmjTNIl8aZGREkuNaW0LBWhk/iDaXQlrupeIzt1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yBmzUYWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yBmzUYWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E058C4CEC6;
	Tue,  8 Oct 2024 02:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352820;
	bh=7oz7RIF3BKe8RhLVYPj6FGFUOq3j87Ej9EoYXASWTX0=;
	h=Date:To:From:Subject:From;
	b=yBmzUYWo4NsendRZePo5FJS6081XMcejnvooIA3qyI2arnsl5Czio4j7SivqKn4OW
	 KvIKIXfZPqLZZTC2hMwSdJeSXWv711DC5D3MggKmDxftaJfRVemtthLmgb9M+6/OS4
	 NYxGnEoqAfBGoqnPrbHMgSLBSxfan2hBbrpPrVMw=
Date: Mon, 07 Oct 2024 19:00:20 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-instrument-copy_from-to_kernel_nofault.patch removed from -mm tree
Message-Id: <20241008020020.9E058C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, kasan: instrument copy_from/to_kernel_nofault
has been removed from the -mm tree.  Its filename was
     mm-instrument-copy_from-to_kernel_nofault.patch

This patch was dropped because an updated version will be issued

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
[snovitoll@gmail.com: proper instrument _kernel_nofault]
  Link: https://lkml.kernel.org/r/20240930102405.2227124-1-snovitoll@gmail.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   31 +++++++++++++++++++++++++++++++
 mm/maccess.c            |    6 ++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-instrument-copy_from-to_kernel_nofault
+++ a/mm/kasan/kasan_test_c.c
@@ -1954,6 +1954,36 @@ static void rust_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_test_rust_uaf());
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
@@ -2027,6 +2057,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(match_all_not_assigned),
 	KUNIT_CASE(match_all_ptr_tag),
 	KUNIT_CASE(match_all_mem_tag),
+	KUNIT_CASE(copy_from_to_kernel_nofault_oob),
 	KUNIT_CASE(rust_uaf),
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
+	instrument_read(src, size);
 	if (!(align & 7))
 		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
@@ -49,7 +50,7 @@ EXPORT_SYMBOL_GPL(copy_from_kernel_nofau
 
 #define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__put_kernel_nofault(dst, src, type, err_label);		\
+		__put_kernel_nofault(dst, src, type, err_label);	\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -63,6 +64,7 @@ long copy_to_kernel_nofault(void *dst, c
 		align = (unsigned long)dst | (unsigned long)src;
 
 	pagefault_disable();
+	instrument_write(dst, size);
 	if (!(align & 7))
 		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
_

Patches currently in -mm which might be from snovitoll@gmail.com are


