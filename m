Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFF71632C8
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765820476; cv=none; b=bUvLEnVHoflvMbZGHReUqy70Wv+1k59Qodskdrbz0plhUqeKO3b6xMxAWfuFBmBngdPiPgYYtyrGdVuK4IMFnqU+nJofJcXYBHIbViEecEMjV0ffC2RlkzGaUGar37ITgfZlP2ATHFBNWTp1A0s2nJ7fS9H9WkhoRMwCLZNhfYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765820476; c=relaxed/simple;
	bh=MTEaIuc5E1E9QQcyMy7KsxBEpyDorPrCrNP/+9/s2f8=;
	h=Date:To:From:Subject:Message-Id; b=DGDz8dXgNRu8W2rLma9rB3eTp3qVHg0HKiCkxm7CsKaWuEzkZyItG88GjzWUOZyPlu4XigfNGjzuq0OC304KPVYSlbgDaLpFQm202DQf7mo6UdyS+iz4MVVek3F7CmOGBa+1zFYA0QLQKoyNcRpw+wbFjgKWtqEkl3ZgfURb/Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XgUVzyaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XgUVzyaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793B5C4CEF5;
	Mon, 15 Dec 2025 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765820475;
	bh=MTEaIuc5E1E9QQcyMy7KsxBEpyDorPrCrNP/+9/s2f8=;
	h=Date:To:From:Subject:From;
	b=XgUVzyaQKmvYDuExQI+JcQ+ndURCCvFAc1lyum2FLuncvWfsNT0qAvzVDCriG+PzC
	 MGWNriHxSPME7i6Gh+Q8mjMHJZG0bXauBLBrPKvTpe3MEHG0vVj4H8mUYt25DI51nr
	 jE3xosL0PYsdaz/kq1+pMO0jaSuB6dPA7vPTN/0E=
Date: Mon, 15 Dec 2025 09:41:14 -0800
To: mm-commits@vger.kernel.org,geert@linux-m68k.org,davidgow@google.com,brendan.higgins@linux.dev,andriy.shevchenko@linux.intel.com,sakamo.ryota@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-convert-test_uuid-module-to-kunit.patch added to mm-nonmm-unstable branch
Message-Id: <20251215174115.793B5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: convert test_uuid module to KUnit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-convert-test_uuid-module-to-kunit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-convert-test_uuid-module-to-kunit.patch

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
From: Ryota Sakamoto <sakamo.ryota@gmail.com>
Subject: lib/tests: convert test_uuid module to KUnit
Date: Mon, 15 Dec 2025 13:43:22 +0000

Move lib/test_uuid.c to lib/tests/uuid_kunit.c and convert it to use KUnit.

This change switches the ad-hoc test code to standard KUnit test cases. 
The test data remains the same, but the verification logic is updated to
use KUNIT_EXPECT_* macros.

Also remove CONFIG_TEST_UUID from arch/*/configs/* because it is no longer
used.  The new CONFIG_UUID_KUNIT_TEST will be automatically enabled by
CONFIG_KUNIT_ALL_TESTS.

Link: https://lkml.kernel.org/r/20251215134322.12949-1-sakamo.ryota@gmail.com
Signed-off-by: Ryota Sakamoto <sakamo.ryota@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/configs/amiga_defconfig    |    1 
 arch/m68k/configs/apollo_defconfig   |    1 
 arch/m68k/configs/atari_defconfig    |    1 
 arch/m68k/configs/bvme6000_defconfig |    1 
 arch/m68k/configs/hp300_defconfig    |    1 
 arch/m68k/configs/mac_defconfig      |    1 
 arch/m68k/configs/multi_defconfig    |    1 
 arch/m68k/configs/mvme147_defconfig  |    1 
 arch/m68k/configs/mvme16x_defconfig  |    1 
 arch/m68k/configs/q40_defconfig      |    1 
 arch/m68k/configs/sun3_defconfig     |    1 
 arch/m68k/configs/sun3x_defconfig    |    1 
 arch/powerpc/configs/ppc64_defconfig |    1 
 lib/Kconfig.debug                    |   14 ++
 lib/Makefile                         |    1 
 lib/test_uuid.c                      |  134 -------------------------
 lib/tests/Makefile                   |    1 
 lib/tests/uuid_kunit.c               |  106 +++++++++++++++++++
 18 files changed, 118 insertions(+), 151 deletions(-)

--- a/arch/m68k/configs/amiga_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/amiga_defconfig
@@ -618,7 +618,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/apollo_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/apollo_defconfig
@@ -575,7 +575,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/atari_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/atari_defconfig
@@ -595,7 +595,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/bvme6000_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/bvme6000_defconfig
@@ -567,7 +567,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/hp300_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/hp300_defconfig
@@ -577,7 +577,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/mac_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/mac_defconfig
@@ -594,7 +594,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/multi_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/multi_defconfig
@@ -681,7 +681,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/mvme147_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/mvme147_defconfig
@@ -567,7 +567,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/mvme16x_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/mvme16x_defconfig
@@ -568,7 +568,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/q40_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/q40_defconfig
@@ -584,7 +584,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/sun3_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/sun3_defconfig
@@ -564,7 +564,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/m68k/configs/sun3x_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/m68k/configs/sun3x_defconfig
@@ -565,7 +565,6 @@ CONFIG_ASYNC_RAID6_TEST=m
 CONFIG_TEST_HEXDUMP=m
 CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/arch/powerpc/configs/ppc64_defconfig~lib-tests-convert-test_uuid-module-to-kunit
+++ a/arch/powerpc/configs/ppc64_defconfig
@@ -443,7 +443,6 @@ CONFIG_TEST_KSTRTOX=m
 CONFIG_TEST_PRINTF=m
 CONFIG_TEST_SCANF=m
 CONFIG_TEST_BITMAP=m
-CONFIG_TEST_UUID=m
 CONFIG_TEST_XARRAY=m
 CONFIG_TEST_MAPLE_TREE=m
 CONFIG_TEST_RHASHTABLE=m
--- a/lib/Kconfig.debug~lib-tests-convert-test_uuid-module-to-kunit
+++ a/lib/Kconfig.debug
@@ -2499,9 +2499,6 @@ config TEST_BITMAP
 
 	  If unsure, say N.
 
-config TEST_UUID
-	tristate "Test functions located in the uuid module at runtime"
-
 config TEST_XARRAY
 	tristate "Test the XArray code at runtime"
 
@@ -3308,6 +3305,17 @@ config RATELIMIT_KUNIT_TEST
 
 	  If unsure, say N.
 
+config UUID_KUNIT_TEST
+	tristate "KUnit test for UUID" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the uuid library,
+	  which provides functions for generating and parsing UUID and GUID.
+	  The test suite checks parsing of UUID and GUID strings.
+
+	  If unsure, say N.
+
 config INT_POW_KUNIT_TEST
 	tristate "Integer exponentiation (int_pow) test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
--- a/lib/Makefile~lib-tests-convert-test_uuid-module-to-kunit
+++ a/lib/Makefile
@@ -89,7 +89,6 @@ ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_KASA
 GCOV_PROFILE_test_bitmap.o := n
 endif
 
-obj-$(CONFIG_TEST_UUID) += test_uuid.o
 obj-$(CONFIG_TEST_XARRAY) += test_xarray.o
 obj-$(CONFIG_TEST_MAPLE_TREE) += test_maple_tree.o
 obj-$(CONFIG_TEST_PARMAN) += test_parman.o
--- a/lib/tests/Makefile~lib-tests-convert-test_uuid-module-to-kunit
+++ a/lib/tests/Makefile
@@ -50,5 +50,6 @@ obj-$(CONFIG_STRING_HELPERS_KUNIT_TEST)
 obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
 obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
+obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
 
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/uuid_kunit.c a/lib/tests/uuid_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/uuid_kunit.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/*
+ * Test cases for lib/uuid.c module.
+ */
+
+#include <kunit/test.h>
+#include <linux/uuid.h>
+
+struct test_uuid_data {
+	const char *uuid;
+	guid_t le;
+	uuid_t be;
+};
+
+static const struct test_uuid_data test_uuid_test_data[] = {
+	{
+		.uuid = "c33f4995-3701-450e-9fbf-206a2e98e576",
+		.le = GUID_INIT(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
+		.be = UUID_INIT(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
+	},
+	{
+		.uuid = "64b4371c-77c1-48f9-8221-29f054fc023b",
+		.le = GUID_INIT(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
+		.be = UUID_INIT(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
+	},
+	{
+		.uuid = "0cb4ddff-a545-4401-9d06-688af53e7f84",
+		.le = GUID_INIT(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
+		.be = UUID_INIT(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
+	},
+};
+
+static const char * const test_uuid_wrong_data[] = {
+	"c33f4995-3701-450e-9fbf206a2e98e576 ",	/* no hyphen(s) */
+	"64b4371c-77c1-48f9-8221-29f054XX023b",	/* invalid character(s) */
+	"0cb4ddff-a545-4401-9d06-688af53e",	/* not enough data */
+};
+
+static void uuid_test_guid_valid(struct kunit *test)
+{
+	unsigned int i;
+	const struct test_uuid_data *data;
+	guid_t le;
+
+	for (i = 0; i < ARRAY_SIZE(test_uuid_test_data); i++) {
+		data = &test_uuid_test_data[i];
+		KUNIT_EXPECT_EQ(test, guid_parse(data->uuid, &le), 0);
+		KUNIT_EXPECT_TRUE(test, guid_equal(&data->le, &le));
+	}
+}
+
+static void uuid_test_uuid_valid(struct kunit *test)
+{
+	unsigned int i;
+	const struct test_uuid_data *data;
+	uuid_t be;
+
+	for (i = 0; i < ARRAY_SIZE(test_uuid_test_data); i++) {
+		data = &test_uuid_test_data[i];
+		KUNIT_EXPECT_EQ(test, uuid_parse(data->uuid, &be), 0);
+		KUNIT_EXPECT_TRUE(test, uuid_equal(&data->be, &be));
+	}
+}
+
+static void uuid_test_guid_invalid(struct kunit *test)
+{
+	unsigned int i;
+	const char *uuid;
+	guid_t le;
+
+	for (i = 0; i < ARRAY_SIZE(test_uuid_wrong_data); i++) {
+		uuid = test_uuid_wrong_data[i];
+		KUNIT_EXPECT_EQ(test, guid_parse(uuid, &le), -EINVAL);
+	}
+}
+
+static void uuid_test_uuid_invalid(struct kunit *test)
+{
+	unsigned int i;
+	const char *uuid;
+	uuid_t be;
+
+	for (i = 0; i < ARRAY_SIZE(test_uuid_wrong_data); i++) {
+		uuid = test_uuid_wrong_data[i];
+		KUNIT_EXPECT_EQ(test, uuid_parse(uuid, &be), -EINVAL);
+	}
+}
+
+static struct kunit_case uuid_test_cases[] = {
+	KUNIT_CASE(uuid_test_guid_valid),
+	KUNIT_CASE(uuid_test_uuid_valid),
+	KUNIT_CASE(uuid_test_guid_invalid),
+	KUNIT_CASE(uuid_test_uuid_invalid),
+	{},
+};
+
+static struct kunit_suite uuid_test_suite = {
+	.name = "uuid",
+	.test_cases = uuid_test_cases,
+};
+
+kunit_test_suite(uuid_test_suite);
+
+MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
+MODULE_DESCRIPTION("Test cases for lib/uuid.c module");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/lib/test_uuid.c a/lib/test_uuid.c
deleted file mode 100644
--- a/lib/test_uuid.c
+++ /dev/null
@@ -1,134 +0,0 @@
-/*
- * Test cases for lib/uuid.c module.
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/uuid.h>
-
-struct test_uuid_data {
-	const char *uuid;
-	guid_t le;
-	uuid_t be;
-};
-
-static const struct test_uuid_data test_uuid_test_data[] = {
-	{
-		.uuid = "c33f4995-3701-450e-9fbf-206a2e98e576",
-		.le = GUID_INIT(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
-		.be = UUID_INIT(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
-	},
-	{
-		.uuid = "64b4371c-77c1-48f9-8221-29f054fc023b",
-		.le = GUID_INIT(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
-		.be = UUID_INIT(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
-	},
-	{
-		.uuid = "0cb4ddff-a545-4401-9d06-688af53e7f84",
-		.le = GUID_INIT(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
-		.be = UUID_INIT(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
-	},
-};
-
-static const char * const test_uuid_wrong_data[] = {
-	"c33f4995-3701-450e-9fbf206a2e98e576 ",	/* no hyphen(s) */
-	"64b4371c-77c1-48f9-8221-29f054XX023b",	/* invalid character(s) */
-	"0cb4ddff-a545-4401-9d06-688af53e",	/* not enough data */
-};
-
-static unsigned total_tests __initdata;
-static unsigned failed_tests __initdata;
-
-static void __init test_uuid_failed(const char *prefix, bool wrong, bool be,
-				    const char *data, const char *actual)
-{
-	pr_err("%s test #%u %s %s data: '%s'\n",
-	       prefix,
-	       total_tests,
-	       wrong ? "passed on wrong" : "failed on",
-	       be ? "BE" : "LE",
-	       data);
-	if (actual && *actual)
-		pr_err("%s test #%u actual data: '%s'\n",
-		       prefix,
-		       total_tests,
-		       actual);
-	failed_tests++;
-}
-
-static void __init test_uuid_test(const struct test_uuid_data *data)
-{
-	guid_t le;
-	uuid_t be;
-	char buf[48];
-
-	/* LE */
-	total_tests++;
-	if (guid_parse(data->uuid, &le))
-		test_uuid_failed("conversion", false, false, data->uuid, NULL);
-
-	total_tests++;
-	if (!guid_equal(&data->le, &le)) {
-		sprintf(buf, "%pUl", &le);
-		test_uuid_failed("cmp", false, false, data->uuid, buf);
-	}
-
-	/* BE */
-	total_tests++;
-	if (uuid_parse(data->uuid, &be))
-		test_uuid_failed("conversion", false, true, data->uuid, NULL);
-
-	total_tests++;
-	if (!uuid_equal(&data->be, &be)) {
-		sprintf(buf, "%pUb", &be);
-		test_uuid_failed("cmp", false, true, data->uuid, buf);
-	}
-}
-
-static void __init test_uuid_wrong(const char *data)
-{
-	guid_t le;
-	uuid_t be;
-
-	/* LE */
-	total_tests++;
-	if (!guid_parse(data, &le))
-		test_uuid_failed("negative", true, false, data, NULL);
-
-	/* BE */
-	total_tests++;
-	if (!uuid_parse(data, &be))
-		test_uuid_failed("negative", true, true, data, NULL);
-}
-
-static int __init test_uuid_init(void)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(test_uuid_test_data); i++)
-		test_uuid_test(&test_uuid_test_data[i]);
-
-	for (i = 0; i < ARRAY_SIZE(test_uuid_wrong_data); i++)
-		test_uuid_wrong(test_uuid_wrong_data[i]);
-
-	if (failed_tests == 0)
-		pr_info("all %u tests passed\n", total_tests);
-	else
-		pr_err("failed %u out of %u tests\n", failed_tests, total_tests);
-
-	return failed_tests ? -EINVAL : 0;
-}
-module_init(test_uuid_init);
-
-static void __exit test_uuid_exit(void)
-{
-	/* do nothing */
-}
-module_exit(test_uuid_exit);
-
-MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
-MODULE_DESCRIPTION("Test cases for lib/uuid.c module");
-MODULE_LICENSE("Dual BSD/GPL");
_

Patches currently in -mm which might be from sakamo.ryota@gmail.com are

lib-tests-convert-test_uuid-module-to-kunit.patch

