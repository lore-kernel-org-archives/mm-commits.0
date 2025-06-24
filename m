Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6A71BC9E2
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750808872; cv=none; b=o4FkiVGCh2ikvvloi5E0kuOuRtMjBLno9JEWvsw3+rQAyett0JR1/j8SfsAoO/rCd1IOYfxyocjFjw4AHkaHgd3B6rIMjKcjR5r7V+6+fi+gJKB9DT/SRYmzotyPn96ZkqVrw5821unDIZEt7FEmIBaRr2MSgXiCEK6DlQRj5vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750808872; c=relaxed/simple;
	bh=J5Z/IpWR+6+yF7C+g497FP0FjpEdib6+nsWTt6dTld0=;
	h=Date:To:From:Subject:Message-Id; b=bnifahp/veDq7M8CZmThhDpTaQxVGxtibyP4lpYiitfmj+HNIV4rebCDd1PjTtuIaL3AgDBbrAUv2AbK6qCaY7TDsjTW2PKwanMQORr8MoKyKVORmkmRd0A0dlzsUbwwx49OZB2Dtck/U898z7lSJz6RMiiQ/y1eihdfYChgNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JCvY9nnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JCvY9nnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F835C4CEE3;
	Tue, 24 Jun 2025 23:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750808871;
	bh=J5Z/IpWR+6+yF7C+g497FP0FjpEdib6+nsWTt6dTld0=;
	h=Date:To:From:Subject:From;
	b=JCvY9nnAb1WdcoKOOOWPqrKVRbPVuessTJ8PFNLfkp0GMl2plL6YbSEGIfS9XELtg
	 WvccQkS2h7eE7+tlJIYpUmR0eASooh5x4iUQ8tFJauXSjVhvLlzaZmJIACEfek4oMU
	 iC/PIhJ73uYLrDVrYR0zzDEuy7xpGJC4MAEsqpkA=
Date: Tue, 24 Jun 2025 16:47:51 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,keith.lucas@oracle.com,joey.gouly@arm.com,hannes@cmpxchg.org,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bagasdotme@gmail.com,aruna.ramakrishna@oracle.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch added to mm-new branch
Message-Id: <20250624234751.8F835C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm_tests: skip hugepage test when Transparent Hugepages are disabled
has been added to the -mm mm-new branch.  Its filename is
     ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Li Wang <liwang@redhat.com>
Subject: ksm_tests: skip hugepage test when Transparent Hugepages are disabled
Date: Tue, 24 Jun 2025 11:27:48 +0800

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

It's true that CONFIG_TRANSPARENT_HUGEPAGE=3Dy is explicitly enabled in
tools/testing/selftests/mm/config, so ideally the runtime environment
should also support THP.

However, in practice, we've found that on some systems:

- THP is disabled at boot time (transparent_hugepage=3Dnever)
- Or manually disabled via sysfs
- Or unavailable in RT kernels, containers, or minimal CI environments

In these cases, the test will fail with EINVAL on madvise(MADV_HUGEPAGE),
even though the kernel config is correct.

To make the test suite more robust and avoid false negatives, this patch
adds a runtime check for /sys/kernel/mm/transparent_hugepage/enabled.

If THP is not available, the hugepage test (-H) is skipped with a clear
message.

Link: https://lkml.kernel.org/r/20250624032748.393836-1-liwang@redhat.com
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
+		ksft_test_result_skip("Transparent Hugepages not available\n");
+		return;
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

selftests-mm-fix-uffdio_api-usage-with-proper-two-step-feature-negotiation.patch
ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch

