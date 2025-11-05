Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD6D2F28FC
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382669; cv=none; b=LEmiOjVuqMwRanGIijVwVkHqe+dQR7Py0PGTp+pCJZYMFEhON61FqGAw7OaPy2wPN7TsMRl35LOhy9rk4M8RBWV7sjfc1cnejzVLa9uVFo5iCAubc8LndeU8UeCy0a2bRRO8Sp74vdImlvDJOKuP7hnXX5nhtAsrUldSFRN7FfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382669; c=relaxed/simple;
	bh=QPfrcDHJn3sLRy5HVZAbghisSQgRLOa+cubOU6Y8C4A=;
	h=Date:To:From:Subject:Message-Id; b=LkuwfcW3Gx3e3BNXPvr3PRxbVtdku9xVPFivYZgjH1JyKuNmneQ9pZ8VffdfvFy6EOjwC3NHJvfJV0PeDfpL5utzvJxFH9ZohxwbMHo78Br4J/tfMCxQyfj971mBdAE0Pbzs3cFXC0acvrHhWrb7qV01m01UzlqPyhKe/bVDHVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0z/kOvyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0z/kOvyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1152DC4CEF5;
	Wed,  5 Nov 2025 22:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382669;
	bh=QPfrcDHJn3sLRy5HVZAbghisSQgRLOa+cubOU6Y8C4A=;
	h=Date:To:From:Subject:From;
	b=0z/kOvyrq6DuzC52Kf2I/NGDp5XZNhhEQfwOh3umLiULiBcrhqmlnx0iaYkp0Y87A
	 vaHD6a7Xm9fe7vF+MNoOH18z62b26+an9FnT+5FwWC5QiNNAXQFsdkV1m7DithQkJd
	 anDbvEYX7WdMj06q6NR4csHeJIwfSxXOoFT1j6n8=
Date: Wed, 05 Nov 2025 14:44:28 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224429.1152DC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: mul_u64_u64_div_u64(): optimise the divide code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch

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

lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch
lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch
lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch
lib-add-tests-for-mul_u64_u64_div_u64_roundup.patch
lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch
lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86.patch
lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch
lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch

