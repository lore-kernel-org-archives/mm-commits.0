From: akpm@linux-foundation.org
Subject: + bitmap-add-test-for-bitmap_cut.patch added to -mm tree
Date: Tue, 16 Jun 2020 12:51:42 -0700
Message-ID: <20200616195142.L3kNm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730393AbgFPTvn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 15:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yury.norov@gmail.com, pablo@netfilter.org, linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, sbrivio@redhat.com


The patch titled
     Subject: lib/test_bitmap.c: add test for bitmap_cut()
has been added to the -mm tree.  Its filename is
     bitmap-add-test-for-bitmap_cut.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-add-test-for-bitmap_cut.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-add-test-for-bitmap_cut.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stefano Brivio <sbrivio@redhat.com>
Subject: lib/test_bitmap.c: add test for bitmap_cut()

Inspired by an original patch from Yury Norov: introduce a test for
bitmap_cut() that also makes sure functionality is as described for
partially overlapping src and dst.

Link: http://lkml.kernel.org/r/5fc45e6bbd4fa837cd9577f8a0c1d639df90a4ce.1592155364.git.sbrivio@redhat.com
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   58 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/lib/test_bitmap.c~bitmap-add-test-for-bitmap_cut
+++ a/lib/test_bitmap.c
@@ -610,6 +610,63 @@ static void __init test_for_each_set_clu
 		expect_eq_clump8(start, CLUMP_EXP_NUMBITS, clump_exp, &clump);
 }
 
+struct test_bitmap_cut {
+	unsigned int first;
+	unsigned int cut;
+	unsigned int nbits;
+	unsigned long in[4];
+	unsigned long expected[4];
+};
+
+static struct test_bitmap_cut test_cut[] = {
+	{  0,  0,  8, { 0x0000000aUL, }, { 0x0000000aUL, }, },
+	{  0,  0, 32, { 0xdadadeadUL, }, { 0xdadadeadUL, }, },
+	{  0,  3,  8, { 0x000000aaUL, }, { 0x00000015UL, }, },
+	{  3,  3,  8, { 0x000000aaUL, }, { 0x00000012UL, }, },
+	{  0,  1, 32, { 0xa5a5a5a5UL, }, { 0x52d2d2d2UL, }, },
+	{  0,  8, 32, { 0xdeadc0deUL, }, { 0x00deadc0UL, }, },
+	{  1,  1, 32, { 0x5a5a5a5aUL, }, { 0x2d2d2d2cUL, }, },
+	{  0, 15, 32, { 0xa5a5a5a5UL, }, { 0x00014b4bUL, }, },
+	{  0, 16, 32, { 0xa5a5a5a5UL, }, { 0x0000a5a5UL, }, },
+	{ 15, 15, 32, { 0xa5a5a5a5UL, }, { 0x000125a5UL, }, },
+	{ 15, 16, 32, { 0xa5a5a5a5UL, }, { 0x0000a5a5UL, }, },
+	{ 16, 15, 32, { 0xa5a5a5a5UL, }, { 0x0001a5a5UL, }, },
+
+	{ BITS_PER_LONG, BITS_PER_LONG, BITS_PER_LONG,
+		{ 0xa5a5a5a5UL, 0xa5a5a5a5UL, },
+		{ 0xa5a5a5a5UL, 0xa5a5a5a5UL, },
+	},
+	{ 1, BITS_PER_LONG - 1, BITS_PER_LONG,
+		{ 0xa5a5a5a5UL, 0xa5a5a5a5UL, },
+		{ 0x00000001UL, 0x00000001UL, },
+	},
+
+	{ 0, BITS_PER_LONG * 2, BITS_PER_LONG * 2 + 1,
+		{ 0xa5a5a5a5UL, 0x00000001UL, 0x00000001UL, 0x00000001UL },
+		{ 0x00000001UL, },
+	},
+	{ 16, BITS_PER_LONG * 2 + 1, BITS_PER_LONG * 2 + 1 + 16,
+		{ 0x0000ffffUL, 0x5a5a5a5aUL, 0x5a5a5a5aUL, 0x5a5a5a5aUL },
+		{ 0x2d2dffffUL, },
+	},
+};
+
+static void __init test_bitmap_cut(void)
+{
+	unsigned long b[5], *in = &b[1], *out = &b[0];	/* Partial overlap */
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cut); i++) {
+		struct test_bitmap_cut *t = &test_cut[i];
+
+		memcpy(in, t->in, sizeof(t->in));
+
+		bitmap_cut(out, in, t->first, t->cut, t->nbits);
+
+		expect_eq_bitmap(t->expected, out, t->nbits);
+	}
+}
+
 static void __init selftest(void)
 {
 	test_zero_clear();
@@ -623,6 +680,7 @@ static void __init selftest(void)
 	test_bitmap_parselist_user();
 	test_mem_optimisations();
 	test_for_each_set_clump8();
+	test_bitmap_cut();
 }
 
 KSTM_MODULE_LOADERS(test_bitmap);
_

Patches currently in -mm which might be from sbrivio@redhat.com are

bitmap-fix-bitmap_cut-for-partial-overlapping-case.patch
bitmap-add-test-for-bitmap_cut.patch
