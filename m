Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D0B14EC61
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 21:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720475753; cv=none; b=AuuQhv1bjzMGeMgcc/HiHgBbwkFiXIZR5Un+0qIfPcS0JEDkszNXHFN6oyaVrSlhDyYB+ntx+EcYqiLWaNIuo5UbWQBFvB9N1qKTi2W4nmI+2h9zCuZI9cKA6iXi5xG8Y22ANqNJY5x0pflWMf+w6zdInxmHYF1L8FtfKKdWzw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720475753; c=relaxed/simple;
	bh=nMwpECel51XswfHeb1Ih4pDyTI+yFqY1gd3KILqCjGM=;
	h=Date:To:From:Subject:Message-Id; b=nLjnZZHCD7WAFTtue1xLBgz1FBOAO5THtmqbHVSHHo+43zVE0T/D8yKXLyXJNFN3vMYF6hyqBMqiekuVa38922DG21WVlZWFlxNstLadEp1WRjoborU40Jnhag4JCLj6rHwuqJ4v4WN4jVUY668h5vOm2jbmv1Qr5c5MRIszjs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHWheUvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHWheUvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CE9C116B1;
	Mon,  8 Jul 2024 21:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720475753;
	bh=nMwpECel51XswfHeb1Ih4pDyTI+yFqY1gd3KILqCjGM=;
	h=Date:To:From:Subject:From;
	b=NHWheUvkGGaLltQwTWVSVaeax+ZaJOMgRyfqVhMjAS0tsupzSwBT2X7vLJw13LETO
	 Q9FC8CLobQCmB6lIji5Bsg7FBswG6XxEBrWSQ2jgrCE1PH4UZSFKgyud5WuKkz0HVr
	 xq2M4duJJKRSpYYg8786Sahlx/291D4UV3s52imY=
Date: Mon, 08 Jul 2024 14:55:52 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,biju.das.jz@bp.renesas.com,npitre@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mul_u64_u64_div_u64-basic-sanity-test.patch added to mm-nonmm-unstable branch
Message-Id: <20240708215553.26CE9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mul_u64_u64_div_u64: basic sanity test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mul_u64_u64_div_u64-basic-sanity-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mul_u64_u64_div_u64-basic-sanity-test.patch

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
From: Nicolas Pitre <npitre@baylibre.com>
Subject: mul_u64_u64_div_u64: basic sanity test
Date: Sun, 7 Jul 2024 15:05:20 -0400

Verify that edge cases produce proper results, and some more.

Link: https://lkml.kernel.org/r/20240707190648.1982714-3-nico@fluxnic.net
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                   |   10 ++
 lib/math/Makefile                   |    1 
 lib/math/test_mul_u64_u64_div_u64.c |   98 ++++++++++++++++++++++++++
 3 files changed, 109 insertions(+)

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
--- a/lib/math/Makefile~mul_u64_u64_div_u64-basic-sanity-test
+++ a/lib/math/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_PRIME_NUMBERS)	+= prime_num
 obj-$(CONFIG_RATIONAL)		+= rational.o
 
 obj-$(CONFIG_TEST_DIV64)	+= test_div64.o
+obj-$(CONFIG_TEST_MULDIV64)	+= test_mul_u64_u64_div_u64.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational-test.o
--- /dev/null
+++ a/lib/math/test_mul_u64_u64_div_u64.c
@@ -0,0 +1,98 @@
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

mul_u64_u64_div_u64-make-it-precise-always.patch
mul_u64_u64_div_u64-basic-sanity-test.patch

