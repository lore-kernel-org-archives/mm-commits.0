Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0636D
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 22:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749336650; cv=none; b=Q3nh5DIB+6R1kBBxW8r6A1xNqDnFSF8KvO7FIA1ui6XJP7yB04IH5WLvVRrvFPdgd3Glf91Oge1ybwiaU1EAit3u3QAURsnB47XbojkDaukRbPfqMBlHErmaI0dHD9+mEPr502jE808CkiHVDo8cbAa+HBTBQAdNMzd180VnRX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749336650; c=relaxed/simple;
	bh=Dcf1PBXKowhQwwJoT97v668zVqXBewkqdGwbL9gSxO8=;
	h=Date:To:From:Subject:Message-Id; b=BKkWWxM7BgJn5Szm7zuGN5TvyWxWeqWqZqf8injiWaVnjHnVJoYKOXRnC5R404Mo8MRY8O73lbOsYdZeZFtRhlf55iRbji3Xz/ipsnIejgAn3qDGQlWPz+TARlvmj680YC+RjX9g4+GeXcpSi1f76Rf0SgWO3A0fiVcUU2j+rcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EDqHpNoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EDqHpNoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C14FC4CEE4;
	Sat,  7 Jun 2025 22:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749336649;
	bh=Dcf1PBXKowhQwwJoT97v668zVqXBewkqdGwbL9gSxO8=;
	h=Date:To:From:Subject:From;
	b=EDqHpNoGXSpTdbhmpKnjKcM8UZryRAkXxUOMFng3Zwly2yAMY4cCDAtwZqVSZKWkj
	 JSBG7LZ21qRkjEuGBNACnmuQynKqyTTDByjJCLsKyysmmGdaJWJZastkDkTuKgW6/m
	 2fejflA/wftmT1WDl3nx2v82X440cgZuvHwGBbdc=
Date: Sat, 07 Jun 2025 15:50:48 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alex@ghiti.fr,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch added to mm-nonmm-unstable branch
Message-Id: <20250607225049.6C14FC4CEE4@smtp.kernel.org>
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
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Yu-Chun Lin <eleanor15x@gmail.com>
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

