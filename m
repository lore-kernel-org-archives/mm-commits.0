Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B8D1EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676269; cv=none; b=bPgZuJnvxm8AUSBaE+DDqCkpt3LhycEpCquAAGbaUjVvuAXmMiMkGPLvw3OetWFCS5YcYxzBV2UPFg2uKDsW9Fytt1JXygLVmMtuU+ur0vErZZ7vBUPB460l1FrfvFKG4Ar0BI7MeGhst90/vCMO8UGG2JUZZEXNxBzZIP7PDYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676269; c=relaxed/simple;
	bh=UA7RsVO10+QXPgl/KB71JCZW1UT9xnVpr/SsKehdssw=;
	h=Date:To:From:Subject:Message-Id; b=cg3nwMhcUtQP4OQisAt49KK6uQ4JefMsDGJE4hx6aldaAqGGYIS/jvj1jnEMsXEnUcH9CNAlWmOR8HBbG/hpc8F5s9HUsPi2U5BWIco2UW7tcLFpVtPmnDsACdXddbfN3mKJ3AOfQpjPoxElVSd5X7LRKAIVmgql6v4ioiKndcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yV51M//i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yV51M//i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D43C4CEF1;
	Thu, 20 Nov 2025 22:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676268;
	bh=UA7RsVO10+QXPgl/KB71JCZW1UT9xnVpr/SsKehdssw=;
	h=Date:To:From:Subject:From;
	b=yV51M//iMBTNzfhS/FCP3WKL9fPTjg6saULS3tmFekGQ+W1n8/xJ8JSmK957JBXbL
	 DlUIoo/CrjxDtvhCPJ+vI46mWiR/TA7itaVLeeYHjZb4xE6v9/CQ72Hg8Rilnrb1M9
	 SR7Aji+CMKDTtzb/lv0OkYtuU8rZuWXVGWCaOAm8=
Date: Thu, 20 Nov 2025 14:04:28 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch removed from -mm tree
Message-Id: <20251120220428.C2D43C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_mul_u64_u64_div_u64(): test both generic and arch versions
has been removed from the -mm tree.  Its filename was
     lib-test_mul_u64_u64_div_u64-test-both-generic-and-arch-versions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


