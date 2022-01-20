Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337BAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377930AbiATVap (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60254 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377923AbiATVap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CE3EB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51A7C340E0;
        Thu, 20 Jan 2022 21:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714243;
        bh=tc7tMp7fPBg0SKCx10too9Pl8v9usRV8nZuKvdQeppw=;
        h=Date:From:To:Subject:From;
        b=gvBsBkx3X9tXC9l3Boz5CThQ7EngJjDkPk+S1ZDrVE+nOMxwDYLknijNkl8ScGV9Q
         X5H6To7lwMzZOFrRbWhNrC8TfqXK3A6vASB/EJ5j+nCpSwXbNM32PrEGl5KzUpIvon
         Pw1/CH1HvbgeGFavJ2NATihz/kdLQ1CBnudXF5ZU=
Date:   Thu, 20 Jan 2022 13:30:42 -0800
From:   akpm@linux-foundation.org
To:     augusto.duraes33@gmail.com, brendanhiggins@google.com,
        davidgow@google.com, dlatypov@google.com, ferreiraenzoa@gmail.com,
        geert@linux-m68k.org, isabbasso@riseup.net, lkp@intel.com,
        mm-commits@vger.kernel.org, rodrigosiqueiramelo@gmail.com,
        skhan@linuxfoundation.org
Subject:  [merged] test_hashc-refactor-into-kunit.patch removed
 from -mm tree
Message-ID: <20220120213042.sljOypQoQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_hash.c: refactor into kunit
has been removed from the -mm tree.  Its filename was
     test_hashc-refactor-into-kunit.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Isabella Basso <isabbasso@riseup.net>
Subject: test_hash.c: refactor into kunit

Use KUnit framework to make tests more easily integrable with CIs.  Even
though these tests are not yet properly written as unit tests this change
should help in debugging.

Also remove kernel messages (i.e.  through pr_info) as KUnit handles all
debugging output and let it handle module init and exit details.

Link: https://lkml.kernel.org/r/20211208183711.390454-6-isabbasso@riseup.net
Reviewed-by: David Gow <davidgow@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: David Gow <davidgow@google.com>
Co-developed-by: Augusto Dur=C3=A3es Camargo <augusto.duraes33@gmail.com>
Signed-off-by: Augusto Dur=C3=A3es Camargo <augusto.duraes33@gmail.com>
Co-developed-by: Enzo Ferreira <ferreiraenzoa@gmail.com>
Signed-off-by: Enzo Ferreira <ferreiraenzoa@gmail.com>
Signed-off-by: Isabella Basso <isabbasso@riseup.net>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   28 ++++--
 lib/Makefile      |    2=20
 lib/test_hash.c   |  194 +++++++++++++-------------------------------
 3 files changed, 81 insertions(+), 143 deletions(-)

--- a/lib/Kconfig.debug~test_hashc-refactor-into-kunit
+++ a/lib/Kconfig.debug
@@ -2213,15 +2213,6 @@ config TEST_RHASHTABLE
=20
 	  If unsure, say N.
=20
-config TEST_HASH
-	tristate "Perform selftest on hash functions"
-	help
-	  Enable this option to test the kernel's integer (<linux/hash.h>), and
-	  string (<linux/stringhash.h>) hash functions on boot (or module load).
-
-	  This is intended to help people writing architecture-specific
-	  optimized versions.  If unsure, say N.
-
 config TEST_SIPHASH
 	tristate "Perform selftest on siphash functions"
 	help
@@ -2370,6 +2361,25 @@ config BITFIELD_KUNIT
=20
 	  If unsure, say N.
=20
+config HASH_KUNIT_TEST
+	tristate "KUnit Test for integer hash functions" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test the kernel's string (<linux/stringhash.h>), =
and
+	  integer (<linux/hash.h>) hash functions on boot.
+
+	  KUnit tests run during boot and output the results to the debug log
+	  in TAP format (https://testanything.org/). Only useful for kernel devs
+	  running the KUnit test harness, and not intended for inclusion into a
+	  production build.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions. If unsure, say N.
+
 config RESOURCE_KUNIT_TEST
 	tristate "KUnit test for resource API"
 	depends on KUNIT
--- a/lib/Makefile~test_hashc-refactor-into-kunit
+++ a/lib/Makefile
@@ -62,7 +62,7 @@ obj-$(CONFIG_TEST_BITOPS) +=3D test_bitops
 CFLAGS_test_bitops.o +=3D -Werror
 obj-$(CONFIG_TEST_SYSCTL) +=3D test_sysctl.o
 obj-$(CONFIG_TEST_SIPHASH) +=3D test_siphash.o
-obj-$(CONFIG_TEST_HASH) +=3D test_hash.o
+obj-$(CONFIG_HASH_KUNIT_TEST) +=3D test_hash.o
 obj-$(CONFIG_TEST_IDA) +=3D test_ida.o
 obj-$(CONFIG_KASAN_KUNIT_TEST) +=3D test_kasan.o
 CFLAGS_test_kasan.o +=3D -fno-builtin
--- a/lib/test_hash.c~test_hashc-refactor-into-kunit
+++ a/lib/test_hash.c
@@ -14,17 +14,15 @@
  * and hash_64().
  */
=20
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt "\n"
-
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/hash.h>
 #include <linux/stringhash.h>
-#include <linux/printk.h>
+#include <kunit/test.h>
=20
 /* 32-bit XORSHIFT generator.  Seed must not be zero. */
-static u32 __init __attribute_const__
+static u32 __attribute_const__
 xorshift(u32 seed)
 {
 	seed ^=3D seed << 13;
@@ -34,7 +32,7 @@ xorshift(u32 seed)
 }
=20
 /* Given a non-zero x, returns a non-zero byte. */
-static u8 __init __attribute_const__
+static u8 __attribute_const__
 mod255(u32 x)
 {
 	x =3D (x & 0xffff) + (x >> 16);	/* 1 <=3D x <=3D 0x1fffe */
@@ -45,8 +43,7 @@ mod255(u32 x)
 }
=20
 /* Fill the buffer with non-zero bytes. */
-static void __init
-fill_buf(char *buf, size_t len, u32 seed)
+static void fill_buf(char *buf, size_t len, u32 seed)
 {
 	size_t i;
=20
@@ -71,40 +68,32 @@ struct test_hash_params {
 };
=20
 #ifdef HAVE_ARCH__HASH_32
-static bool __init
-test_int__hash_32(struct test_hash_params *params)
+static void
+test_int__hash_32(struct kunit *test, struct test_hash_params *params)
 {
 	params->hash_or[1][0] |=3D params->h2 =3D __hash_32_generic(params->h0);
 #if HAVE_ARCH__HASH_32 =3D=3D 1
-	if (params->h1 !=3D params->h2) {
-		pr_err("__hash_32(%#x) =3D %#x !=3D __hash_32_generic() =3D %#x",
-		       params->h0, params->h1, params->h2);
-		return false;
-	}
+	KUNIT_EXPECT_EQ_MSG(test, params->h1, params->h2,
+			    "__hash_32(%#x) =3D %#x !=3D __hash_32_generic() =3D %#x",
+			    params->h0, params->h1, params->h2);
 #endif
-	return true;
 }
 #endif
=20
 #ifdef HAVE_ARCH_HASH_64
-static bool __init
-test_int_hash_64(struct test_hash_params *params, u32 const *m, int *k)
+static void
+test_int_hash_64(struct kunit *test, struct test_hash_params *params, u32 =
const *m, int *k)
 {
 	params->h2 =3D hash_64_generic(*params->h64, *k);
 #if HAVE_ARCH_HASH_64 =3D=3D 1
-	if (params->h1 !=3D params->h2) {
-		pr_err("hash_64(%#llx, %d) =3D %#x !=3D hash_64_generic() =3D %#x",
-		       *params->h64, *k, params->h1, params->h2);
-		return false;
-	}
+	KUNIT_EXPECT_EQ_MSG(test, params->h1, params->h2,
+			    "hash_64(%#llx, %d) =3D %#x !=3D hash_64_generic() =3D %#x",
+			    *params->h64, *k, params->h1, params->h2);
 #else
-	if (params->h2 > *m) {
-		pr_err("hash_64_generic(%#llx, %d) =3D %#x > %#x",
-		       *params->h64, *k, params->h1, *m);
-		return false;
-	}
+	KUNIT_EXPECT_LE_MSG(test, params->h1, params->h2,
+			    "hash_64_generic(%#llx, %d) =3D %#x > %#x",
+			    *params->h64, *k, params->h1, *m);
 #endif
-	return true;
 }
 #endif
=20
@@ -117,8 +106,8 @@ test_int_hash_64(struct test_hash_params
  * inline, the code being tested is actually in the module, and you can
  * recompile and re-test the module without rebooting.
  */
-static bool __init
-test_int_hash(unsigned long long h64, u32 hash_or[2][33])
+static void
+test_int_hash(struct kunit *test, unsigned long long h64, u32 hash_or[2][3=
3])
 {
 	int k;
 	struct test_hash_params params =3D { &h64, (u32)h64, 0, 0, hash_or };
@@ -126,8 +115,7 @@ test_int_hash(unsigned long long h64, u3
 	/* Test __hash32 */
 	hash_or[0][0] |=3D params.h1 =3D __hash_32(params.h0);
 #ifdef HAVE_ARCH__HASH_32
-	if (!test_int__hash_32(&params))
-		return false;
+	test_int__hash_32(test, &params);
 #endif
=20
 	/* Test k =3D 1..32 bits */
@@ -136,29 +124,24 @@ test_int_hash(unsigned long long h64, u3
=20
 		/* Test hash_32 */
 		hash_or[0][k] |=3D params.h1 =3D hash_32(params.h0, k);
-		if (params.h1 > m) {
-			pr_err("hash_32(%#x, %d) =3D %#x > %#x", params.h0, k, params.h1, m);
-			return false;
-		}
+		KUNIT_EXPECT_LE_MSG(test, params.h1, m,
+				    "hash_32(%#x, %d) =3D %#x > %#x",
+				    params.h0, k, params.h1, m);
=20
 		/* Test hash_64 */
 		hash_or[1][k] |=3D params.h1 =3D hash_64(h64, k);
-		if (params.h1 > m) {
-			pr_err("hash_64(%#llx, %d) =3D %#x > %#x", h64, k, params.h1, m);
-			return false;
-		}
+		KUNIT_EXPECT_LE_MSG(test, params.h1, m,
+				    "hash_64(%#llx, %d) =3D %#x > %#x",
+				    h64, k, params.h1, m);
 #ifdef HAVE_ARCH_HASH_64
-		if (!test_int_hash_64(&params, &m, &k))
-			return false;
+		test_int_hash_64(test, &params, &m, &k);
 #endif
 	}
-
-	return true;
 }
=20
 #define SIZE 256	/* Run time is cubic in SIZE */
=20
-static int __init test_string_or(void)
+static void test_string_or(struct kunit *test)
 {
 	char buf[SIZE+1];
 	u32 string_or =3D 0;
@@ -178,20 +161,15 @@ static int __init test_string_or(void)
 	} /* j */
=20
 	/* The OR of all the hash values should cover all the bits */
-	if (~string_or) {
-		pr_err("OR of all string hash results =3D %#x !=3D %#x",
-		       string_or, -1u);
-		return -EINVAL;
-	}
-
-	return 0;
+	KUNIT_EXPECT_EQ_MSG(test, string_or, -1u,
+			    "OR of all string hash results =3D %#x !=3D %#x",
+			    string_or, -1u);
 }
=20
-static int __init test_hash_or(void)
+static void test_hash_or(struct kunit *test)
 {
 	char buf[SIZE+1];
 	u32 hash_or[2][33] =3D { { 0, } };
-	unsigned tests =3D 0;
 	unsigned long long h64 =3D 0;
 	int i, j;
=20
@@ -206,39 +184,27 @@ static int __init test_hash_or(void)
 			u32 h0 =3D full_name_hash(buf+i, buf+i, j-i);
=20
 			/* Check that hashlen_string gets the length right */
-			if (hashlen_len(hashlen) !=3D j-i) {
-				pr_err("hashlen_string(%d..%d) returned length"
-					" %u, expected %d",
-					i, j, hashlen_len(hashlen), j-i);
-				return -EINVAL;
-			}
+			KUNIT_EXPECT_EQ_MSG(test, hashlen_len(hashlen), j-i,
+					    "hashlen_string(%d..%d) returned length %u, expected %d",
+					    i, j, hashlen_len(hashlen), j-i);
 			/* Check that the hashes match */
-			if (hashlen_hash(hashlen) !=3D h0) {
-				pr_err("hashlen_string(%d..%d) =3D %08x !=3D "
-					"full_name_hash() =3D %08x",
-					i, j, hashlen_hash(hashlen), h0);
-				return -EINVAL;
-			}
+			KUNIT_EXPECT_EQ_MSG(test, hashlen_hash(hashlen), h0,
+					    "hashlen_string(%d..%d) =3D %08x !=3D full_name_hash() =3D %08x",
+					    i, j, hashlen_hash(hashlen), h0);
=20
 			h64 =3D h64 << 32 | h0;	/* For use with hash_64 */
-			if (!test_int_hash(h64, hash_or))
-				return -EINVAL;
-			tests++;
+			test_int_hash(test, h64, hash_or);
 		} /* i */
 	} /* j */
=20
-	if (~hash_or[0][0]) {
-		pr_err("OR of all __hash_32 results =3D %#x !=3D %#x",
-			hash_or[0][0], -1u);
-		return -EINVAL;
-	}
+	KUNIT_EXPECT_EQ_MSG(test, hash_or[0][0], -1u,
+			    "OR of all __hash_32 results =3D %#x !=3D %#x",
+			    hash_or[0][0], -1u);
 #ifdef HAVE_ARCH__HASH_32
 #if HAVE_ARCH__HASH_32 !=3D 1	/* Test is pointless if results match */
-	if (~hash_or[1][0]) {
-		pr_err("OR of all __hash_32_generic results =3D %#x !=3D %#x",
-			hash_or[1][0], -1u);
-		return -EINVAL;
-	}
+	KUNIT_EXPECT_EQ_MSG(test, hash_or[1][0], -1u,
+			    "OR of all __hash_32_generic results =3D %#x !=3D %#x",
+			    hash_or[1][0], -1u);
 #endif
 #endif
=20
@@ -246,65 +212,27 @@ static int __init test_hash_or(void)
 	for (i =3D 1; i <=3D 32; i++) {
 		u32 const m =3D ((u32)2 << (i-1)) - 1;	/* Low i bits set */
=20
-		if (hash_or[0][i] !=3D m) {
-			pr_err("OR of all hash_32(%d) results =3D %#x "
-				"(%#x expected)", i, hash_or[0][i], m);
-			return -EINVAL;
-		}
-		if (hash_or[1][i] !=3D m) {
-			pr_err("OR of all hash_64(%d) results =3D %#x "
-				"(%#x expected)", i, hash_or[1][i], m);
-			return -EINVAL;
-		}
+		KUNIT_EXPECT_EQ_MSG(test, hash_or[0][i], m,
+				    "OR of all hash_32(%d) results =3D %#x (%#x expected)",
+				    i, hash_or[0][i], m);
+		KUNIT_EXPECT_EQ_MSG(test, hash_or[1][i], m,
+				    "OR of all hash_64(%d) results =3D %#x (%#x expected)",
+				    i, hash_or[1][i], m);
 	}
-
-	pr_notice("%u tests passed.", tests);
-
-	return 0;
 }
=20
-static void __init notice_skipped_tests(void)
-{
-	/* Issue notices about skipped tests. */
-#ifdef HAVE_ARCH__HASH_32
-#if HAVE_ARCH__HASH_32 !=3D 1
-	pr_info("__hash_32() is arch-specific; not compared to generic.");
-#endif
-#else
-	pr_info("__hash_32() has no arch implementation to test.");
-#endif
-#ifdef HAVE_ARCH_HASH_64
-#if HAVE_ARCH_HASH_64 !=3D 1
-	pr_info("hash_64() is arch-specific; not compared to generic.");
-#endif
-#else
-	pr_info("hash_64() has no arch implementation to test.");
-#endif
-}
-
-static int __init
-test_hash_init(void)
-{
-	int ret;
-
-	ret =3D test_string_or();
-	if (ret < 0)
-		return ret;
-
-	ret =3D test_hash_or();
-	if (ret < 0)
-		return ret;
-
-	notice_skipped_tests();
+static struct kunit_case hash_test_cases[] __refdata =3D {
+	KUNIT_CASE(test_string_or),
+	KUNIT_CASE(test_hash_or),
+	{}
+};
=20
-	return ret;
-}
+static struct kunit_suite hash_test_suite =3D {
+	.name =3D "hash",
+	.test_cases =3D hash_test_cases,
+};
=20
-static void __exit test_hash_exit(void)
-{
-}
=20
-module_init(test_hash_init);	/* Does everything */
-module_exit(test_hash_exit);	/* Does nothing */
+kunit_test_suite(hash_test_suite);
=20
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from isabbasso@riseup.net are


