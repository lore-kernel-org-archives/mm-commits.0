Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265213FB7C7
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633771; cv=none; b=ncGr7LP5IJOtGUmAbi6FRv+J3oscq0zvpOZ+AZVgPQIN4NW3osT296ldIKzSEB1kI0z+5cSf/VqeMsC6dJqnDvGFhKuiJJZMsKl9i+eJaBSH1oJEIJAay+Iz6k25xBHJ5NxYvOysPuWJEJhSXmTEyGHJGX/8GG/hdGekZs03MeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633771; c=relaxed/simple;
	bh=Et1f6drNWV4CBCwhTFKqcTKbQmp7H/fKoAiyJk4YKIg=;
	h=Date:To:From:Subject:Message-Id; b=XqTKq7JX2eqwCe05KFAtqQ2WD73NzgBEzWCG5l3LLgCV/vZdgoWGEGZq8nklx6HGfepQJ9oL/+/tF3tJzwopAq7OCYk+YjO6n94LC6a/CeWrFuHZGo1JcuDxgq/nwD7JHwE6LsCUfLSfmTnXjxfV5g//Fys5tiQNQKBreVt/ufE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l70xYejo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l70xYejo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A8C19423;
	Fri, 27 Mar 2026 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633770;
	bh=Et1f6drNWV4CBCwhTFKqcTKbQmp7H/fKoAiyJk4YKIg=;
	h=Date:To:From:Subject:From;
	b=l70xYejoI4jUfECwHMbN9XLdCXmJGJd58phr65mLHXva7pIvU6Wpfzog300eDG8Jb
	 RJR0FNtsjmumuXMyxBcphrwLOXrXfMWGF4eKg/APjoaw2a9Nyb5IWlKVF8WNmHF3fp
	 feadXmcOKjq0HNlo8EpsTVlx/LuBDptDe9EZslog=
Date: Fri, 27 Mar 2026 10:49:30 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + um-xor-cleanup-xorh.patch added to mm-nonmm-unstable branch
Message-Id: <20260327174930.AF4A8C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: um/xor: cleanup xor.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     um-xor-cleanup-xorh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/um-xor-cleanup-xorh.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: um/xor: cleanup xor.h
Date: Fri, 27 Mar 2026 07:16:36 +0100

Since commit c055e3eae0f1 ("crypto: xor - use ktime for template
benchmarking") the benchmarking works just fine even for TT_MODE_INFCPU,
so drop the workarounds.  Note that for CPUs supporting AVX2, which
includes almost everything built in the last 10 years, the AVX2
implementation is forced anyway.

CONFIG_X86_32 is always correctly set for UM in arch/x86/um/Kconfig, so
don't override it either.

Link: https://lkml.kernel.org/r/20260327061704.3707577-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Richard Weinberger <richard@nod.at>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/xor.h |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/arch/um/include/asm/xor.h~um-xor-cleanup-xorh
+++ a/arch/um/include/asm/xor.h
@@ -2,23 +2,7 @@
 #ifndef _ASM_UM_XOR_H
 #define _ASM_UM_XOR_H
 
-#ifdef CONFIG_64BIT
-#undef CONFIG_X86_32
-#define TT_CPU_INF_XOR_DEFAULT (AVX_SELECT(&xor_block_sse_pf64))
-#else
-#define CONFIG_X86_32 1
-#define TT_CPU_INF_XOR_DEFAULT (AVX_SELECT(&xor_block_8regs))
-#endif
-
 #include <asm/cpufeature.h>
 #include <../../x86/include/asm/xor.h>
-#include <linux/time-internal.h>
-
-#ifdef CONFIG_UML_TIME_TRAVEL_SUPPORT
-#undef XOR_SELECT_TEMPLATE
-/* pick an arbitrary one - measuring isn't possible with inf-cpu */
-#define XOR_SELECT_TEMPLATE(x)	\
-	(time_travel_mode == TT_MODE_INFCPU ? TT_CPU_INF_XOR_DEFAULT : x)
-#endif
 
 #endif
_

Patches currently in -mm which might be from hch@lst.de are

xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch
arm-xor-remove-in_interrupt-handling.patch
arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch
um-xor-cleanup-xorh.patch
xor-move-to-lib-raid.patch
xor-small-cleanups.patch
xor-cleanup-registration-and-probing.patch
xor-split-xorh.patch
xor-remove-macro-abuse-for-xor-implementation-registrations.patch
xor-move-generic-implementations-out-of-asm-generic-xorh.patch
alpha-move-the-xor-code-to-lib-raid.patch
arm-move-the-xor-code-to-lib-raid.patch
arm64-move-the-xor-code-to-lib-raid.patch
loongarch-move-the-xor-code-to-lib-raid.patch
powerpc-move-the-xor-code-to-lib-raid.patch
riscv-move-the-xor-code-to-lib-raid.patch
sparc-move-the-xor-code-to-lib-raid.patch
s390-move-the-xor-code-to-lib-raid.patch
x86-move-the-xor-code-to-lib-raid.patch
xor-avoid-indirect-calls-for-arm64-optimized-ops.patch
xor-make-xorko-self-contained-in-lib-raid.patch
xor-add-a-better-public-api.patch
xor-add-a-better-public-api-2.patch
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

