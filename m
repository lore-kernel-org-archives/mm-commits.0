Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572B616DEA9
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 23:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723591349; cv=none; b=MFEIv3rD3B+9QMFV98x25i10ajTStYnRoRvww+vpvg5v2xOPJONwlZYeG5AzIRk8/ipP1Sd08WWG3xjhUvxFWCwD8YPm1woecFm2amTRD6D01oeOCj+c1oOQyvqgF1rliTWKJcNi9yqdq2ZAemRmUBjYUAdxROv31VCQZ+8UULg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723591349; c=relaxed/simple;
	bh=pUS9mhpuqjKwN/P7MThI2ZFEIBm+wPLtfvo/A1qUSjE=;
	h=Date:To:From:Subject:Message-Id; b=HvUYfbSmWnDsA5vH26Dm59DmYLWxVG7i0dUIQJqUdnFEsxFefmmPFklA+VvqIAtyoUXsHQlefbQ6gsE1YQOBCx/V+WvJD0sDIDscSZbKQfnMAv3NovyqHyAYg7bXasqC4y+o/x6kjKR5f53yB/shJF/vRoYiLHoXvWk8vDLgmKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/PIdri7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/PIdri7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57C5C32782;
	Tue, 13 Aug 2024 23:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723591348;
	bh=pUS9mhpuqjKwN/P7MThI2ZFEIBm+wPLtfvo/A1qUSjE=;
	h=Date:To:From:Subject:From;
	b=F/PIdri7D7CW3aAtiyaUaLFWtitGWSOTDG0RZI8WH0HtGl4ZqCAH6DvnlkXgaf0A6
	 dyfL8thYEvEEHBuxQGnhnsNiXblubdsZjtPn87b3+EkORa7K+9aXEfH1M/Z4WUPLwM
	 vUqowk5HdJo6eka2wOrp6MR1lvyGt78TatiJqx5U=
Date: Tue, 13 Aug 2024 16:22:28 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,ojeda@kernel.org,mmaurer@google.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-simplify-and-clarify-makefile.patch added to mm-unstable branch
Message-Id: <20240813232228.C57C5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: simplify and clarify Makefile
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-simplify-and-clarify-makefile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-simplify-and-clarify-makefile.patch

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

Link: https://lkml.kernel.org/r/20240813224027.84503-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |   43 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/scripts/Makefile.kasan~kasan-simplify-and-clarify-makefile
+++ a/scripts/Makefile.kasan
@@ -22,30 +22,29 @@ endif
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
+# a normal --param). Instead of ifdef-checking the compiler, rely on cc-option.
+CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
+		-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
+		$(call cc-option, -fsanitize=kernel-address \
+		-mllvm -asan-mapping-offset=$(KASAN_SHADOW_OFFSET)))
+
+# Now, add other parameters enabled in a similar way with GCC and Clang.
+CFLAGS_KASAN += $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
+		$(call cc-param,asan-stack=$(stack_enable)) \
+		$(call cc-param,asan-instrument-allocas=1) \
+		$(call cc-param,asan-globals=1)
 
 # Instrument memcpy/memset/memmove calls by using instrumented __asan_mem*()
 # instead. With compilers that don't support this option, compiler-inserted
@@ -57,9 +56,9 @@ endif # CONFIG_KASAN_GENERIC
 ifdef CONFIG_KASAN_SW_TAGS
 
 ifdef CONFIG_KASAN_INLINE
-    instrumentation_flags := $(call cc-param,hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET))
+	instrumentation_flags := $(call cc-param,hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET))
 else
-    instrumentation_flags := $(call cc-param,hwasan-instrument-with-calls=1)
+	instrumentation_flags := $(call cc-param,hwasan-instrument-with-calls=1)
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
@@ -70,7 +69,7 @@ CFLAGS_KASAN := -fsanitize=kernel-hwaddr
 
 # Instrument memcpy/memset/memmove calls by using instrumented __hwasan_mem*().
 ifeq ($(call clang-min-version, 150000)$(call gcc-min-version, 130000),y)
-CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
+	CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
 endif
 
 endif # CONFIG_KASAN_SW_TAGS
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-simplify-and-clarify-makefile.patch
kcov-dont-instrument-lib-find_bitc.patch

