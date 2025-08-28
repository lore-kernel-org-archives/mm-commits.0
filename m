Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C7E13DDAA;
	Thu, 28 Aug 2025 05:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359982; cv=none; b=IvLFKNwF2lU8eraJfvAMWJMqtfNK8Eypjg29rkDsnBk3uN9rj87N4YeZqfcjrlpJ2B8ONizJRFmt8N/CVSfl5OyLpI5C8HKBaUL5nxepplR3x5VwYJj8sCnukq/+Y9EG0UD4mBkLW7bd64UovSY7JhEY3q9+qBHjuM8OOJR5HFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359982; c=relaxed/simple;
	bh=2bAGBP2ziuX2W1E04tKsFONmq8gPpepEi41uFrqWTdg=;
	h=Date:To:From:Subject:Message-Id; b=Or3Wgw1/KTkzi6xDCcVSVRrnyxJMXGlESDJjRdEZAiPo3+EruDskw3A/91O4IvV9RgaBIUcd0yfqpY74BXIUhpEk30mWBhRz2QX06KjEEf6QGI97T7y9u/6H38R1guY2Of/sMT7OzZH2N7/YpDw2k1jLYQppNc+3fy+6SplI/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YZVuWO16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YZVuWO16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC81C4CEEB;
	Thu, 28 Aug 2025 05:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359981;
	bh=2bAGBP2ziuX2W1E04tKsFONmq8gPpepEi41uFrqWTdg=;
	h=Date:To:From:Subject:From;
	b=YZVuWO169CIW+TRmv6LSBNNVG8B1HRQezyaE4h8/F56E7SIwQDPtv9Io6eWvSbmAZ
	 8pWSixG9fN42wgwYTKwg3rlvGNcB4JekpSanXAFlBgDvt3OZ4Sndylhdm3SFY5Owqe
	 QOh88O8dIXMozKq8MxaxH8fgyF6F3Ef+tOiQVjD4=
Date: Wed, 27 Aug 2025 22:46:20 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,nathan@kernel.org,mpe@ellerman.id.au,mark.rutland@arm.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,ada.coupriediaz@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-fix-gcc-mem-intrinsic-prefix-with-sw-tags.patch removed from -mm tree
Message-Id: <20250828054621.0FC81C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix GCC mem-intrinsic prefix with sw tags
has been removed from the -mm tree.  Its filename was
     kasan-fix-gcc-mem-intrinsic-prefix-with-sw-tags.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20250821120735.156244-1-ada.coupriediaz@arm.com
Link: https://gcc.gnu.org/onlinedocs/gcc-13.4.0/gcc/Optimize-Options.html [0]
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


