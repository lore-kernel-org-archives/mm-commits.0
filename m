Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7482C6F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423480; cv=none; b=B0/8S2IsyThXSnIExNpfmhUy+f5/SZJp7UXOYrR8UxRSJeXnJtIJ4G3Ui8vxw1wOzq+fs952yvezLtnmKN65kt9xChjW8eIUYzgcP5W8a5yCEXeuCceeZpyVwL8B3pPxvjDjqyhlxC8yekDsN6Yn5vJZH4Fgx4x8g7psc1pDpkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423480; c=relaxed/simple;
	bh=9dAyZuGnn2xkOdbsmflNJnXfBSRvJI4Kb/9jHqWax7o=;
	h=Date:To:From:Subject:Message-Id; b=faYGlcnQ6Y1W+7EvU9hznCZZVO6KShstQ6iXGEquL1kvYvWYc5TGy7LR6P21yOglQg18nxxRn2nyNN4xglXyhyMRY7vVknvS4msLabgNXQiQzb5ErtYMsCD2XlePzecc1Rv/FQCZxokbPJ+HNfEq6jEwFldNCerkWuUu/j7kTgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbpeXESL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbpeXESL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486C6C4CEC2;
	Wed,  4 Sep 2024 04:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423480;
	bh=9dAyZuGnn2xkOdbsmflNJnXfBSRvJI4Kb/9jHqWax7o=;
	h=Date:To:From:Subject:From;
	b=kbpeXESLBLPdBCQPdoRD3fu8FWhXJarzfT+cgW7RRx8kIEx4QfNoL7Eaa9WuTvSEf
	 Py7ZXIAq5TGDO9MoAPqdciB5d4RGhH41e4MWIiFM8F+BJKjBDRtYWDblH+uSHV/s8p
	 A1nWsCANoiS7nzGQzBvf/k9TR4uVtzd0LYjhekiY=
Date: Tue, 03 Sep 2024 21:17:59 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,ojeda@kernel.org,mmaurer@google.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-simplify-and-clarify-makefile.patch removed from -mm tree
Message-Id: <20240904041800.486C6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: simplify and clarify Makefile
has been removed from the -mm tree.  Its filename was
     kasan-simplify-and-clarify-makefile.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: simplify and clarify Makefile
Date: Wed, 14 Aug 2024 00:40:27 +0200

When KASAN support was being added to the Linux kernel, GCC did not yet
support all of the KASAN-related compiler options.  Thus, the KASAN
Makefile had to probe the compiler for supported options.

Nowadays, the Linux kernel GCC version requirement is 5.1+, and thus we
don't need the probing of the -fasan-shadow-offset parameter: it exists in
all 5.1+ GCCs.

Simplify the KASAN Makefile to drop CFLAGS_KASAN_MINIMAL.

Also add a few more comments and unify the indentation.

[andreyknvl@gmail.com: comments fixes per Miguel]
  Link: https://lkml.kernel.org/r/20240814161052.10374-1-andrey.konovalov@linux.dev
Link: https://lkml.kernel.org/r/20240813224027.84503-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |   45 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/scripts/Makefile.kasan~kasan-simplify-and-clarify-makefile
+++ a/scripts/Makefile.kasan
@@ -22,30 +22,31 @@ endif
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
+	# When the number of memory accesses in a function is less than this
+	# call threshold number, the compiler will use inline instrumentation.
+	# 10000 is chosen offhand as a sufficiently large number to make all
+	# kernel functions to be instrumented inline.
 	call_threshold := 10000
 else
 	call_threshold := 0
 endif
 
-CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
-
-# -fasan-shadow-offset fails without -fsanitize
-CFLAGS_KASAN_SHADOW := $(call cc-option, -fsanitize=kernel-address \
-			-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
-			$(call cc-option, -fsanitize=kernel-address \
-			-mllvm -asan-mapping-offset=$(KASAN_SHADOW_OFFSET)))
-
-ifeq ($(strip $(CFLAGS_KASAN_SHADOW)),)
-	CFLAGS_KASAN := $(CFLAGS_KASAN_MINIMAL)
-else
-	# Now add all the compiler specific options that are valid standalone
-	CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
-	 $(call cc-param,asan-globals=1) \
-	 $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
-	 $(call cc-param,asan-instrument-allocas=1)
-endif
-
-CFLAGS_KASAN += $(call cc-param,asan-stack=$(stack_enable))
+# First, enable -fsanitize=kernel-address together with providing the shadow
+# mapping offset, as for GCC, -fasan-shadow-offset fails without -fsanitize
+# (GCC accepts the shadow mapping offset via -fasan-shadow-offset instead of
+# a --param like the other KASAN parameters).
+# Instead of ifdef-checking the compiler, rely on cc-option.
+CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
+		-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
+		$(call cc-option, -fsanitize=kernel-address \
+		-mllvm -asan-mapping-offset=$(KASAN_SHADOW_OFFSET)))
+
+# Now, add other parameters enabled similarly in both GCC and Clang.
+# As some of them are not supported by older compilers, use cc-param.
+CFLAGS_KASAN += $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
+		$(call cc-param,asan-stack=$(stack_enable)) \
+		$(call cc-param,asan-instrument-allocas=1) \
+		$(call cc-param,asan-globals=1)
 
 # Instrument memcpy/memset/memmove calls by using instrumented __asan_mem*()
 # instead. With compilers that don't support this option, compiler-inserted
@@ -57,9 +58,9 @@ endif # CONFIG_KASAN_GENERIC
 ifdef CONFIG_KASAN_SW_TAGS
 
 ifdef CONFIG_KASAN_INLINE
-    instrumentation_flags := $(call cc-param,hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET))
+	instrumentation_flags := $(call cc-param,hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET))
 else
-    instrumentation_flags := $(call cc-param,hwasan-instrument-with-calls=1)
+	instrumentation_flags := $(call cc-param,hwasan-instrument-with-calls=1)
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
@@ -70,7 +71,7 @@ CFLAGS_KASAN := -fsanitize=kernel-hwaddr
 
 # Instrument memcpy/memset/memmove calls by using instrumented __hwasan_mem*().
 ifeq ($(call clang-min-version, 150000)$(call gcc-min-version, 130000),y)
-CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
+	CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
 endif
 
 endif # CONFIG_KASAN_SW_TAGS
_

Patches currently in -mm which might be from andreyknvl@gmail.com are


