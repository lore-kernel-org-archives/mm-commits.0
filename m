Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EDA335C7
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770672; cv=none; b=lXnnnXEup5s4JlKAQsQla2amrkMx/qpKAnN65tWCKnA5VPLVDVa+u4+FkxE8FLxaKlKRqZoah7L/ybPDXJKYTnUayTTnKX7YaBi5o6hSSE940Wbxo+04wHXBUFZRUWA8Z/9+pHZ7c1a6j6grSSPO1Uyf1ZFzD2XamaGjO2enYtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770672; c=relaxed/simple;
	bh=dVR0qfoWYw0R1V6DdOEiJOa/xb67VijAQ16+y3sGVgE=;
	h=Date:To:From:Subject:Message-Id; b=apOyXH6H3HW8/WDEGTvXDnADw63+a/QPApGahtn/XL/p2oLph4C8GrH/lTYYYCoBfyTaBDxJ/JkfU+DEh+tu9m7ThVtVhI50/9rJaXD8e25iEAncEy1y9NnigNM7l1hze6PbL52tLKS8r0sMz1B7RmSEjdyyDVk1TfMk9TC63Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CE/Ui2zH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CE/Ui2zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54FEC4CEC6;
	Sat, 12 Oct 2024 22:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728770671;
	bh=dVR0qfoWYw0R1V6DdOEiJOa/xb67VijAQ16+y3sGVgE=;
	h=Date:To:From:Subject:From;
	b=CE/Ui2zHKbf9d8zoc7+kQKkoRCo1173xXkG/+q+/iUahBQvmLvkLByO24yeI7Uals
	 1+KDb+MMZvELfucxxs0Hk1vVoTW3UA2UR4qIaD4C3YQmeTt66lP7ao4DL9C7+uEN2c
	 S9gGKn0xk3mrEywE5/1P7OwN9yjkISbR5LS5O5So=
Date: Sat, 12 Oct 2024 15:04:30 -0700
To: mm-commits@vger.kernel.org,rmoar@google.com,fgasperin@lkcamp.dev,ebertoloti@lkcamp.dev,David.Laight@ACULAB.COM,davidgow@google.com,brendan.higgins@linux.dev,vpeixoto@lkcamp.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-crc16_kunitc-add-kunit-tests-for-crc16.patch added to mm-nonmm-unstable branch
Message-Id: <20241012220430.E54FEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/crc16_kunit.c: add KUnit tests for crc16
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-crc16_kunitc-add-kunit-tests-for-crc16.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-crc16_kunitc-add-kunit-tests-for-crc16.patch

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
From: Vinicius Peixoto <vpeixoto@lkcamp.dev>
Subject: lib/crc16_kunit.c: add KUnit tests for crc16
Date: Sat, 12 Oct 2024 04:43:49 -0300

Add Kunit tests for the kernel's implementation of the standard CRC-16
algorithm (<linux/crc16.h>).  The test data consists of 100
randomly-generated test cases, validated against a naive CRC-16
implementation.

This test follows roughly the same logic as lib/crc32test.c, but without
the performance measurements.

Link: https://lkml.kernel.org/r/20241012-crc16-kunit-v3-1-0ca75cb58ca9@lkcamp.dev
Signed-off-by: Vinicius Peixoto <vpeixoto@lkcamp.dev>
Co-developed-by: Enzo Bertoloti <ebertoloti@lkcamp.dev>
Signed-off-by: Enzo Bertoloti <ebertoloti@lkcamp.dev>
Co-developed-by: Fabricio Gasperin <fgasperin@lkcamp.dev>
Signed-off-by: Fabricio Gasperin <fgasperin@lkcamp.dev>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    9 ++
 lib/Makefile      |    1 
 lib/crc16_kunit.c |  155 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)

diff --git a/lib/crc16_kunit.c a/lib/crc16_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/crc16_kunit.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnits tests for CRC16.
+ *
+ * Copyright (C) 2024, LKCAMP
+ * Author: Vinicius Peixoto <vpeixoto@lkcamp.dev>
+ * Author: Fabricio Gasperin <fgasperin@lkcamp.dev>
+ * Author: Enzo Bertoloti <ebertoloti@lkcamp.dev>
+ */
+#include <kunit/test.h>
+#include <linux/crc16.h>
+#include <linux/prandom.h>
+
+#define CRC16_KUNIT_DATA_SIZE 4096
+#define CRC16_KUNIT_TEST_SIZE 100
+#define CRC16_KUNIT_SEED 0x12345678
+
+/**
+ * struct crc16_test - CRC16 test data
+ * @crc: initial input value to CRC16
+ * @start: Start index within the data buffer
+ * @length: Length of the data
+ */
+static struct crc16_test {
+	u16 crc;
+	u16 start;
+	u16 length;
+} tests[CRC16_KUNIT_TEST_SIZE];
+
+u8 data[CRC16_KUNIT_DATA_SIZE];
+
+
+/* Naive implementation of CRC16 for validation purposes */
+static inline u16 _crc16_naive_byte(u16 crc, u8 data)
+{
+	u8 i = 0;
+
+	crc ^= (u16) data;
+	for (i = 0; i < 8; i++) {
+		if (crc & 0x01)
+			crc = (crc >> 1) ^ 0xa001;
+		else
+			crc = crc >> 1;
+	}
+
+	return crc;
+}
+
+
+static inline u16 _crc16_naive(u16 crc, u8 *buffer, size_t len)
+{
+	while (len--)
+		crc = _crc16_naive_byte(crc, *buffer++);
+	return crc;
+}
+
+
+/* Small helper for generating pseudorandom 16-bit data */
+static inline u16 _rand16(void)
+{
+	static u32 rand = CRC16_KUNIT_SEED;
+
+	rand = next_pseudo_random32(rand);
+	return rand & 0xFFFF;
+}
+
+
+static int crc16_init_test_data(struct kunit_suite *suite)
+{
+	size_t i;
+
+	/* Fill the data buffer with random bytes */
+	for (i = 0; i < CRC16_KUNIT_DATA_SIZE; i++)
+		data[i] = _rand16() & 0xFF;
+
+	/* Generate random test data while ensuring the random
+	 * start + length values won't overflow the 4096-byte
+	 * buffer (0x7FF * 2 = 0xFFE < 0x1000)
+	 */
+	for (size_t i = 0; i < CRC16_KUNIT_TEST_SIZE; i++) {
+		tests[i].crc = _rand16();
+		tests[i].start = _rand16() & 0x7FF;
+		tests[i].length = _rand16() & 0x7FF;
+	}
+
+	return 0;
+}
+
+static void crc16_test_empty(struct kunit *test)
+{
+	u16 crc;
+
+	/* The result for empty data should be the same as the
+	 * initial crc
+	 */
+	crc = crc16(0x00, data, 0);
+	KUNIT_EXPECT_EQ(test, crc, 0);
+	crc = crc16(0xFF, data, 0);
+	KUNIT_EXPECT_EQ(test, crc, 0xFF);
+}
+
+static void crc16_test_correctness(struct kunit *test)
+{
+	size_t i;
+	u16 crc, crc_naive;
+
+	for (i = 0; i < CRC16_KUNIT_TEST_SIZE; i++) {
+		/* Compare results with the naive crc16 implementation */
+		crc = crc16(tests[i].crc, data + tests[i].start,
+			    tests[i].length);
+		crc_naive = _crc16_naive(tests[i].crc, data + tests[i].start,
+					 tests[i].length);
+		KUNIT_EXPECT_EQ(test, crc, crc_naive);
+	}
+}
+
+
+static void crc16_test_combine(struct kunit *test)
+{
+	size_t i, j;
+	u16 crc, crc_naive;
+
+	/* Make sure that combining two consecutive crc16 calculations
+	 * yields the same result as calculating the crc16 for the whole thing
+	 */
+	for (i = 0; i < CRC16_KUNIT_TEST_SIZE; i++) {
+		crc_naive = crc16(tests[i].crc, data + tests[i].start, tests[i].length);
+		for (j = 0; j < tests[i].length; j++) {
+			crc = crc16(tests[i].crc, data + tests[i].start, j);
+			crc = crc16(crc, data + tests[i].start + j, tests[i].length - j);
+			KUNIT_EXPECT_EQ(test, crc, crc_naive);
+		}
+	}
+}
+
+
+static struct kunit_case crc16_test_cases[] = {
+	KUNIT_CASE(crc16_test_empty),
+	KUNIT_CASE(crc16_test_combine),
+	KUNIT_CASE(crc16_test_correctness),
+	{},
+};
+
+static struct kunit_suite crc16_test_suite = {
+	.name = "crc16",
+	.test_cases = crc16_test_cases,
+	.suite_init = crc16_init_test_data,
+};
+kunit_test_suite(crc16_test_suite);
+
+MODULE_AUTHOR("Fabricio Gasperin <fgasperin@lkcamp.dev>");
+MODULE_AUTHOR("Vinicius Peixoto <vpeixoto@lkcamp.dev>");
+MODULE_AUTHOR("Enzo Bertoloti <ebertoloti@lkcamp.dev>");
+MODULE_DESCRIPTION("Unit tests for crc16");
+MODULE_LICENSE("GPL");
--- a/lib/Kconfig.debug~lib-crc16_kunitc-add-kunit-tests-for-crc16
+++ a/lib/Kconfig.debug
@@ -2850,6 +2850,15 @@ config USERCOPY_KUNIT_TEST
 	  on the copy_to/from_user infrastructure, making sure basic
 	  user/kernel boundary testing is working.
 
+config CRC16_KUNIT_TEST
+	tristate "KUnit tests for CRC16"
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	select CRC16
+	help
+	  Enable this option to run unit tests for the kernel's CRC16
+	  implementation (<linux/crc16.h>).
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	help
--- a/lib/Makefile~lib-crc16_kunitc-add-kunit-tests-for-crc16
+++ a/lib/Makefile
@@ -390,6 +390,7 @@ CFLAGS_fortify_kunit.o += $(DISABLE_STRU
 obj-$(CONFIG_FORTIFY_KUNIT_TEST) += fortify_kunit.o
 obj-$(CONFIG_SIPHASH_KUNIT_TEST) += siphash_kunit.o
 obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
+obj-$(CONFIG_CRC16_KUNIT_TEST) += crc16_kunit.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
_

Patches currently in -mm which might be from vpeixoto@lkcamp.dev are

lib-crc16_kunitc-add-kunit-tests-for-crc16.patch

