Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC471EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676265; cv=none; b=f2IUkVlSESvF0zbDleCVEZsdTFVB+60BC3MXqIEKZON8iIOGpKxks+/wJin0kIL43ddX7V4kP6Zl2jfdgbhLZwMrQGTqgr+J/jetI29ab9cv6ODuQsuMOE3zyoc2bU93PSuhmHKWmETpbT/G3sK4jtskP8q+efpjAUVmg4XJQHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676265; c=relaxed/simple;
	bh=tO4XEe38VClGqLui78o9IPJz8sxg/Nl+QZLtNi43fDo=;
	h=Date:To:From:Subject:Message-Id; b=VuA/WScb0I9DgWG3rNeWPW8q1cxRJsvRHtLYJOtgiTs14mB1lAT5Tn5oYLFALjO83GmrSvgj7kgwMEtXdH4wFXdxOWJyhI3KNvhWaPCXc+47AFrfuTnc8chwR+zgVEewyU3yjy3JmvunvblmV6qsRNPa0+RYrjYxHLeKV+v5CO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sz517J8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sz517J8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512C7C4CEF1;
	Thu, 20 Nov 2025 22:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676265;
	bh=tO4XEe38VClGqLui78o9IPJz8sxg/Nl+QZLtNi43fDo=;
	h=Date:To:From:Subject:From;
	b=sz517J8o3ACzVZ/x0lcIgBlKVp8Mfk/UebdwlIs0xRogbyi6qvdMQEH30wJfxaQ6P
	 CjvYpzCVXOAitD497mWGie9uZInZ7He1dv4gCD9tTvO7yWIF2bOr7gArwrWn9WVcwp
	 HD1FtL/jGyUZs/88yIndvcmz5w1Wzc9UA0wZU3Xs=
Date: Thu, 20 Nov 2025 14:04:24 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch removed from -mm tree
Message-Id: <20251120220425.512C7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: mul_u64_u64_div_u64(): simplify check for a 64bit product
has been removed from the -mm tree.  Its filename was
     lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


