Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42D815F306
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756847; cv=none; b=SahECYYXPZXXVkcYqToZK80v4CGhYBPMeDOY/FzsH4Ywq+ITyRduZNjgIqZDFJBrF7/2UF6eGkmGUFTrMV4SPL/1Ut+7l4Odw3eLpCzyBxz83y4HPNhJTsB75lK7iuug61F48WCG4yZH98uw3nsIPuRL4EE+WtrDd7cPqwgXfiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756847; c=relaxed/simple;
	bh=TiaqZTmDfeyWOdxLv5rKt06hDDhVr9oqL6Gfldof2nM=;
	h=Date:To:From:Subject:Message-Id; b=KrsP85cx7DQDe6/fJQijdW/eM11n+du94K7168VVHYtTww/19fe/ZYoup0LqIbwT4LUCoD8Mf6IN1YwU8W0rwNpgN3sbwE7afdxj1VcXLSCSzLnAXTP/D/x+05vJEC7Zo3pbLTX+mYna85a/+99yKVRSxRY6JdxLnFbo1/xxmuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xjg2SaUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xjg2SaUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87214C4CEED;
	Sun,  1 Jun 2025 05:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756847;
	bh=TiaqZTmDfeyWOdxLv5rKt06hDDhVr9oqL6Gfldof2nM=;
	h=Date:To:From:Subject:From;
	b=xjg2SaUB1lHVvLyIn2y5tJQomwzxCbGy+ikJPaQeOg/B1IM6eTPfH1mionwrh5ErU
	 TQf14qTZU5rserh/OghToD9WIOPv6BY3PfS2FX1rFnV0v94ggvBcU+xlBVcWH2g2QF
	 RpXf5DpH985Ee4Y56QfLaPIejlR8pSylUylNoqV4=
Date: Sat, 31 May 2025 22:47:27 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,nogikh@google.com,nathan@kernel.org,morbo@google.com,mmaurer@google.com,masahiroy@kernel.org,justinstitt@google.com,glider@google.com,gary@garyguo.net,dvyukov@google.com,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,andreyknvl@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kcov-rust-add-flags-for-kcov-with-rust.patch removed from -mm tree
Message-Id: <20250601054727.87214C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: rust: add flags for KCOV with Rust
has been removed from the -mm tree.  Its filename was
     kcov-rust-add-flags-for-kcov-with-rust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: kcov: rust: add flags for KCOV with Rust
Date: Thu, 01 May 2025 12:16:16 +0000

Rust code is currently not instrumented properly when KCOV is enabled.
Thus, add the relevant flags to perform instrumentation correctly. This
is necessary for efficient fuzzing of Rust code.

The sanitizer-coverage features of LLVM have existed for long enough
that they are available on any LLVM version supported by rustc, so we do
not need any Kconfig feature detection. The coverage level is set to 3,
as that is the level needed by trace-pc.

We do not instrument `core` since when we fuzz the kernel, we are
looking for bugs in the kernel, not the Rust stdlib.

Link: https://lkml.kernel.org/r/20250501-rust-kcov-v2-1-b71e83e9779f@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Co-developed-by: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Aleksandr Nogikh <nogikh@google.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Bill Wendling <morbo@google.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/Makefile         |    1 +
 scripts/Makefile.kcov |    6 ++++++
 scripts/Makefile.lib  |    3 +++
 3 files changed, 10 insertions(+)

--- a/rust/Makefile~kcov-rust-add-flags-for-kcov-with-rust
+++ a/rust/Makefile
@@ -492,6 +492,7 @@ $(obj)/core.o: $(RUST_LIB_SRC)/core/src/
 ifneq ($(or $(CONFIG_X86_64),$(CONFIG_X86_32)),)
 $(obj)/core.o: scripts/target.json
 endif
+KCOV_INSTRUMENT_core.o := n
 
 $(obj)/compiler_builtins.o: private skip_gendwarfksyms = 1
 $(obj)/compiler_builtins.o: private rustc_objcopy = -w -W '__*'
--- a/scripts/Makefile.kcov~kcov-rust-add-flags-for-kcov-with-rust
+++ a/scripts/Makefile.kcov
@@ -3,4 +3,10 @@ kcov-flags-$(CONFIG_CC_HAS_SANCOV_TRACE_
 kcov-flags-$(CONFIG_KCOV_ENABLE_COMPARISONS)	+= -fsanitize-coverage=trace-cmp
 kcov-flags-$(CONFIG_GCC_PLUGIN_SANCOV)		+= -fplugin=$(objtree)/scripts/gcc-plugins/sancov_plugin.so
 
+kcov-rflags-y					+= -Cpasses=sancov-module
+kcov-rflags-y					+= -Cllvm-args=-sanitizer-coverage-level=3
+kcov-rflags-y					+= -Cllvm-args=-sanitizer-coverage-trace-pc
+kcov-rflags-$(CONFIG_KCOV_ENABLE_COMPARISONS)	+= -Cllvm-args=-sanitizer-coverage-trace-compares
+
 export CFLAGS_KCOV := $(kcov-flags-y)
+export RUSTFLAGS_KCOV := $(kcov-rflags-y)
--- a/scripts/Makefile.lib~kcov-rust-add-flags-for-kcov-with-rust
+++ a/scripts/Makefile.lib
@@ -169,6 +169,9 @@ ifeq ($(CONFIG_KCOV),y)
 _c_flags += $(if $(patsubst n%,, \
 	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(if $(is-kernel-object),$(CONFIG_KCOV_INSTRUMENT_ALL))), \
 	$(CFLAGS_KCOV))
+_rust_flags += $(if $(patsubst n%,, \
+	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(if $(is-kernel-object),$(CONFIG_KCOV_INSTRUMENT_ALL))), \
+	$(RUSTFLAGS_KCOV))
 endif
 
 #
_

Patches currently in -mm which might be from aliceryhl@google.com are


