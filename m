Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924D12C0262;
	Thu, 21 Aug 2025 20:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755808086; cv=none; b=QHSg9oIpRHUJwRl7i6BJBeleP71fMnVOUDV6qpk2gy8dLCP+d0a/CVhN5iQjbBX/WqmkN/KIJD/iyJZECocbCw2xoFFwH+OQsO+cR4VkVM4LmTIZ8GgmQB4sdWvqH8tpxrk/7ywliVOqhD3p9fFPH/bhuQ2mGrij9QDb/Mzber8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755808086; c=relaxed/simple;
	bh=/QztYoFg+jJTuyuejgU8lHBzqLNV+Fm+lsNA5GbqqeI=;
	h=Date:To:From:Subject:Message-Id; b=eSuczV9yLw3gDor7Mjx9QYIr1LeN7nR5rBHRiICDvOj7sw+MByvCxq3FcTxt4b/AgEW95sYQIM83l8RXXGj9RIN6lPBUpto6GR6V0mQ6AfpLyBE3vnPsvEQOlpiw5cEfQP+QP688acEzr6ahSCrOafiTEK2Eg89znXzMtmIqalo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0g4yBPlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0g4yBPlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AE0C4CEEB;
	Thu, 21 Aug 2025 20:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755808086;
	bh=/QztYoFg+jJTuyuejgU8lHBzqLNV+Fm+lsNA5GbqqeI=;
	h=Date:To:From:Subject:From;
	b=0g4yBPlcVOJaDIqTMe6rbv/2c86T0CXX59XjONhUZLXHITfPUhD1PdeYbsiL4Rog4
	 2Ga0Hp4XF9rK0g8uxvFg4vTofczNjJtjURv0HK+MCd4svGkC2VVaaKZ4n71Bqjq5U7
	 bciAnAZ0KQIu7JQUKwFSaAMfe7eXJ2dwMjYJkwss=
Date: Thu, 21 Aug 2025 13:28:05 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,nathan@kernel.org,mpe@ellerman.id.au,mark.rutland@arm.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,ada.coupriediaz@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-gcc-mem-intrinsic-prefix-with-sw-tags.patch added to mm-hotfixes-unstable branch
Message-Id: <20250821202806.14AE0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: fix GCC mem-intrinsic prefix with sw tags
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-fix-gcc-mem-intrinsic-prefix-with-sw-tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-gcc-mem-intrinsic-prefix-with-sw-tags.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Subject: kasan: fix GCC mem-intrinsic prefix with sw tags
Date: Thu, 21 Aug 2025 13:07:35 +0100

GCC doesn't support "hwasan-kernel-mem-intrinsic-prefix", only
"asan-kernel-mem-intrinsic-prefix"[0], while LLVM supports both.  This is
already taken into account when checking
"CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX", but not in the KASAN Makefile
adding those parameters when "CONFIG_KASAN_SW_TAGS" is enabled.

Replace the version check with "CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX",
which already validates that mem-intrinsic prefix parameter can be used,
and choose the correct name depending on compiler.

GCC 13 and above trigger "CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX" which
prevents `mem{cpy,move,set}()` being redefined in "mm/kasan/shadow.c"
since commit 36be5cba99f6 ("kasan: treat meminstrinsic as builtins in
uninstrumented files"), as we expect the compiler to prefix those calls
with `__(hw)asan_` instead.  But as the option passed to GCC has been
incorrect, the compiler has not been emitting those prefixes, effectively
never calling the instrumented versions of `mem{cpy,move,set}()` with
"CONFIG_KASAN_SW_TAGS" enabled.

If "CONFIG_FORTIFY_SOURCES" is enabled, this issue would be mitigated as
it redefines `mem{cpy,move,set}()` and properly aliases the
`__underlying_mem*()` that will be called to the instrumented versions.

[0]: https://gcc.gnu.org/onlinedocs/gcc-13.4.0/gcc/Optimize-Options.html

Link: https://lkml.kernel.org/r/20250821120735.156244-1-ada.coupriediaz@arm.com
Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Fixes: 36be5cba99f6 ("kasan: treat meminstrinsic as builtins in uninstrumented files")
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/scripts/Makefile.kasan~kasan-fix-gcc-mem-intrinsic-prefix-with-sw-tags
+++ a/scripts/Makefile.kasan
@@ -86,10 +86,14 @@ kasan_params += hwasan-instrument-stack=
 		hwasan-use-short-granules=0 \
 		hwasan-inline-all-checks=0
 
-# Instrument memcpy/memset/memmove calls by using instrumented __hwasan_mem*().
-ifeq ($(call clang-min-version, 150000)$(call gcc-min-version, 130000),y)
-	kasan_params += hwasan-kernel-mem-intrinsic-prefix=1
-endif
+# Instrument memcpy/memset/memmove calls by using instrumented __(hw)asan_mem*().
+ifdef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
+	ifdef CONFIG_CC_IS_GCC
+		kasan_params += asan-kernel-mem-intrinsic-prefix=1
+	else
+		kasan_params += hwasan-kernel-mem-intrinsic-prefix=1
+	endif
+endif # CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
 
 endif # CONFIG_KASAN_SW_TAGS
 
_

Patches currently in -mm which might be from ada.coupriediaz@arm.com are

kasan-fix-gcc-mem-intrinsic-prefix-with-sw-tags.patch

