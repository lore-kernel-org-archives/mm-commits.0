Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDA92EACEF
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382665; cv=none; b=gfFx4NRVEabeWOlp3x4FaWfGUo3r4eQX67aC6RvnztiRYvoIk/GbhgVxpLx6oqCZhecTBOe+cQ77l21MESZx4QIIWMU3UGuRqVBdPpITzFBX345hH37ETi1shc9Aw1FSQQLvueLn77hap7YnFLPMQv++M/RqsDAXK6Ae7VLVYVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382665; c=relaxed/simple;
	bh=uX2qvniQLXfu5Z2xOY1cak+rgIeyG+9n4NABl6+HoFo=;
	h=Date:To:From:Subject:Message-Id; b=AqEjYKtmc0FZ1z/9wAFNCaScLyIvJp3F/oHGOI1qmQ6bRbi4tRRGzpuT3ReFRsxy9gT9tUmr1sakldwlqjyZlo60heM9lnIqwUBrI3RZHTe5fs2ckPAGwu7Rs+pYIjh9zTSur+OhWY6Jr+28hdLAwXhT4vo/WtEx6pWSXV9XJcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J5uDlGyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J5uDlGyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7809C4CEF5;
	Wed,  5 Nov 2025 22:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382665;
	bh=uX2qvniQLXfu5Z2xOY1cak+rgIeyG+9n4NABl6+HoFo=;
	h=Date:To:From:Subject:From;
	b=J5uDlGywPUMaFWCUIcORdeiIr4pLW8dDf2aVrJljfqCaT/l2Q8UQaUksrrW6TNLps
	 kjPZu7l1inyJxvFGGUTmlJs6h43ei2VhGoltvSTqEZwm61AnrwLn87h1i1zB3iBo9Z
	 Fg/dJrhD9BEfgBvs0L7+/ujkbY3/oykX9gGh7RV8=
Date: Wed, 05 Nov 2025 14:44:24 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,tglx@linutronix.de,peterz@infradead.org,oleg@redhat.com,npitre@baylibre.com,mingo@redhat.com,lirongqing@baidu.com,hpa@zytor.com,bp@alien8.de,biju.das.jz@bp.renesas.com,axboe@kernel.dk,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-tests-for-mul_u64_u64_div_u64_roundup.patch added to mm-nonmm-unstable branch
Message-Id: <20251105224424.E7809C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add tests for mul_u64_u64_div_u64_roundup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-tests-for-mul_u64_u64_div_u64_roundup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-tests-for-mul_u64_u64_div_u64_roundup.patch

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
Subject: lib: add tests for mul_u64_u64_div_u64_roundup()
Date: Wed, 5 Nov 2025 20:10:31 +0000

Replicate the existing mul_u64_u64_div_u64() test cases with round up. 
Update the shell script that verifies the table, remove the comment
markers so that it can be directly pasted into a shell.

Rename the divisor from 'c' to 'd' to match mul_u64_add_u64_div_u64().

It any tests fail then fail the module load with -EINVAL.

Link: https://lkml.kernel.org/r/20251105201035.64043-6-david.laight.linux@gmail.com
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

 lib/math/test_mul_u64_u64_div_u64.c |  122 +++++++++++++++-----------
 1 file changed, 73 insertions(+), 49 deletions(-)

--- a/lib/math/test_mul_u64_u64_div_u64.c~lib-add-tests-for-mul_u64_u64_div_u64_roundup
+++ a/lib/math/test_mul_u64_u64_div_u64.c
@@ -10,61 +10,73 @@
 #include <linux/printk.h>
 #include <linux/math64.h>
 
-typedef struct { u64 a; u64 b; u64 c; u64 result; } test_params;
+typedef struct { u64 a; u64 b; u64 d; u64 result; uint round_up;} test_params;
 
 static test_params test_values[] = {
 /* this contains many edge values followed by a couple random values */
-{                0xb,                0x7,                0x3,               0x19 },
-{         0xffff0000,         0xffff0000,                0xf, 0x1110eeef00000000 },
-{         0xffffffff,         0xffffffff,                0x1, 0xfffffffe00000001 },
-{         0xffffffff,         0xffffffff,                0x2, 0x7fffffff00000000 },
-{        0x1ffffffff,         0xffffffff,                0x2, 0xfffffffe80000000 },
-{        0x1ffffffff,         0xffffffff,                0x3, 0xaaaaaaa9aaaaaaab },
-{        0x1ffffffff,        0x1ffffffff,                0x4, 0xffffffff00000000 },
-{ 0xffff000000000000, 0xffff000000000000, 0xffff000000000001, 0xfffeffffffffffff },
-{ 0x3333333333333333, 0x3333333333333333, 0x5555555555555555, 0x1eb851eb851eb851 },
-{ 0x7fffffffffffffff,                0x2,                0x3, 0x5555555555555554 },
-{ 0xffffffffffffffff,                0x2, 0x8000000000000000,                0x3 },
-{ 0xffffffffffffffff,                0x2, 0xc000000000000000,                0x2 },
-{ 0xffffffffffffffff, 0x4000000000000004, 0x8000000000000000, 0x8000000000000007 },
-{ 0xffffffffffffffff, 0x4000000000000001, 0x8000000000000000, 0x8000000000000001 },
-{ 0xffffffffffffffff, 0x8000000000000001, 0xffffffffffffffff, 0x8000000000000001 },
-{ 0xfffffffffffffffe, 0x8000000000000001, 0xffffffffffffffff, 0x8000000000000000 },
-{ 0xffffffffffffffff, 0x8000000000000001, 0xfffffffffffffffe, 0x8000000000000001 },
-{ 0xffffffffffffffff, 0x8000000000000001, 0xfffffffffffffffd, 0x8000000000000002 },
-{ 0x7fffffffffffffff, 0xffffffffffffffff, 0xc000000000000000, 0xaaaaaaaaaaaaaaa8 },
-{ 0xffffffffffffffff, 0x7fffffffffffffff, 0xa000000000000000, 0xccccccccccccccca },
-{ 0xffffffffffffffff, 0x7fffffffffffffff, 0x9000000000000000, 0xe38e38e38e38e38b },
-{ 0x7fffffffffffffff, 0x7fffffffffffffff, 0x5000000000000000, 0xccccccccccccccc9 },
-{ 0xffffffffffffffff, 0xfffffffffffffffe, 0xffffffffffffffff, 0xfffffffffffffffe },
-{ 0xe6102d256d7ea3ae, 0x70a77d0be4c31201, 0xd63ec35ab3220357, 0x78f8bf8cc86c6e18 },
-{ 0xf53bae05cb86c6e1, 0x3847b32d2f8d32e0, 0xcfd4f55a647f403c, 0x42687f79d8998d35 },
-{ 0x9951c5498f941092, 0x1f8c8bfdf287a251, 0xa3c8dc5f81ea3fe2, 0x1d887cb25900091f },
-{ 0x374fee9daa1bb2bb, 0x0d0bfbff7b8ae3ef, 0xc169337bd42d5179, 0x03bb2dbaffcbb961 },
-{ 0xeac0d03ac10eeaf0, 0x89be05dfa162ed9b, 0x92bb1679a41f0e4b, 0xdc5f5cc9e270d216 },
+{                0xb,                0x7,                0x3,               0x19, 1 },
+{         0xffff0000,         0xffff0000,                0xf, 0x1110eeef00000000, 0 },
+{         0xffffffff,         0xffffffff,                0x1, 0xfffffffe00000001, 0 },
+{         0xffffffff,         0xffffffff,                0x2, 0x7fffffff00000000, 1 },
+{        0x1ffffffff,         0xffffffff,                0x2, 0xfffffffe80000000, 1 },
+{        0x1ffffffff,         0xffffffff,                0x3, 0xaaaaaaa9aaaaaaab, 0 },
+{        0x1ffffffff,        0x1ffffffff,                0x4, 0xffffffff00000000, 1 },
+{ 0xffff000000000000, 0xffff000000000000, 0xffff000000000001, 0xfffeffffffffffff, 1 },
+{ 0x3333333333333333, 0x3333333333333333, 0x5555555555555555, 0x1eb851eb851eb851, 1 },
+{ 0x7fffffffffffffff,                0x2,                0x3, 0x5555555555555554, 1 },
+{ 0xffffffffffffffff,                0x2, 0x8000000000000000,                0x3, 1 },
+{ 0xffffffffffffffff,                0x2, 0xc000000000000000,                0x2, 1 },
+{ 0xffffffffffffffff, 0x4000000000000004, 0x8000000000000000, 0x8000000000000007, 1 },
+{ 0xffffffffffffffff, 0x4000000000000001, 0x8000000000000000, 0x8000000000000001, 1 },
+{ 0xffffffffffffffff, 0x8000000000000001, 0xffffffffffffffff, 0x8000000000000001, 0 },
+{ 0xfffffffffffffffe, 0x8000000000000001, 0xffffffffffffffff, 0x8000000000000000, 1 },
+{ 0xffffffffffffffff, 0x8000000000000001, 0xfffffffffffffffe, 0x8000000000000001, 1 },
+{ 0xffffffffffffffff, 0x8000000000000001, 0xfffffffffffffffd, 0x8000000000000002, 1 },
+{ 0x7fffffffffffffff, 0xffffffffffffffff, 0xc000000000000000, 0xaaaaaaaaaaaaaaa8, 1 },
+{ 0xffffffffffffffff, 0x7fffffffffffffff, 0xa000000000000000, 0xccccccccccccccca, 1 },
+{ 0xffffffffffffffff, 0x7fffffffffffffff, 0x9000000000000000, 0xe38e38e38e38e38b, 1 },
+{ 0x7fffffffffffffff, 0x7fffffffffffffff, 0x5000000000000000, 0xccccccccccccccc9, 1 },
+{ 0xffffffffffffffff, 0xfffffffffffffffe, 0xffffffffffffffff, 0xfffffffffffffffe, 0 },
+{ 0xe6102d256d7ea3ae, 0x70a77d0be4c31201, 0xd63ec35ab3220357, 0x78f8bf8cc86c6e18, 1 },
+{ 0xf53bae05cb86c6e1, 0x3847b32d2f8d32e0, 0xcfd4f55a647f403c, 0x42687f79d8998d35, 1 },
+{ 0x9951c5498f941092, 0x1f8c8bfdf287a251, 0xa3c8dc5f81ea3fe2, 0x1d887cb25900091f, 1 },
+{ 0x374fee9daa1bb2bb, 0x0d0bfbff7b8ae3ef, 0xc169337bd42d5179, 0x03bb2dbaffcbb961, 1 },
+{ 0xeac0d03ac10eeaf0, 0x89be05dfa162ed9b, 0x92bb1679a41f0e4b, 0xdc5f5cc9e270d216, 1 },
 };
 
 /*
  * The above table can be verified with the following shell script:
- *
- * #!/bin/sh
- * sed -ne 's/^{ \+\(.*\), \+\(.*\), \+\(.*\), \+\(.*\) },$/\1 \2 \3 \4/p' \
- *     lib/math/test_mul_u64_u64_div_u64.c |
- * while read a b c r; do
- *   expected=$( printf "obase=16; ibase=16; %X * %X / %X\n" $a $b $c | bc )
- *   given=$( printf "%X\n" $r )
- *   if [ "$expected" = "$given" ]; then
- *     echo "$a * $b / $c = $r OK"
- *   else
- *     echo "$a * $b / $c = $r is wrong" >&2
- *     echo "should be equivalent to 0x$expected" >&2
- *     exit 1
- *   fi
- * done
+
+#!/bin/sh
+sed -ne 's/^{ \+\(.*\), \+\(.*\), \+\(.*\), \+\(.*\), \+\(.*\) },$/\1 \2 \3 \4 \5/p' \
+    lib/math/test_mul_u64_u64_div_u64.c |
+while read a b d r e; do
+  expected=$( printf "obase=16; ibase=16; %X * %X / %X\n" $a $b $d | bc )
+  given=$( printf "%X\n" $r )
+  if [ "$expected" = "$given" ]; then
+    echo "$a * $b  / $d = $r OK"
+  else
+    echo "$a * $b  / $d = $r is wrong" >&2
+    echo "should be equivalent to 0x$expected" >&2
+    exit 1
+  fi
+  expected=$( printf "obase=16; ibase=16; (%X * %X + %X) / %X\n" $a $b $((d-1)) $d | bc )
+  given=$( printf "%X\n" $((r + e)) )
+  if [ "$expected" = "$given" ]; then
+    echo "$a * $b +/ $d = $(printf '%#x' $((r + e))) OK"
+  else
+    echo "$a * $b +/ $d = $(printf '%#x' $((r + e))) is wrong" >&2
+    echo "should be equivalent to 0x$expected" >&2
+    exit 1
+  fi
+done
+
  */
 
 static int __init test_init(void)
 {
+	int errors = 0;
+	int tests = 0;
 	int i;
 
 	pr_info("Starting mul_u64_u64_div_u64() test\n");
@@ -72,19 +84,31 @@ static int __init test_init(void)
 	for (i = 0; i < ARRAY_SIZE(test_values); i++) {
 		u64 a = test_values[i].a;
 		u64 b = test_values[i].b;
-		u64 c = test_values[i].c;
+		u64 d = test_values[i].d;
 		u64 expected_result = test_values[i].result;
-		u64 result = mul_u64_u64_div_u64(a, b, c);
+		u64 result = mul_u64_u64_div_u64(a, b, d);
+		u64 result_up = mul_u64_u64_div_u64_roundup(a, b, d);
+
+		tests += 2;
 
 		if (result != expected_result) {
-			pr_err("ERROR: 0x%016llx * 0x%016llx / 0x%016llx\n", a, b, c);
+			pr_err("ERROR: 0x%016llx * 0x%016llx / 0x%016llx\n", a, b, d);
 			pr_err("ERROR: expected result: %016llx\n", expected_result);
 			pr_err("ERROR: obtained result: %016llx\n", result);
+			errors++;
+		}
+		expected_result += test_values[i].round_up;
+		if (result_up != expected_result) {
+			pr_err("ERROR: 0x%016llx * 0x%016llx +/ 0x%016llx\n", a, b, d);
+			pr_err("ERROR: expected result: %016llx\n", expected_result);
+			pr_err("ERROR: obtained result: %016llx\n", result_up);
+			errors++;
 		}
 	}
 
-	pr_info("Completed mul_u64_u64_div_u64() test\n");
-	return 0;
+	pr_info("Completed mul_u64_u64_div_u64() test, %d tests, %d errors\n",
+		tests, errors);
+	return errors ? -EINVAL : 0;
 }
 
 static void __exit test_exit(void)
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

