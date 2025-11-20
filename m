Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B068B1EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676264; cv=none; b=LjMKvKroD5CiGd6MeBiepF//QWKunR2bavDvpd9zD+cn5QNUuNVPdZL25wLuBDynR2sfu5vyr9JyAFBbWMZ4Ydqn/p0jwHOP1tnxNERKUF9bg1SdEtE+jCvX91z11/2fkm7/5QU6oLKcRFllgwsA89ok3WeqzO1NkG0/Rd+3Ndo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676264; c=relaxed/simple;
	bh=8d1baK3/U3Qzp3mMpbcSWgNrRgAdUf8LlTq6m7BQvZs=;
	h=Date:To:From:Subject:Message-Id; b=q8xTeVAgq76/NEpS0GQjX/RGMugGZd+rFDw1SdAc6Li477jnJArbxKXl3NV7epa0ba1Pszg/vPbkvnpGsgj7IDEu36BZiaNcIEqtohf4s4oRaX5dlWqNcH+KF1JsrxBJd/xjBpQq2e8CUsfuDCOnKjW/oz/lPUbxh8fXeWPnS9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L1WFf1ut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L1WFf1ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3394FC4CEF1;
	Thu, 20 Nov 2025 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676264;
	bh=8d1baK3/U3Qzp3mMpbcSWgNrRgAdUf8LlTq6m7BQvZs=;
	h=Date:To:From:Subject:From;
	b=L1WFf1utq0yOzLFK4u6h0sbRtvl42Y41SpCtRyFU6jCb69sBYrfXkFyc2ZBT9Qrey
	 J09n8y3UK/1rHOzpSPNZ/7K5HzYoQlwD4PyaVr8xzSlHPsQpHwIPT28UlxkF0Tg0tG
	 RokEtNWGtT4VF2hymEipbdnut9mI+Il6lsuLYEXY=
Date: Thu, 20 Nov 2025 14:04:23 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch removed from -mm tree
Message-Id: <20251120220424.3394FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: mul_u64_u64_div_u64(): combine overflow and divide by zero checks
has been removed from the -mm tree.  Its filename was
     lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


