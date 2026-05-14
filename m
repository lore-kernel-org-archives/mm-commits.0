Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3946D4A33
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717334; cv=none; b=cKh8jgdaSB1yNKBhAYJze7UwgDVrqk42+QvsS4iXESTN/7W0NRGgkuns532rXcEPygAppmCsMl2KCgYC8qhFTZiIUuz2jamlOmGecqjgXFhLf8dGiCGZnEGubyFYZrRANIIPZlCxa70zGMsDah9BWmRUuqja8GY/rMxze4hVMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717334; c=relaxed/simple;
	bh=k3sh1FDkTJjWT+w/nyiu8lNv4h1fsVk2QuLQLJS8zXY=;
	h=Date:To:From:Subject:Message-Id; b=IlwsuHZB75WMH02LocYvRlrz1CJHEkD6QJO/aUSXLmfYfaSnWCWp8qVRSDSBOB0SX+DT64vD7BcsiCe3gcyO6vpcrUu8lUZxrVJfWgy9eeIU20zmvHs3DW8IhgPJPKJmi9g5k1EI2xm6OU+PwLc5vHlq6tRDh/mmYJ9BHSDYsmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wIjNJ9Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wIjNJ9Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1ACC19425;
	Thu, 14 May 2026 00:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778717333;
	bh=k3sh1FDkTJjWT+w/nyiu8lNv4h1fsVk2QuLQLJS8zXY=;
	h=Date:To:From:Subject:From;
	b=wIjNJ9Zu+MI2MC4K8DVx0b/MMtjQsWdSL1SiqPOiFkN1DZ6ivcQto9w8HiZZWdHId
	 cs8O/UmdFlySoCI6xaHe7PWeffNKeBZxd1tzCa5gpEFdL1Jxhgv83u9kzl1p3pbpQq
	 iJ6PC1eoum/I2RYDmWXPKOUuY6WvERWS1467zrB0=
Date: Wed, 13 May 2026 17:08:53 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,lkp@intel.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch added to mm-nonmm-unstable branch
Message-Id: <20260514000853.BF1ACC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
Date: Wed, 13 May 2026 16:44:06 +0300

Add KUnit tests for '__ashldi3()', '__ashrdi3()', and '__lshrdi3()' helper
functions used to implement 64-bit arithmetic shift left, arithmetic shift
right and logical shift right, respectively, on a 32-bit CPUs.

Tested with 'qemu-system-riscv32 -M virt' and 'qemu-system-arm -M virt'.

Link: https://lore.kernel.org/20260513134407.884033-8-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug       |   10 ++
 lib/tests/Makefile      |    1 
 lib/tests/shdi3_kunit.c |  175 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)

--- a/lib/Kconfig.debug~lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3
+++ a/lib/Kconfig.debug
@@ -2981,6 +2981,16 @@ config BITS_TEST
 
 	  If unsure, say N.
 
+config SHDI3_KUNIT_TEST
+	tristate "KUnit test for __ashldi3(), __ashrdi3(), and __lshrdi3()"
+	depends on KUNIT
+	depends on (32BIT || ARM)
+	help
+	  This builds the unit test for __ashldi3(), __ashrdi3(), and
+	  __lshrdi3() helper functions used to implement 64-bit arithmetic
+	  shift left, arithmetic shift right and logical shift right,
+	  respectively, on a 32-bit CPUs.
+
 config SLUB_KUNIT_TEST
 	tristate "KUnit test for SLUB cache error detection" if !KUNIT_ALL_TESTS
 	depends on SLUB_DEBUG && KUNIT
--- a/lib/tests/Makefile~lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3
+++ a/lib/tests/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_BASE64_KUNIT) += base64_kun
 obj-$(CONFIG_BITOPS_KUNIT) += bitops_kunit.o
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
+obj-$(CONFIG_SHDI3_KUNIT_TEST) += shdi3_kunit.o
 obj-$(CONFIG_BLACKHOLE_DEV_KUNIT_TEST) += blackhole_dev_kunit.o
 obj-$(CONFIG_CHECKSUM_KUNIT) += checksum_kunit.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
diff --git a/lib/tests/shdi3_kunit.c a/lib/tests/shdi3_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/shdi3_kunit.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR Apache-2.0
+/*
+ * Test cases for __ashldi3(), __ashrdi3(), and __lshrdi3().
+ */
+
+#include <linux/array_size.h>
+#include <linux/module.h>
+#include <linux/libgcc.h>
+#include <kunit/test.h>
+
+struct shdi3_test_entry {
+	long long input;
+	int shift;
+	long long result;
+};
+
+static const struct shdi3_test_entry ashldi3_testdata[] = {
+	/* https://github.com/llvm/llvm-project/compiler-rt/test/builtins/Unit/ashldi3_test.c */
+	{ 0x0123456789ABCDEFLL, 0, 0x123456789ABCDEFLL },
+	{ 0x0123456789ABCDEFLL, 1, 0x2468ACF13579BDELL },
+	{ 0x0123456789ABCDEFLL, 2, 0x48D159E26AF37BCLL },
+	{ 0x0123456789ABCDEFLL, 3, 0x91A2B3C4D5E6F78LL },
+	{ 0x0123456789ABCDEFLL, 4, 0x123456789ABCDEF0LL },
+	{ 0x0123456789ABCDEFLL, 28, 0x789ABCDEF0000000LL },
+	{ 0x0123456789ABCDEFLL, 29, 0xF13579BDE0000000LL },
+	{ 0x0123456789ABCDEFLL, 30, 0xE26AF37BC0000000LL },
+	{ 0x0123456789ABCDEFLL, 31, 0xC4D5E6F780000000LL },
+	{ 0x0123456789ABCDEFLL, 32, 0x89ABCDEF00000000LL },
+	{ 0x0123456789ABCDEFLL, 33, 0x13579BDE00000000LL },
+	{ 0x0123456789ABCDEFLL, 34, 0x26AF37BC00000000LL },
+	{ 0x0123456789ABCDEFLL, 35, 0x4D5E6F7800000000LL },
+	{ 0x0123456789ABCDEFLL, 36, 0x9ABCDEF000000000LL },
+	{ 0x0123456789ABCDEFLL, 60, 0xF000000000000000LL },
+	{ 0x0123456789ABCDEFLL, 61, 0xE000000000000000LL },
+	{ 0x0123456789ABCDEFLL, 62, 0xC000000000000000LL },
+	{ 0x0123456789ABCDEFLL, 63, 0x8000000000000000LL },
+};
+
+static void shdi3_test_ashldi3(struct kunit *test)
+{
+	const struct shdi3_test_entry *e;
+	long long ret;
+
+	for (e = ashldi3_testdata;
+	     e < ashldi3_testdata + ARRAY_SIZE(ashldi3_testdata); e++) {
+		ret = __ashldi3(e->input, e->shift);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when evaluating __ashldi3(%lld, %d)",
+				    e->input, e->shift);
+	}
+}
+
+static const struct shdi3_test_entry ashrdi3_testdata[] = {
+	/* https://github.com/llvm/llvm-project/compiler-rt/test/builtins/Unit/ashrdi3_test.c */
+	{ 0x0123456789ABCDEFLL, 0, 0x123456789ABCDEFLL },
+	{ 0x0123456789ABCDEFLL, 1, 0x91A2B3C4D5E6F7LL },
+	{ 0x0123456789ABCDEFLL, 2, 0x48D159E26AF37BLL },
+	{ 0x0123456789ABCDEFLL, 3, 0x2468ACF13579BDLL },
+	{ 0x0123456789ABCDEFLL, 4, 0x123456789ABCDELL },
+	{ 0x0123456789ABCDEFLL, 28, 0x12345678LL },
+	{ 0x0123456789ABCDEFLL, 29, 0x91A2B3CLL },
+	{ 0x0123456789ABCDEFLL, 30, 0x48D159ELL },
+	{ 0x0123456789ABCDEFLL, 31, 0x2468ACFLL },
+	{ 0x0123456789ABCDEFLL, 32, 0x1234567LL },
+	{ 0x0123456789ABCDEFLL, 33, 0x91A2B3LL },
+	{ 0x0123456789ABCDEFLL, 34, 0x48D159LL },
+	{ 0x0123456789ABCDEFLL, 35, 0x2468ACLL },
+	{ 0x0123456789ABCDEFLL, 36, 0x123456LL },
+	{ 0x0123456789ABCDEFLL, 60, 0 },
+	{ 0x0123456789ABCDEFLL, 61, 0 },
+	{ 0x0123456789ABCDEFLL, 62, 0 },
+	{ 0x0123456789ABCDEFLL, 63, 0 },
+	{ 0xFEDCBA9876543210LL, 0, 0xFEDCBA9876543210LL },
+	{ 0xFEDCBA9876543210LL, 1, 0xFF6E5D4C3B2A1908LL },
+	{ 0xFEDCBA9876543210LL, 2, 0xFFB72EA61D950C84LL },
+	{ 0xFEDCBA9876543210LL, 3, 0xFFDB97530ECA8642LL },
+	{ 0xFEDCBA9876543210LL, 4, 0xFFEDCBA987654321LL },
+	{ 0xFEDCBA9876543210LL, 28, 0xFFFFFFFFEDCBA987LL },
+	{ 0xFEDCBA9876543210LL, 29, 0xFFFFFFFFF6E5D4C3LL },
+	{ 0xFEDCBA9876543210LL, 30, 0xFFFFFFFFFB72EA61LL },
+	{ 0xFEDCBA9876543210LL, 31, 0xFFFFFFFFFDB97530LL },
+	{ 0xFEDCBA9876543210LL, 32, 0xFFFFFFFFFEDCBA98LL },
+	{ 0xFEDCBA9876543210LL, 33, 0xFFFFFFFFFF6E5D4CLL },
+	{ 0xFEDCBA9876543210LL, 34, 0xFFFFFFFFFFB72EA6LL },
+	{ 0xFEDCBA9876543210LL, 35, 0xFFFFFFFFFFDB9753LL },
+	{ 0xFEDCBA9876543210LL, 36, 0xFFFFFFFFFFEDCBA9LL },
+	{ 0xAEDCBA9876543210LL, 60, 0xFFFFFFFFFFFFFFFALL },
+	{ 0xAEDCBA9876543210LL, 61, 0xFFFFFFFFFFFFFFFDLL },
+	{ 0xAEDCBA9876543210LL, 62, 0xFFFFFFFFFFFFFFFELL },
+	{ 0xAEDCBA9876543210LL, 63, 0xFFFFFFFFFFFFFFFFLL },
+};
+
+static void shdi3_test_ashrdi3(struct kunit *test)
+{
+	const struct shdi3_test_entry *e;
+	long long ret;
+
+	for (e = ashrdi3_testdata;
+	     e < ashrdi3_testdata + ARRAY_SIZE(ashrdi3_testdata); e++) {
+		ret = __ashrdi3(e->input, e->shift);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when evaluating __ashrdi3(%lld, %d)",
+				    e->input, e->shift);
+	}
+}
+
+static const struct shdi3_test_entry lshrdi3_testdata[] = {
+	/* https://github.com/llvm/llvm-project/compiler-rt/test/builtins/Unit/lshrdi3_test.c */
+	{ 0x0123456789ABCDEFLL, 0, 0x123456789ABCDEFLL },
+	{ 0x0123456789ABCDEFLL, 1, 0x91A2B3C4D5E6F7LL },
+	{ 0x0123456789ABCDEFLL, 2, 0x48D159E26AF37BLL },
+	{ 0x0123456789ABCDEFLL, 3, 0x2468ACF13579BDLL },
+	{ 0x0123456789ABCDEFLL, 4, 0x123456789ABCDELL },
+	{ 0x0123456789ABCDEFLL, 28, 0x12345678LL },
+	{ 0x0123456789ABCDEFLL, 29, 0x91A2B3CLL },
+	{ 0x0123456789ABCDEFLL, 30, 0x48D159ELL },
+	{ 0x0123456789ABCDEFLL, 31, 0x2468ACFLL },
+	{ 0x0123456789ABCDEFLL, 32, 0x1234567LL },
+	{ 0x0123456789ABCDEFLL, 33, 0x91A2B3LL },
+	{ 0x0123456789ABCDEFLL, 34, 0x48D159LL },
+	{ 0x0123456789ABCDEFLL, 35, 0x2468ACLL },
+	{ 0x0123456789ABCDEFLL, 36, 0x123456LL },
+	{ 0x0123456789ABCDEFLL, 60, 0 },
+	{ 0x0123456789ABCDEFLL, 61, 0 },
+	{ 0x0123456789ABCDEFLL, 62, 0 },
+	{ 0x0123456789ABCDEFLL, 63, 0 },
+	{ 0xFEDCBA9876543210LL, 0, 0xFEDCBA9876543210LL },
+	{ 0xFEDCBA9876543210LL, 1, 0x7F6E5D4C3B2A1908LL },
+	{ 0xFEDCBA9876543210LL, 2, 0x3FB72EA61D950C84LL },
+	{ 0xFEDCBA9876543210LL, 3, 0x1FDB97530ECA8642LL },
+	{ 0xFEDCBA9876543210LL, 4, 0xFEDCBA987654321LL },
+	{ 0xFEDCBA9876543210LL, 28, 0xFEDCBA987LL },
+	{ 0xFEDCBA9876543210LL, 29, 0x7F6E5D4C3LL },
+	{ 0xFEDCBA9876543210LL, 30, 0x3FB72EA61LL },
+	{ 0xFEDCBA9876543210LL, 31, 0x1FDB97530LL },
+	{ 0xFEDCBA9876543210LL, 32, 0xFEDCBA98LL },
+	{ 0xFEDCBA9876543210LL, 33, 0x7F6E5D4CLL },
+	{ 0xFEDCBA9876543210LL, 34, 0x3FB72EA6LL },
+	{ 0xFEDCBA9876543210LL, 35, 0x1FDB9753LL },
+	{ 0xFEDCBA9876543210LL, 36, 0xFEDCBA9LL },
+	{ 0xAEDCBA9876543210LL, 60, 0xALL },
+	{ 0xAEDCBA9876543210LL, 61, 0x5LL },
+	{ 0xAEDCBA9876543210LL, 62, 0x2LL },
+	{ 0xAEDCBA9876543210LL, 63, 0x1LL },
+};
+
+static void shdi3_test_lshrdi3(struct kunit *test)
+{
+	const struct shdi3_test_entry *e;
+	long long ret;
+
+	for (e = lshrdi3_testdata;
+	     e < lshrdi3_testdata + ARRAY_SIZE(lshrdi3_testdata); e++) {
+		ret = __lshrdi3(e->input, e->shift);
+		KUNIT_EXPECT_EQ_MSG(test, ret, e->result,
+				    "    when evaluating __lshrdi3(%lld, %d)",
+				    e->input, e->shift);
+	}
+}
+
+static struct kunit_case shdi3_test_cases[] = {
+	KUNIT_CASE(shdi3_test_ashldi3),
+	KUNIT_CASE(shdi3_test_ashrdi3),
+	KUNIT_CASE(shdi3_test_lshrdi3),
+	{}
+};
+
+static struct kunit_suite shdi3_test_suite = {
+	.name = "shdi3",
+	.test_cases = shdi3_test_cases,
+};
+kunit_test_suite(shdi3_test_suite);
+
+MODULE_DESCRIPTION("Test cases for __ashldi3(), __ashrdi3(), and __lshrdi3()");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

