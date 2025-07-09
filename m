Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C8221766A
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 23:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752103192; cv=none; b=GOvU8/ZUCT25+UTZ0CmWUQX7GxfktdvVkaWfcDrxBpriW16Qkk+7NWtnb5VnCFG4KydFQ9CgDom6ks/ka0pMc8/sy03oaJDQn02LBAucrPt/r0aCMV7D7QD5dec/0KQsOba72g/AhWWqE8DLctp1FMToacNfqR9HRSdGW0Td4l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752103192; c=relaxed/simple;
	bh=zSA7iVQeNzoI32/ZyDdx7QgVaL5jUNAcZIk1nTzqhyM=;
	h=Date:To:From:Subject:Message-Id; b=t1keIifuK08NvvjkG93jMK6yJT6JxxrIHIvI3PHPGcPaXQVo/sfHGOyLwYUb5MtEfxDQfIMUo42T20TQyAJYL/wxOxbW0l7MfSAmSs7+Ow0a1W3co0bfuOk8xYwoW/+qR35MhKgZvWmN1NNr849odCJ2ppUYNlHXo7RRosXnIwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O+BmcTaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O+BmcTaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3103C4CEEF;
	Wed,  9 Jul 2025 23:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752103192;
	bh=zSA7iVQeNzoI32/ZyDdx7QgVaL5jUNAcZIk1nTzqhyM=;
	h=Date:To:From:Subject:From;
	b=O+BmcTaGc94cjyKtg6Eyt7C+rJ5y45DQk/L1LDKY4tXwNmwFmSHwR8gTYBqP3d3W1
	 jdfgA8JW+Tc7Gj+8TU9/Hs54L3zFCFQ8xtx6PYe7Cnb8eBoDl5071rwqNjm+QDZzYk
	 FTtFDOVCnIs6nExYA5EhvyPxfKUB+FxYiOpE61iQ=
Date: Wed, 09 Jul 2025 16:19:51 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch added to mm-nonmm-unstable branch
Message-Id: <20250709231951.E3103C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/math/gcd: use static key to select implementation at runtime
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/math/gcd: use static key to select implementation at runtime
Date: Fri, 6 Jun 2025 21:47:56 +0800

Patch series "Optimize GCD performance on RISC-V by selecting
implementation at runtime", v3.

The current implementation of gcd() selects between the binary GCD and the
odd-even GCD algorithm at compile time, depending on whether
CONFIG_CPU_NO_EFFICIENT_FFS is set.  On platforms like RISC-V, however,
this compile-time decision can be misleading: even when the compiler emits
ctz instructions based on the assumption that they are efficient (as is
the case when CONFIG_RISCV_ISA_ZBB is enabled), the actual hardware may
lack support for the Zbb extension.  In such cases, ffs() falls back to a
software implementation at runtime, making the binary GCD algorithm
significantly slower than the odd-even variant.

To address this, we introduce a static key to allow runtime selection
between the binary and odd-even GCD implementations.  On RISC-V, the
kernel now checks for Zbb support during boot.  If Zbb is unavailable, the
static key is disabled so that gcd() consistently uses the more efficient
odd-even algorithm in that scenario.  Additionally, to further reduce code
size, we select CONFIG_CPU_NO_EFFICIENT_FFS automatically when
CONFIG_RISCV_ISA_ZBB is not enabled, avoiding compilation of the unused
binary GCD implementation entirely on systems where it would never be
executed.

This series ensures that the most efficient GCD algorithm is used in
practice and avoids compiling unnecessary code based on hardware
capabilities and kernel configuration.


This patch (of 3):

On platforms like RISC-V, the compiler may generate hardware FFS
instructions even if the underlying CPU does not actually support them. 
Currently, the GCD implementation is chosen at compile time based on
CONFIG_CPU_NO_EFFICIENT_FFS, which can result in suboptimal behavior on
such systems.

Introduce a static key, efficient_ffs_key, to enable runtime selection
between the binary GCD (using ffs) and the odd-even GCD implementation. 
This allows the kernel to default to the faster binary GCD when FFS is
efficient, while retaining the ability to fall back when needed.

Link: https://lkml.kernel.org/r/20250606134758.1308400-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20250606134758.1308400-2-visitorckw@gmail.com
Co-developed-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gcd.h |    3 +++
 lib/math/gcd.c      |   27 +++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

--- a/include/linux/gcd.h~lib-math-gcd-use-static-key-to-select-implementation-at-runtime
+++ a/include/linux/gcd.h
@@ -3,6 +3,9 @@
 #define _GCD_H
 
 #include <linux/compiler.h>
+#include <linux/jump_label.h>
+
+DECLARE_STATIC_KEY_TRUE(efficient_ffs_key);
 
 unsigned long gcd(unsigned long a, unsigned long b) __attribute_const__;
 
--- a/lib/math/gcd.c~lib-math-gcd-use-static-key-to-select-implementation-at-runtime
+++ a/lib/math/gcd.c
@@ -11,22 +11,16 @@
  * has decent hardware division.
  */
 
+DEFINE_STATIC_KEY_TRUE(efficient_ffs_key);
+
 #if !defined(CONFIG_CPU_NO_EFFICIENT_FFS)
 
 /* If __ffs is available, the even/odd algorithm benchmarks slower. */
 
-/**
- * gcd - calculate and return the greatest common divisor of 2 unsigned longs
- * @a: first value
- * @b: second value
- */
-unsigned long gcd(unsigned long a, unsigned long b)
+static unsigned long binary_gcd(unsigned long a, unsigned long b)
 {
 	unsigned long r = a | b;
 
-	if (!a || !b)
-		return r;
-
 	b >>= __ffs(b);
 	if (b == 1)
 		return r & -r;
@@ -44,9 +38,15 @@ unsigned long gcd(unsigned long a, unsig
 	}
 }
 
-#else
+#endif
 
 /* If normalization is done by loops, the even/odd algorithm is a win. */
+
+/**
+ * gcd - calculate and return the greatest common divisor of 2 unsigned longs
+ * @a: first value
+ * @b: second value
+ */
 unsigned long gcd(unsigned long a, unsigned long b)
 {
 	unsigned long r = a | b;
@@ -54,6 +54,11 @@ unsigned long gcd(unsigned long a, unsig
 	if (!a || !b)
 		return r;
 
+#if !defined(CONFIG_CPU_NO_EFFICIENT_FFS)
+	if (static_branch_likely(&efficient_ffs_key))
+		return binary_gcd(a, b);
+#endif
+
 	/* Isolate lsbit of r */
 	r &= -r;
 
@@ -80,6 +85,4 @@ unsigned long gcd(unsigned long a, unsig
 	}
 }
 
-#endif
-
 EXPORT_SYMBOL_GPL(gcd);
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

