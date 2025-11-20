Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826971EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676271; cv=none; b=jQ0Bjsrsz42kRujRjGg+f8kAznDq+0z1Gh+nMNdx1OWKxxx+ey7bDiUBPwqhYCXHc9yCqEVoGtBCcz5t83nRpOrbK6VH5tJX8PKOmIw9fHdihLn1w3MnvEZGDquJ9gTGuDKgOVIc27NSNaQK/BloXCmGA4MFFPgB4kRTyRGxK7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676271; c=relaxed/simple;
	bh=FjbclY5nAMxk20SFI2YghjuZswtYcf6FgNvposanO/0=;
	h=Date:To:From:Subject:Message-Id; b=HOgriaPFb//nlYkmKAbnf7R1Mkmx75W/etVKk5tlzUg0Y/lblxg5gLT74kCyTUSiCfAhjsU8kumZ/aKlqCEMy5mK4P7JI7cmZ54Nt3ei884LBDCkVaP73+K5G4zBWShwjyxDSY04zBiHkmyZanWqxVObXte05BybF+Ff/Eq3b6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kB90k4C7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kB90k4C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9F0C116B1;
	Thu, 20 Nov 2025 22:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676271;
	bh=FjbclY5nAMxk20SFI2YghjuZswtYcf6FgNvposanO/0=;
	h=Date:To:From:Subject:From;
	b=kB90k4C72j4NXCsBAUsbA6vcGuRycc+9Li6nyznvDPnG+ElqizOGA50PjPI8xIiJb
	 o9c7E56AM8JDGyaWW+sYfXvyM+2zszuZQjQizHXig39A50lUgom/Iak6Y+Q+YRuaDy
	 9HvqHm9sjUUaMwB3TAybktX585BIOO7pdl/Uyobk=
Date: Thu, 20 Nov 2025 14:04:30 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch removed from -mm tree
Message-Id: <20251120220431.1B9F0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: mul_u64_u64_div_u64(): optimise the divide code
has been removed from the -mm tree.  Its filename was
     lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <david.laight.linux@gmail.com>
Subject: lib: mul_u64_u64_div_u64(): optimise the divide code
Date: Wed, 5 Nov 2025 20:10:34 +0000

Replace the bit by bit algorithm with one that generates 16 bits per
iteration on 32bit architectures and 32 bits on 64bit ones.

On my zen 5 this reduces the time for the tests (using the generic code)
from ~3350ns to ~1000ns.

Running the 32bit algorithm on 64bit x86 takes ~1500ns.  It'll be slightly
slower on a real 32bit system, mostly due to register pressure.

The savings for 32bit x86 are much higher (tested in userspace).  The
worst case (lots of bits in the quotient) drops from ~900 clocks to ~130
(pretty much independant of the arguments).  Other 32bit architectures may
see better savings.

It is possibly to optimise for divisors that span less than
__LONG_WIDTH__/2 bits.  However I suspect they don't happen that often and
it doesn't remove any slow cpu divide instructions which dominate the
result.

Typical improvements for 64bit random divides:
               old     new
sandy bridge:  470     150
haswell:       400     144
piledriver:    960     467   I think rdpmc is very slow.
zen5:          244      80
(Timing is 'rdpmc; mul_div(); rdpmc' with the multiply depending on the
first rdpmc and the second rdpmc depending on the quotient.)

Object code (64bit x86 test program): old 0x173 new 0x141.

Link: https://lkml.kernel.org/r/20251105201035.64043-9-david.laight.linux@gmail.com
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

 lib/math/div64.c |  124 ++++++++++++++++++++++++++++++---------------
 1 file changed, 85 insertions(+), 39 deletions(-)

--- a/lib/math/div64.c~lib-mul_u64_u64_div_u64-optimise-the-divide-code
+++ a/lib/math/div64.c
@@ -190,7 +190,6 @@ EXPORT_SYMBOL(iter_div_u64_rem);
 #define mul_add(a, b, c) add_u64_u32(mul_u32_u32(a, b), c)
 
 #if defined(__SIZEOF_INT128__) && !defined(test_mul_u64_add_u64_div_u64)
-
 static inline u64 mul_u64_u64_add_u64(u64 *p_lo, u64 a, u64 b, u64 c)
 {
 	/* native 64x64=128 bits multiplication */
@@ -199,9 +198,7 @@ static inline u64 mul_u64_u64_add_u64(u6
 	*p_lo = prod;
 	return prod >> 64;
 }
-
 #else
-
 static inline u64 mul_u64_u64_add_u64(u64 *p_lo, u64 a, u64 b, u64 c)
 {
 	/* perform a 64x64=128 bits multiplication in 32bit chunks */
@@ -216,12 +213,37 @@ static inline u64 mul_u64_u64_add_u64(u6
 	*p_lo = (y << 32) + (u32)x;
 	return add_u64_u32(z, y >> 32);
 }
+#endif
 
+#ifndef BITS_PER_ITER
+#define BITS_PER_ITER (__LONG_WIDTH__ >= 64 ? 32 : 16)
+#endif
+
+#if BITS_PER_ITER == 32
+#define mul_u64_long_add_u64(p_lo, a, b, c) mul_u64_u64_add_u64(p_lo, a, b, c)
+#define add_u64_long(a, b) ((a) + (b))
+#else
+#undef BITS_PER_ITER
+#define BITS_PER_ITER 16
+static inline u32 mul_u64_long_add_u64(u64 *p_lo, u64 a, u32 b, u64 c)
+{
+	u64 n_lo = mul_add(a, b, c);
+	u64 n_med = mul_add(a >> 32, b, c >> 32);
+
+	n_med = add_u64_u32(n_med, n_lo >> 32);
+	*p_lo = n_med << 32 | (u32)n_lo;
+	return n_med >> 32;
+}
+
+#define add_u64_long(a, b) add_u64_u32(a, b)
 #endif
 
 u64 mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d)
 {
-	u64 n_lo, n_hi;
+	unsigned long d_msig, q_digit;
+	unsigned int reps, d_z_hi;
+	u64 quotient, n_lo, n_hi;
+	u32 overflow;
 
 	n_hi = mul_u64_u64_add_u64(&n_lo, a, b, c);
 
@@ -240,46 +262,70 @@ u64 mul_u64_add_u64_div_u64(u64 a, u64 b
 		return ~0ULL;
 	}
 
-	int shift = __builtin_ctzll(d);
-
-	/* try reducing the fraction in case the dividend becomes <= 64 bits */
-	if ((n_hi >> shift) == 0) {
-		u64 n = shift ? (n_lo >> shift) | (n_hi << (64 - shift)) : n_lo;
-
-		return div64_u64(n, d >> shift);
-		/*
-		 * The remainder value if needed would be:
-		 *   res = div64_u64_rem(n, d >> shift, &rem);
-		 *   rem = (rem << shift) + (n_lo - (n << shift));
-		 */
+	/* Left align the divisor, shifting the dividend to match */
+	d_z_hi = __builtin_clzll(d);
+	if (d_z_hi) {
+		d <<= d_z_hi;
+		n_hi = n_hi << d_z_hi | n_lo >> (64 - d_z_hi);
+		n_lo <<= d_z_hi;
 	}
 
-	/* Do the full 128 by 64 bits division */
-
-	shift = __builtin_clzll(d);
-	d <<= shift;
+	reps = 64 / BITS_PER_ITER;
+	/* Optimise loop count for small dividends */
+	if (!(u32)(n_hi >> 32)) {
+		reps -= 32 / BITS_PER_ITER;
+		n_hi = n_hi << 32 | n_lo >> 32;
+		n_lo <<= 32;
+	}
+#if BITS_PER_ITER == 16
+	if (!(u32)(n_hi >> 48)) {
+		reps--;
+		n_hi = add_u64_u32(n_hi << 16, n_lo >> 48);
+		n_lo <<= 16;
+	}
+#endif
 
-	int p = 64 + shift;
-	u64 res = 0;
-	bool carry;
-
-	do {
-		carry = n_hi >> 63;
-		shift = carry ? 1 : __builtin_clzll(n_hi);
-		if (p < shift)
-			break;
-		p -= shift;
-		n_hi <<= shift;
-		n_hi |= n_lo >> (64 - shift);
-		n_lo <<= shift;
-		if (carry || (n_hi >= d)) {
-			n_hi -= d;
-			res |= 1ULL << p;
+	/* Invert the dividend so we can use add instead of subtract. */
+	n_lo = ~n_lo;
+	n_hi = ~n_hi;
+
+	/*
+	 * Get the most significant BITS_PER_ITER bits of the divisor.
+	 * This is used to get a low 'guestimate' of the quotient digit.
+	 */
+	d_msig = (d >> (64 - BITS_PER_ITER)) + 1;
+
+	/*
+	 * Now do a 'long division' with BITS_PER_ITER bit 'digits'.
+	 * The 'guess' quotient digit can be low and BITS_PER_ITER+1 bits.
+	 * The worst case is dividing ~0 by 0x8000 which requires two subtracts.
+	 */
+	quotient = 0;
+	while (reps--) {
+		q_digit = (unsigned long)(~n_hi >> (64 - 2 * BITS_PER_ITER)) / d_msig;
+		/* Shift 'n' left to align with the product q_digit * d */
+		overflow = n_hi >> (64 - BITS_PER_ITER);
+		n_hi = add_u64_u32(n_hi << BITS_PER_ITER, n_lo >> (64 - BITS_PER_ITER));
+		n_lo <<= BITS_PER_ITER;
+		/* Add product to negated divisor */
+		overflow += mul_u64_long_add_u64(&n_hi, d, q_digit, n_hi);
+		/* Adjust for the q_digit 'guestimate' being low */
+		while (overflow < 0xffffffff >> (32 - BITS_PER_ITER)) {
+			q_digit++;
+			n_hi += d;
+			overflow += n_hi < d;
 		}
-	} while (n_hi);
-	/* The remainder value if needed would be n_hi << p */
+		quotient = add_u64_long(quotient << BITS_PER_ITER, q_digit);
+	}
 
-	return res;
+	/*
+	 * The above only ensures the remainder doesn't overflow,
+	 * it can still be possible to add (aka subtract) another copy
+	 * of the divisor.
+	 */
+	if ((n_hi + d) > n_hi)
+		quotient++;
+	return quotient;
 }
 #if !defined(test_mul_u64_add_u64_div_u64)
 EXPORT_SYMBOL(mul_u64_add_u64_div_u64);
_

Patches currently in -mm which might be from david.laight.linux@gmail.com are


