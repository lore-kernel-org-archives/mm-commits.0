Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794862093;
	b=SNiYzyY1cHG5LFZB2GA90YngIuBolJsdlZVLjiZ1BfIH0F2AUAco+MULK2d1+8pYfJes
	 Pgc/pSaKktjQIroXK+kd3kaLEWPF16SAd2qMQjmjh5Uw/Oaj614MUXbwnMI4pNZuk+psT
	 WDkgmHNfmi8LQkcMUZt4JLbPe9hTPghtMda9b+gbg5qyf/qeypHC0E/bqvqfY7AJzbyus
	 8EOBx+f3JanQQbRZZkTMO61Ia2FlMwbCM8BrvXInj50FJ3UhzwkqPtxfqKOOnbgWm1o4V
	 HvmKzb2wSZ9PIBgTEo82dja9TOwYCQ6ULaaHXclL+AAlMVwHL41wq/6X31xGQt3sTBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794862093;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=LyRNw/Ji1Obfof47RaS/xxnFB7y+xpF9m4mizFmB+BA=;
	b=ljooZFOhAVXsvQGgDhzFKi88aSGx1grmLO5rQYmS33leFiIcGpHYkkirks1pWCWh1p1W
	 PQEqhxvmSyL1n62dZ5K82T/nPuPE43Ag+ai5ptj7XP7C6zmy4oZhsTqQBKA3Z3gmv02pQ
	 P3R4IpFm+5kYfLaHH21Gcor4TJLPSdJXAMNjRiCJS51wbghLZTGFd4ORUoOVK8dvcw2uq
	 04vdqj8faaDakfYJ4cbT8vcLJAT9OKobM6CwAiNmvaWCxKRpGU3pZh62ImXwHwgk3DCSL
	 gMQiieKjAEevZ3IDalrhUl7ZQrQQuR/OUTrS63IhzH6Y6uW2PQF5V9X5iaGwGY66uSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WtgPJ6Sj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5AD606A322
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 20:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WtgPJ6Sj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A5E1F000C4;
	Mon, 16 Nov 2026 20:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794862092;
	bh=LyRNw/Ji1Obfof47RaS/xxnFB7y+xpF9m4mizFmB+BA=;
	h=Date:To:From:Subject;
	b=WtgPJ6Sj3ZoRpznyx94cfAQognByK0WdgmXTzAK80hNoR0LIQvZJZHmNJUooW/wY0
	 JBIlpz6VYDlM9skINd04W3pm4GCfwe17ewLHkJ9CrIet/poaorhyat8eYgYDIbU2Cf
	 T9zGpg8LcitOOX9aK+/cXJV1uxC2eBUKrp+eVIqI=
Date: Mon, 16 Nov 2026 12:48:12 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,rdunlap@infradead.org,
	lienze@kylinos.cn,jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch added to mm-new branch
Message-Id: <20261116204812.86A5E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/paddr: add KUnit tests for addr_unit conversion
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/paddr: add KUnit tests for addr_unit conversion
Date: Mon, 16 Nov 2026 07:10:51 -0800

Patch series "mm/damon: add paddr kunit and replace weird "same to" uses in
design doc".

Add kunit tests for physical address space DAMON operation set, via
patch 1 from Avelin Noir.  Use idiomatic "same as" instead of weird
"same to" in design doc, via patch 2 from Enze Li.

This is a batched reposting of DAMON patches for mm.git merge request.
Refer to changelog in each patch for their real changelog.


This patch (of 2):

damon_pa_phys_addr() and damon_pa_core_addr() convert between DAMON core
addresses and physical addresses using addr_unit.  addr_unit lets 32-bit
kernels with a 64-bit phys_addr_t monitor physical memory above 4 GiB,
but no test covers the conversions.

Add a KUnit suite for both helpers, including a case for addresses above
4 GiB that is skipped when phys_addr_t is 32-bit.

Link: https://lore.kernel.org/20261116151057.81692-1-sj@kernel.org
Link: https://lore.kernel.org/20261116151057.81692-2-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Randy Dunlap <rdunlap@infradead.org>

 mm/damon/Kconfig             |   12 +++++++
 mm/damon/paddr.c             |    2 +
 mm/damon/tests/.kunitconfig  |    4 ++
 mm/damon/tests/paddr-kunit.h |   55 +++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion
+++ a/mm/damon/Kconfig
@@ -65,6 +65,18 @@ config DAMON_VADDR_KUNIT_TEST
 
 	  If unsure, say N.
 
+config DAMON_PADDR_KUNIT_TEST
+	bool "Tets for DAMON physical address operations" if !KUNIT_ALL_TESTS
+	depends on DAMON_PADDR && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the DAMON physical address operations Kunit test suite.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation.
+
+	  If unsure, say N.
+
 config DAMON_SYSFS
 	bool "DAMON sysfs interface"
 	depends on DAMON && SYSFS
--- a/mm/damon/paddr.c~mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion
+++ a/mm/damon/paddr.c
@@ -479,3 +479,5 @@ static int __init damon_pa_initcall(void
 }
 
 subsys_initcall(damon_pa_initcall);
+
+#include "tests/paddr-kunit.h"
--- a/mm/damon/tests/.kunitconfig~mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion
+++ a/mm/damon/tests/.kunitconfig
@@ -9,6 +9,10 @@ CONFIG_PAGE_IDLE_FLAG=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_VADDR_KUNIT_TEST=y
 
+# for DAMON paddr ops
+CONFIG_DAMON_PADDR=y
+CONFIG_DAMON_PADDR_KUNIT_TEST=y
+
 # for DAMON sysfs interface
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
diff --git a/mm/damon/tests/paddr-kunit.h a/mm/damon/tests/paddr-kunit.h
new file mode 100644
--- /dev/null
+++ a/mm/damon/tests/paddr-kunit.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Data Access Monitor Unit Tests
+ */
+
+#ifdef CONFIG_DAMON_PADDR_KUNIT_TEST
+
+#ifndef _DAMON_PADDR_TEST_H
+#define _DAMON_PADDR_TEST_H
+
+#include <kunit/test.h>
+
+static void damon_test_pa_phys_addr(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(0x1000, 1), 0x1000);
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(0x40000, 0x1000), 0x40000000);
+}
+
+static void damon_test_pa_core_addr(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0x1000000, 0x1000), 0x1000);
+	/* The conversion rounds down. */
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0x1fff, 0x1000), 1);
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0xfff, 0x1000), 0);
+}
+
+static void damon_test_pa_addr_over_4g(struct kunit *test)
+{
+	unsigned long addr = 0xffffffffUL;
+	unsigned long addr_unit = 0x1000;
+	u64 pa = 0xffffffff000ULL;
+
+	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
+		kunit_skip(test, "phys_addr_t is 32-bit");
+
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
+}
+
+static struct kunit_case damon_paddr_test_cases[] = {
+	KUNIT_CASE(damon_test_pa_phys_addr),
+	KUNIT_CASE(damon_test_pa_core_addr),
+	KUNIT_CASE(damon_test_pa_addr_over_4g),
+	{},
+};
+
+static struct kunit_suite damon_paddr_test_suite = {
+	.name = "damon-paddr",
+	.test_cases = damon_paddr_test_cases,
+};
+kunit_test_suite(damon_paddr_test_suite);
+
+#endif /* _DAMON_PADDR_TEST_H */
+
+#endif	/* CONFIG_DAMON_PADDR_KUNIT_TEST */
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch

