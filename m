Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB86A1E535
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352910; cv=none; b=Nqme7XNCUlklq5AgQe7eFi98g39WqhGHfzDZuJsG7JIlIepLKIJcFKblyhunOPBaUmtGxu88ENN2m/PpeyW3zJ2iKgrm+dQIqVTTi3hkxO/g/mK+mGpI4hVAeK8yp4xTADFUNrKl0FbrEHb+oas+z56mQeqXxWO5m0/6eT+IQLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352910; c=relaxed/simple;
	bh=tRXFJmMOwN6pky130YgbnCmj8ZK0KSHWXGvvkZpcJOs=;
	h=Date:To:From:Subject:Message-Id; b=RajuG1WulW/Kj5IO40M+lhh3KCyvx4NmNpM2PBsYcHLcysYqkS+9ne+cFgUQgd1V3t+mlKR6VVtNyX30JegAIKoK7dsjfRSA6YKVMbRwvaJxz3VrZysahs+BR1KNFCcaVtwPm+RMoWN7QZYYeaKWcRRAlcpCW+ixkdfynJTSDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y6V5GpV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y6V5GpV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4795AC4CEC6;
	Tue,  8 Oct 2024 02:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352910;
	bh=tRXFJmMOwN6pky130YgbnCmj8ZK0KSHWXGvvkZpcJOs=;
	h=Date:To:From:Subject:From;
	b=Y6V5GpV1jGXpE9iH4t42ChgLgjqtXzxWuH54k7XLbgFBkrI2gri96o2McmLWilAcm
	 36mJDjq919e5fZQTehH1qqpHxXU0zxLjHGUt2fubv0pNV9S+no1f/j+umwuR/nwtvr
	 nvo216qU3nQ06XqFOmItPOd6/B2xahXdwWZkJIxU=
Date: Mon, 07 Oct 2024 19:01:49 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-kmsan-copy_from-to_kernel_nofault.patch added to mm-unstable branch
Message-Id: <20241008020150.4795AC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, kasan, kmsan: copy_from/to_kernel_nofault
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
Subject: mm, kasan, kmsan: copy_from/to_kernel_nofault
Date: Sat, 5 Oct 2024 21:48:13 +0500

Instrument copy_from_kernel_nofault() with KMSAN for uninitialized kernel
memory check and copy_to_kernel_nofault() with KASAN, KCSAN to detect the
memory corruption.

syzbot reported that bpf_probe_read_kernel() kernel helper triggered KASAN
report via kasan_check_range() which is not the expected behaviour as
copy_from_kernel_nofault() is meant to be a non-faulting helper.

Solution is, suggested by Marco Elver, to replace KASAN, KCSAN check in
copy_from_kernel_nofault() with KMSAN detection of copying uninitilaized
kernel memory.  In copy_to_kernel_nofault() we can retain
instrument_write() for the memory corruption instrumentation but before
pagefault_disable().

copy_to_kernel_nofault() is tested on x86_64 and arm64 with
CONFIG_KASAN_SW_TAGS.  On arm64 with CONFIG_KASAN_HW_TAGS, kunit test
currently fails.  Need more clarification on it - currently, disabled in
kunit test.

Link: https://lore.kernel.org/linux-mm/CANpmjNMAVFzqnCZhEity9cjiqQ9CVN1X7qeeeAp_6yKjwKo8iw@mail.gmail.com/
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Link: https://lkml.kernel.org/r/20241005164813.2475778-2-snovitoll@gmail.com
Suggested-by: Marco Elver <elver@google.com>
Reported-by: syzbot+61123a5daeb9f7454599@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61123a5daeb9f7454599
Reported-by: Andrey Konovalov <andreyknvl@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210505
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   27 +++++++++++++++++++++++++++
 mm/kmsan/kmsan_test.c   |   17 +++++++++++++++++
 mm/maccess.c            |    7 +++++--
 3 files changed, 49 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-kmsan-copy_from-to_kernel_nofault
+++ a/mm/kasan/kasan_test_c.c
@@ -1954,6 +1954,32 @@ static void rust_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_test_rust_uaf());
 }
 
+static void copy_to_kernel_nofault_oob(struct kunit *test)
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
+		copy_to_kernel_nofault(&buf[0], ptr, size));
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		copy_to_kernel_nofault(ptr, &buf[0], size));
+	kfree(ptr);
+}
+
 static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
@@ -2027,6 +2053,7 @@ static struct kunit_case kasan_kunit_tes
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
@@ -15,7 +15,7 @@ bool __weak copy_from_kernel_nofault_all
 
 #define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__get_kernel_nofault(dst, src, type, err_label);		\
+		__get_kernel_nofault(dst, src, type, err_label);	\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -31,6 +31,8 @@ long copy_from_kernel_nofault(void *dst,
 	if (!copy_from_kernel_nofault_allowed(src, size))
 		return -ERANGE;
 
+	/* Make sure uninitialized kernel memory isn't copied. */
+	kmsan_check_memory(src, size);
 	pagefault_disable();
 	if (!(align & 7))
 		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
@@ -49,7 +51,7 @@ EXPORT_SYMBOL_GPL(copy_from_kernel_nofau
 
 #define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__put_kernel_nofault(dst, src, type, err_label);		\
+		__put_kernel_nofault(dst, src, type, err_label);	\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
 		len -= sizeof(type);					\
@@ -62,6 +64,7 @@ long copy_to_kernel_nofault(void *dst, c
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		align = (unsigned long)dst | (unsigned long)src;
 
+	instrument_write(dst, size);
 	pagefault_disable();
 	if (!(align & 7))
 		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

