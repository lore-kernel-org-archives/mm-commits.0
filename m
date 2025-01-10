Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFCDE56C
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468129; cv=none; b=rIlyr8nhowXNk6IOP8jITxFOUlXAbviPhUsshVrUO8j3wozGTGvrOvBCcLg0ZKCH07IfhDPiccoB3InXe2QSFhNlXqRhNLZ//ty3NYPvVQRpgv08jdFW4Tir6rMiw5x0oyu4OY+oonuEQZ2k3bCue7pAXgXpLIBdwU3YlOOCm3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468129; c=relaxed/simple;
	bh=BfoPE3VTbUGIMnvSZ3H3+VORXfdEHIYKaZhVWu7L5ag=;
	h=Date:To:From:Subject:Message-Id; b=TKk7x7JIQWE0PevvGN1xS+Gko8hWW8TcLyWwGCaivhsC3A/KtSkzAQ9+a13lifTaTJ4HR+xNcp0xfDLmoJ3FVA3uXY+6WAhNbSWVPIEu2YqPZc/ketDF+OzZh4IfVzpavsWwnU3F9/iilQGBBcXtm320s6YPwrNjJ8ajaRg4L/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fAnjSqd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fAnjSqd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24EBC4CED2;
	Fri, 10 Jan 2025 00:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468128;
	bh=BfoPE3VTbUGIMnvSZ3H3+VORXfdEHIYKaZhVWu7L5ag=;
	h=Date:To:From:Subject:From;
	b=fAnjSqd3ZA1UjpmhbC6ObJgt9RAA6MtSXBE8NZUaxptO077eAbXw08hCNbK0bpQ1y
	 HlWQaoq1wKsFDlviK6JVpJNScVWNZtBn989PODMdtVYlRk9O9i2gXI++nMYnaWggzA
	 kTW9pY+mBEukVSU/Vgay3Lyo/buytnTJjRhqjS6o=
Date: Thu, 09 Jan 2025 16:15:28 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-argc-and-argv-unused-parameters.patch added to mm-unstable branch
Message-Id: <20250110001528.A24EBC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove argc and argv unused parameters
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-argc-and-argv-unused-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-argc-and-argv-unused-parameters.patch

This patch will later appear in the mm-unstable branch at
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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: remove argc and argv unused parameters
Date: Thu, 9 Jan 2025 22:38:27 +0500

Patch series "selftest/mm: Remove warnings found by adding compiler flags".

Recently, I reviewed a patch on the mm/kselftest mailing list about a test
which had obvious type mismatch fix in it.  It was strange why that wasn't
caught during development and when patch was accepted.  This led me to
discover that those extra compiler options to catch these warnings aren't
being used.  When I added them, I found tens of warnings in just mm suite.

In this series, I'm fixing those warnings.  The last check adds the
compiler flags with which the warnings have been caught.


This patch (of 16):

Remove the following warnings by removing unused argc and argv
parameters:
In function `main':
  warning: unused parameter `argc' [-Wunused-parameter]
    158 | int main(int argc, char *argv[])
        |          ~~~~^~~~
  warning: unused parameter `argv' [-Wunused-parameter]
    158 | int main(int argc, char *argv[])
        |                    ~~~~~~^~~~~~

Link: https://lkml.kernel.org/r/20250109173842.1142376-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20250109173842.1142376-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c       |    2 +-
 tools/testing/selftests/mm/cow.c                   |    2 +-
 tools/testing/selftests/mm/droppable.c             |    2 +-
 tools/testing/selftests/mm/gup_longterm.c          |    2 +-
 tools/testing/selftests/mm/hugepage-vmemmap.c      |    2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c       |    2 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c  |    2 +-
 tools/testing/selftests/mm/madv_populate.c         |    2 +-
 tools/testing/selftests/mm/map_populate.c          |    2 +-
 tools/testing/selftests/mm/memfd_secret.c          |    2 +-
 tools/testing/selftests/mm/mlock-random-test.c     |    2 +-
 tools/testing/selftests/mm/mlock2-tests.c          |    2 +-
 tools/testing/selftests/mm/on-fault-limit.c        |    2 +-
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    2 +-
 tools/testing/selftests/mm/soft-dirty.c            |    2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c        |    2 +-
 tools/testing/selftests/mm/virtual_address_range.c |    2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -194,7 +194,7 @@ int set_zero_hugepages(unsigned long *in
 	return ret;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct rlimit lim;
 	struct map_list *list = NULL, *entry;
--- a/tools/testing/selftests/mm/cow.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/cow.c
@@ -1769,7 +1769,7 @@ static int tests_per_non_anon_test_case(
 	return tests;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int err;
 	struct thp_settings default_settings;
--- a/tools/testing/selftests/mm/droppable.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/droppable.c
@@ -15,7 +15,7 @@
 
 #include "../kselftest.h"
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	size_t alloc_size = 134217728;
 	size_t page_size = getpagesize();
--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -444,7 +444,7 @@ static int tests_per_test_case(void)
 	return 3 + nr_hugetlbsizes;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int i, err;
 
--- a/tools/testing/selftests/mm/hugepage-vmemmap.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -87,7 +87,7 @@ static int check_page_flags(unsigned lon
 	return 0;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	void *addr;
 	unsigned long pfn;
--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -58,7 +58,7 @@ void read_fault_pages(void *addr, unsign
 	}
 }
 
-int main(int argc, char **argv)
+int main(int __attribute__((unused)) argc, char **argv)
 {
 	unsigned long free_hugepages;
 	void *addr, *addr2;
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -216,7 +216,7 @@ static void test_soft_offline_common(int
 			 enable_soft_offline);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	ksft_print_header();
 	ksft_set_plan(2);
--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -281,7 +281,7 @@ static int system_has_softdirty(void)
 #endif
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int nr_tests = 16;
 	int err;
--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -74,7 +74,7 @@ static int child_f(int sock, unsigned lo
 	return ksft_cnt.ksft_pass;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int sock[2], child, ret;
 	FILE *ftmp;
--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -297,7 +297,7 @@ static void prepare(void)
 
 #define NUM_TESTS 6
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	int fd;
 
--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -425,7 +425,7 @@ static void test_mlockall(void)
 	munlockall();
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int ret, size = 3 * getpagesize();
 	void *map;
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -236,7 +236,7 @@ static void test_mlock_outof_limit(char
 	ksft_test_result_pass("%s\n", __func__);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	char *p = NULL;
 
--- a/tools/testing/selftests/mm/on-fault-limit.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/on-fault-limit.c
@@ -28,7 +28,7 @@ static void test_limit(void)
 	munlockall();
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	ksft_print_header();
 	ksft_set_plan(1);
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -528,7 +528,7 @@ static void (*pkey_tests[])(void) = {
 	test_pkru_sigreturn
 };
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	int i;
 
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -187,7 +187,7 @@ static void test_mprotect_file(int pagem
 	test_mprotect(pagemap_fd, pagesize, false);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int pagemap_fd;
 	int pagesize;
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -331,7 +331,7 @@ static const struct testcase testcases[]
 	},
 };
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct thp_settings settings;
 	int i, j, plan = 0;
--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-remove-argc-and-argv-unused-parameters
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -160,7 +160,7 @@ static int validate_complete_va_space(vo
 	return 0;
 }
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	char *ptr[NR_CHUNKS_LOW];
 	char **hptr;
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch
selftests-mm-remove-argc-and-argv-unused-parameters.patch
selftests-mm-fix-unused-parameter-warnings.patch
selftests-mm-fix-type-mismatch-warnings.patch
selftests-mm-kselftest_harness-fix-warnings.patch
selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch
selftests-mm-hmm-tests-remove-always-false-expressions.patch
selftests-mm-guard-pages-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch
selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch
selftests-mm-khugepaged-fix-type-mismatch-warnings.patch
selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch
selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch
selftests-mm-uffd-fix-all-type-mismatch-warnings.patch
selftests-mm-makefile-add-the-compiler-flags.patch

