Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F242EACEF
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382662; cv=none; b=ruXVk+vr33qVSHXL6fEqn95tM7S8Uo3fD1v+qDdXfsF3ZAAfduiF0Ko47g2GmLDuFDnfMl5K5RyHLWKT+08tuqUpmocCw45kZAU0gpllLak0XjN7zvHhBaTbNVDCXi1PbWHZlpVdC0uCiiVva9LubH0xKfJ9YQi3r3aQZndAPQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382662; c=relaxed/simple;
	bh=gI9JOhD3ZS2OVpnEUyrFygTSKn9Jy6e16oblm+8Q3GM=;
	h=Date:To:From:Subject:Message-Id; b=LX3hPJAr83VIYrTJW8sCLed6aZ3TXLOi+nErV5LvARQAlx6wthErRtj4qqlLPMbOx2YzsowAxBLgtcCA+G/OfFK3geXSKChxS1kRDd+knlLGiONLO/kKXFdG90GxkVd1SlnQxk0obrdhLNs7bVzQR6lofOyiKXAYVofa5eI9Qgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=shazglvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="shazglvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1477AC4CEFB;
	Wed,  5 Nov 2025 22:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382661;
	bh=gI9JOhD3ZS2OVpnEUyrFygTSKn9Jy6e16oblm+8Q3GM=;
	h=Date:To:From:Subject:From;
	b=shazglvnbQ3fzYSXCt7/vIVCywHcWdGyUxK+tW8OyW0sTnCxcueXrcwr2ORXTIDBy
	 6AZhl8lHbc8hRS2N7ofjtX8ZdU2clFoZRAU455amB0mgXQarAZG9X9sJGTqi6WLi9Y
	 2WrURTiIYft2VSeMCxytXA3VCZRkZ88hu9FculK8=
Date: Wed, 05 Nov 2025 14:44:20 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224421.1477AC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: mul_u64_u64_div_u64(): combine overflow and divide by zero checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch

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
Subject: lib: mul_u64_u64_div_u64(): combine overflow and divide by zero checks
Date: Wed, 5 Nov 2025 20:10:28 +0000

Since the overflow check always triggers when the divisor is zero
move the check for divide by zero inside the overflow check.
This means there is only one test in the normal path.

Link: https://lkml.kernel.org/r/20251105201035.64043-3-david.laight.linux@gmail.com
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

 lib/math/div64.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/lib/math/div64.c~lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks
+++ a/lib/math/div64.c
@@ -212,12 +212,16 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 
 #endif
 
-	/* make sure d is not zero, trigger runtime exception otherwise */
-	if (unlikely(d == 0)) {
-		unsigned long zero = 0;
-
-		OPTIMIZER_HIDE_VAR(zero);
-		return ~0UL/zero;
+	if (unlikely(n_hi >= d)) {
+		/* trigger runtime exception if divisor is zero */
+		if (d == 0) {
+			unsigned long zero = 0;
+
+			OPTIMIZER_HIDE_VAR(zero);
+			return ~0UL/zero;
+		}
+		/* overflow: result is unrepresentable in a u64 */
+		return ~0ULL;
 	}
 
 	int shift = __builtin_ctzll(d);
@@ -234,11 +238,6 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 		 */
 	}
 
-	if (n_hi >= d) {
-		/* overflow: result is unrepresentable in a u64 */
-		return -1;
-	}
-
 	/* Do the full 128 by 64 bits division */
 
 	shift = __builtin_clzll(d);
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

