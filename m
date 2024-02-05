Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABA648CCF
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174530; cv=none; b=kzAaRFl748dGy/uNqJARaOXJhTaJr1d/6GvJS6vBnEEit13Cr4ILvbRiibEF+xHJGeUZ3374wahsy0HDGz41qdmOnR+bY3xwWoqSs4Gp4/z5EpZcDgEUjSiEnYzX19N+VMTkJNIrjjh+kuZCVfdK3oSdFYNGVgSIJDH6mCrkck0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174530; c=relaxed/simple;
	bh=Ofsm5+3Fs+P2FS9ncp/1086GsSTr9gcOF9StxnhRwPw=;
	h=Date:To:From:Subject:Message-Id; b=SGDlWmalCBkzFqhbHI/ePbbfiOMBXNUAdNmiM1n725IiWzq9kF7+kLYMRMnZrpG6pD7J2h8sMSWPyZcnK71Unvr3vpMTy8JetxXZurPLIO1Q2nH5z4kmukEiz0ON6YdFtdU8vzETKniCk6bY71Ggh9e9aiTNc2toil4DyebM7M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RwzT9RP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RwzT9RP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CA4C433C7;
	Mon,  5 Feb 2024 23:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707174530;
	bh=Ofsm5+3Fs+P2FS9ncp/1086GsSTr9gcOF9StxnhRwPw=;
	h=Date:To:From:Subject:From;
	b=RwzT9RP+iU0Xb0rxVNFg06b//CIu4k6Kda2a30SQJpv4gJfywP8UKja1mtlcOFvVT
	 ckWmIce6Otds97zLBR6IzEWHaDUHx08svdN/6vODt2iZPtLwswpo0YwfShWp1YZUep
	 yNQGZdZBgFU1rDZrSMZHBHkOtk95AYBUKzmrBUfw=
Date: Mon, 05 Feb 2024 15:08:49 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,przemyslaw.kitszel@intel.com,peterz@infradead.org,ojeda@kernel.org,nicolas@fjasle.eu,ndesaulniers@google.com,nathan@kernel.org,masahiroy@kernel.org,justinstitt@google.com,haoluo@google.com,elver@google.com,andreyknvl@gmail.com,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ubsan-reintroduce-signed-overflow-sanitizer.patch added to mm-unstable branch
Message-Id: <20240205230850.07CA4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ubsan: reintroduce signed overflow sanitizer
has been added to the -mm mm-unstable branch.  Its filename is
     ubsan-reintroduce-signed-overflow-sanitizer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ubsan-reintroduce-signed-overflow-sanitizer.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: reintroduce signed overflow sanitizer
Date: Mon, 5 Feb 2024 01:37:29 -0800

In order to mitigate unexpected signed wrap-around[1], bring back the
signed integer overflow sanitizer.  It was removed in commit 6aaa31aeb9cf
("ubsan: remove overflow checks") because it was effectively a no-op when
combined with -fno-strict-overflow (which correctly changes signed
overflow from being "undefined" to being explicitly "wrap around").

Compilers are adjusting their sanitizers to trap wrap-around and to
detecting common code patterns that should not be instrumented (e.g.  "var
+ offset < var").  Prepare for this and explicitly rename the option from
"OVERFLOW" to "WRAP".

To annotate intentional wrap-around arithmetic, the add/sub/mul_wrap()
helpers can be used for individual statements.  At the function level, the
__signed_wrap attribute can be used to mark an entire function as
expecting its signed arithmetic to wrap around.  For a single object file
the Makefile can use "UBSAN_WRAP_SIGNED_target.o := n" to mark it as
wrapping, and for an entire directory, "UBSAN_WRAP_SIGNED := n" can be
used.

Additionally keep these disabled under CONFIG_COMPILE_TEST for now.

Link: https://github.com/KSPP/linux/issues/26 [1]
Link: https://lkml.kernel.org/r/20240205093725.make.582-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hao Luo <haoluo@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    9 +++-
 lib/Kconfig.ubsan              |   14 ++++++
 lib/test_ubsan.c               |   37 ++++++++++++++++
 lib/ubsan.c                    |   68 +++++++++++++++++++++++++++++++
 lib/ubsan.h                    |    4 +
 scripts/Makefile.lib           |    3 +
 scripts/Makefile.ubsan         |    3 +
 7 files changed, 137 insertions(+), 1 deletion(-)

--- a/include/linux/compiler_types.h~ubsan-reintroduce-signed-overflow-sanitizer
+++ a/include/linux/compiler_types.h
@@ -282,11 +282,18 @@ struct ftrace_likely_data {
 #define __no_sanitize_or_inline __always_inline
 #endif
 
+/* Do not trap wrapping arithmetic within an annotated function. */
+#ifdef CONFIG_UBSAN_SIGNED_WRAP
+# define __signed_wrap __attribute__((no_sanitize("signed-integer-overflow")))
+#else
+# define __signed_wrap
+#endif
+
 /* Section for code which can't be instrumented at all */
 #define __noinstr_section(section)					\
 	noinline notrace __attribute((__section__(section)))		\
 	__no_kcsan __no_sanitize_address __no_profile __no_sanitize_coverage \
-	__no_sanitize_memory
+	__no_sanitize_memory __signed_wrap
 
 #define noinstr __noinstr_section(".noinstr.text")
 
--- a/lib/Kconfig.ubsan~ubsan-reintroduce-signed-overflow-sanitizer
+++ a/lib/Kconfig.ubsan
@@ -116,6 +116,20 @@ config UBSAN_UNREACHABLE
 	  This option enables -fsanitize=unreachable which checks for control
 	  flow reaching an expected-to-be-unreachable position.
 
+config UBSAN_SIGNED_WRAP
+	bool "Perform checking for signed arithmetic wrap-around"
+	default UBSAN
+	depends on !COMPILE_TEST
+	depends on $(cc-option,-fsanitize=signed-integer-overflow)
+	help
+	  This option enables -fsanitize=signed-integer-overflow which checks
+	  for wrap-around of any arithmetic operations with signed integers.
+	  This currently performs nearly no instrumentation due to the
+	  kernel's use of -fno-strict-overflow which converts all would-be
+	  arithmetic undefined behavior into wrap-around arithmetic. Future
+	  sanitizer versions will allow for wrap-around checking (rather than
+	  exclusively undefined behavior).
+
 config UBSAN_BOOL
 	bool "Perform checking for non-boolean values used as boolean"
 	default UBSAN
--- a/lib/test_ubsan.c~ubsan-reintroduce-signed-overflow-sanitizer
+++ a/lib/test_ubsan.c
@@ -11,6 +11,39 @@ typedef void(*test_ubsan_fp)(void);
 			#config, IS_ENABLED(config) ? "y" : "n");	\
 	} while (0)
 
+static void test_ubsan_add_overflow(void)
+{
+	volatile int val = INT_MAX;
+
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
+	val += 2;
+}
+
+static void test_ubsan_sub_overflow(void)
+{
+	volatile int val = INT_MIN;
+	volatile int val2 = 2;
+
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
+	val -= val2;
+}
+
+static void test_ubsan_mul_overflow(void)
+{
+	volatile int val = INT_MAX / 2;
+
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
+	val *= 3;
+}
+
+static void test_ubsan_negate_overflow(void)
+{
+	volatile int val = INT_MIN;
+
+	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
+	val = -val;
+}
+
 static void test_ubsan_divrem_overflow(void)
 {
 	volatile int val = 16;
@@ -90,6 +123,10 @@ static void test_ubsan_misaligned_access
 }
 
 static const test_ubsan_fp test_ubsan_array[] = {
+	test_ubsan_add_overflow,
+	test_ubsan_sub_overflow,
+	test_ubsan_mul_overflow,
+	test_ubsan_negate_overflow,
 	test_ubsan_shift_out_of_bounds,
 	test_ubsan_out_of_bounds,
 	test_ubsan_load_invalid_value,
--- a/lib/ubsan.c~ubsan-reintroduce-signed-overflow-sanitizer
+++ a/lib/ubsan.c
@@ -222,6 +222,74 @@ static void ubsan_epilogue(void)
 	check_panic_on_warn("UBSAN");
 }
 
+static void handle_overflow(struct overflow_data *data, void *lhs,
+			void *rhs, char op)
+{
+
+	struct type_descriptor *type = data->type;
+	char lhs_val_str[VALUE_LENGTH];
+	char rhs_val_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, type_is_signed(type) ?
+			"signed-integer-overflow" :
+			"unsigned-integer-overflow");
+
+	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
+	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
+	pr_err("%s %c %s cannot be represented in type %s\n",
+		lhs_val_str,
+		op,
+		rhs_val_str,
+		type->type_name);
+
+	ubsan_epilogue();
+}
+
+void __ubsan_handle_add_overflow(void *data,
+				void *lhs, void *rhs)
+{
+
+	handle_overflow(data, lhs, rhs, '+');
+}
+EXPORT_SYMBOL(__ubsan_handle_add_overflow);
+
+void __ubsan_handle_sub_overflow(void *data,
+				void *lhs, void *rhs)
+{
+	handle_overflow(data, lhs, rhs, '-');
+}
+EXPORT_SYMBOL(__ubsan_handle_sub_overflow);
+
+void __ubsan_handle_mul_overflow(void *data,
+				void *lhs, void *rhs)
+{
+	handle_overflow(data, lhs, rhs, '*');
+}
+EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
+
+void __ubsan_handle_negate_overflow(void *_data, void *old_val)
+{
+	struct overflow_data *data = _data;
+	char old_val_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, "negation-overflow");
+
+	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
+
+	pr_err("negation of %s cannot be represented in type %s:\n",
+		old_val_str, data->type->type_name);
+
+	ubsan_epilogue();
+}
+EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
+
+
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
 {
 	struct overflow_data *data = _data;
--- a/lib/ubsan.h~ubsan-reintroduce-signed-overflow-sanitizer
+++ a/lib/ubsan.h
@@ -124,6 +124,10 @@ typedef s64 s_max;
 typedef u64 u_max;
 #endif
 
+void __ubsan_handle_add_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_sub_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_mul_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_negate_overflow(void *_data, void *old_val);
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs);
 void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr);
 void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr);
--- a/scripts/Makefile.lib~ubsan-reintroduce-signed-overflow-sanitizer
+++ a/scripts/Makefile.lib
@@ -177,6 +177,9 @@ ifeq ($(CONFIG_UBSAN),y)
 _c_flags += $(if $(patsubst n%,, \
 		$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANITIZE_ALL)), \
 		$(CFLAGS_UBSAN))
+_c_flags += $(if $(patsubst n%,, \
+		$(UBSAN_WRAP_SIGNED_$(basetarget).o)$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_WRAP_SIGNED)$(UBSAN_SANITIZE)y), \
+		$(CFLAGS_UBSAN_WRAP_SIGNED))
 endif
 
 ifeq ($(CONFIG_KCOV),y)
--- a/scripts/Makefile.ubsan~ubsan-reintroduce-signed-overflow-sanitizer
+++ a/scripts/Makefile.ubsan
@@ -13,3 +13,6 @@ ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -f
 ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= -fsanitize-undefined-trap-on-error
 
 export CFLAGS_UBSAN := $(ubsan-cflags-y)
+
+ubsan-wrap-signed-cflags-$(CONFIG_UBSAN_SIGNED_WRAP)     += -fsanitize=signed-integer-overflow
+export CFLAGS_UBSAN_WRAP_SIGNED := $(ubsan-wrap-signed-cflags-y)
_

Patches currently in -mm which might be from keescook@chromium.org are

ubsan-reintroduce-signed-overflow-sanitizer.patch
iov_iter-avoid-wrap-around-instrumentation-in-copy_compat_iovec_from_user.patch

