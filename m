Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87612F1FE6
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382662; cv=none; b=Uk9vLw/FdPpAVqN5SZP0RWwmIrOIPX9fW5Ilq5OnRpIHf8Lig9vsyrc3vl4xLhPMXy7OlYXbII8ZF3JdnwYin2g7ipL5mjANAwMlfFOMYrMD/81eDEkr+nB0T1/q+WW0s/c8ji4p2hbo+PuuzhpVT+tc8FkTL6To8ElsGJdmd+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382662; c=relaxed/simple;
	bh=cNN5o1OYgmolZ//NayW0rGXilnMn/SNslj1mgY7sBsU=;
	h=Date:To:From:Subject:Message-Id; b=CdXKUZOGmNA90eLY9q86ZKDRCUUgOeK/6UNavBzxWTCZI75HHYEC7owc3XApX4J5j1gqZXWUS+OE8zV1KD1g0hv/rfzT/8IgbDsP2KhvD6Ag04FXJRix6pS3l2QsQuGsEt7jze+I5A8tmsQHQOOciiYXP8r7A4qvbyJWVn7keXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJSJzKXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJSJzKXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C8C4CEF5;
	Wed,  5 Nov 2025 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382662;
	bh=cNN5o1OYgmolZ//NayW0rGXilnMn/SNslj1mgY7sBsU=;
	h=Date:To:From:Subject:From;
	b=WJSJzKXkIL+z90x1PNWox8j8ANBrNztALinO2WmF5FGRcT1bsvM/UDeOXBVWr59Ps
	 sS86Awrp2l6VWViLD3bvJ5Ku481UwL15Ijy0V74JpPb29faEyO64OlQC3+lxhcycoJ
	 wGnqfwQUGfuZGl9H2UXZeZjEy+uRSev6ghteeEfU=
Date: Wed, 05 Nov 2025 14:44:21 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224422.338C8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: mul_u64_u64_div_u64(): simplify check for a 64bit product
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch

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
Subject: lib: mul_u64_u64_div_u64(): simplify check for a 64bit product
Date: Wed, 5 Nov 2025 20:10:29 +0000

If the product is only 64bits div64_u64() can be used for the divide. 
Replace the pre-multiply check (ilog2(a) + ilog2(b) <= 62) with a simple
post-multiply check that the high 64bits are zero.

This has the advantage of being simpler, more accurate and less code.  It
will always be faster when the product is larger than 64bits.

Most 64bit cpu have a native 64x64=128 bit multiply, this is needed (for
the low 64bits) even when div64_u64() is called - so the early check gains
nothing and is just extra code.

32bit cpu will need a compare (etc) to generate the 64bit ilog2() from two
32bit bit scans - so that is non-trivial.  (Never mind the mess of x86's
'bsr' and any oddball cpu without fast bit-scan instructions.) Whereas the
additional instructions for the 128bit multiply result are pretty much one
multiply and two adds (typically the 'adc $0,%reg' can be run in parallel
with the instruction that follows).

The only outliers are 64bit systems without 128bit mutiply and simple in
order 32bit ones with fast bit scan but needing extra instructions to get
the high bits of the multiply result.  I doubt it makes much difference to
either, the latter is definitely not mainstream.

If anyone is worried about the analysis they can look at the generated
code for x86 (especially when cmov isn't used).

Link: https://lkml.kernel.org/r/20251105201035.64043-4-david.laight.linux@gmail.com
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

 lib/math/div64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/math/div64.c~lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product
+++ a/lib/math/div64.c
@@ -186,9 +186,6 @@ EXPORT_SYMBOL(iter_div_u64_rem);
 #ifndef mul_u64_u64_div_u64
 u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 d)
 {
-	if (ilog2(a) + ilog2(b) <= 62)
-		return div64_u64(a * b, d);
-
 #if defined(__SIZEOF_INT128__)
 
 	/* native 64x64=128 bits multiplication */
@@ -212,6 +209,9 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 
 #endif
 
+	if (!n_hi)
+		return div64_u64(n_lo, d);
+
 	if (unlikely(n_hi >= d)) {
 		/* trigger runtime exception if divisor is zero */
 		if (d == 0) {
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

