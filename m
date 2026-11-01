Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793561086;
	b=C4PDy07h6VHBYpLl5wrT5HVeB1mrBpYMjDkfAHaLdELTE8Khc/cefIAptibQnsI8iiz+
	 um2Ruz1vJGlHZFBs6fA4sIoKQIB60MJdrNav5G6JEIeEkVVlVkpbqPx2634nV9U74axWF
	 b0RKdpqCM6+7vrNFf+qPv5JYLdHSHaTBaRpDSC0tn89MoU4gN6G67+9kbNvIuZpQ+S5qS
	 HZI9spp1xrGbHHSDdhGy8CegzL69TGQS4oVmK96Y5VxISIJaehdbKshQor3hKr8WGo19z
	 CAc9sDRXdWEebmtSRzRekPz8HYX0wOVCBiZwxrYg7WnveI/u5P7V94Sa/Xtj42GU96Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793561086;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BFL31ghs5GTV7vHd2u128mIg2lN/GK7xiZdsXrn7X80=;
	b=m2GEEscpOzysTLPCvM0gaBzNZW3eHPO+ekGXxUsfpesdHPChNbipO+2Xrga6NojY9y+Z
	 22K1aXbXMLXONzRhC3PFfwsuIqGfr6zs1DZte0d3EsHeWiucCssowqcdBUVgIarMTnn7T
	 Lao/oto7tp9Dt7P5wYzOp+QCvoSvtG8y7ZdGTXOi8fLiSX+OrUks9q6KixVrrHZQXJ4AS
	 Ok4SfkOfhwnY1ebNxbddWk2O9LqwOmKU2st9mc86Udn/22WmHaK4Bt6eWwXwmytOvFTgr
	 hRADOnn3nZxhgn5j9MVdMtXTs4mmrb5PZZ2P8jGGAcrjhbd9aPxNfl2GKZTJvAcV+2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PFUu9Mt2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C6C606A326
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 19:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PFUu9Mt2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEE81F000C1;
	Sun,  1 Nov 2026 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793561085;
	bh=BFL31ghs5GTV7vHd2u128mIg2lN/GK7xiZdsXrn7X80=;
	h=Date:To:From:Subject;
	b=PFUu9Mt2Kd06DR0E+NZ3d0P9LcYbPGF7Ssm1eiZQYjtgwp6pIt98DedVVnK5LJXPL
	 uI+cv/QFAlOShnTiAd3n4gj02LGxBDJTYgeUkg2rshaHfjbw1dVJKv3pK2+DiscGs7
	 LgZmZTl64y+Rq7zFAx/ihpxN2FNjSYEPcxSlTPHQ=
Date: Sun, 01 Nov 2026 11:24:45 -0800
To: mm-commits@vger.kernel.org,shinichiro.kawasaki@wdc.com,
	keithrteeple@gmail.com,david@davidgow.net,axboe@kernel.dk,szwyb123@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sbitmap-add-kunit-test-suite.patch added to mm-nonmm-unstable branch
Message-Id: <20261101192445.9CEE81F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/sbitmap: add KUnit test suite
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sbitmap-add-kunit-test-suite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sbitmap-add-kunit-test-suite.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wang Yibo <szwyb123@gmail.com>
Subject: lib/sbitmap: add KUnit test suite
Date: Fri, 16 Oct 2026 15:32:53 +0800

sbitmap is the tag allocator used by blk-mq and the I/O schedulers built
on top of it, but the plain, synchronous part of its API has no test
coverage at all.

Add a KUnit suite covering initialisation, allocation and exhaustion,
deferred clears, round-robin ordering, resize, the bitmap helpers and
sbitmap_for_each_set(), so that the behaviour is checked on every boot.

The new file is added to the BLOCK LAYER entry in MAINTAINERS, next to
lib/sbitmap.c, so that it does not end up without a maintainer.

Link: https://lore.kernel.org/20261016073253.520971-1-szwyb123@gmail.com
Signed-off-by: Wang Yibo <szwyb123@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Gow <david@davidgow.net>
Tested-by: Keith Teeple <keithrteeple@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---

 MAINTAINERS               |    1 
 lib/Kconfig.debug         |   13 +
 lib/tests/Makefile        |    1 
 lib/tests/sbitmap_kunit.c |  308 ++++++++++++++++++++++++++++++++++++
 4 files changed, 323 insertions(+)

--- a/lib/Kconfig.debug~lib-sbitmap-add-kunit-test-suite
+++ a/lib/Kconfig.debug
@@ -2503,6 +2503,19 @@ config PRINTF_KUNIT_TEST
 
 	  If unsure, say N.
 
+config SBITMAP_KUNIT_TEST
+	tristate "KUnit test for sbitmap" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on SBITMAP
+	default KUNIT_ALL_TESTS
+	help
+	  Enable to turn on sbitmap tests, running at boot or module load time.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config SCANF_KUNIT_TEST
 	tristate "KUnit test scanf() family of functions at runtime" if !KUNIT_ALL_TESTS
 	depends on KUNIT
--- a/lib/tests/Makefile~lib-sbitmap-add-kunit-test-suite
+++ a/lib/tests/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_OVERFLOW_KUNIT_TEST) += ove
 obj-$(CONFIG_PRANDOM_KUNIT_TEST) += random32_kunit.o
 obj-$(CONFIG_PRINTF_KUNIT_TEST) += printf_kunit.o
 obj-$(CONFIG_RANDSTRUCT_KUNIT_TEST) += randstruct_kunit.o
+obj-$(CONFIG_SBITMAP_KUNIT_TEST) += sbitmap_kunit.o
 obj-$(CONFIG_SCANF_KUNIT_TEST) += scanf_kunit.o
 obj-$(CONFIG_SEQ_BUF_KUNIT_TEST) += seq_buf_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
diff --git a/lib/tests/sbitmap_kunit.c a/lib/tests/sbitmap_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/sbitmap_kunit.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for the scalable bitmap (sbitmap) implementation.
+ *
+ * sbitmap is the tag allocator used by blk-mq and the I/O schedulers built on
+ * top of it, but it has no tests.  These tests pin down the observable
+ * behaviour of the plain, synchronous parts of the API.
+ *
+ * Copyright (C) 2026 Wang Yibo <szwyb123@gmail.com>
+ */
+
+#include <linux/bitmap.h>
+#include <linux/gfp.h>
+#include <linux/sbitmap.h>
+
+#include <kunit/test.h>
+
+/*
+ * Big enough to span several words for any plausible BITS_PER_LONG, and not a
+ * power of two so that the last word is partially used.
+ */
+#define SBITMAP_TEST_DEPTH	(3 * BITS_PER_LONG + 5)
+
+static void sbitmap_test_init(struct kunit *test)
+{
+	const unsigned int depth = 97;
+	struct sbitmap sb;
+	int ret;
+
+	ret = sbitmap_init_node(&sb, depth, -1, GFP_KERNEL, NUMA_NO_NODE,
+				false, true);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, sb.depth, depth);
+	KUNIT_EXPECT_EQ(test, sb.shift,
+			(unsigned int)sbitmap_calculate_shift(depth));
+	KUNIT_EXPECT_EQ(test, sb.map_nr, DIV_ROUND_UP(depth, 1U << sb.shift));
+	KUNIT_EXPECT_FALSE(test, sb.round_robin);
+	/*
+	 * alloc_hint is a __percpu pointer, which the generic pointer
+	 * assertions cannot take: on x86, where percpu data lives in
+	 * __seg_gs, passing it through a const void * does not compile.
+	 * Test it as a plain boolean instead.
+	 */
+	KUNIT_EXPECT_TRUE(test, sb.alloc_hint);
+	KUNIT_EXPECT_FALSE(test, sbitmap_any_bit_set(&sb));
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb), 0U);
+	sbitmap_free(&sb);
+
+	/* An explicitly requested shift is honoured. */
+	ret = sbitmap_init_node(&sb, depth, 3, GFP_KERNEL, NUMA_NO_NODE,
+				false, true);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, sb.shift, 3U);
+	KUNIT_EXPECT_EQ(test, sb.map_nr, DIV_ROUND_UP(depth, 1U << 3));
+	sbitmap_free(&sb);
+
+	/* BITS_PER_LONG bits per word is the largest representable granularity. */
+	ret = sbitmap_init_node(&sb, depth, ilog2(BITS_PER_LONG), GFP_KERNEL,
+				NUMA_NO_NODE, false, true);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, sb.shift, (unsigned int)ilog2(BITS_PER_LONG));
+	KUNIT_EXPECT_EQ(test, sb.map_nr, DIV_ROUND_UP(depth, BITS_PER_LONG));
+	sbitmap_free(&sb);
+
+	/* Anything above that cannot be represented and must be rejected. */
+	ret = sbitmap_init_node(&sb, depth, ilog2(BITS_PER_LONG) + 1,
+				GFP_KERNEL, NUMA_NO_NODE, false, true);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+}
+
+static void sbitmap_test_calculate_shift(struct kunit *test)
+{
+	/* Maps too small to spread over several words keep the default. */
+	KUNIT_EXPECT_EQ(test, sbitmap_calculate_shift(0), ilog2(BITS_PER_LONG));
+	KUNIT_EXPECT_EQ(test, sbitmap_calculate_shift(1), ilog2(BITS_PER_LONG));
+	KUNIT_EXPECT_EQ(test, sbitmap_calculate_shift(3), ilog2(BITS_PER_LONG));
+
+	/* Four bits map to one bit per word. */
+	KUNIT_EXPECT_EQ(test, sbitmap_calculate_shift(4), 0);
+
+	/* The shift grows back as the depth increases. */
+	KUNIT_EXPECT_EQ(test, sbitmap_calculate_shift(4 * BITS_PER_LONG - 1),
+			ilog2(BITS_PER_LONG) - 1);
+	KUNIT_EXPECT_EQ(test, sbitmap_calculate_shift(4 * BITS_PER_LONG),
+			ilog2(BITS_PER_LONG));
+}
+
+static void sbitmap_test_get_exhaust(struct kunit *test)
+{
+	DECLARE_BITMAP(seen, SBITMAP_TEST_DEPTH) = { 0 };
+	struct sbitmap sb;
+	unsigned int i;
+	int bit;
+
+	KUNIT_ASSERT_EQ(test, sbitmap_init_node(&sb, SBITMAP_TEST_DEPTH, -1,
+						GFP_KERNEL, NUMA_NO_NODE,
+						false, true), 0);
+
+	/* Every bit is handed out exactly once, then the map is empty. */
+	for (i = 0; i < SBITMAP_TEST_DEPTH; i++) {
+		bit = sbitmap_get(&sb);
+		KUNIT_ASSERT_GE(test, bit, 0);
+		KUNIT_ASSERT_LT(test, bit, (int)SBITMAP_TEST_DEPTH);
+		KUNIT_ASSERT_FALSE(test, test_bit(bit, seen));
+		__set_bit(bit, seen);
+	}
+
+	KUNIT_EXPECT_TRUE(test, sbitmap_any_bit_set(&sb));
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb),
+			(unsigned int)SBITMAP_TEST_DEPTH);
+	KUNIT_EXPECT_EQ(test, sbitmap_get(&sb), -1);
+
+	sbitmap_free(&sb);
+}
+
+static void sbitmap_test_put_reuse(struct kunit *test)
+{
+	struct sbitmap sb;
+	unsigned int i;
+	int bit;
+
+	KUNIT_ASSERT_EQ(test, sbitmap_init_node(&sb, BITS_PER_LONG, -1,
+						GFP_KERNEL, NUMA_NO_NODE,
+						true, true), 0);
+
+	for (i = 0; i < BITS_PER_LONG; i++)
+		KUNIT_ASSERT_GE(test, sbitmap_get(&sb), 0);
+
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb), (unsigned int)BITS_PER_LONG);
+	KUNIT_EXPECT_EQ(test, sbitmap_get(&sb), -1);
+
+	/*
+	 * Freeing a single bit must make exactly that bit available again, no
+	 * matter which bit it was.
+	 */
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		sbitmap_put(&sb, i);
+		KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb),
+				(unsigned int)BITS_PER_LONG - 1);
+		bit = sbitmap_get(&sb);
+		KUNIT_EXPECT_EQ(test, bit, (int)i);
+		KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb),
+				(unsigned int)BITS_PER_LONG);
+		KUNIT_EXPECT_EQ(test, sbitmap_get(&sb), -1);
+	}
+
+	sbitmap_free(&sb);
+}
+
+static void sbitmap_test_round_robin(struct kunit *test)
+{
+	struct sbitmap sb;
+	unsigned int i;
+	int bit, prev = -1;
+
+	KUNIT_ASSERT_EQ(test, sbitmap_init_node(&sb, SBITMAP_TEST_DEPTH, -1,
+						GFP_KERNEL, NUMA_NO_NODE,
+						true, true), 0);
+
+	/*
+	 * round_robin must hand out strictly increasing bit numbers while the
+	 * map fills up from empty.
+	 */
+	for (i = 0; i < SBITMAP_TEST_DEPTH; i++) {
+		bit = sbitmap_get(&sb);
+		KUNIT_ASSERT_GE(test, bit, 0);
+		KUNIT_ASSERT_LT(test, bit, (int)SBITMAP_TEST_DEPTH);
+		if (prev != -1)
+			KUNIT_ASSERT_GT(test, bit, prev);
+		prev = bit;
+	}
+
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb),
+			(unsigned int)SBITMAP_TEST_DEPTH);
+	KUNIT_EXPECT_EQ(test, sbitmap_get(&sb), -1);
+
+	sbitmap_free(&sb);
+}
+
+static void sbitmap_test_resize(struct kunit *test)
+{
+	const unsigned int depth = 4 * BITS_PER_LONG;
+	struct sbitmap sb;
+	unsigned int i;
+
+	KUNIT_ASSERT_EQ(test, sbitmap_init_node(&sb, depth, -1, GFP_KERNEL,
+						NUMA_NO_NODE, true, true), 0);
+
+	for (i = 0; i < depth; i++)
+		KUNIT_ASSERT_GE(test, sbitmap_get(&sb), 0);
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb), depth);
+
+	/* Shrinking hides the bits past the new depth. */
+	sbitmap_resize(&sb, depth / 2);
+	KUNIT_EXPECT_EQ(test, sb.depth, depth / 2);
+	KUNIT_EXPECT_EQ(test, sb.map_nr,
+			DIV_ROUND_UP(depth / 2, 1U << sb.shift));
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb), depth / 2);
+	KUNIT_EXPECT_EQ(test, sbitmap_get(&sb), -1);
+
+	/* Growing makes them visible again; they are still allocated. */
+	sbitmap_resize(&sb, depth);
+	KUNIT_EXPECT_EQ(test, sb.depth, depth);
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb), depth);
+	KUNIT_EXPECT_EQ(test, sbitmap_get(&sb), -1);
+
+	sbitmap_free(&sb);
+}
+
+static void sbitmap_test_set_clear_bit(struct kunit *test)
+{
+	static const unsigned int bits[] = {
+		0, 1, BITS_PER_LONG - 1, BITS_PER_LONG,
+		2 * BITS_PER_LONG + 3, SBITMAP_TEST_DEPTH - 1
+	};
+	struct sbitmap sb;
+	unsigned int i;
+
+	KUNIT_ASSERT_EQ(test, sbitmap_init_node(&sb, SBITMAP_TEST_DEPTH, -1,
+						GFP_KERNEL, NUMA_NO_NODE,
+						false, true), 0);
+
+	KUNIT_EXPECT_FALSE(test, sbitmap_any_bit_set(&sb));
+
+	for (i = 0; i < ARRAY_SIZE(bits); i++) {
+		sbitmap_set_bit(&sb, bits[i]);
+		KUNIT_EXPECT_TRUE(test, sbitmap_test_bit(&sb, bits[i]));
+	}
+	KUNIT_EXPECT_TRUE(test, sbitmap_any_bit_set(&sb));
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb), (unsigned int)ARRAY_SIZE(bits));
+
+	for (i = 0; i < ARRAY_SIZE(bits); i++) {
+		sbitmap_clear_bit(&sb, bits[i]);
+		KUNIT_EXPECT_FALSE(test, sbitmap_test_bit(&sb, bits[i]));
+	}
+	KUNIT_EXPECT_FALSE(test, sbitmap_any_bit_set(&sb));
+	KUNIT_EXPECT_EQ(test, sbitmap_weight(&sb), 0U);
+
+	sbitmap_free(&sb);
+}
+
+struct sbitmap_iter_ctx {
+	struct kunit *test;
+	DECLARE_BITMAP(visited, SBITMAP_TEST_DEPTH);
+	unsigned int nr_visited;
+};
+
+static bool sbitmap_iter_collect(struct sbitmap *sb, unsigned int bitnr,
+				 void *data)
+{
+	struct sbitmap_iter_ctx *ctx = data;
+
+	KUNIT_ASSERT_LT(ctx->test, bitnr, SBITMAP_TEST_DEPTH);
+	__set_bit(bitnr, ctx->visited);
+	ctx->nr_visited++;
+
+	return true;
+}
+
+static void sbitmap_test_iterate_set(struct kunit *test)
+{
+	static const unsigned int bits[] = {
+		0, 5, BITS_PER_LONG - 1, BITS_PER_LONG, 2 * BITS_PER_LONG + 3,
+		SBITMAP_TEST_DEPTH - 1
+	};
+	struct sbitmap_iter_ctx ctx = { .test = test };
+	struct sbitmap sb;
+	unsigned int i;
+
+	KUNIT_ASSERT_EQ(test, sbitmap_init_node(&sb, SBITMAP_TEST_DEPTH, -1,
+						GFP_KERNEL, NUMA_NO_NODE,
+						false, true), 0);
+
+	for (i = 0; i < ARRAY_SIZE(bits); i++) {
+		KUNIT_ASSERT_LT(test, bits[i], SBITMAP_TEST_DEPTH);
+		sbitmap_set_bit(&sb, bits[i]);
+	}
+
+	sbitmap_for_each_set(&sb, sbitmap_iter_collect, &ctx);
+
+	KUNIT_EXPECT_EQ(test, ctx.nr_visited, (unsigned int)ARRAY_SIZE(bits));
+	for (i = 0; i < ARRAY_SIZE(bits); i++)
+		KUNIT_EXPECT_TRUE(test, test_bit(bits[i], ctx.visited));
+
+	sbitmap_free(&sb);
+}
+
+static struct kunit_case sbitmap_test_cases[] = {
+	KUNIT_CASE(sbitmap_test_init),
+	KUNIT_CASE(sbitmap_test_calculate_shift),
+	KUNIT_CASE(sbitmap_test_get_exhaust),
+	KUNIT_CASE(sbitmap_test_put_reuse),
+	KUNIT_CASE(sbitmap_test_round_robin),
+	KUNIT_CASE(sbitmap_test_resize),
+	KUNIT_CASE(sbitmap_test_set_clear_bit),
+	KUNIT_CASE(sbitmap_test_iterate_set),
+	{}
+};
+
+static struct kunit_suite sbitmap_test_suite = {
+	.name = "sbitmap",
+	.test_cases = sbitmap_test_cases,
+};
+
+kunit_test_suite(sbitmap_test_suite);
+
+MODULE_DESCRIPTION("KUnit test for sbitmap");
+MODULE_LICENSE("GPL");
--- a/MAINTAINERS~lib-sbitmap-add-kunit-test-suite
+++ a/MAINTAINERS
@@ -4833,6 +4833,7 @@ F:	include/uapi/linux/blk*
 F:	include/uapi/linux/ioprio.h
 F:	kernel/trace/blktrace.c
 F:	lib/sbitmap.c
+F:	lib/tests/sbitmap_kunit.c
 
 BLOCK LAYER DEVICE DRIVER API [RUST]
 M:	Andreas Hindborg <a.hindborg@kernel.org>
_

Patches currently in -mm which might be from szwyb123@gmail.com are

lib-sbitmap-add-kunit-test-suite.patch

