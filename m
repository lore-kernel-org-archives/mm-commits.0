Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0045748D
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 03:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734061793; cv=none; b=Yut4Sif5X3E0AjA4038hauteFvUb0TVO0pxC0YNYDoqV+fmJSQHlKpqPFv9jI0Y8dkXBXsIhGhdrTJl55IqS3qQe7nhEP5PNElE/qbGvJZk2Nu/qDmlImHAa2jFMBbtA2eddUKoyqMADtv8GiBKAfGf6KkpXFcrw/LEFFDag+0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734061793; c=relaxed/simple;
	bh=0m5/r3zNz48cl7K0++DC1iaMB0Lvg2wT7ECmJkG0Dqo=;
	h=Date:To:From:Subject:Message-Id; b=W3kM4bH0cEZcYOMopqeMHVvos3f4FJUw2OiL6pDrhAThUhvTvmoK+mYErUbgXc6P8TBsfNIHTjlcd1X898EtXU+je9WQXEu1yyhmJTUPpbbVzg8c/BgtLOevddYZ4F9vbUAoTl/Dob1Iq37R62jUpWGVZ0gOeNu8kAYJzGGg3SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLDenG9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLDenG9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367F4C4CED2;
	Fri, 13 Dec 2024 03:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734061793;
	bh=0m5/r3zNz48cl7K0++DC1iaMB0Lvg2wT7ECmJkG0Dqo=;
	h=Date:To:From:Subject:From;
	b=MLDenG9gEg1ExIVK47O3M52CDahu98s2+p1S5BWbkldXYqx+u2L1J0kMDs175m+kF
	 304FtuDz6uwisJYy+FzMdEqXEfAf6ZvKqvKjiEycISGeVK71lECOlMNjTYEzIgQXyW
	 Zw4zgm66oD4DKlAteKvZiLiEFm40tMkDbs/ICVdE=
Date: Thu, 12 Dec 2024 19:49:52 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-introduce-typeof_unqual-macro.patch added to mm-unstable branch
Message-Id: <20241213034953.367F4C4CED2@smtp.kernel.org>
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
Date: Sun, 8 Dec 2024 21:45:17 +0100

Define TYPEOF_UNQUAL() to use __typeof_unqual__() as typeof operator when
available, to return unqualified type of the expression.

Current version of sparse doesn't know anything about __typeof_unqual__()
operator.  Avoid the usage of __typeof_unqual__() when sparse checking is
active to prevent sparse errors with unknowing keyword.

Link: https://lkml.kernel.org/r/20241208204708.3742696-3-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Nadav Amit <nadav.amit@gmail.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |   13 +++++++++++++
 init/Kconfig             |    3 +++
 2 files changed, 16 insertions(+)

--- a/include/linux/compiler.h~compilerh-introduce-typeof_unqual-macro
+++ a/include/linux/compiler.h
@@ -321,6 +321,19 @@ static inline void *offset_to_ptr(const
  */
 #define prevent_tail_call_optimization()	mb()
 
+/*
+ * Define TYPEOF_UNQUAL() to use __typeof_unqual__() as typeof
+ * operator when available, to return unqualified type of the exp.
+ *
+ * XXX: Remove test for __CHECKER__ once
+ * sparse learns about __typeof_unqual__.
+ */
+#if defined(CONFIG_CC_HAS_TYPEOF_UNQUAL) && !defined(__CHECKER__)
+# define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
+#else
+# define TYPEOF_UNQUAL(exp) __typeof__(exp)
+#endif
+
 #include <asm/rwonce.h>
 
 #endif /* __LINUX_COMPILER_H */
--- a/init/Kconfig~compilerh-introduce-typeof_unqual-macro
+++ a/init/Kconfig
@@ -894,6 +894,9 @@ config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 config CC_HAS_INT128
 	def_bool !$(cc-option,$(m64-flag) -D__SIZEOF_INT128__=0) && 64BIT
 
+config CC_HAS_TYPEOF_UNQUAL
+	def_bool $(success,echo 'int foo (int a) { __typeof_unqual__(a) b = a; return b; }' | $(CC) -x c - -S -o /dev/null)
+
 config CC_IMPLICIT_FALLTHROUGH
 	string
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
_

Patches currently in -mm which might be from ubizjak@gmail.com are

x86-kgdb-use-is_err_pcpu-macro.patch
compilerh-introduce-typeof_unqual-macro.patch
percpu-use-typeof_unqual-in-variable-declarations.patch
percpu-use-typeof_unqual-in-_cpu_ptr-accessors.patch
percpu-repurpose-__percpu-tag-as-a-named-address-space-qualifier.patch
percpu-x86-enable-strict-percpu-checks-via-named-as-qualifiers.patch

