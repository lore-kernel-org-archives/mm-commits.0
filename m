Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D4C1EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676267; cv=none; b=M60OnbHgOCLFu/5PQoWRtJflpWLg5glLRV2pfYPD0cJIbSDS1lzLffWbk3ueDdUnzihTdARCnfSvcWBBPwTO9Q0EWK5YS16Kr/bwFR0LePHepXDFBDo7AwXxZwNE5PiIIEDP+ccbJ2HCOwy39SCPeVjrzOUnY9OO3UK6CWzDPh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676267; c=relaxed/simple;
	bh=3IKoZE8Oq+CLVbJVZZpmW46FMVqb9OfCqbJB4ZtUeY0=;
	h=Date:To:From:Subject:Message-Id; b=dfOQTXBy5oLxwQwV56KzS1s3XfdnbWCbbKQxn21fy6gnrCUkRQntlhD1jNyls9azoIuMJ/raCgy9/Wkv8WB74WbO5x3VwzNn49i4aADwDRkJVUutWX4JPlvLMasvwKB7Qr2FLDLEezCZyqGMrRnrRoGJh++JHzGvmmhuctED3VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LYJQ1vUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LYJQ1vUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F57AC4CEF1;
	Thu, 20 Nov 2025 22:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676266;
	bh=3IKoZE8Oq+CLVbJVZZpmW46FMVqb9OfCqbJB4ZtUeY0=;
	h=Date:To:From:Subject:From;
	b=LYJQ1vUtCjI658KqOLTnWN13pPq7n97DAhY23buALoSSY/CsSvdqr3DeDZKPu8WVx
	 2Q+GuJLi654WoZdOF/m5n2gJMvK8Pi/kLubecHH0xFPpWvR5X7WLHv7D9Gb9z02/zv
	 BX1PHpYOEXMgObfkB43VCeIxSfWqyP//d8evWHGE=
Date: Thu, 20 Nov 2025 14:04:25 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch removed from -mm tree
Message-Id: <20251120220426.7F57AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add mul_u64_add_u64_div_u64() and mul_u64_u64_div_u64_roundup()
has been removed from the -mm tree.  Its filename was
     lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <david.laight.linux@gmail.com>
Subject: lib: add mul_u64_add_u64_div_u64() and mul_u64_u64_div_u64_roundup()
Date: Wed, 5 Nov 2025 20:10:30 +0000

The existing mul_u64_u64_div_u64() rounds down, a 'rounding up' variant
needs 'divisor - 1' adding in between the multiply and divide so cannot
easily be done by a caller.

Add mul_u64_add_u64_div_u64(a, b, c, d) that calculates (a * b + c)/d and
implement the 'round down' and 'round up' using it.

Update the x86-64 asm to optimise for 'c' being a constant zero.

Add kerndoc definitions for all three functions.

Link: https://lkml.kernel.org/r/20251105201035.64043-5-david.laight.linux@gmail.com
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

 arch/x86/include/asm/div64.h |   20 ++++++++-----
 include/linux/math64.h       |   48 ++++++++++++++++++++++++++++++++-
 lib/math/div64.c             |   14 +++++----
 3 files changed, 67 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/div64.h~lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup
+++ a/arch/x86/include/asm/div64.h
@@ -84,21 +84,25 @@ static inline u64 mul_u32_u32(u32 a, u32
  * Will generate an #DE when the result doesn't fit u64, could fix with an
  * __ex_table[] entry when it becomes an issue.
  */
-static inline u64 mul_u64_u64_div_u64(u64 a, u64 mul, u64 div)
+static inline u64 mul_u64_add_u64_div_u64(u64 rax, u64 mul, u64 add, u64 div)
 {
-	u64 q;
+	u64 rdx;
 
-	asm ("mulq %2; divq %3" : "=a" (q)
-				: "a" (a), "rm" (mul), "rm" (div)
-				: "rdx");
+	asm ("mulq %[mul]" : "+a" (rax), "=d" (rdx) : [mul] "rm" (mul));
 
-	return q;
+	if (!statically_true(!add))
+		asm ("addq %[add], %[lo]; adcq $0, %[hi]" :
+			[lo] "+r" (rax), [hi] "+r" (rdx) : [add] "irm" (add));
+
+	asm ("divq %[div]" : "+a" (rax), "+d" (rdx) : [div] "rm" (div));
+
+	return rax;
 }
-#define mul_u64_u64_div_u64 mul_u64_u64_div_u64
+#define mul_u64_add_u64_div_u64 mul_u64_add_u64_div_u64
 
 static inline u64 mul_u64_u32_div(u64 a, u32 mul, u32 div)
 {
-	return mul_u64_u64_div_u64(a, mul, div);
+	return mul_u64_add_u64_div_u64(a, mul, 0, div);
 }
 #define mul_u64_u32_div	mul_u64_u32_div
 
--- a/include/linux/math64.h~lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup
+++ a/include/linux/math64.h
@@ -282,7 +282,53 @@ static inline u64 mul_u64_u32_div(u64 a,
 }
 #endif /* mul_u64_u32_div */
 
-u64 mul_u64_u64_div_u64(u64 a, u64 mul, u64 div);
+/**
+ * mul_u64_add_u64_div_u64 - unsigned 64bit multiply, add, and divide
+ * @a: first unsigned 64bit multiplicand
+ * @b: second unsigned 64bit multiplicand
+ * @c: unsigned 64bit addend
+ * @d: unsigned 64bit divisor
+ *
+ * Multiply two 64bit values together to generate a 128bit product
+ * add a third value and then divide by a fourth.
+ * The Generic code divides by 0 if @d is zero and returns ~0 on overflow.
+ * Architecture specific code may trap on zero or overflow.
+ *
+ * Return: (@a * @b + @c) / @d
+ */
+u64 mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d);
+
+/**
+ * mul_u64_u64_div_u64 - unsigned 64bit multiply and divide
+ * @a: first unsigned 64bit multiplicand
+ * @b: second unsigned 64bit multiplicand
+ * @d: unsigned 64bit divisor
+ *
+ * Multiply two 64bit values together to generate a 128bit product
+ * and then divide by a third value.
+ * The Generic code divides by 0 if @d is zero and returns ~0 on overflow.
+ * Architecture specific code may trap on zero or overflow.
+ *
+ * Return: @a * @b / @d
+ */
+#define mul_u64_u64_div_u64(a, b, d) mul_u64_add_u64_div_u64(a, b, 0, d)
+
+/**
+ * mul_u64_u64_div_u64_roundup - unsigned 64bit multiply and divide rounded up
+ * @a: first unsigned 64bit multiplicand
+ * @b: second unsigned 64bit multiplicand
+ * @d: unsigned 64bit divisor
+ *
+ * Multiply two 64bit values together to generate a 128bit product
+ * and then divide and round up.
+ * The Generic code divides by 0 if @d is zero and returns ~0 on overflow.
+ * Architecture specific code may trap on zero or overflow.
+ *
+ * Return: (@a * @b + @d - 1) / @d
+ */
+#define mul_u64_u64_div_u64_roundup(a, b, d) \
+	({ u64 _tmp = (d); mul_u64_add_u64_div_u64(a, b, _tmp - 1, _tmp); })
+
 
 /**
  * DIV64_U64_ROUND_UP - unsigned 64bit divide with 64bit divisor rounded up
--- a/lib/math/div64.c~lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup
+++ a/lib/math/div64.c
@@ -183,13 +183,13 @@ u32 iter_div_u64_rem(u64 dividend, u32 d
 }
 EXPORT_SYMBOL(iter_div_u64_rem);
 
-#ifndef mul_u64_u64_div_u64
-u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 d)
+#ifndef mul_u64_add_u64_div_u64
+u64 mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d)
 {
 #if defined(__SIZEOF_INT128__)
 
 	/* native 64x64=128 bits multiplication */
-	u128 prod = (u128)a * b;
+	u128 prod = (u128)a * b + c;
 	u64 n_lo = prod, n_hi = prod >> 64;
 
 #else
@@ -198,8 +198,10 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 	u32 a_lo = a, a_hi = a >> 32, b_lo = b, b_hi = b >> 32;
 	u64 x, y, z;
 
-	x = (u64)a_lo * b_lo;
-	y = (u64)a_lo * b_hi + (u32)(x >> 32);
+	/* Since (x-1)(x-1) + 2(x-1) == x.x - 1 two u32 can be added to a u64 */
+	x = (u64)a_lo * b_lo + (u32)c;
+	y = (u64)a_lo * b_hi + (u32)(c >> 32);
+	y += (u32)(x >> 32);
 	z = (u64)a_hi * b_hi + (u32)(y >> 32);
 	y = (u64)a_hi * b_lo + (u32)y;
 	z += (u32)(y >> 32);
@@ -265,5 +267,5 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 
 	return res;
 }
-EXPORT_SYMBOL(mul_u64_u64_div_u64);
+EXPORT_SYMBOL(mul_u64_add_u64_div_u64);
 #endif
_

Patches currently in -mm which might be from david.laight.linux@gmail.com are


