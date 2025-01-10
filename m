Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C17DDCD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468163; cv=none; b=aVZc4n4f44kSb3unyCuniXAAsHeF2IpXFpk/kET/UdQMjEOkF7ldX5mMaRlbd3GDKXJ1Gbb20n6nvBlaZSEk78zwBJ8VnkrE9iYLUW6Ct0gkw8mlbhry2mCX1Fwp+7pJmfGd3C2CF+OIi4D4QOEYO39HgKZ5Uvw6azCX9xgrd6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468163; c=relaxed/simple;
	bh=YMkUoQa6JW8hQc2uMo4LnB5guYeb7UAihWSNpZy7tBU=;
	h=Date:To:From:Subject:Message-Id; b=gSnKNQ7+8FMeiea4kvFtZLyzIvsMIOlqq4rb5BmSF1/uuPDIPy20w8PsxbV8fShP+M7lyUlwh3JszkOJw6/xnUHMfy+0pXhTubdtGBbTQRG/c3g0/fCEcVDqyetowCNoqEEVGBnozotXuBfaFt9WPxMdqOwZymIs/3x14sqoVi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DciYMA9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DciYMA9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AE1C4CED2;
	Fri, 10 Jan 2025 00:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468163;
	bh=YMkUoQa6JW8hQc2uMo4LnB5guYeb7UAihWSNpZy7tBU=;
	h=Date:To:From:Subject:From;
	b=DciYMA9stzZfF4eiyNHK8aWz3Oivd3Of6AKp25oIXX8xAdSnDynRLm1M+48ici5JH
	 ucGilWaaVVCpIFgPZm0Sb1j61GhbMkgvR0IgFD7J7iv6YRBMoY+uPUxIx6F/O6l4uV
	 loewgFMus+Bg9YtkVe0aRBb3U9qLqscZHyx45lo4=
Date: Thu, 09 Jan 2025 16:16:02 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001603.77AE1C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: protection_keys: fix variables types mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch

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
Subject: selftests/mm: protection_keys: fix variables types mismatch warnings
Date: Thu, 9 Jan 2025 22:38:39 +0500

Fix variable type mismatch warnings.

Link: https://lkml.kernel.org/r/20250109173842.1142376-14-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-fix-variables-types-mismatch-warnings
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -78,7 +78,7 @@ static void cat_into_file(char *str, cha
 	}
 
 	ret = write(fd, str, strlen(str));
-	if (ret != strlen(str)) {
+	if (ret != (signed int)strlen(str)) {
 		perror("write to file failed");
 		fprintf(stderr, "filename: '%s' str: '%s'\n", file, str);
 		exit(__LINE__);
@@ -597,10 +597,10 @@ struct pkey_malloc_record *pkey_last_mal
 static long nr_pkey_malloc_records;
 void record_pkey_malloc(void *ptr, long size, int prot)
 {
-	long i;
+	unsigned long i;
 	struct pkey_malloc_record *rec = NULL;
 
-	for (i = 0; i < nr_pkey_malloc_records; i++) {
+	for (i = 0; i < (unsigned long)nr_pkey_malloc_records; i++) {
 		rec = &pkey_malloc_records[i];
 		/* find a free record */
 		if (rec)
@@ -866,7 +866,7 @@ static int nr_test_fds;
 static void __save_test_fd(int fd)
 {
 	pkey_assert(fd >= 0);
-	pkey_assert(nr_test_fds < ARRAY_SIZE(test_fds));
+	pkey_assert(nr_test_fds < (signed int)ARRAY_SIZE(test_fds));
 	test_fds[nr_test_fds] = fd;
 	nr_test_fds++;
 }
@@ -897,7 +897,7 @@ static void test_pkey_alloc_free_attach_
 	int max_nr_pkey_allocs;
 	int alloced_pkeys[NR_PKEYS];
 	int nr_alloced = 0;
-	long size;
+	unsigned long size;
 
 	pkey_assert(pkey_last_malloc_record);
 	size = pkey_last_malloc_record->size;
@@ -1280,7 +1280,7 @@ static void test_pkey_init_state(int *pt
  */
 static void test_mprotect_with_pkey_0(int *ptr, u16 pkey)
 {
-	long size;
+	unsigned long size;
 	int prot;
 
 	assert(pkey_last_malloc_record);
@@ -1528,7 +1528,7 @@ static void test_ptrace_modifies_pkru(in
 	pkey_assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);
 
 	xsave = (void *)malloc(xsave_size);
-	pkey_assert(xsave > 0);
+	pkey_assert(xsave != NULL);
 
 	/* Modify the PKRU register directly */
 	iov.iov_base = xsave;
@@ -1725,7 +1725,7 @@ static void run_tests_once(void)
 	int *ptr;
 	int prot = PROT_READ|PROT_WRITE;
 
-	for (test_nr = 0; test_nr < ARRAY_SIZE(pkey_tests); test_nr++) {
+	for (test_nr = 0; test_nr < (signed int)ARRAY_SIZE(pkey_tests); test_nr++) {
 		int pkey;
 		int orig_pkey_faults = pkey_faults;
 
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

