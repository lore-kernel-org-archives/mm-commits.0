Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302DD2D837E;
	Thu, 25 Sep 2025 23:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841869; cv=none; b=uQPnQHQj7yMOPANFacLC7JVz5qg1d/RViz4HDy0+72qRFxDYHIQDGRxEPto+M+rBTzoJfK14JWyGoCAYh7KkDJb0mfhNbGw2DjqlZSXnFnq5718poickfrORWU6IYXUp00OJIv0CnohSF5uvj3YCroVd2kJeEQlq+mYMIyPBs2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841869; c=relaxed/simple;
	bh=8SstXx6jnlD5MC453SXmk7nBnUdIhqWepozKWhJFMZ8=;
	h=Date:To:From:Subject:Message-Id; b=sR8fNMYD2ld4by9Ax0iwI1K8auJel8fOqz3GmmwLquw/Azuw0kPKFjnCYMrdPCcR10WFFLjqlENt2iYq8QEGPvcD4/CMOXRZ+chib7rLtoh6k7/+/FpY/L0EjDOgik3j/BNQxCbsczqokm69y5dZHCaiVHJ36mpc+S9D8NyzE10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VZ8ak5sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VZ8ak5sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD69C4CEF7;
	Thu, 25 Sep 2025 23:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841868;
	bh=8SstXx6jnlD5MC453SXmk7nBnUdIhqWepozKWhJFMZ8=;
	h=Date:To:From:Subject:From;
	b=VZ8ak5sjDD/w28wuuYvGuneEHkIh5iqCuOztYIFJu+TND60jvb2omXsKS8zyjyN3Q
	 +g8a8ZnXCIHJ0McRIQWi9SxGldmNlc47V9cTi0WmwtnSSwHP1tTyviBwtS10YdKcsm
	 mwI/TIO5sLWHilZNzj+oy/5Db5/rLsv+/+i7X3Os=
Date: Thu, 25 Sep 2025 16:11:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kmsan-fix-out-of-bounds-access-to-shadow-memory.patch removed from -mm tree
Message-Id: <20250925231108.BAD69C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: fix out-of-bounds access to shadow memory
has been removed from the -mm tree.  Its filename was
     kmsan-fix-out-of-bounds-access-to-shadow-memory.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Biggers <ebiggers@kernel.org>
Subject: kmsan: fix out-of-bounds access to shadow memory
Date: Thu, 11 Sep 2025 12:58:58 -0700

Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
kmsan_internal_set_shadow_origin():

    BUG: unable to handle page fault for address: ffffbc3840291000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
    Oops: 0000 [#1] SMP NOPTI
    CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
    Tainted: [N]=TEST
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
    RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
    [...]
    Call Trace:
    <TASK>
    __msan_memset+0xee/0x1a0
    sha224_final+0x9e/0x350
    test_hash_buffer_overruns+0x46f/0x5f0
    ? kmsan_get_shadow_origin_ptr+0x46/0xa0
    ? __pfx_test_hash_buffer_overruns+0x10/0x10
    kunit_try_run_case+0x198/0xa00

This occurs when memset() is called on a buffer that is not 4-byte aligned
and extends to the end of a guard page, i.e.  the next page is unmapped.

The bug is that the loop at the end of kmsan_internal_set_shadow_origin()
accesses the wrong shadow memory bytes when the address is not 4-byte
aligned.  Since each 4 bytes are associated with an origin, it rounds the
address and size so that it can access all the origins that contain the
buffer.  However, when it checks the corresponding shadow bytes for a
particular origin, it incorrectly uses the original unrounded shadow
address.  This results in reads from shadow memory beyond the end of the
buffer's shadow memory, which crashes when that memory is not mapped.

To fix this, correctly align the shadow address before accessing the 4
shadow bytes corresponding to each origin.

Link: https://lkml.kernel.org/r/20250911195858.394235-1-ebiggers@kernel.org
Fixes: 2ef3cec44c60 ("kmsan: do not wipe out origin when doing partial unpoisoning")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c       |   10 +++++++---
 mm/kmsan/kmsan_test.c |   16 ++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

--- a/mm/kmsan/core.c~kmsan-fix-out-of-bounds-access-to-shadow-memory
+++ a/mm/kmsan/core.c
@@ -195,7 +195,8 @@ void kmsan_internal_set_shadow_origin(vo
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	u32 *shadow_start, *origin_start;
+	void *shadow_start;
+	u32 *aligned_shadow, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
@@ -214,9 +215,12 @@ void kmsan_internal_set_shadow_origin(vo
 	}
 	__memset(shadow_start, b, size);
 
-	if (!IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+	if (IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+		aligned_shadow = shadow_start;
+	} else {
 		pad = address % KMSAN_ORIGIN_SIZE;
 		address -= pad;
+		aligned_shadow = shadow_start - pad;
 		size += pad;
 	}
 	size = ALIGN(size, KMSAN_ORIGIN_SIZE);
@@ -230,7 +234,7 @@ void kmsan_internal_set_shadow_origin(vo
 	 * corresponding shadow slot is zero.
 	 */
 	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
-		if (origin || !shadow_start[i])
+		if (origin || !aligned_shadow[i])
 			origin_start[i] = origin;
 	}
 }
--- a/mm/kmsan/kmsan_test.c~kmsan-fix-out-of-bounds-access-to-shadow-memory
+++ a/mm/kmsan/kmsan_test.c
@@ -556,6 +556,21 @@ DEFINE_TEST_MEMSETXX(16)
 DEFINE_TEST_MEMSETXX(32)
 DEFINE_TEST_MEMSETXX(64)
 
+/* Test case: ensure that KMSAN does not access shadow memory out of bounds. */
+static void test_memset_on_guarded_buffer(struct kunit *test)
+{
+	void *buf = vmalloc(PAGE_SIZE);
+
+	kunit_info(test,
+		   "memset() on ends of guarded buffer should not crash\n");
+
+	for (size_t size = 0; size <= 128; size++) {
+		memset(buf, 0xff, size);
+		memset(buf + PAGE_SIZE - size, 0xff, size);
+	}
+	vfree(buf);
+}
+
 static noinline void fibonacci(int *array, int size, int start)
 {
 	if (start < 2 || (start == size))
@@ -677,6 +692,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_memset16),
 	KUNIT_CASE(test_memset32),
 	KUNIT_CASE(test_memset64),
+	KUNIT_CASE(test_memset_on_guarded_buffer),
 	KUNIT_CASE(test_long_origin_chain),
 	KUNIT_CASE(test_stackdepot_roundtrip),
 	KUNIT_CASE(test_unpoison_memory),
_

Patches currently in -mm which might be from ebiggers@kernel.org are


