Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B41A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188161; cv=none; b=WbDK+joA1WA/2stAS8tmW9trTX2KcNdQ4kbjcRlm+2GgZxm8C0hn101wMThven9rowWZAfM/b+Ah9xiEfPuiuEsRiOkArlp+K+rpwdFaJpno/dyArfNj7j6AkceQwmLp38BbSR2BarM4j2w3dMBrZnvGDRpP1ukwTWiEL05vSRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188161; c=relaxed/simple;
	bh=UExeLkOwg1GG4PPSmsDyVq5P3aurApatb0HdLAYjgcw=;
	h=Date:To:From:Subject:Message-Id; b=oNbu7u+GYOZysj76p2YxdfUE0uuIggzr8/8/8KQKPA1WlEpYD7xKtM9oIehnMcmKxEE5hkNn+2AxDjm9h16UH5qIvQAM9x8d74lhXArfu5E6n7SjEi3uSGxQlbPJFQC9Bonn65rxXbTh7+U80lRm90WA9RV+0iwUT5ISZ3qyJIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y6sPfX/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y6sPfX/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978FCC4CEEC;
	Mon, 17 Mar 2025 05:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188160;
	bh=UExeLkOwg1GG4PPSmsDyVq5P3aurApatb0HdLAYjgcw=;
	h=Date:To:From:Subject:From;
	b=Y6sPfX/CZbewyTQPg78qZngAzFIeDUIRU5F8DcjQdTtiDJX5ws+PLelBrMTAKkqVv
	 y0OFqUhTc5tumBGeV4lNhAg/umC2F1wPWMbqK2+BHUmPX+uoaMonTSOnryeWFU0lHC
	 eLJfJp0egQA88OZvuVjEd4wA1ukFqNmfw3KhRZD0=
Date: Sun, 16 Mar 2025 22:09:19 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] compilerh-introduce-typeof_unqual-macro.patch removed from -mm tree
Message-Id: <20250317050920.978FCC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler.h: introduce TYPEOF_UNQUAL() macro
has been removed from the -mm tree.  Its filename was
     compilerh-introduce-typeof_unqual-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: compiler.h: introduce TYPEOF_UNQUAL() macro
Date: Mon, 27 Jan 2025 17:05:06 +0100

Define TYPEOF_UNQUAL() to use __typeof_unqual__() as typeof operator when
available, to return unqualified type of the expression.

Current version of sparse doesn't know anything about __typeof_unqual__()
operator.  Avoid the usage of __typeof_unqual__() when sparse checking is
active to prevent sparse errors with unknowing keyword.

Link: https://lkml.kernel.org/r/20250127160709.80604-3-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    8 ++++++++
 include/linux/compiler-gcc.h   |    8 ++++++++
 include/linux/compiler.h       |   20 ++++++++++++++++++++
 3 files changed, 36 insertions(+)

--- a/include/linux/compiler-clang.h~compilerh-introduce-typeof_unqual-macro
+++ a/include/linux/compiler-clang.h
@@ -128,3 +128,11 @@
  */
 #define ASM_INPUT_G "ir"
 #define ASM_INPUT_RM "r"
+
+/*
+ * Declare compiler support for __typeof_unqual__() operator.
+ *
+ * Bindgen uses LLVM even if our C compiler is GCC, so we cannot
+ * rely on the auto-detected CONFIG_CC_HAS_TYPEOF_UNQUAL.
+ */
+#define CC_HAS_TYPEOF_UNQUAL (__clang_major__ >= 19)
--- a/include/linux/compiler-gcc.h~compilerh-introduce-typeof_unqual-macro
+++ a/include/linux/compiler-gcc.h
@@ -137,3 +137,11 @@
 #if GCC_VERSION < 90100
 #undef __alloc_size__
 #endif
+
+/*
+ * Declare compiler support for __typeof_unqual__() operator.
+ *
+ * Bindgen uses LLVM even if our C compiler is GCC, so we cannot
+ * rely on the auto-detected CONFIG_CC_HAS_TYPEOF_UNQUAL.
+ */
+#define CC_HAS_TYPEOF_UNQUAL (__GNUC__ >= 14)
--- a/include/linux/compiler.h~compilerh-introduce-typeof_unqual-macro
+++ a/include/linux/compiler.h
@@ -210,6 +210,26 @@ void ftrace_likely_update(struct ftrace_
 #define __must_be_cstr(p) \
 	__BUILD_BUG_ON_ZERO_MSG(__annotated(p, nonstring), "must be cstr (NUL-terminated)")
 
+/*
+ * Use __typeof_unqual__() when available.
+ *
+ * XXX: Remove test for __CHECKER__ once
+ * sparse learns about __typeof_unqual__().
+ */
+#if CC_HAS_TYPEOF_UNQUAL && !defined(__CHECKER__)
+# define USE_TYPEOF_UNQUAL 1
+#endif
+
+/*
+ * Define TYPEOF_UNQUAL() to use __typeof_unqual__() as typeof
+ * operator when available, to return an unqualified type of the exp.
+ */
+#if defined(USE_TYPEOF_UNQUAL)
+# define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
+#else
+# define TYPEOF_UNQUAL(exp) __typeof__(exp)
+#endif
+
 #endif /* __KERNEL__ */
 
 /**
_

Patches currently in -mm which might be from ubizjak@gmail.com are


