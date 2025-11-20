Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695E1EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676263; cv=none; b=YMoTnFC2OJLrWTaBHGIBCz8IFS3sIwTO4sNv6WaNjCrddzAE/rzOebyy3TwObAHfoc8prQ8kZ7tjKMoznuDPzE7k7HyqDoJYjvTU9RoqDGrJ/ipMffjKwaej0dNH2wQ2oyKodsGJQG5aLYYlhY/Hi5iPRm2ftV2k8L2xxHUCH5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676263; c=relaxed/simple;
	bh=wDbjr824MpxvVWNUVtyT1M8tUoeIwZfhBc5A89uTSVA=;
	h=Date:To:From:Subject:Message-Id; b=k6+R3hSnsPujpU9GGYmI1RmShHYQAxsMGajQ3i/Wd0Dn5PrYlR7MaCc4vsR910XdrGTHWdJckb795UwvBW6U9/WpjFQZaes1I1IjKUZsqVi9WCGHyuS2H4deLHjsadWS+9G/qVd8fmnyfkU/7C1PL18ooHim/jmN43CLj0R8P/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yiVevXhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yiVevXhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186DBC4CEF1;
	Thu, 20 Nov 2025 22:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676263;
	bh=wDbjr824MpxvVWNUVtyT1M8tUoeIwZfhBc5A89uTSVA=;
	h=Date:To:From:Subject:From;
	b=yiVevXhAl3mzoCDlbDJFs4smfh82ULIlSs6bz+xBcwGZbflGTuoOKSNvd6tmPuV+a
	 wRd0eX/ZpubqjhdPkzYTS6bl1AjOjWPMs38PzQn4IS25iD4qRxohT58REwNLTbborD
	 22TCiVPXbDUxwwcJbccD95xd+G9UQCBOYtSIoC9M=
Date: Thu, 20 Nov 2025 14:04:22 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch removed from -mm tree
Message-Id: <20251120220423.186DBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: mul_u64_u64_div_u64(): rename parameter 'c' to 'd'
has been removed from the -mm tree.  Its filename was
     lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


