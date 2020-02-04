From: akpm@linux-foundation.org
Subject: [merged] lib-add-test-for-bitmap_parse.patch removed from
 -mm tree
Date: Tue, 04 Feb 2020 10:42:27 -0800
Message-ID: <20200204184227.8TXgEMKH0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgBDSm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: lib: add test for bitmap_parse()
has been removed from the -mm tree.  Its filename was
     lib-add-test-for-bitmap_parse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: add test for bitmap_parse()

The test is derived from bitmap_parselist() NO_LEN is reserved for use in
following patches.

[yury.norov@gmail.com: fix rebase issue]
  Link: http://lkml.kernel.org/r/20200102182659.6685-1-yury.norov@gmail.com
[andriy.shevchenko@linux.intel.com: fix address space when test user buffer]
  Link: http://lkml.kernel.org/r/20200109103601.45929-2-andriy.shevchenko@linux.intel.com
Link: http://lkml.kernel.org/r/20200102043031.30357-4-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   97 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

--- a/lib/test_bitmap.c~lib-add-test-for-bitmap_parse
+++ a/lib/test_bitmap.c
@@ -295,7 +295,8 @@ static void __init test_replace(void)
 	expect_eq_bitmap(bmap, exp3_1_0, nbits);
 }
 
-#define PARSE_TIME 0x1
+#define PARSE_TIME	0x1
+#define NO_LEN		0x2
 
 struct test_bitmap_parselist{
 	const int errno;
@@ -349,7 +350,6 @@ static const struct test_bitmap_parselis
 	{-EINVAL, "0-31:a/1", NULL, 8, 0},
 	{-EINVAL, "0-\n", NULL, 8, 0},
 
-#undef step
 };
 
 static void __init __test_bitmap_parselist(int is_user)
@@ -401,6 +401,87 @@ static void __init __test_bitmap_parseli
 	}
 }
 
+static const unsigned long parse_test[] __initconst = {
+	BITMAP_FROM_U64(0),
+	BITMAP_FROM_U64(1),
+	BITMAP_FROM_U64(0xdeadbeef),
+	BITMAP_FROM_U64(0x100000000ULL),
+};
+
+static const unsigned long parse_test2[] __initconst = {
+	BITMAP_FROM_U64(0x100000000ULL), BITMAP_FROM_U64(0xdeadbeef),
+	BITMAP_FROM_U64(0x100000000ULL), BITMAP_FROM_U64(0xbaadf00ddeadbeef),
+	BITMAP_FROM_U64(0x100000000ULL), BITMAP_FROM_U64(0x0badf00ddeadbeef),
+};
+
+static const struct test_bitmap_parselist parse_tests[] __initconst = {
+	{0, "0",			&parse_test[0 * step], 32, 0},
+	{0, "1",			&parse_test[1 * step], 32, 0},
+	{0, "deadbeef",			&parse_test[2 * step], 32, 0},
+	{0, "1,0",			&parse_test[3 * step], 33, 0},
+
+	{0, "deadbeef,1,0",		&parse_test2[0 * 2 * step], 96, 0},
+	{0, "baadf00d,deadbeef,1,0",	&parse_test2[1 * 2 * step], 128, 0},
+	{0, "badf00d,deadbeef,1,0",	&parse_test2[2 * 2 * step], 124, 0},
+
+	{-EINVAL,    "goodfood,deadbeef,1,0",	NULL, 128, 0},
+	{-EOVERFLOW, "3,0",			NULL, 33, 0},
+	{-EOVERFLOW, "123badf00d,deadbeef,1,0",	NULL, 128, 0},
+	{-EOVERFLOW, "badf00d,deadbeef,1,0",	NULL, 90, 0},
+	{-EOVERFLOW, "fbadf00d,deadbeef,1,0",	NULL, 95, 0},
+	{-EOVERFLOW, "badf00d,deadbeef,1,0",	NULL, 100, 0},
+#undef step
+};
+
+static void __init __test_bitmap_parse(int is_user)
+{
+	int i;
+	int err;
+	ktime_t time;
+	DECLARE_BITMAP(bmap, 2048);
+	char *mode = is_user ? "_user"  : "";
+
+	for (i = 0; i < ARRAY_SIZE(parse_tests); i++) {
+		struct test_bitmap_parselist test = parse_tests[i];
+
+		if (is_user) {
+			size_t len = strlen(test.in);
+			mm_segment_t orig_fs = get_fs();
+
+			set_fs(KERNEL_DS);
+			time = ktime_get();
+			err = bitmap_parse_user((__force const char __user *)test.in, len,
+						bmap, test.nbits);
+			time = ktime_get() - time;
+			set_fs(orig_fs);
+		} else {
+			size_t len = test.flags & NO_LEN ?
+				UINT_MAX : strlen(test.in);
+			time = ktime_get();
+			err = bitmap_parse(test.in, len, bmap, test.nbits);
+			time = ktime_get() - time;
+		}
+
+		if (err != test.errno) {
+			pr_err("parse%s: %d: input is %s, errno is %d, expected %d\n",
+					mode, i, test.in, err, test.errno);
+			continue;
+		}
+
+		if (!err && test.expected
+			 && !__bitmap_equal(bmap, test.expected, test.nbits)) {
+			pr_err("parse%s: %d: input is %s, result is 0x%lx, expected 0x%lx\n",
+					mode, i, test.in, bmap[0],
+					*test.expected);
+			continue;
+		}
+
+		if (test.flags & PARSE_TIME)
+			pr_err("parse%s: %d: input is '%s' OK, Time: %llu\n",
+					mode, i, test.in, time);
+	}
+}
+
 static void __init test_bitmap_parselist(void)
 {
 	__test_bitmap_parselist(0);
@@ -411,6 +492,16 @@ static void __init test_bitmap_parselist
 	__test_bitmap_parselist(1);
 }
 
+static void __init test_bitmap_parse(void)
+{
+	__test_bitmap_parse(0);
+}
+
+static void __init test_bitmap_parse_user(void)
+{
+	__test_bitmap_parse(1);
+}
+
 #define EXP1_IN_BITS	(sizeof(exp1) * 8)
 
 static void __init test_bitmap_arr32(void)
@@ -516,6 +607,8 @@ static void __init selftest(void)
 	test_copy();
 	test_replace();
 	test_bitmap_arr32();
+	test_bitmap_parse();
+	test_bitmap_parse_user();
 	test_bitmap_parselist();
 	test_bitmap_parselist_user();
 	test_mem_optimisations();
_

Patches currently in -mm which might be from yury.norov@gmail.com are
