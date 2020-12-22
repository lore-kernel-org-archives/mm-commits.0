Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13968C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF5222AB9
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgLVUnN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:43:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgLVUnN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7390C22AB9;
        Tue, 22 Dec 2020 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608669752;
        bh=3NK0+ZukGgNe3x2kARhAp7qaM0dirOMFNbXhXTdJkOs=;
        h=Date:From:To:Subject:From;
        b=aw/LG/0Ot+9pnBEZMPGgtucxd1ihjYMt3TTduiVp7ecx3VVS4/0PArGiL4YtCAAeC
         3Qc+MsPqqtGQ9MKgVI6ALzSf2rXchchkxKo9qylaHxWR1XTn5SBXfpw8jp0WMA3aTt
         fdhiI+Oi3ExLVCIiTt5rqp7/Gn8gBndwgIT1beFE=
Date:   Tue, 22 Dec 2020 12:42:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vilhelm.gray@gmail.com,
        andriy.shevchenko@linux.intel.com, syednwaris@gmail.com
Subject:  [to-be-updated]
 lib-test_bitmapc-add-for_each_set_clump-test-cases.patch removed from -mm
 tree
Message-ID: <20201222204232.tbD33%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bitmap.c: add for_each_set_clump test cases
has been removed from the -mm tree.  Its filename was
     lib-test_bitmapc-add-for_each_set_clump-test-cases.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Syed Nayyar Waris <syednwaris@gmail.com>
Subject: lib/test_bitmap.c: add for_each_set_clump test cases

The introduction of the generic for_each_set_clump macro need test cases
to verify the implementation.  This patch adds test cases for scenarios in
which clump sizes are 8 bits, 24 bits, 30 bits and 6 bits.  The cases
contain situations where clump is getting split at the word boundary and
also when zeroes are present in the start and middle of bitmap.

[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/bf4d78db5d56a6b22e68a4ecb24d4cb09d1a3124.1603055402.git.syednwaris@gmail.com
Signed-off-by: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |  143 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)

--- a/lib/test_bitmap.c~lib-test_bitmapc-add-for_each_set_clump-test-cases
+++ a/lib/test_bitmap.c
@@ -155,6 +155,37 @@ static bool __init __check_eq_clump8(con
 	return true;
 }
 
+static bool __init __check_eq_clump(const char *srcfile, unsigned int line,
+				    const unsigned int offset,
+				    const unsigned int size,
+				    const unsigned long *const clump_exp,
+				    const unsigned long *const clump,
+				    const unsigned long clump_size)
+{
+	unsigned long exp;
+
+	if (offset >= size) {
+		pr_warn("[%s:%u] bit offset for clump out-of-bounds: expected less than %u, got %u\n",
+			srcfile, line, size, offset);
+		return false;
+	}
+
+	exp = clump_exp[offset / clump_size];
+	if (!exp) {
+		pr_warn("[%s:%u] bit offset for zero clump: expected nonzero clump, got bit offset %u with clump value 0",
+			srcfile, line, offset);
+		return false;
+	}
+
+	if (*clump != exp) {
+		pr_warn("[%s:%u] expected clump value of 0x%lX, got clump value of 0x%lX",
+			srcfile, line, exp, *clump);
+		return false;
+	}
+
+	return true;
+}
+
 #define __expect_eq(suffix, ...)					\
 	({								\
 		int result = 0;						\
@@ -172,6 +203,7 @@ static bool __init __check_eq_clump8(con
 #define expect_eq_pbl(...)		__expect_eq(pbl, ##__VA_ARGS__)
 #define expect_eq_u32_array(...)	__expect_eq(u32_array, ##__VA_ARGS__)
 #define expect_eq_clump8(...)		__expect_eq(clump8, ##__VA_ARGS__)
+#define expect_eq_clump(...)		__expect_eq(clump, ##__VA_ARGS__)
 
 static void __init test_zero_clear(void)
 {
@@ -530,6 +562,28 @@ static void noinline __init test_mem_opt
 	}
 }
 
+static const unsigned long clump_bitmap_data[] __initconst = {
+	0x38000201,
+	0x05ff0f38,
+	0xeffedcba,
+	0xbbbbabcd,
+	0x000000aa,
+	0x000000aa,
+	0x00ff0000,
+	0xaaaaaa00,
+	0xff000000,
+	0x00aa0000,
+	0x00000000,
+	0x00000000,
+	0x00000000,
+	0x0f000000,
+	0x00ff0000,
+	0xaaaaaa00,
+	0xff000000,
+	0x00aa0000,
+	0x00000ac0,
+};
+
 static const unsigned char clump_exp[] __initconst = {
 	0x01,	/* 1 bit set */
 	0x02,	/* non-edge 1 bit set */
@@ -541,6 +595,94 @@ static const unsigned char clump_exp[] _
 	0x05,	/* non-adjacent 2 bits set */
 };
 
+static const unsigned long clump_exp1[] __initconst = {
+	0x01,	/* 1 bit set */
+	0x02,	/* non-edge 1 bit set */
+	0x00,	/* zero bits set */
+	0x38,	/* 3 bits set across 4-bit boundary */
+	0x38,	/* Repeated clump */
+	0x0F,	/* 4 bits set */
+	0xFF,	/* all bits set */
+	0x05,	/* non-adjacent 2 bits set */
+};
+
+static const unsigned long clump_exp2[] __initconst = {
+	0xfedcba,	/* 24 bits */
+	0xabcdef,
+	0xaabbbb,	/* Clump split between 2 words */
+	0x000000,	/* zeroes in between */
+	0x0000aa,
+	0x000000,
+	0x0000ff,
+	0xaaaaaa,
+	0x000000,
+	0x0000ff,
+};
+
+static const unsigned long clump_exp3[] __initconst = {
+	0x00000000,	/* starting with 0s*/
+	0x00000000,	/* All 0s */
+	0x00000000,
+	0x00000000,
+	0x3f00000f,     /* Non zero set */
+	0x2aa80003,
+	0x00000aaa,
+	0x00003fc0,
+};
+
+static const unsigned long clump_exp4[] __initconst = {
+	0x00,
+	0x2b,
+};
+
+struct clump_test_data_params {
+	DECLARE_BITMAP(data, 256);
+	unsigned long count;
+	unsigned long offset;
+	unsigned long limit;
+	unsigned long clump_size;
+	unsigned long const *exp;
+};
+
+static struct clump_test_data_params clump_test_data[] __initdata =
+				      { {{0}, 2, 0, 64, 8, clump_exp1},
+					{{0}, 8, 2, 240, 24, clump_exp2},
+					{{0}, 8, 10, 240, 30, clump_exp3},
+					{{0}, 1, 18, 18, 6, clump_exp4} };
+
+static void __init prepare_test_data(unsigned int index)
+{
+	int i;
+	unsigned long width = 0;
+
+	for (i = 0; i < clump_test_data[index].count; i++) {
+		bitmap_set_value(clump_test_data[index].data,
+			clump_bitmap_data[(clump_test_data[index].offset)++], width, 32);
+		width += 32;
+	}
+}
+
+static void __init execute_for_each_set_clump_test(unsigned int index)
+{
+	unsigned long start, clump;
+
+	for_each_set_clump(start, clump, clump_test_data[index].data,
+						clump_test_data[index].limit,
+						clump_test_data[index].clump_size)
+	expect_eq_clump(start, clump_test_data[index].limit, clump_test_data[index].exp,
+						&clump, clump_test_data[index].clump_size);
+}
+
+static void __init test_for_each_set_clump(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(clump_test_data); i++) {
+		prepare_test_data(i);
+		execute_for_each_set_clump_test(i);
+	}
+}
+
 static void __init test_for_each_set_clump8(void)
 {
 #define CLUMP_EXP_NUMBITS 64
@@ -631,6 +773,7 @@ static void __init selftest(void)
 	test_bitmap_parselist();
 	test_mem_optimisations();
 	test_for_each_set_clump8();
+	test_for_each_set_clump();
 	test_bitmap_cut();
 }
 
_

Patches currently in -mm which might be from syednwaris@gmail.com are

gpio-thunderx-utilize-for_each_set_clump-macro.patch
gpio-xilinx-utilize-generic-bitmap_get_value-and-_set_value.patch

