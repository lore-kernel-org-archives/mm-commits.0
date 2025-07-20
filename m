Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8674C62
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977372; cv=none; b=P5JsRE27WFg2vmvkZrpnmUlzPSVzBf5xtM3DyVzirePPmq4+jv0wMWXhqYc1iSCRBgwtY9kzNOeTBi5amKTwNIPOTQ+bSa3OtGMM3oFNN9xdvt4EBt4MZOz/rPulQn7dr6Ko+e65+07Tf6cq2RnvpnHX7j4ZrUAXzpFBPDzBJ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977372; c=relaxed/simple;
	bh=qHFfXBBpVSAGcuu5iqNUptqgj6uNTQQPCRbAFlwfH4Q=;
	h=Date:To:From:Subject:Message-Id; b=ikwv9jZGOA2h24Kz0ODFPFHBm88sv1jwp/5mrrGBc0UTvExuUdiTlRs271VtI0bY7s4YRbPrjhpyYsNEK9w2VQCWdnelJkucD7poA0AUg5O0aJq5MYyIyUkUbNQ3O2krQocOnMOYP5ucspGUrJsCYEBDGvfVW/LJk5g0IfeGsnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0WrmFSpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0WrmFSpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C28C4CEE3;
	Sun, 20 Jul 2025 02:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977372;
	bh=qHFfXBBpVSAGcuu5iqNUptqgj6uNTQQPCRbAFlwfH4Q=;
	h=Date:To:From:Subject:From;
	b=0WrmFSptW5E9AyLwh0upe8HWLzV2I+xy59C9pqp36sVQkOEcUCIfn0iLzbxicjGBj
	 OVuGZKsn4qWkF4i2ermEY4mMyOEjDjVmlt0qK2xmDL+5RpcqFmW/kHX3yoj2cWwsj2
	 esvS/jk1abRbTGy30yGJcYxcyocA9TyG1C++thNU=
Date: Sat, 19 Jul 2025 19:09:32 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch removed from -mm tree
Message-Id: <20250720020932.92C28C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/math/gcd: use static key to select implementation at runtime
has been removed from the -mm tree.  Its filename was
     lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


