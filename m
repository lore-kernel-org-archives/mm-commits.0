Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84D421B8F6
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718080; cv=none; b=aMpK2xqCkaeQ9cv3qmxqBhqotT7M33ggQ6DKy++B+LpbfJs8UbMaFAxYHIh12yiOWC2+6GLWUhfSw7lA9jqCyW/l65Qg49OTkEHiRyJlBfGB8/WJ9u1HAA+LHbQIE/JOmEwrvreULp14VdFpyD2N7Y5sOngI2rYFOwvr94kpSA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718080; c=relaxed/simple;
	bh=0lqRWkPkn//wMBBmIOZ2V9s5pjKGyMYhvSKfjVLwQb0=;
	h=Date:To:From:Subject:Message-Id; b=LhmuR3MXzmo1MjulbMqQklaFZURc4bl0sIcHkvjbsodXdmIkydKtF+M9u3VgKv4todiJUDFNxxKhiBPrOPmv98B/9rhd2wnnnx8os1PBRSj91+8MnVPsOzrQxHkMrHiGqJfE54nivnPQxk+gzBF36lsuSbZ/KUcQN2erocu6UUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iMgv7Eh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iMgv7Eh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B95C4CEEA;
	Mon, 23 Jun 2025 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750718080;
	bh=0lqRWkPkn//wMBBmIOZ2V9s5pjKGyMYhvSKfjVLwQb0=;
	h=Date:To:From:Subject:From;
	b=iMgv7Eh8k0HLTJIlDTouP48N0cMVVkH1kVeSlwkId+TP5Dp6ZNZnF/FDLKavqWBQa
	 Cg7xj3+7bHGW7ebONkIY1xlseiMWDdQT2u05apAhasilAm6yh0Rw+MSZvC5hTK/gQR
	 z1sneB0epmx3vJqfBWAvO5IaTfyAv9M6lScIkgi4=
Date: Mon, 23 Jun 2025 15:34:39 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,keith.lucas@oracle.com,joey.gouly@arm.com,hannes@cmpxchg.org,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bagasdotme@gmail.com,aruna.ramakrishna@oracle.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch removed from -mm tree
Message-Id: <20250623223440.40B95C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm_tests: skip hugepage test when Transparent Hugepages are disabled
has been removed from the -mm tree.  Its filename was
     ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Li Wang <liwang@redhat.com>
Subject: ksm_tests: skip hugepage test when Transparent Hugepages are disabled
Date: Sat, 21 Jun 2025 08:48:08 +0800

Some systems (e.g.  minimal or real-time kernels) may not enable
Transparent Hugepages (THP), causing MADV_HUGEPAGE to return EINVAL.  This
patch introduces a runtime check using the existing THP sysfs interface
and skips the hugepage merging test (`-H`) when THP is not available.

To avoid those failures:

  # -----------------------------
  # running ./ksm_tests -H -s 100
  # -----------------------------
  # ksm_tests: MADV_HUGEPAGE: Invalid argument
  # [FAIL]
  not ok 1 ksm_tests -H -s 100 # exit=2

  # --------------------
  # running ./khugepaged
  # --------------------
  # Reading PMD pagesize failed# [FAIL]
  not ok 1 khugepaged # exit=1

  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..15
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # Bail out! Reading PMD pagesize failed# Planned tests != run tests (15 != 3)
  # # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 soft-dirty # exit=1
  # SUMMARY: PASS=0 SKIP=0 FAIL=1

  # -------------------
  # running ./migration
  # -------------------
  # TAP version 13
  # 1..3
  # # Starting 3 tests from 1 test cases.
  # #  RUN           migration.private_anon ...
  # #            OK  migration.private_anon
  # ok 1 migration.private_anon
  # #  RUN           migration.shared_anon ...
  # #            OK  migration.shared_anon
  # ok 2 migration.shared_anon
  # #  RUN           migration.private_anon_thp ...
  # # migration.c:196:private_anon_thp:Expected madvise(ptr, TWOMEG, MADV_HUGEPAGE) (-1) == 0 (0)
  # # private_anon_thp: Test terminated by assertion
  # #          FAIL  migration.private_anon_thp
  # not ok 3 migration.private_anon_thp
  # # FAILED: 2 / 3 tests passed.
  # # Totals: pass:2 fail:1 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 migration # exit=1

Link: https://lkml.kernel.org/r/20250621004808.368878-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c   |    5 +++++
 tools/testing/selftests/mm/ksm_tests.c    |    6 ++++++
 tools/testing/selftests/mm/migration.c    |    8 ++++++++
 tools/testing/selftests/mm/soft-dirty.c   |    9 ++++++++-
 tools/testing/selftests/mm/thp_settings.c |   11 +++++++++++
 tools/testing/selftests/mm/thp_settings.h |    2 ++
 6 files changed, 40 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1188,6 +1188,11 @@ int main(int argc, char **argv)
 		.read_ahead_kb = 0,
 	};
 
+	if (!thp_is_enabled()) {
+		printf("Transparent Hugepages not available\n");
+		return KSFT_SKIP;
+	}
+
 	parse_test_type(argc, argv);
 
 	setbuf(stdout, NULL);
--- a/tools/testing/selftests/mm/ksm_tests.c~ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -15,6 +15,7 @@
 #include "../kselftest.h"
 #include <include/vdso/time64.h>
 #include "vm_util.h"
+#include "thp_settings.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
@@ -527,6 +528,11 @@ static int ksm_merge_hugepages_time(int
 	unsigned long scan_time_ns;
 	int pagemap_fd, n_normal_pages, n_huge_pages;
 
+	if (!thp_is_enabled()) {
+		printf("Transparent Hugepages not available\n");
+		return KSFT_SKIP;
+	}
+
 	map_size *= MB;
 	size_t len = map_size;
 
--- a/tools/testing/selftests/mm/migration.c~ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled
+++ a/tools/testing/selftests/mm/migration.c
@@ -5,6 +5,8 @@
  */
 
 #include "../kselftest_harness.h"
+#include "thp_settings.h"
+
 #include <strings.h>
 #include <pthread.h>
 #include <numa.h>
@@ -185,6 +187,9 @@ TEST_F_TIMEOUT(migration, private_anon_t
 	uint64_t *ptr;
 	int i;
 
+	if (!thp_is_enabled())
+		SKIP(return, "Transparent Hugepages not available");
+
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
@@ -214,6 +219,9 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 	uint64_t *ptr;
 	int i;
 
+	if (!thp_is_enabled())
+		SKIP(return, "Transparent Hugepages not available");
+
 	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
--- a/tools/testing/selftests/mm/soft-dirty.c~ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -6,8 +6,10 @@
 #include <stdint.h>
 #include <malloc.h>
 #include <sys/mman.h>
+
 #include "../kselftest.h"
 #include "vm_util.h"
+#include "thp_settings.h"
 
 #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
 #define TEST_ITERATIONS 10000
@@ -78,8 +80,13 @@ static void test_hugepage(int pagemap_fd
 {
 	char *map;
 	int i, ret;
-	size_t hpage_len = read_pmd_pagesize();
 
+	if (!thp_is_enabled()) {
+		printf("Skipping test: Transparent Hugepages not available\n");
+		return KSFT_SKIP;
+	}
+
+	size_t hpage_len = read_pmd_pagesize();
 	if (!hpage_len)
 		ksft_exit_fail_msg("Reading PMD pagesize failed");
 
--- a/tools/testing/selftests/mm/thp_settings.c~ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled
+++ a/tools/testing/selftests/mm/thp_settings.c
@@ -381,3 +381,14 @@ unsigned long thp_shmem_supported_orders
 {
 	return __thp_supported_orders(true);
 }
+
+bool thp_is_enabled(void)
+{
+	if (access(THP_SYSFS, F_OK) != 0)
+		return false;
+
+	int mode = thp_read_string("enabled", thp_enabled_strings);
+
+	/* THP is considered enabled if it's either "always" or "madvise" */
+	return mode == 1 || mode == 3;
+}
--- a/tools/testing/selftests/mm/thp_settings.h~ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled
+++ a/tools/testing/selftests/mm/thp_settings.h
@@ -84,4 +84,6 @@ void thp_set_read_ahead_path(char *path)
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+bool thp_is_enabled(void);
+
 #endif /* __THP_SETTINGS_H__ */
_

Patches currently in -mm which might be from liwang@redhat.com are

mm-selftests-improve-uffd-wp-feature-detection-in-ksm-test.patch

