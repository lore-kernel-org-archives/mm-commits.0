From: akpm@linux-foundation.org
Subject: [merged] lib-add-test-for-bitmap_parselist.patch removed
 from -mm tree
Date: Mon, 11 Sep 2017 12:42:25 -0700
Message-ID: <20170911194225.2BpHmcnu8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdIKTm0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mchehab@kernel.org, mm-commits@vger.kernel.org, noamca@mellanox.com, ynorov@caviumnetworks.com


The patch titled
     Subject: lib/test_bitmap.c: add test for bitmap_parselist()
has been removed from the -mm tree.  Its filename was
     lib-add-test-for-bitmap_parselist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <ynorov@caviumnetworks.com>
Subject: lib/test_bitmap.c: add test for bitmap_parselist()

Do some basic checks for bitmap_parselist().

[akpm@linux-foundation.org: fix printk warning]
Link: http://lkml.kernel.org/r/20170807225438.16161-2-ynorov@caviumnetworks.com
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Cc: Noam Camus <noamca@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   74 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff -puN lib/test_bitmap.c~lib-add-test-for-bitmap_parselist lib/test_bitmap.c
--- a/lib/test_bitmap.c~lib-add-test-for-bitmap_parselist
+++ a/lib/test_bitmap.c
@@ -165,6 +165,79 @@ static void __init test_zero_fill_copy(v
 	expect_eq_pbl("128-1023", bmap2, 1024);
 }
 
+#define PARSE_TIME 0x1
+
+struct test_bitmap_parselist{
+	const int errno;
+	const char *in;
+	const unsigned long *expected;
+	const int nbits;
+	const int flags;
+};
+
+static const unsigned long exp[] = {1, 2, 0x0000ffff, 0xffff0000, 0x55555555,
+				0xaaaaaaaa, 0x11111111, 0x22222222, 0xffffffff,
+				0xfffffffe, 0x3333333311111111, 0xffffffff77777777};
+static const unsigned long exp2[] = {0x3333333311111111, 0xffffffff77777777};
+
+static const struct test_bitmap_parselist parselist_tests[] __initconst = {
+	{0, "0",			&exp[0], 8, 0},
+	{0, "1",			&exp[1], 8, 0},
+	{0, "0-15",			&exp[2], 32, 0},
+	{0, "16-31",			&exp[3], 32, 0},
+	{0, "0-31:1/2",			&exp[4], 32, 0},
+	{0, "1-31:1/2",			&exp[5], 32, 0},
+	{0, "0-31:1/4",			&exp[6], 32, 0},
+	{0, "1-31:1/4",			&exp[7], 32, 0},
+	{0, "0-31:4/4",			&exp[8], 32, 0},
+	{0, "1-31:4/4",			&exp[9], 32, 0},
+	{0, "0-31:1/4,32-63:2/4",	&exp[10], 64, 0},
+	{0, "0-31:3/4,32-63:4/4",	&exp[11], 64, 0},
+
+	{0, "0-31:1/4,32-63:2/4,64-95:3/4,96-127:4/4",	exp2, 128, 0},
+
+	{0, "0-2047:128/256", NULL, 2048, PARSE_TIME},
+
+	{-EINVAL, "-1",	NULL, 8, 0},
+	{-EINVAL, "-0",	NULL, 8, 0},
+	{-EINVAL, "10-1", NULL, 8, 0},
+	{-EINVAL, "0-31:10/1", NULL, 8, 0},
+};
+
+static void __init test_bitmap_parselist(void)
+{
+	int i;
+	int err;
+	cycles_t cycles;
+	DECLARE_BITMAP(bmap, 2048);
+
+	for (i = 0; i < ARRAY_SIZE(parselist_tests); i++) {
+#define ptest parselist_tests[i]
+
+		cycles = get_cycles();
+		err = bitmap_parselist(ptest.in, bmap, ptest.nbits);
+		cycles = get_cycles() - cycles;
+
+		if (err != ptest.errno) {
+			pr_err("test %d: input is %s, errno is %d, expected %d\n",
+					i, ptest.in, err, ptest.errno);
+			continue;
+		}
+
+		if (!err && ptest.expected
+			 && !__bitmap_equal(bmap, ptest.expected, ptest.nbits)) {
+			pr_err("test %d: input is %s, result is 0x%lx, expected 0x%lx\n",
+					i, ptest.in, bmap[0], *ptest.expected);
+			continue;
+		}
+
+		if (ptest.flags & PARSE_TIME)
+			pr_err("test %d: input is '%s' OK, Time: %llu\n",
+					i, ptest.in,
+					(unsigned long long)cycles);
+	}
+}
+
 static void __init test_bitmap_u32_array_conversions(void)
 {
 	DECLARE_BITMAP(bmap1, 1024);
@@ -365,6 +438,7 @@ static int __init test_bitmap_init(void)
 {
 	test_zero_fill_copy();
 	test_bitmap_u32_array_conversions();
+	test_bitmap_parselist();
 	test_mem_optimisations();
 
 	if (failed_tests == 0)
_

Patches currently in -mm which might be from ynorov@caviumnetworks.com are


