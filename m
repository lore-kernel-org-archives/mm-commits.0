Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C3C2F28FC
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382666; cv=none; b=nVSS439PacA+e9EZ8rXYRmH6HWLPELOPE/RMMXHbG8bCVCRU9HUGU+FDmHRgFm3KPEfHkEfbyAPvVt19BODSpJC4TppgAbgvJEV4B9UWXRC1OsmH9XeFLcHIDOJUrnUQ1C8hon1avCHvhz82yMSCZHxo0gvfrEcfRXnLm+9hnuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382666; c=relaxed/simple;
	bh=alBsTZUxBwnQXo+KlOKgtlKAG0gnCfyeyyQtaifcUiI=;
	h=Date:To:From:Subject:Message-Id; b=WrzXs7tsyYqDEIqulE7V7xUUDhImslFrTInK1aepp1Ut/oxpbSNCNkjFyLJRTCNSmdiDOcN16cuJP699xu/hG0As5WqM5NzWByL7wFJsBGsb5gWYdf6PKP/KlUnhsnv6gAPus22rALGtqPJt3/jGOBrvM3L/uuQuR5ODOpdrWlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nURvA00d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nURvA00d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD16C4AF0B;
	Wed,  5 Nov 2025 22:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382666;
	bh=alBsTZUxBwnQXo+KlOKgtlKAG0gnCfyeyyQtaifcUiI=;
	h=Date:To:From:Subject:From;
	b=nURvA00d2nMFEhhM9CojiaEbqE0shpHMvRKgXqlnc3xWBcbUFVD7Pgx0D3nRUEks5
	 j1R9xLuvfD+KD+lhse4AXhXPD7+gmaAvTyL5VNe8tvvZ/AEw7nNqQsmjDwxvcIC4MT
	 BPyZBNZ/XJZ6xvKVSLwf8xKBrNWthEShi5ZC+qW4=
Date: Wed, 05 Nov 2025 14:44:25 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224426.2BD16C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_mul_u64_u64_div_u64(): test both generic and arch versions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch

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
Subject: lib: test_mul_u64_u64_div_u64(): test both generic and arch versions
Date: Wed, 5 Nov 2025 20:10:32 +0000

Change the #if in div64.c so that test_mul_u64_u64_div_u64.c can compile
and test the generic version (including the 'long multiply') on
architectures (eg amd64) that define their own copy.

Test the kernel version and the locally compiled version on all arch. 
Output the time taken (in ns) on the 'test completed' trace.

For reference, on my zen 5, the optimised version takes ~220ns and the
generic version ~3350ns.  Using the native multiply saves ~200ns and
adding back the ilog2() 'optimisation' test adds ~50ms.

Link: https://lkml.kernel.org/r/20251105201035.64043-7-david.laight.linux@gmail.com
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

 lib/math/div64.c                    |    8 +++-
 lib/math/test_mul_u64_u64_div_u64.c |   52 ++++++++++++++++++++++----
 2 files changed, 51 insertions(+), 9 deletions(-)

--- a/lib/math/div64.c~lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions
+++ a/lib/math/div64.c
@@ -177,16 +177,18 @@ EXPORT_SYMBOL(div64_s64);
  * Iterative div/mod for use when dividend is not expected to be much
  * bigger than divisor.
  */
+#ifndef iter_div_u64_rem
 u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
 {
 	return __iter_div_u64_rem(dividend, divisor, remainder);
 }
 EXPORT_SYMBOL(iter_div_u64_rem);
+#endif
 
-#ifndef mul_u64_add_u64_div_u64
+#if !defined(mul_u64_add_u64_div_u64) || defined(test_mul_u64_add_u64_div_u64)
 u64 mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d)
 {
-#if defined(__SIZEOF_INT128__)
+#if defined(__SIZEOF_INT128__) && !defined(test_mul_u64_add_u64_div_u64)
 
 	/* native 64x64=128 bits multiplication */
 	u128 prod = (u128)a * b + c;
@@ -267,5 +269,7 @@ u64 mul_u64_add_u64_div_u64(u64 a, u64 b
 
 	return res;
 }
+#if !defined(test_mul_u64_add_u64_div_u64)
 EXPORT_SYMBOL(mul_u64_add_u64_div_u64);
 #endif
+#endif
--- a/lib/math/test_mul_u64_u64_div_u64.c~lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions
+++ a/lib/math/test_mul_u64_u64_div_u64.c
@@ -73,21 +73,34 @@ done
 
  */
 
-static int __init test_init(void)
+static u64 test_mul_u64_add_u64_div_u64(u64 a, u64 b, u64 c, u64 d);
+
+static int __init test_run(unsigned int fn_no, const char *fn_name)
 {
+	u64 start_time;
 	int errors = 0;
 	int tests = 0;
 	int i;
 
-	pr_info("Starting mul_u64_u64_div_u64() test\n");
+	start_time = ktime_get_ns();
 
 	for (i = 0; i < ARRAY_SIZE(test_values); i++) {
 		u64 a = test_values[i].a;
 		u64 b = test_values[i].b;
 		u64 d = test_values[i].d;
 		u64 expected_result = test_values[i].result;
-		u64 result = mul_u64_u64_div_u64(a, b, d);
-		u64 result_up = mul_u64_u64_div_u64_roundup(a, b, d);
+		u64 result, result_up;
+
+		switch (fn_no) {
+		default:
+			result = mul_u64_u64_div_u64(a, b, d);
+			result_up = mul_u64_u64_div_u64_roundup(a, b, d);
+			break;
+		case 1:
+			result = test_mul_u64_add_u64_div_u64(a, b, 0, d);
+			result_up = test_mul_u64_add_u64_div_u64(a, b, d - 1, d);
+			break;
+		}
 
 		tests += 2;
 
@@ -106,15 +119,40 @@ static int __init test_init(void)
 		}
 	}
 
-	pr_info("Completed mul_u64_u64_div_u64() test, %d tests, %d errors\n",
-		tests, errors);
-	return errors ? -EINVAL : 0;
+	pr_info("Completed %s() test, %d tests, %d errors, %llu ns\n",
+		fn_name, tests, errors, ktime_get_ns() - start_time);
+	return errors;
+}
+
+static int __init test_init(void)
+{
+	pr_info("Starting mul_u64_u64_div_u64() test\n");
+	if (test_run(0, "mul_u64_u64_div_u64"))
+		return -EINVAL;
+	if (test_run(1, "test_mul_u64_u64_div_u64"))
+		return -EINVAL;
+	return 0;
 }
 
 static void __exit test_exit(void)
 {
 }
 
+/* Compile the generic mul_u64_add_u64_div_u64() code */
+#undef __div64_32
+#define __div64_32 __div64_32
+#define div_s64_rem div_s64_rem
+#define div64_u64_rem div64_u64_rem
+#define div64_u64 div64_u64
+#define div64_s64 div64_s64
+#define iter_div_u64_rem iter_div_u64_rem
+
+#undef mul_u64_add_u64_div_u64
+#define mul_u64_add_u64_div_u64 test_mul_u64_add_u64_div_u64
+#define test_mul_u64_add_u64_div_u64 test_mul_u64_add_u64_div_u64
+
+#include "div64.c"
+
 module_init(test_init);
 module_exit(test_exit);
 
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

