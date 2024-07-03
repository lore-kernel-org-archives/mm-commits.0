Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190C5442C
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 17:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028394; cv=none; b=Kcj53lAj57ldrYMOM9RTrcou41X0uSa1F3ZO3oP+GHoPeOtUrKXYj8cQHuUHFA+eiiyMWv3gk5GIjDhkcFGnKs3w0ttEmgt4/yWrlyDQ5rpolfYKlTLZHo+ZmYSXsiMG72raIZVa4fpsmhmJnehmJ1pJFSVbI5bRMcKoJOYEM4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028394; c=relaxed/simple;
	bh=H1DFqXz2HAQLXXMR3Ukw9lc9hqBOJM+xmmG/5O8wfK0=;
	h=Date:To:From:Subject:Message-Id; b=MPxHMDxV5C/2ALAD4RtuMAyPmWvu0OPh8lUqvqmMqBBzPPAOJeieXRbzsrlFvMF4tVTKkXIqA0US28Il11S8kmMWKbGvFnxxZg3EHv01gzFgWr9Ozj0eOPpUxyjEpEouP5/coIB35n8/t07KJ0YbKUagw+Ch6m2of2jfG/sccyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tuIaufkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tuIaufkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BFCC2BD10;
	Wed,  3 Jul 2024 17:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720028393;
	bh=H1DFqXz2HAQLXXMR3Ukw9lc9hqBOJM+xmmG/5O8wfK0=;
	h=Date:To:From:Subject:From;
	b=tuIaufkQ7iNvmR9yZmXWTlZdgGOqB2nL5Ybgn89FIsmJNf3xpDw6fHz2fk0dKkhSJ
	 FnHa04eBdQ35pRJ2ka6Zr9pjoThEGiH7t7QYqmq0WKbDmq9N85oQYgbKT1E0GyLvNV
	 S1EbNEanf2MAC7s/0dk7kqr3wSCWyoyIDlffGwRI=
Date: Wed, 03 Jul 2024 10:39:52 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,npitre@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mul_u64_u64_div_u64-make-it-precise-always.patch added to mm-nonmm-unstable branch
Message-Id: <20240703173953.85BFCC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mul_u64_u64_div_u64: make it precise always
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mul_u64_u64_div_u64-make-it-precise-always.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mul_u64_u64_div_u64-make-it-precise-always.patch

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
From: Nicolas Pitre <npitre@baylibre.com>
Subject: mul_u64_u64_div_u64: make it precise always
Date: Tue, 2 Jul 2024 23:34:08 -0400

Patch series "mul_u64_u64_div_u64: new implementation", v2.

This provides an implementation for mul_u64_u64_div_u64() that always
produces exact results.


This patch (of 2):

Library facilities must always return exact results.  If the caller may be
contented with approximations then it should do the approximation on its
own.

In this particular case the comment in the code says "the algorithm ... 
below might lose some precision".  Well, if you try it with e.g.:

	a =3D 18446462598732840960
	b =3D 18446462598732840960
	c =3D 18446462598732840961

then the produced answer is 0 whereas the exact answer should be
18446462598732840959.  This is _some_ precision lost indeed!

Let's reimplement this function so it always produces the exact result
regardless of its inputs while preserving existing fast paths when
possible.

Link: https://lkml.kernel.org/r/20240703033552.906852-2-nico@fluxnic.net
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/div64.c |  123 +++++++++++++++++++++++++++++----------------
 1 file changed, 80 insertions(+), 43 deletions(-)

--- a/lib/math/div64.c~mul_u64_u64_div_u64-make-it-precise-always
+++ a/lib/math/div64.c
@@ -186,55 +186,92 @@ EXPORT_SYMBOL(iter_div_u64_rem);
 #ifndef mul_u64_u64_div_u64
 u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 c)
 {
-	u64 res = 0, div, rem;
-	int shift;
+	if (ilog2(a) + ilog2(b) <= 62)
+		return div64_u64(a * b, c);
 
-	/* can a * b overflow ? */
-	if (ilog2(a) + ilog2(b) > 62) {
-		/*
-		 * Note that the algorithm after the if block below might lose
-		 * some precision and the result is more exact for b > a. So
-		 * exchange a and b if a is bigger than b.
-		 *
-		 * For example with a = 43980465100800, b = 100000000, c = 1000000000
-		 * the below calculation doesn't modify b at all because div == 0
-		 * and then shift becomes 45 + 26 - 62 = 9 and so the result
-		 * becomes 4398035251080. However with a and b swapped the exact
-		 * result is calculated (i.e. 4398046510080).
-		 */
-		if (a > b)
-			swap(a, b);
+#if defined(__SIZEOF_INT128__)
+
+	/* native 64x64=128 bits multiplication */
+	u128 prod = (u128)a * b;
+	u64 n_lo = prod, n_hi = prod >> 64;
+
+#else
+
+	/* perform a 64x64=128 bits multiplication manually */
+	union {
+		u64 v;
+		struct {
+#if defined(CONFIG_CPU_LITTLE_ENDIAN)
+			u32 l;
+			u32 h;
+#elif defined(CONFIG_CPU_BIG_ENDIAN)
+			u32 h;
+			u32 l;
+#else
+#error "unknown endianness"
+#endif
+		};
+	} A, B, X, Y, Z;
+
+	A.v = a;
+	B.v = b;
+
+	X.v = (u64)A.l * B.l;
+	Y.v = (u64)A.l * B.h + X.h;
+	Z.v = (u64)A.h * B.h + Y.h;
+	Y.v = (u64)A.h * B.l + Y.l;
+	X.h = Y.l;
+	Z.v += Y.h;
+
+	u64 n_lo = X.v, n_hi = Z.v;
+
+#endif
 
+	int shift = __builtin_ctzll(c);
+
+	/* try reducing the fraction in case the dividend becomes <= 64 bits */
+	if ((n_hi >> shift) == 0) {
+		u64 n = (n_lo >> shift) | (n_hi << (64 - shift));
+
+		return div64_u64(n, c >> shift);
 		/*
-		 * (b * a) / c is equal to
-		 *
-		 *      (b / c) * a +
-		 *      (b % c) * a / c
-		 *
-		 * if nothing overflows. Can the 1st multiplication
-		 * overflow? Yes, but we do not care: this can only
-		 * happen if the end result can't fit in u64 anyway.
-		 *
-		 * So the code below does
-		 *
-		 *      res = (b / c) * a;
-		 *      b = b % c;
+		 * The remainder value if needed would be:
+		 *   res = div64_u64_rem(n, c >> shift, &rem);
+		 *   rem = (rem << shift) + (n_lo - (n << shift));
 		 */
-		div = div64_u64_rem(b, c, &rem);
-		res = div * a;
-		b = rem;
-
-		shift = ilog2(a) + ilog2(b) - 62;
-		if (shift > 0) {
-			/* drop precision */
-			b >>= shift;
-			c >>= shift;
-			if (!c)
-				return res;
-		}
 	}
 
-	return res + div64_u64(a * b, c);
+	if (n_hi >= c) {
+		/* overflow: result is unrepresentable in a u64 */
+		return -1;
+	}
+
+	/* Do the full 128 by 64 bits division */
+
+	shift = __builtin_clzll(c);
+	c <<= shift;
+
+	int p = 64 + shift;
+	u64 res = 0;
+	bool carry;
+
+	do {
+		carry = n_hi >> 63;
+		shift = carry ? 1 : __builtin_clzll(n_hi);
+		if (p < shift)
+			break;
+		p -= shift;
+		n_hi <<= shift;
+		n_hi |= n_lo >> (64 - shift);
+		n_lo <<= shift;
+		if (carry || (n_hi >= c)) {
+			n_hi -= c;
+			res |= 1ULL << p;
+		}
+	} while (n_hi);
+	/* The remainder value if needed would be n_hi << p */
+
+	return res;
 }
 EXPORT_SYMBOL(mul_u64_u64_div_u64);
 #endif
_

Patches currently in -mm which might be from npitre@baylibre.com are

mul_u64_u64_div_u64-make-it-precise-always.patch
mul_u64_u64_div_u64-basic-sanity-test.patch

