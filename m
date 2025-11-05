Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77402F360E
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382663; cv=none; b=lxfAAa+qeT3DGFn73VAVgr5CvNmr9/eU8YgghPsDxKxLxy+i58u7gGKbojPxJEYtfywc3yv+pAi61/UuM5y6X6I3lDxiXRojHnhkUzvY3kjg/WsqlyfLrKD54pnTJ07e5/8fUNVPgzf8COpC9/zDZSfFcWiyyXyZ+bV+eC54PYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382663; c=relaxed/simple;
	bh=KBTs40StHg31oLqhwSVQfVUPdqAtKd4zpH8uVncZ390=;
	h=Date:To:From:Subject:Message-Id; b=YtFI6oPGskOMHxIDfmtHPEn15zvBEAV61wCW9fVxMBHhLggIc7gXO+b60j6UtzR7pv0qY+6IrYizpsJfICRHNt8OkyNcg3HjJ0bt3biqGu4vrqzhYv/muLL2jqkB0yR+VzK+AANkI0/+Cs0HcvzANuRBTc1Un0Gv9h6RsEYilmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GtAQJAT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GtAQJAT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BB0C4CEF5;
	Wed,  5 Nov 2025 22:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382663;
	bh=KBTs40StHg31oLqhwSVQfVUPdqAtKd4zpH8uVncZ390=;
	h=Date:To:From:Subject:From;
	b=GtAQJAT1+mrNkj96Og7Okg1+pRhzY4Qqkx7Vc1uPQLvr0MfXnK2MHIt3bbHlzQIYa
	 VED9mib0Ra1gtK5eZBa9Zuzb5n4nvQmj6hynUfhMkk4PlgzswtpsgpdEqnnqbsvRzr
	 WiCveMjNZ8c2aoGibCgB4O7rdMKfaTwDPLtmqP28=
Date: Wed, 05 Nov 2025 14:44:22 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224423.63BB0C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add mul_u64_add_u64_div_u64() and mul_u64_u64_div_u64_roundup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch

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

lib-mul_u64_u64_div_u64-rename-parameter-c-to-d.patch
lib-mul_u64_u64_div_u64-combine-overflow-and-divide-by-zero-checks.patch
lib-mul_u64_u64_div_u64-simplify-check-for-a-64bit-product.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup.patch
lib-add-tests-for-mul_u64_u64_div_u64_roundup.patch
lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch
lib-mul_u64_u64_div_u64-optimise-multiply-on-32bit-x86.patch
lib-mul_u64_u64_div_u64-optimise-the-divide-code.patch
lib-test_mul_u64_u64_div_u64-test-the-32bit-code-on-64bit.patch

