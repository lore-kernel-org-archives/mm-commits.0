Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793332668;
	b=3CwnVmnF41l6gJ4SyaM41wkW6l25tiTEfonzMrm0LZNMmEyCAi5Zv24D4w3klo+qTUIh
	 I2CaC+2GDYbuPEHMtW5vVK/rTkaSbhk2MwkewLO2thVX/rrAGkTJstq7Y+JWNzsXZvPRb
	 uOIiDtL2YdZAmpOPfQtwCnxcWhbgwSOMhbCW5f9dWfT3EgFIpKqHMLfjA3GZ64+zdzQk5
	 7M7jZn2EeGade90gF+O7vGwGpzOstyZTPlR/6KI+mPebHSdhFBPTdbHeIHTgB6/LDKUKN
	 xlzeHH9lBEotLYEdPCzAzMf7ZTzBIQjqm7Flr77u0ukf67D1Tr4Rc3GbJgUAvJ9cF+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793332668;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gx9Vi0x1jfEm02KILwM0s8yqXpLK+K3xPrLrvjNau0M=;
	b=nb4IRhAY6wCNaiyQJjH9Q154aavSrbtMotzSFyJPFx6zrdMuqvqzAALpCqsd/UHlN1lp
	 ivUXuTd3ndGXez0ulFUJacErjA+H00te32FndOaSQRWC8jfeO8wwUxDXhJGXHl5dSHntU
	 u2xCSVEfgNB1YjU1ZIwspiw8FPUXoSaVCxogYpPskQf1X03pYFDFyJUQ7cNtSJp0RJjnA
	 KaDksVY73FQh2QKhcOFKbBVtsch+yRI/k0nnU29JFomjm76kqirx9RPBKwojFftVxxpea
	 4m2GnJ2tnNBt3rYl9HMY1ywwqNPOcjBjXmje41kMZoySeXkA5Ec9Z6VbdD1srEuGmHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Dbb/6KSW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EAC606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 03:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Dbb/6KSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999C51F000C1;
	Fri, 30 Oct 2026 03:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793332667;
	bh=gx9Vi0x1jfEm02KILwM0s8yqXpLK+K3xPrLrvjNau0M=;
	h=Date:To:From:Subject;
	b=Dbb/6KSW/+9xIHInLuPiBekO++SRQ0Db0GirSj6YCEsikHjA5ne80TrrfVO4d2xPq
	 CmeKvT4TDUxxFke8OPTQlDMJPjRF2V3xdT5AJrvvp50C+BcES4k26xpy87ItYQP9ZY
	 t4uKM9HhsN2kX/uPXP1oKcWD+WM0KP9vj1FqkFwc=
Date: Thu, 29 Oct 2026 20:57:47 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vincenzo.frascino@arm.com,
	tglx@kernel.org,svens@linux.ibm.com,sshegde@linux.ibm.com,shuah@kernel.org,
	ryabinin.a.a@gmail.com,ritesh.list@gmail.com,pjw@kernel.org,peter@pcc.me.uk,
	palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,
	mark.rutland@arm.com,maddy@linux.ibm.com,linux@armlinux.org.uk,
	kees@kernel.org,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,
	glider@google.com,elver@google.com,dvyukov@google.com,
	dave.hansen@linux.intel.com,chleroy@kernel.org,catalin.marinas@arm.com,
	bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,
	andreyknvl@gmail.com,alex@ghiti.fr,agordeev@linux.ibm.com,
	odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-test-cover-load_unaligned_zeropad.patch added to mm-new branch
Message-Id: <20261030035747.999C51F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kasan/test: cover load_unaligned_zeropad()
has been added to the -mm mm-new branch.  Its filename is
     kasan-test-cover-load_unaligned_zeropad.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-test-cover-load_unaligned_zeropad.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: kasan/test: cover load_unaligned_zeropad()
Date: Fri, 23 Oct 2026 09:49:49 +0800

On architectures with CONFIG_DCACHE_WORD_ACCESS, load_unaligned_zeropad()
does the word loads of the dcache name compare and of path name hashing.

None of the KASAN test cases reads memory through it, so nothing noticed
that KASAN did not check these loads at all.

Add a case that reads a freed object through load_unaligned_zeropad() and
expects a report.  Skip it with hardware tag-based KASAN, since arm64
turns tag checking off for this load:

  kasan_load_unaligned_zeropad, x86_64, generic KASAN
  without "word-at-a-time: check the first byte in
  load_unaligned_zeropad()"                                 FAILED
  with it                                                   PASSED

Link: https://lore.kernel.org/20261023-bug-word-at-a-time-zeropad-kasan-v2-2-be0ecfbae847@gmail.com
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: AlexandreGhiti <alex@ghiti.fr>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Collingbourne <peter@pcc.me.uk>
---

 mm/kasan/kasan_test_c.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-test-cover-load_unaligned_zeropad
+++ a/mm/kasan/kasan_test_c.c
@@ -28,6 +28,9 @@
 #include <trace/events/printk.h>
 
 #include <asm/page.h>
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+#include <asm/word-at-a-time.h>
+#endif
 
 #include "kasan.h"
 #include "../slab.h"
@@ -1807,6 +1810,26 @@ static void kasan_memcmp(struct kunit *t
 	kfree(ptr);
 }
 
+static void kasan_load_unaligned_zeropad(struct kunit *test)
+{
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+	char *ptr;
+
+	/* The tag check is turned off for this load on arm64 with MTE. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
+
+	ptr = kmalloc(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	kfree(ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
+		kasan_int_result = load_unaligned_zeropad(ptr));
+#else
+	kunit_skip(test, "Test requires CONFIG_DCACHE_WORD_ACCESS=y");
+#endif
+}
+
 static void kasan_strings(struct kunit *test)
 {
 	char *ptr;
@@ -2403,6 +2426,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_alloca_oob_right),
 	KUNIT_CASE(kasan_memchr),
 	KUNIT_CASE(kasan_memcmp),
+	KUNIT_CASE(kasan_load_unaligned_zeropad),
 	KUNIT_CASE(kasan_strings),
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),
_

Patches currently in -mm which might be from odys.yuan@gmail.com are

selftests-mm-track-the-modules-run_vmtestssh-loads.patch
selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch
word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad.patch
kasan-test-cover-load_unaligned_zeropad.patch

