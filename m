Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1452230C35C;
	Sat, 17 Jan 2026 02:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768617895; cv=none; b=akGDIXQpiyZqnOh+x0NqA4E+sLRkS8pwimMavcXE+YNpwSKgshG1SEIci1XmBiS+GqDCwGrNFKMz/ksBZPCKAzSDlylSphaE7Z77QBKKikV78hNUSL0okyPk6zuhyRXM+Gp1UtPE6mSIahzqgcwRTxQjMczzV5m4ngL7nRV//V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768617895; c=relaxed/simple;
	bh=gPjWkW8379/mhEUrTwjImL8/8fy28t/gJimZCEwbmuE=;
	h=Date:To:From:Subject:Message-Id; b=UQPTnTH6RLTOTrf8LlnzVueNnNr+vWpbvZYKbsr7hIKTx51nv1LUBVxMXT5v3tNupgXuvJCek6DvVSXJy0M/NMidWGlk3XXbqz9/CrkZ0iba7Dbp1F/J6zqxUOued9grYVf5d1rSgPVUR+AApLWM0zdppZreeIlQSmLuVLnvBRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tu8rr7jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tu8rr7jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6B8C116C6;
	Sat, 17 Jan 2026 02:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768617894;
	bh=gPjWkW8379/mhEUrTwjImL8/8fy28t/gJimZCEwbmuE=;
	h=Date:To:From:Subject:From;
	b=tu8rr7jlaa4c8F1DdZYPNcZWXZEypXKhCn6RaEsFIYNrQGTLkSpF/bVAkz5yKv9/m
	 OdUJ+JJfKPcfwgZhPnk2dM9fN5+Ds5FkbBElRtVYTyuqbu9W36N/XqkH2ocvVPH80s
	 ACehpoau2oOv/4Wqzr6vJmIqVEgF9I3Pl6G6Clpc=
Date: Fri, 16 Jan 2026 18:44:53 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,stable@vger.kernel.org,morbo@google.com,justinstitt@google.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-clangh-require-llvm-1910-or-higher-for-__typeof_unqual__.patch added to mm-nonmm-unstable branch
Message-Id: <20260117024454.6C6B8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler-clang.h: Require LLVM 19.1.0 or higher for __typeof_unqual__
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler-clangh-require-llvm-1910-or-higher-for-__typeof_unqual__.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-clangh-require-llvm-1910-or-higher-for-__typeof_unqual__.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: compiler-clang.h: Require LLVM 19.1.0 or higher for __typeof_unqual__
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

compiler-clangh-require-llvm-1910-or-higher-for-__typeof_unqual__.patch

