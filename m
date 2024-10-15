Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F321E3DB
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729034173; cv=none; b=MSi1Y6Ms1qbIeDeLtShc5BrUejsI8sMjTM7Mus2VwicpEVxFnIZGQl2BmyoG4FfFxeHye1B7q4KZaCka5DXw+FcQoauYvFhpJ2T5EsaQT9FBAPwK/cNbMFCUwIVZOXlbH64pY5gQ6zJMNFxzt9gw7EXo27i4PSJyBR9e8nXf07U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729034173; c=relaxed/simple;
	bh=J6qbX4+j7Tx2Ks3WWjWL8oApUgGFVXY+7Y3Y54eIvpo=;
	h=Date:To:From:Subject:Message-Id; b=AcxqaKnzheo+hrh9c1QVbnryC3vdE3vHlkD1Hrg4tuK8jxu5q5zjOCDIH0BVyH2lM1+oyXGYfLQ9BN+CNyh7Mwk76XC5EZx+XsTbvl+o3PvKzQIqamk1BKulrFXRwKC6uwdTj0ZeOzdFhea8kCe/4JzeDZvVa5XjLvNw9xloh5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wHTbjO7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHTbjO7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ADAC4CEC6;
	Tue, 15 Oct 2024 23:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729034172;
	bh=J6qbX4+j7Tx2Ks3WWjWL8oApUgGFVXY+7Y3Y54eIvpo=;
	h=Date:To:From:Subject:From;
	b=wHTbjO7kEqWedgYbMKMXqTKTFVpjSKQXnVIZEjRJKDUWhjiV7cTX1WzWCQHY/ET7I
	 qnbSTp3Vg5CLHGxiKdV+17vHWcmNwW5lx93jW/kI+YyMXs4l+/GfpyBlS8bbycbtwT
	 7nGG8enxigTnBfYDffhcslyjMmxrMy7FqAD72Pe4=
Date: Tue, 15 Oct 2024 16:16:12 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-kmsan-copy_from-to_kernel_nofault.patch added to mm-unstable branch
Message-Id: <20241015231612.D2ADAC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, kasan, kmsan: instrument copy_from/to_kernel_nofault
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

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
Subject: mm, kasan, kmsan: instrument copy_from/to_kernel_nofault
Date: Fri, 11 Oct 2024 08:53:10 +0500

Instrument copy_from_kernel_nofault() with KMSAN for uninitialized kernel
memory check and copy_to_kernel_nofault() with KASAN, KCSAN to detect the
memory corruption.

syzbot reported that bpf_probe_read_kernel() kernel helper triggered KASAN
report via kasan_check_range() which is not the expected behaviour as
copy_from_kernel_nofault() is meant to be a non-faulting helper.

Solution is, suggested by Marco Elver, to replace KASAN, KCSAN check in
copy_from_kernel_nofault() with KMSAN detection of copying uninitilaized
kernel memory.  In copy_to_kernel_nofault() we can retain
instrument_write() explicitly for the memory corruption instrumentation.

copy_to_kernel_nofault() is tested on x86_64 and arm64 with
CONFIG_KASAN_SW_TAGS.  On arm64 with CONFIG_KASAN_HW_TAGS, kunit test
currently fails.  Need more clarification on it.

Link: https://lore.kernel.org/linux-mm/CANpmjNMAVFzqnCZhEity9cjiqQ9CVN1X7qeeeAp_6yKjwKo8iw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20241011035310.2982017-1-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Reported-by: syzbot+61123a5daeb9f7454599@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61123a5daeb9f7454599
Reported-by: Andrey Konovalov <andreyknvl@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210505
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>	[KASAN]
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>	[KASAN]
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   34 ++++++++++++++++++++++++++++++++++
 mm/kmsan/kmsan_test.c   |   17 +++++++++++++++++
 mm/maccess.c            |   10 ++++++++--
 3 files changed, 59 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-kmsan-copy_from-to_kernel_nofault
+++ a/mm/kasan/kasan_test_c.c
@@ -1954,6 +1954,39 @@ static void rust_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_test_rust_uaf());
 }
 
+static void copy_to_kernel_nofault_oob(struct kunit *test)
+{
+	char *ptr;
+	char buf[128];
+	size_t size = sizeof(buf);
+
+	/* This test currently fails with the HW_TAGS mode.
+	 * The reason is unknown and needs to be investigated. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
+
+	ptr = kmalloc(size - KASAN_GRANULE_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	OPTIMIZER_HIDE_VAR(ptr);
+
+	/*
+	* We test copy_to_kernel_nofault() to detect corrupted memory that is
+	* being written into the kernel. In contrast, copy_from_kernel_nofault()
+	* is primarily used in kernel helper functions where the source address
+	* might be random or uninitialized. Applying KASAN instrumentation to
+	* copy_from_kernel_nofault() could lead to false positives.
+	* By focusing KASAN checks only on copy_to_kernel_nofault(),
+	* we ensure that only valid memory is written to the kernel,
+	* minimizing the risk of kernel corruption while avoiding
+	* false positives in the reverse case.
+	*/
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		copy_to_kernel_nofault(&buf[0], ptr, size));
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		copy_to_kernel_nofault(ptr, &buf[0], size));
+
+	kfree(ptr);
+}
+
 static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
@@ -2027,6 +2060,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(match_all_not_assigned),
 	KUNIT_CASE(match_all_ptr_tag),
 	KUNIT_CASE(match_all_mem_tag),
+	KUNIT_CASE(copy_to_kernel_nofault_oob),
 	KUNIT_CASE(rust_uaf),
 	{}
 };
--- a/mm/kmsan/kmsan_test.c~mm-kasan-kmsan-copy_from-to_kernel_nofault
+++ a/mm/kmsan/kmsan_test.c
@@ -640,6 +640,22 @@ static void test_unpoison_memory(struct
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+static void test_copy_from_kernel_nofault(struct kunit *test)
+{
+	long ret;
+	char buf[4], src[4];
+	size_t size = sizeof(buf);
+
+	EXPECTATION_UNINIT_VALUE_FN(expect, "copy_from_kernel_nofault");
+	kunit_info(
+		test,
+		"testing copy_from_kernel_nofault with uninitialized memory\n");
+
+	ret = copy_from_kernel_nofault((char *)&buf[0], (char *)&src[0], size);
+	USE(ret);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 static struct kunit_case kmsan_test_cases[] = {
 	KUNIT_CASE(test_uninit_kmalloc),
 	KUNIT_CASE(test_init_kmalloc),
@@ -664,6 +680,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_long_origin_chain),
 	KUNIT_CASE(test_stackdepot_roundtrip),
 	KUNIT_CASE(test_unpoison_memory),
+	KUNIT_CASE(test_copy_from_kernel_nofault),
 	{},
 };
 
--- a/mm/maccess.c~mm-kasan-kmsan-copy_from-to_kernel_nofault
+++ a/mm/maccess.c
@@ -13,9 +13,14 @@ bool __weak copy_from_kernel_nofault_all
 	return true;
 }
 
+/*
+ * The below only uses kmsan_check_memory() to ensure uninitialized kernel
+ * memory isn't leaked.
+ */
 #define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__get_kernel_nofault(dst, src, type, err_label);		\
+		__get_kernel_nofault(dst, src, type, err_label);	\
+		kmsan_check_memory(src, sizeof(type));			\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -49,7 +54,8 @@ EXPORT_SYMBOL_GPL(copy_from_kernel_nofau
 
 #define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__put_kernel_nofault(dst, src, type, err_label);		\
+		__put_kernel_nofault(dst, src, type, err_label);	\
+		instrument_write(dst, sizeof(type));			\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

