Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90291D0BA4
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730490494; cv=none; b=Ccu/YghvzH0pm+gBHaY9XYVLb/UPob2u9/zg+68k1Hf3z6tj7bxzwXSP5JZi2dq7dsFnuw3UVsonFxGz4yZapJVsP2fMtxiLUHKKCGDs2ZlcAUHxWvvdfLf2p8FBbyirVnpNza2OySTRkTiPCERxN5MzCo5o3VfyvCz+1/LDSic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730490494; c=relaxed/simple;
	bh=J/ViuEwU071x6lfw3sUHu155iPWtS5xkn6DSNJ/TKKE=;
	h=Date:To:From:Subject:Message-Id; b=dH7raxv1aqA8zpNyHzsB+yhp/aK4EctEP0SErNXkyL4MWEHLRxyTC5CPGohw5LjaLI980op7DLsUHel65I4HPtGzcjN4O4H3sRkcFdDUR4bbZTPsnvNRKRr/0L6YlNl0E5BhOeKHYu5BVwqFLF2f+3g5u6Atvqo5aqCka5zgKo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DUv8aWEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DUv8aWEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768ACC4CECD;
	Fri,  1 Nov 2024 19:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730490493;
	bh=J/ViuEwU071x6lfw3sUHu155iPWtS5xkn6DSNJ/TKKE=;
	h=Date:To:From:Subject:From;
	b=DUv8aWEekQ1B2L4AkT6IYXW/c3xZzXwCNgFOszCtdJpCQG75GgswuWc0/OJbfHYK9
	 dm4rf3iUGbpBXX2q1y52vV33hfbRCnUtURcjwuzo+9HVX+yOOeA0hOfkZx9RPcCNgc
	 AtyyHossPvicO4A8chfoTVA/ZeqavHVXvIYzj2S0=
Date: Fri, 01 Nov 2024 12:48:12 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch added to mm-unstable branch
Message-Id: <20241101194813.768ACC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: change kasan_atomics kunit test as KUNIT_CASE_SLOW
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch

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
Subject: kasan: change kasan_atomics kunit test as KUNIT_CASE_SLOW
Date: Fri, 1 Nov 2024 23:40:11 +0500

During running KASAN Kunit tests with CONFIG_KASAN enabled, the following
"warning" is reported by kunit framework:

	# kasan_atomics: Test should be marked slow (runtime: 2.604703115s)

It took 2.6 seconds on my PC (Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz),
apparently, due to multiple atomic checks in kasan_atomics_helper().

Let's mark it with KUNIT_CASE_SLOW which reports now as:

	# kasan_atomics.speed: slow

Link: https://lkml.kernel.org/r/20241101184011.3369247-3-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow
+++ a/mm/kasan/kasan_test_c.c
@@ -2075,7 +2075,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_strings),
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),
-	KUNIT_CASE(kasan_atomics),
+	KUNIT_CASE_SLOW(kasan_atomics),
 	KUNIT_CASE(vmalloc_helpers_tags),
 	KUNIT_CASE(vmalloc_oob),
 	KUNIT_CASE(vmap_tags),
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-kasan-kmsan-copy_from-to_kernel_nofault.patch
kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch
kasan-delete-config_kasan_module_test-fix.patch
kasan-use-export_symbol_if_kunit-to-export-symbols.patch
kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch

