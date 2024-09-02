Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE7CA32
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248750; cv=none; b=hUns33eVY0XISgB4zOOxCfMPN91LwqhLnqk0xuDE2ifeUKMXI8jC8iRmXNdvwTriFXDexZ0wzgv9s8US+WNHVwO90kqfwvPDWvhtGJRFr9yXcTfbAfhxtjVRZvCOHooz0iqoE9S2S727bsJxeudbX7cV6za3NPEXPZSOPSV1IrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248750; c=relaxed/simple;
	bh=XnbBTGQayClBgrGWeWSl8gy9LgZgSwKX0UE70RgLuKs=;
	h=Date:To:From:Subject:Message-Id; b=ToxSX4PUcmC32WqSpyIwNCNLaMVrJBXAfW5emkzfNAK9h1PWVQODwZlPp44OLk1lXHgRsA0XFWeFu4Z6QM5DiFb8if3x0IdC6EPm3UTxDFWupsUKHQNKjobhnpzCvyBJI/KUHE7ntWtZZ8Dj9n/CXnS1l5dfo+QA6YbmOoej1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y6MjF47U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y6MjF47U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3E5C4CEC2;
	Mon,  2 Sep 2024 03:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248749;
	bh=XnbBTGQayClBgrGWeWSl8gy9LgZgSwKX0UE70RgLuKs=;
	h=Date:To:From:Subject:From;
	b=y6MjF47UUsC/Ey34fXFdWgdNPcrC59eGEnISgZihA44SARfdI+Wh0Hs0mtVYyNHAr
	 5nB/M1Lwf7Ikz9SFRsI3A15W3WlGT/7INLlsHVFpxmAUR3eO3ch7xiGBRkyIJ5+BZS
	 AuD4L0VGysriziWQr4f3OXFcorbeZlh/CsFl4fwY=
Date: Sun, 01 Sep 2024 20:45:49 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,biju.das.jz@bp.renesas.com,npitre@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mul_u64_u64_div_u64-basic-sanity-test.patch removed from -mm tree
Message-Id: <20240902034549.CD3E5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mul_u64_u64_div_u64: basic sanity test
has been removed from the -mm tree.  Its filename was
     mul_u64_u64_div_u64-basic-sanity-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nicolas Pitre <npitre@baylibre.com>
Subject: mul_u64_u64_div_u64: basic sanity test
Date: Sun, 7 Jul 2024 15:05:20 -0400

Verify that edge cases produce proper results, and some more.

[npitre@baylibre.com: avoid undefined shift value]
  Link: https://lkml.kernel.org/r/7rrs9pn1-n266-3013-9q6n-1osp8r8s0rrn@syhkavp.arg
Link: https://lkml.kernel.org/r/20240707190648.1982714-3-nico@fluxnic.net
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                   |   10 ++
 lib/math/Makefile                   |    1 
 lib/math/div64.c                    |    9 ++
 lib/math/test_mul_u64_u64_div_u64.c |   99 ++++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~mul_u64_u64_div_u64-basic-sanity-test
+++ a/lib/Kconfig.debug
@@ -2280,6 +2280,16 @@ config TEST_DIV64
 
 	  If unsure, say N.
 
+config TEST_MULDIV64
+	tristate "mul_u64_u64_div_u64() test"
+	depends on DEBUG_KERNEL || m
+	help
+	  Enable this to turn on 'mul_u64_u64_div_u64()' function test.
+	  This test is executed only once during system boot (so affects
+	  only boot time), or at module load time.
+
+	  If unsure, say N.
+
 config TEST_IOV_ITER
 	tristate "Test iov_iter operation" if !KUNIT_ALL_TESTS
 	depends on KUNIT
--- a/lib/math/div64.c~mul_u64_u64_div_u64-basic-sanity-test
+++ a/lib/math/div64.c
@@ -212,11 +212,18 @@ u64 mul_u64_u64_div_u64(u64 a, u64 b, u6
 
 #endif
 
+	/* make sure c is not zero, trigger exception otherwise */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wdiv-by-zero"
+	if (unlikely(c == 0))
+		return 1/0;
+#pragma GCC diagnostic pop
+
 	int shift = __builtin_ctzll(c);
 
 	/* try reducing the fraction in case the dividend becomes <= 64 bits */
 	if ((n_hi >> shift) == 0) {
-		u64 n = (n_lo >> shift) | (n_hi << (64 - shift));
+		u64 n = shift ? (n_lo >> shift) | (n_hi << (64 - shift)) : n_lo;
 
 		return div64_u64(n, c >> shift);
 		/*
--- a/lib/math/Makefile~mul_u64_u64_div_u64-basic-sanity-test
+++ a/lib/math/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_PRIME_NUMBERS)	+= prime_num
 obj-$(CONFIG_RATIONAL)		+= rational.o
 
 obj-$(CONFIG_TEST_DIV64)	+= test_div64.o
+obj-$(CONFIG_TEST_MULDIV64)	+= test_mul_u64_u64_div_u64.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational-test.o
diff --git a/lib/math/test_mul_u64_u64_div_u64.c a/lib/math/test_mul_u64_u64_div_u64.c
new file mode 100664
--- /dev/null
+++ a/lib/math/test_mul_u64_u64_div_u64.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 BayLibre SAS
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/math64.h>
+
+typedef struct { u64 a; u64 b; u64 c; u64 result; } test_params;
+
+static test_params test_values[] = {
+/* this contains many edge values followed by a couple random values */
+{                0xb,                0x7,                0x3,               0x19 },
+{         0xffff0000,         0xffff0000,                0xf, 0x1110eeef00000000 },
+{         0xffffffff,         0xffffffff,                0x1, 0xfffffffe00000001 },
+{         0xffffffff,         0xffffffff,                0x2, 0x7fffffff00000000 },
+{        0x1ffffffff,         0xffffffff,                0x2, 0xfffffffe80000000 },
+{        0x1ffffffff,         0xffffffff,                0x3, 0xaaaaaaa9aaaaaaab },
+{        0x1ffffffff,        0x1ffffffff,                0x4, 0xffffffff00000000 },
+{ 0xffff000000000000, 0xffff000000000000, 0xffff000000000001, 0xfffeffffffffffff },
+{ 0x3333333333333333, 0x3333333333333333, 0x5555555555555555, 0x1eb851eb851eb851 },
+{ 0x7fffffffffffffff,                0x2,                0x3, 0x5555555555555554 },
+{ 0xffffffffffffffff,                0x2, 0x8000000000000000,                0x3 },
+{ 0xffffffffffffffff,                0x2, 0xc000000000000000,                0x2 },
+{ 0xffffffffffffffff, 0x4000000000000004, 0x8000000000000000, 0x8000000000000007 },
+{ 0xffffffffffffffff, 0x4000000000000001, 0x8000000000000000, 0x8000000000000001 },
+{ 0xffffffffffffffff, 0x8000000000000001, 0xffffffffffffffff, 0x8000000000000001 },
+{ 0xfffffffffffffffe, 0x8000000000000001, 0xffffffffffffffff, 0x8000000000000000 },
+{ 0xffffffffffffffff, 0x8000000000000001, 0xfffffffffffffffe, 0x8000000000000001 },
+{ 0xffffffffffffffff, 0x8000000000000001, 0xfffffffffffffffd, 0x8000000000000002 },
+{ 0x7fffffffffffffff, 0xffffffffffffffff, 0xc000000000000000, 0xaaaaaaaaaaaaaaa8 },
+{ 0xffffffffffffffff, 0x7fffffffffffffff, 0xa000000000000000, 0xccccccccccccccca },
+{ 0xffffffffffffffff, 0x7fffffffffffffff, 0x9000000000000000, 0xe38e38e38e38e38b },
+{ 0x7fffffffffffffff, 0x7fffffffffffffff, 0x5000000000000000, 0xccccccccccccccc9 },
+{ 0xffffffffffffffff, 0xfffffffffffffffe, 0xffffffffffffffff, 0xfffffffffffffffe },
+{ 0xe6102d256d7ea3ae, 0x70a77d0be4c31201, 0xd63ec35ab3220357, 0x78f8bf8cc86c6e18 },
+{ 0xf53bae05cb86c6e1, 0x3847b32d2f8d32e0, 0xcfd4f55a647f403c, 0x42687f79d8998d35 },
+{ 0x9951c5498f941092, 0x1f8c8bfdf287a251, 0xa3c8dc5f81ea3fe2, 0x1d887cb25900091f },
+{ 0x374fee9daa1bb2bb, 0x0d0bfbff7b8ae3ef, 0xc169337bd42d5179, 0x03bb2dbaffcbb961 },
+{ 0xeac0d03ac10eeaf0, 0x89be05dfa162ed9b, 0x92bb1679a41f0e4b, 0xdc5f5cc9e270d216 },
+};
+
+/*
+ * The above table can be verified with the following shell script:
+ *
+ * #!/bin/sh
+ * sed -ne 's/^{ \+\(.*\), \+\(.*\), \+\(.*\), \+\(.*\) },$/\1 \2 \3 \4/p' \
+ *     lib/math/test_mul_u64_u64_div_u64.c |
+ * while read a b c r; do
+ *   expected=$( printf "obase=16; ibase=16; %X * %X / %X\n" $a $b $c | bc )
+ *   given=$( printf "%X\n" $r )
+ *   if [ "$expected" = "$given" ]; then
+ *     echo "$a * $b / $c = $r OK"
+ *   else
+ *     echo "$a * $b / $c = $r is wrong" >&2
+ *     echo "should be equivalent to 0x$expected" >&2
+ *     exit 1
+ *   fi
+ * done
+ */
+
+static int __init test_init(void)
+{
+	int i;
+
+	pr_info("Starting mul_u64_u64_div_u64() test\n");
+
+	for (i = 0; i < ARRAY_SIZE(test_values); i++) {
+		u64 a = test_values[i].a;
+		u64 b = test_values[i].b;
+		u64 c = test_values[i].c;
+		u64 expected_result = test_values[i].result;
+		u64 result = mul_u64_u64_div_u64(a, b, c);
+
+		if (result != expected_result) {
+			pr_err("ERROR: 0x%016llx * 0x%016llx / 0x%016llx\n", a, b, c);
+			pr_err("ERROR: expected result: %016llx\n", expected_result);
+			pr_err("ERROR: obtained result: %016llx\n", result);
+		}
+	}
+
+	pr_info("Completed mul_u64_u64_div_u64() test\n");
+	return 0;
+}
+
+static void __exit test_exit(void)
+{
+}
+
+module_init(test_init);
+module_exit(test_exit);
+
+MODULE_AUTHOR("Nicolas Pitre");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("mul_u64_u64_div_u64() test module");
_

Patches currently in -mm which might be from npitre@baylibre.com are


