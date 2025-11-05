Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5B72EACEF
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382660; cv=none; b=JhaG+iZFqt2mB6EYDFxUDHMkHd92DQImeUDuqli0PGyiSYI0TbSvZ8sI0F+JDGlWNfW76g4PR4/b5O+OMlU26HjcOpEhvN3dGzRKQqOFlc1YKRyP9ZSUoGwFTz25eyG87xP1Fo0pKkZAhhjQRbKQzDxupS4ufPrMuRJt/OSkfAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382660; c=relaxed/simple;
	bh=HJubS61adpihLgbeh4rXAerZp+cOaDVBHjPpmAVyaoA=;
	h=Date:To:From:Subject:Message-Id; b=rW2M4/ioWKNJgjwFClPFv+sjPdHAUwNhfrwvWkib5uQdXA99On1nKWYL4tsMb5KHjQYrpg7eZHJSPxhJ8Suc623gKw/6WEM6OcXEKf1WvMM8wMx54Dlbc3Uf7joSbr2JYKQ91wqnncR4ybIA9wBTo9mqQOQQeKBRZGONOFsLiFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NGCnh7Wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NGCnh7Wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E27C4CEF5;
	Wed,  5 Nov 2025 22:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382659;
	bh=HJubS61adpihLgbeh4rXAerZp+cOaDVBHjPpmAVyaoA=;
	h=Date:To:From:Subject:From;
	b=NGCnh7WnrctIesP9TKYAj91BGyZtv6uTUmXZkNxaWHFLHuQy8tvG3h+jvtBfNVAdJ
	 1iLk3h0stciskF3F9hJgGrOhAlZTOEWBjfT1Yqc/wNzPg6bYBvKmgOOjVsuHoOP13k
	 HKmA4Meie3dLUKXbOA6HbbZE/FAm/fA+IbjJM71w=
Date: Wed, 05 Nov 2025 14:44:19 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224419.D7E27C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: mul_u64_u64_div_u64(): rename parameter 'c' to 'd'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch

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
Subject: lib: mul_u64_u64_div_u64(): rename parameter 'c' to 'd'
Date: Wed, 5 Nov 2025 20:10:27 +0000

Patch series "Implement mul_u64_u64_div_u64_roundup()", v5.

The pwm-stm32.c code wants a 'rounding up' version of
mul_u64_u64_div_u64().  This can be done simply by adding 'divisor - 1' to
the 128bit product.  Implement mul_u64_add_u64_div_u64(a, b, c, d) = (a *
b + c)/d based on the existing code.  Define mul_u64_u64_div_u64(a, b, d)
as mul_u64_add_u64_div_u64(a, b, 0, d) and mul_u64_u64_div_u64_roundup(a,
b, d) as mul_u64_add_u64_div_u64(a, b, d-1, d).

Only x86-64 has an optimsed (asm) version of the function.  That is
optimised to avoid the 'add c' when c is known to be zero.  In all other
cases the extra code will be noise compared to the software divide code.

The test module has been updated to test mul_u64_u64_div_u64_roundup() and
also enhanced it to verify the C division code on x86-64 and the 32bit
division code on 64bit.


This patch (of 9):

Change to prototype from mul_u64_u64_div_u64(u64 a, u64 b, u64 c) to
mul_u64_u64_div_u64(u64 a, u64 b, u64 d).  Using 'd' for 'divisor' makes
more sense.

An upcoming change adds a 'c' parameter to calculate (a * b + c)/d.

Link: https://lkml.kernel.org/r/20251105201035.64043-1-david.laight.linux@gmail.com
Link: https://lkml.kernel.org/r/20251105201035.64043-2-david.laight.linux@gmail.com
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

 lib/math/div64.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/lib/math/div64.c~lib-mul_u64_u64_div_u64-rename-parameter-c-to-d
+++ a/lib/math/div64.c
@@ -184,10 +184,10 @@ u32 iter_div_u64_rem(u64 dividend, u32 d
 EXPORT_SYMBOL(iter_div_u64_rem);
 
 #ifndef mul_u64_u64_div_u64
-u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 c)
+u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 d)
 {
 	if (ilog2(a) + ilog2(b) <= 62)
-		return div64_u64(a * b, c);
+		return div64_u64(a * b, d);
 
 #if defined(__SIZEOF_INT128__)
 
@@ -212,37 +212,37 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 
 #endif
 
-	/* make sure c is not zero, trigger runtime exception otherwise */
-	if (unlikely(c == 0)) {
+	/* make sure d is not zero, trigger runtime exception otherwise */
+	if (unlikely(d == 0)) {
 		unsigned long zero = 0;
 
 		OPTIMIZER_HIDE_VAR(zero);
 		return ~0UL/zero;
 	}
 
-	int shift = __builtin_ctzll(c);
+	int shift = __builtin_ctzll(d);
 
 	/* try reducing the fraction in case the dividend becomes <= 64 bits */
 	if ((n_hi >> shift) == 0) {
 		u64 n = shift ? (n_lo >> shift) | (n_hi << (64 - shift)) : n_lo;
 
-		return div64_u64(n, c >> shift);
+		return div64_u64(n, d >> shift);
 		/*
 		 * The remainder value if needed would be:
-		 *   res = div64_u64_rem(n, c >> shift, &rem);
+		 *   res = div64_u64_rem(n, d >> shift, &rem);
 		 *   rem = (rem << shift) + (n_lo - (n << shift));
 		 */
 	}
 
-	if (n_hi >= c) {
+	if (n_hi >= d) {
 		/* overflow: result is unrepresentable in a u64 */
 		return -1;
 	}
 
 	/* Do the full 128 by 64 bits division */
 
-	shift = __builtin_clzll(c);
-	c <<= shift;
+	shift = __builtin_clzll(d);
+	d <<= shift;
 
 	int p = 64 + shift;
 	u64 res = 0;
@@ -257,8 +257,8 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 		n_hi <<= shift;
 		n_hi |= n_lo >> (64 - shift);
 		n_lo <<= shift;
-		if (carry || (n_hi >= c)) {
-			n_hi -= c;
+		if (carry || (n_hi >= d)) {
+			n_hi -= d;
 			res |= 1ULL << p;
 		}
 	} while (n_hi);
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

