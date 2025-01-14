Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E223ED6D
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837074; cv=none; b=Z8uLy5KPuxQ46af+yixcH/RfDu5G6SkDwXb2p49mjmO/ek2fROfr5QmCpbbILxKCzjkfagOQFAfqtMTlxQFeKW1U0ugkYjkhMluN5GPC8cYOhK1j4k0443pwmGfIgzgUugAX36/yhuUpZB+JX3r0ORjnlQrU59PINsnlK4HJ4A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837074; c=relaxed/simple;
	bh=pDCf1JwK15lTXfpDBR5faTj5s0QFiI7GrROqmpkMgNE=;
	h=Date:To:From:Subject:Message-Id; b=LMsv5ziyP60YIXKXpgahr4pRZLD3uUUCnK+thoLQ7kT+orZjtnO865ilu2pRb45GaFJKov5+wv+leH5D+nadFVP1hW5okY0fe1naRUazgEzb1E1dhwbxIrXWgjP6dwrjLffNWhgX+WgThr7XVGPZY6VxZh2dAFc80U3P618irOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dofOf9LM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dofOf9LM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363AC4CEE5;
	Tue, 14 Jan 2025 06:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837074;
	bh=pDCf1JwK15lTXfpDBR5faTj5s0QFiI7GrROqmpkMgNE=;
	h=Date:To:From:Subject:From;
	b=dofOf9LM513H3qJTTaTFWjJKAeuWTewfsQ6pEvk2DnLNm0fh+7U2TEVyV4KV95gEY
	 RO4m996WlhANY/AIqZql9UYpyER/ieERLgdqTDfGgtNrisWmFslFKeGJk8GX8xBOWF
	 ffflK0bhq9xZd0BIhBa/I/ml/EfBfXuK/SOJcZ0c=
Date: Mon, 13 Jan 2025 22:44:34 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,peterz@infradead.org,pabeni@redhat.com,nadav.amit@gmail.com,mingo@kernel.org,luto@kernel.org,longman@redhat.com,kuba@kernel.org,kent.overstreet@linux.dev,hpa@zytor.com,edumazet@google.com,dvlasenk@redhat.com,dennis@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,cl@linux.com,brgerst@gmail.com,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] compilerh-introduce-typeof_unqual-macro.patch removed from -mm tree
Message-Id: <20250114064434.A363AC4CEE5@smtp.kernel.org>
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
@@ -336,6 +336,19 @@ static inline void *offset_to_ptr(const
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


