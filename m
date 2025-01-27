Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CB825776
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010750; cv=none; b=CsH3IHmUwKKuofR2hntA1As9cLclWnMoiIyNwVji3s/MFQvSk3GxYVMjNKsI4x0hoflQwYf0gXYRZ6pXGhpfTlrH+28c95UojwhbGK1nNajLQDuuERt/FPhHIEEYYBswFh7BzZb/tV7YQwWA6TA+b8oeQ3ZYimyUMdqQXEFhutI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010750; c=relaxed/simple;
	bh=8RSMgS6ntKK6J2Pp/4piDDS9jTRp5vAVNeCkzBAr4jc=;
	h=Date:To:From:Subject:Message-Id; b=ULKadD3EFwGPdhCbEY+YHHALSgh736/PK0SCufCjOhZJIms2MoG26x5gNcQRqmfjmPTSYe1bNPkwYheDYhgYo45z0iRyAtvCHEbTVox4KkUry+XEPGIqpo3L8w3/clWzGSAAD1Kylbe7p8IqBj8llQtxFraEDjrTkQ2jktQXlFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2tOXa1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2tOXa1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C0EC4CED2;
	Mon, 27 Jan 2025 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738010750;
	bh=8RSMgS6ntKK6J2Pp/4piDDS9jTRp5vAVNeCkzBAr4jc=;
	h=Date:To:From:Subject:From;
	b=K2tOXa1d1NWmp85jXmA+iQVbBz4uIv+UC08baYklrco4c5zJROt5CxFeL23ep8zel
	 eD5XlfI6Ldwer+YOqczYR/a8cN+THp6icqL1pMsPTg1avJGi/arKA85aFZRwQmoMsb
	 TMgf7JUmP6rHz8hioqHR0qe0HuQUtspFTWahwar0=
Date: Mon, 27 Jan 2025 12:45:49 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-introduce-typeof_unqual-macro.patch added to mm-unstable branch
Message-Id: <20250127204550.11C0EC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler.h: introduce TYPEOF_UNQUAL() macro
has been added to the -mm mm-unstable branch.  Its filename is
     compilerh-introduce-typeof_unqual-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compilerh-introduce-typeof_unqual-macro.patch

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
@@ -191,6 +191,26 @@ void ftrace_likely_update(struct ftrace_
 	__v;								\
 })
 
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

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch

