Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9E02F28FC
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382667; cv=none; b=Tu7T2nRmNV49E3olAfJcKTyMryKWP/LRjNPsAt8EYSz9/u7+uUN1hq7OO1+u/4UJrbmgIgmqrpzUYENaUC0KuOdrLkTVeNF8GUBp2s8XubEQjTLLzHrKdKBfhjHmmMmRvxexms6He5Mzx0yduoz7o48EUWov4FeW97IUKjOWsBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382667; c=relaxed/simple;
	bh=s3uOZ8DOAhMePXYL9L3719vL/FoT3QJ2hcEBK0OrHCs=;
	h=Date:To:From:Subject:Message-Id; b=nGIfvi4H2y9QRe/HhelhAmv+WQT2nnKFxDkgLD/1Ho5IeKoC+A/FHzbwn5E19MFE8rf7/00l9slWCoJXx+ka6gd2vvUZJJhTZ4NTXCbQZgJUkUTS5oDJ/3YvMp/gIbXineV40QBiY8w+IEHcMskm299FX8sA/sL+MpxeFlpw8Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=elWw+sCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="elWw+sCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868E2C4CEF5;
	Wed,  5 Nov 2025 22:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382667;
	bh=s3uOZ8DOAhMePXYL9L3719vL/FoT3QJ2hcEBK0OrHCs=;
	h=Date:To:From:Subject:From;
	b=elWw+sCmgY0kTx4MuCwFJ9VPcdzZxPBgzQSKCxGlRcSGchO1QuiYWZVhOc+4xavyG
	 Gkop8xMKCXir9d54rY1Q4OBhyN445C3+XBqD0bn2QL8m9FkxnwQQbymBnyGNZlPr1p
	 2BasekUY/jRGxgHg5KVuqQRoRZ5/jwGijG/xKreo=
Date: Wed, 05 Nov 2025 14:44:27 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224427.868E2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: mul_u64_u64_div_u64(): optimise multiply on 32bit x86
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86.patch

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
From: David Laight <david.laight.linux@gmail.com>
Subject: lib: mul_u64_u64_div_u64(): optimise multiply on 32bit x86
Date: Wed, 5 Nov 2025 20:10:33 +0000

gcc generates horrid code for both ((u64)u32_a * u32_b) and (u64_a +
u32_b).  As well as the extra instructions it can generate a lot of spills
to stack (including spills of constant zeros and even multiplies by
constant zero).

mul_u32_u32() already exists to optimise the multiply.  Add a similar
add_u64_32() for the addition.  Disable both for clang - it generates
better code without them.

Move the 64x64 => 128 multiply into a static inline helper function for
code clarity.  No need for the a/b_hi/lo variables, the implicit casts on
the function calls do the work for us.  Should have minimal effect on the
generated code.

Use mul_u32_u32() and add_u64_u32() in the 64x64 => 128 multiply in
mul_u64_add_u64_div_u64().

Link: https://lkml.kernel.org/r/20251105201035.64043-8-david.laight.linux@gmail.com
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Reviewed-by: Nicolas Pitre <npitre@baylibre.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/div64.h |   19 +++++++++++++++
 include/linux/math64.h       |   11 +++++++++
 lib/math/div64.c             |   40 +++++++++++++++++++++------------
 3 files changed, 56 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/div64.h~lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86
+++ a/arch/x86/include/asm/div64.h
@@ -60,6 +60,12 @@ static inline u64 div_u64_rem(u64 divide
 }
 #define div_u64_rem	div_u64_rem
 
+/*
+ * gcc tends to zero extend 32bit values and do full 64bit maths.
+ * Define asm functions that avoid this.
+ * (clang generates better code for the C versions.)
+ */
+#ifndef __clang__
 static inline u64 mul_u32_u32(u32 a, u32 b)
 {
 	u32 high, low;
@@ -71,6 +77,19 @@ static inline u64 mul_u32_u32(u32 a, u32
 }
 #define mul_u32_u32 mul_u32_u32
 
+static inline u64 add_u64_u32(u64 a, u32 b)
+{
+	u32 high = a >> 32, low = a;
+
+	asm ("addl %[b], %[low]; adcl $0, %[high]"
+		: [low] "+r" (low), [high] "+r" (high)
+		: [b] "rm" (b) );
+
+	return low | (u64)high << 32;
+}
+#define add_u64_u32 add_u64_u32
+#endif
+
 /*
  * __div64_32() is never called on x86, so prevent the
  * generic definition from getting built.
--- a/include/linux/math64.h~lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86
+++ a/include/linux/math64.h
@@ -158,6 +158,17 @@ static inline u64 mul_u32_u32(u32 a, u32
 }
 #endif
 
+#ifndef add_u64_u32
+/*
+ * Many a GCC version also messes this up.
+ * Zero extending b and then spilling everything to stack.
+ */
+static inline u64 add_u64_u32(u64 a, u32 b)
+{
+	return a + b;
+}
+#endif
+
 #if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
 
 #ifndef mul_u64_u32_shr
--- a/lib/math/div64.c~lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86
+++ a/lib/math/div64.c
@@ -186,33 +186,45 @@ EXPORT_SYMBOL(iter_div_u64_rem);
 #endif
 
 #if !defined(mul_u64_add_u64_div_u64) || defined(test_mul_u64_add_u64_div_u64)
-u64 mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d)
-{
+
+#define mul_add(a, b, c) add_u64_u32(mul_u32_u32(a, b), c)
+
 #if defined(__SIZEOF_INT128__) && !defined(test_mul_u64_add_u64_div_u64)
 
+static inline u64 mul_u64_u64_add_u64(u64 *p_lo, u64 a, u64 b, u64 c)
+{
 	/* native 64x64=128 bits multiplication */
 	u128 prod = (u128)a * b + c;
-	u64 n_lo = prod, n_hi = prod >> 64;
+
+	*p_lo = prod;
+	return prod >> 64;
+}
 
 #else
 
-	/* perform a 64x64=128 bits multiplication manually */
-	u32 a_lo = a, a_hi = a >> 32, b_lo = b, b_hi = b >> 32;
+static inline u64 mul_u64_u64_add_u64(u64 *p_lo, u64 a, u64 b, u64 c)
+{
+	/* perform a 64x64=128 bits multiplication in 32bit chunks */
 	u64 x, y, z;
 
 	/* Since (x-1)(x-1) + 2(x-1) == x.x - 1 two u32 can be added to a u64 */
-	x = (u64)a_lo * b_lo + (u32)c;
-	y = (u64)a_lo * b_hi + (u32)(c >> 32);
-	y += (u32)(x >> 32);
-	z = (u64)a_hi * b_hi + (u32)(y >> 32);
-	y = (u64)a_hi * b_lo + (u32)y;
-	z += (u32)(y >> 32);
-	x = (y << 32) + (u32)x;
-
-	u64 n_lo = x, n_hi = z;
+	x = mul_add(a, b, c);
+	y = mul_add(a, b >> 32, c >> 32);
+	y = add_u64_u32(y, x >> 32);
+	z = mul_add(a >> 32, b >> 32, y >> 32);
+	y = mul_add(a >> 32, b, y);
+	*p_lo = (y << 32) + (u32)x;
+	return add_u64_u32(z, y >> 32);
+}
 
 #endif
 
+u64 mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d)
+{
+	u64 n_lo, n_hi;
+
+	n_hi = mul_u64_u64_add_u64(&n_lo, a, b, c);
+
 	if (!n_hi)
 		return div64_u64(n_lo, d);
 
_

Patches currently in -mm which might be from david.laight.linux@gmail.com are

lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch
lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch
lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch
lib-add-tests-for-mul_u64_u64_div_u64_roundup.patch
lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch
lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86.patch
lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch
lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch

