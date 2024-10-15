Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCEF1D63F4
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729036578; cv=none; b=duYQS610vQbmbd3FutoQe6SqdbcNu/loPYzFMn3sIzZFivEsyPMbaMB0IqE+JbkdnygmwZHRUnKk2owexEY0ojBtqqtNAKOuUkH2UlOeQSDPXGHe06OvzEMkWvb/4KLzRDGXdF59Q8IDpYFQSspXqZi5sMwqO5PvNVSMXIYk2m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729036578; c=relaxed/simple;
	bh=raafqv0LOls2cfimXzte8rj0I7is0sVeARceHjmIK0M=;
	h=Date:To:From:Subject:Message-Id; b=l7EPL7rMDeblYPm7ufexYpKZyNX6kq6Ugd0fZ0fg819hCLNfsG7T2c/W1Ehv2e0SJMbrB3N3gHRG3MjjoitEOgCnAKEMPkXb0dzY83+6te84vonX1hTiQoh1RYscILg1CRiYqHh4SjSysn++dKBbrRpKVKNqZnH9Rq5pXC4oLl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yOmd5crY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yOmd5crY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AABC4CEC6;
	Tue, 15 Oct 2024 23:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729036577;
	bh=raafqv0LOls2cfimXzte8rj0I7is0sVeARceHjmIK0M=;
	h=Date:To:From:Subject:From;
	b=yOmd5crYiS+tFdgSXTXMSJ8TTArsyKY4vKXLivmSBV+oxa0xdyEr4DDm5nQlbgHz+
	 xY2IEHVRvi3hJoKCxLoltyAi51qKL3/76FVx5hkEtPTKBiWXCb+jrcDp4C+LSke1LE
	 0QShAf1BsgJnKaBvGllhxqwGgogf1Wm1M9iMQGpE=
Date: Tue, 15 Oct 2024 16:56:17 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,snovitoll@gmail.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch added to mm-unstable branch
Message-Id: <20241015235617.85AABC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-kasan-kmsan-copy_from-to_kernel_nofault-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-kmsan-copy_from-to_kernel_nofault-fix
Date: Tue Oct 15 04:53:38 PM PDT 2024

fix comment layout, per checkpatch

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-kmsan-copy_from-to_kernel_nofault-fix
+++ a/mm/kasan/kasan_test_c.c
@@ -1960,8 +1960,10 @@ static void copy_to_kernel_nofault_oob(s
 	char buf[128];
 	size_t size = sizeof(buf);
 
-	/* This test currently fails with the HW_TAGS mode.
-	 * The reason is unknown and needs to be investigated. */
+	/*
+	 * This test currently fails with the HW_TAGS mode. The reason is
+	 * unknown and needs to be investigated.
+	 */
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
 
 	ptr = kmalloc(size - KASAN_GRANULE_SIZE, GFP_KERNEL);
@@ -1969,16 +1971,16 @@ static void copy_to_kernel_nofault_oob(s
 	OPTIMIZER_HIDE_VAR(ptr);
 
 	/*
-	* We test copy_to_kernel_nofault() to detect corrupted memory that is
-	* being written into the kernel. In contrast, copy_from_kernel_nofault()
-	* is primarily used in kernel helper functions where the source address
-	* might be random or uninitialized. Applying KASAN instrumentation to
-	* copy_from_kernel_nofault() could lead to false positives.
-	* By focusing KASAN checks only on copy_to_kernel_nofault(),
-	* we ensure that only valid memory is written to the kernel,
-	* minimizing the risk of kernel corruption while avoiding
-	* false positives in the reverse case.
-	*/
+	 * We test copy_to_kernel_nofault() to detect corrupted memory that is
+	 * being written into the kernel. In contrast,
+	 * copy_from_kernel_nofault() is primarily used in kernel helper
+	 * functions where the source address might be random or uninitialized.
+	 * Applying KASAN instrumentation to copy_from_kernel_nofault() could
+	 * lead to false positives.  By focusing KASAN checks only on
+	 * copy_to_kernel_nofault(), we ensure that only valid memory is
+	 * written to the kernel, minimizing the risk of kernel corruption
+	 * while avoiding false positives in the reverse case.
+	 */
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		copy_to_kernel_nofault(&buf[0], ptr, size));
 	KUNIT_EXPECT_KASAN_FAIL(test,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch

