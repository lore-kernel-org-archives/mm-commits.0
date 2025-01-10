Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931BBA2D
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468150; cv=none; b=SUHK3QLmRjdyh/aE8BUox7VGM4sX38V4KMRWF06gbZIXiha7pf1L+usW0pNknfbIMXMlG2h6V63hzERRkJlZN53LW4fubVlVyJp/XqezXp0UELL4G1CYpB7hizp23NT8I6nsKYxZ/SdaPcT1dv/om0b+TlFhQ1AcPpMVfPK5csk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468150; c=relaxed/simple;
	bh=KKPVO86Vrs8hxcBvg/8UGBMxpwQ+IpdK456aF8/8mvQ=;
	h=Date:To:From:Subject:Message-Id; b=q8TL8D8O1f53nb9K7mlSyZzmIU9rxYPPpF9k0i8pxUPga46EpeINqWDdPt/8QVzYZmdqxeEvvwZVa68450Bbz4q4Dbt9CfoufKIH1yuPfAeflQEHTo5f+Hhn20l5BZwvJEKlPd10T8F7E2myVehZwqQ6rUE3VxKPjEgA/W87gk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POKA2fQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POKA2fQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12648C4CED2;
	Fri, 10 Jan 2025 00:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468150;
	bh=KKPVO86Vrs8hxcBvg/8UGBMxpwQ+IpdK456aF8/8mvQ=;
	h=Date:To:From:Subject:From;
	b=POKA2fQQBH/n70QvYEkfrfnv7OkEfhR5vuEFwOCm0DWB4yDBPOQjjMmIw+tg9SU5H
	 lww762YB4cnw0oFqZP4v/8WK9IIjzN4A8C4OEm+UfRIYio08Bm5AYSBoFiYEmjjRCw
	 OgTJriuTZNT7Xda6ytHtXP4Opk55NvVlmgHx0j6c=
Date: Thu, 09 Jan 2025 16:15:49 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch added to mm-unstable branch
Message-Id: <20250110001550.12648C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: cow: remove unused variables and fix type mismatch errors
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch

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
Subject: selftests/mm: cow: remove unused variables and fix type mismatch errors
Date: Thu, 9 Jan 2025 22:38:32 +0500

Fix following warnings:
- Remove unused variables
- Use __attribute__(unused) with unused variables which aren't being
  used and cannot be removed because of function pointer declaration
- Fix type mismatches

Link: https://lkml.kernel.org/r/20250109173842.1142376-7-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   46 +++++++++++++++++------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors
+++ a/tools/testing/selftests/mm/cow.c
@@ -84,7 +84,7 @@ static void detect_huge_zeropage(void)
 		return;
 
 	ret = pread(fd, buf, sizeof(buf), 0);
-	if (ret > 0 && ret < sizeof(buf)) {
+	if (ret > 0 && (unsigned int)ret < sizeof(buf)) {
 		buf[ret] = 0;
 
 		enabled = strtoul(buf, NULL, 10);
@@ -263,12 +263,14 @@ close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_cow_in_parent(char *mem, size_t size, bool is_hugetlb)
+static void test_cow_in_parent(char *mem, size_t size,
+			       bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_cow_in_parent(mem, size, false, child_memcmp_fn, false);
 }
 
-static void test_cow_in_parent_mprotect(char *mem, size_t size, bool is_hugetlb)
+static void test_cow_in_parent_mprotect(char *mem, size_t size,
+					bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_cow_in_parent(mem, size, true, child_memcmp_fn, false);
 }
@@ -408,10 +410,11 @@ static void do_test_iouring(char *mem, s
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	struct io_uring ring;
-	ssize_t cur, total;
 	struct iovec iov;
 	char *buf, *tmp;
+	size_t total;
 	int ret, fd;
+	ssize_t cur;
 	FILE *file;
 
 	ret = setup_comm_pipes(&comm_pipes);
@@ -515,7 +518,7 @@ static void do_test_iouring(char *mem, s
 		goto quit_child;
 	}
 
-	if (cqe->res != size) {
+	if ((unsigned int) cqe->res != size) {
 		ksft_test_result_fail("write_fixed failed\n");
 		goto quit_child;
 	}
@@ -529,7 +532,7 @@ static void do_test_iouring(char *mem, s
 			ksft_test_result_fail("pread() failed\n");
 			goto quit_child;
 		}
-		total += cur;
+		total += (size_t)cur;
 	}
 
 	/* Finally, check if we read what we expected. */
@@ -553,12 +556,14 @@ close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_iouring_ro(char *mem, size_t size, bool is_hugetlb)
+static void test_iouring_ro(char *mem, size_t size,
+			    bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_iouring(mem, size, false);
 }
 
-static void test_iouring_fork(char *mem, size_t size, bool is_hugetlb)
+static void test_iouring_fork(char *mem, size_t size,
+			      bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_iouring(mem, size, true);
 }
@@ -702,36 +707,38 @@ free_tmp:
 	free(tmp);
 }
 
-static void test_ro_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
+static void test_ro_pin_on_shared(char *mem, size_t size,
+				  bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, false);
 }
 
-static void test_ro_fast_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
+static void test_ro_fast_pin_on_shared(char *mem, size_t size,
+				       bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, true);
 }
 
 static void test_ro_pin_on_ro_previously_shared(char *mem, size_t size,
-		bool is_hugetlb)
+						bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, false);
 }
 
 static void test_ro_fast_pin_on_ro_previously_shared(char *mem, size_t size,
-		bool is_hugetlb)
+						     bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, true);
 }
 
 static void test_ro_pin_on_ro_exclusive(char *mem, size_t size,
-		bool is_hugetlb)
+					bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, false);
 }
 
 static void test_ro_fast_pin_on_ro_exclusive(char *mem, size_t size,
-		bool is_hugetlb)
+					     bool __attribute__((unused)) is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, true);
 }
@@ -1192,7 +1199,7 @@ static void run_anon_test_case(struct te
 
 static void run_anon_test_cases(void)
 {
-	int i;
+	unsigned int i;
 
 	ksft_print_msg("[INFO] Anonymous memory tests in private mappings\n");
 
@@ -1420,7 +1427,7 @@ static const struct test_case anon_thp_t
 
 static void run_anon_thp_test_cases(void)
 {
-	int i;
+	unsigned int i;
 
 	if (!pmdsize)
 		return;
@@ -1457,13 +1464,14 @@ static void test_cow(char *mem, const ch
 			 "Other mapping not modified\n");
 	free(old);
 }
+//typedef void (*non_anon_test_fn)(char *mem, const char *smem, size_t size);
 
-static void test_ro_pin(char *mem, const char *smem, size_t size)
+static void test_ro_pin(char *mem, const char __attribute__((unused)) *smem, size_t size)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST, false);
 }
 
-static void test_ro_fast_pin(char *mem, const char *smem, size_t size)
+static void test_ro_fast_pin(char *mem, const char __attribute__((unused)) *smem, size_t size)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST, true);
 }
@@ -1752,7 +1760,7 @@ static void run_non_anon_test_case(struc
 
 static void run_non_anon_test_cases(void)
 {
-	int i;
+	unsigned int i;
 
 	ksft_print_msg("[RUN] Non-anonymous memory tests in private mappings\n");
 
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

