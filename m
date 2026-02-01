Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28D73EBF1D;
	Sun,  1 Feb 2026 00:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905006; cv=none; b=KHGaUSeE67dq45Yqi80EZdPp8dCPhEliaIvhnWHZwtW/uWLThne+ebBnAdiORey1pa+KNUWmlEKuYJxltoNPkonPCaJjntYUVXbuQvRkjXrYoRXdzQ9Xk9213BwnTfLIz/f063LyQetUFho6AK1fZ/oLZ79a3Zw+Tcoq4rYe7Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905006; c=relaxed/simple;
	bh=RLzHHZizplOr80+cGQElSRYkOI/ePm4eYRnerU6DYPQ=;
	h=Date:To:From:Subject:Message-Id; b=hn7USriCOGLhzs22qGrMGSX+wpVGlL7dM5kFk9w+EssJhVIEX6X9XrVBHHqlM0BqXKJ436FFn5I+GJo7t31qjWsBtdS4CmVnkDI8+nzM9C2m+jaZnBfyBQ4XojM7pyDP4HTOoSCYB7ROswFFQF4/ftFiXfOmWWTc9EquOVpXkIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+vo6uK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+vo6uK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A24C4CEF1;
	Sun,  1 Feb 2026 00:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905005;
	bh=RLzHHZizplOr80+cGQElSRYkOI/ePm4eYRnerU6DYPQ=;
	h=Date:To:From:Subject:From;
	b=k+vo6uK4JQASjEWd4uaCdrlEB/iB+N+khmQbU37pbS7mBcVrRSzUAjkcZBuQ4gfxa
	 VgQkrjBbmOQkYDGdNWx9uJWydLl2QySarPdU+dJuyaGP5nH2U3T9gBkgGzCRelNWDq
	 ZKn4XOxlJq+cVYmsjSqSP6IPAQwHx/c778LapglY=
Date: Sat, 31 Jan 2026 16:16:45 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,stable@vger.kernel.org,morbo@google.com,justinstitt@google.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compiler-clangh-require-llvm-1910-or-higher-for-__typeof_unqual__.patch removed from -mm tree
Message-Id: <20260201001645.92A24C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler-clang.h: require LLVM 19.1.0 or higher for __typeof_unqual__
has been removed from the -mm tree.  Its filename was
     compiler-clangh-require-llvm-1910-or-higher-for-__typeof_unqual__.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: compiler-clang.h: require LLVM 19.1.0 or higher for __typeof_unqual__
Date: Fri, 16 Jan 2026 16:26:27 -0700

When building the kernel using a version of LLVM between llvmorg-19-init
(the first commit of the LLVM 19 development cycle) and the change in
LLVM that actually added __typeof_unqual__ for all C modes [1], which
might happen during a bisect of LLVM, there is a build failure:

  In file included from arch/x86/kernel/asm-offsets.c:9:
  In file included from include/linux/crypto.h:15:
  In file included from include/linux/completion.h:12:
  In file included from include/linux/swait.h:7:
  In file included from include/linux/spinlock.h:56:
  In file included from include/linux/preempt.h:79:
  arch/x86/include/asm/preempt.h:61:2: error: call to undeclared function '__typeof_unqual__'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     61 |         raw_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
        |         ^
  arch/x86/include/asm/percpu.h:478:36: note: expanded from macro 'raw_cpu_and_4'
    478 | #define raw_cpu_and_4(pcp, val)                         percpu_binary_op(4, , "and", (pcp), val)
        |                                                         ^
  arch/x86/include/asm/percpu.h:210:3: note: expanded from macro 'percpu_binary_op'
    210 |                 TYPEOF_UNQUAL(_var) pto_tmp__;                          \
        |                 ^
  include/linux/compiler.h:248:29: note: expanded from macro 'TYPEOF_UNQUAL'
    248 | # define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
        |                             ^

The current logic of CC_HAS_TYPEOF_UNQUAL just checks for a major
version of 19 but half of the 19 development cycle did not have support
for __typeof_unqual__.

Harden the logic of CC_HAS_TYPEOF_UNQUAL to avoid this error by only
using __typeof_unqual__ with a released version of LLVM 19, which is
greater than or equal to 19.1.0 with LLVM's versioning scheme that
matches GCC's [2].

Link: https://github.com/llvm/llvm-project/commit/cc308f60d41744b5920ec2e2e5b25e1273c8704b [1]
Link: https://github.com/llvm/llvm-project/commit/4532617ae420056bf32f6403dde07fb99d276a49 [2]
Link: https://lkml.kernel.org/r/20260116-require-llvm-19-1-for-typeof_unqual-v1-1-3b9a4a4b212b@kernel.org
Fixes: ac053946f5c4 ("compiler.h: introduce TYPEOF_UNQUAL() macro")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler-clang.h~compiler-clangh-require-llvm-1910-or-higher-for-__typeof_unqual__
+++ a/include/linux/compiler-clang.h
@@ -153,4 +153,4 @@
  * Bindgen uses LLVM even if our C compiler is GCC, so we cannot
  * rely on the auto-detected CONFIG_CC_HAS_TYPEOF_UNQUAL.
  */
-#define CC_HAS_TYPEOF_UNQUAL (__clang_major__ >= 19)
+#define CC_HAS_TYPEOF_UNQUAL (__clang_major__ > 19 || (__clang_major__ == 19 && __clang_minor__ > 0))
_

Patches currently in -mm which might be from nathan@kernel.org are


