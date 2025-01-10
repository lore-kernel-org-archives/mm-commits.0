Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A45A2D
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468148; cv=none; b=OxHoyG9RCQm11MruwDI9kxRI75dxRia0rHr2rl+6YySd6Nl8ugX4OUQzWC+FtQTfZDp+dCl3sEG+W7jxQnuElJNwKl7E0Q8G5G+NfcOpZqrRiM6cnBxcXfufskXdUbDxdae4gA6w5aojsJP1o3xcVr3qxNtjovaxJpWvnoYJZHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468148; c=relaxed/simple;
	bh=pCf6JHZ1+UNVQGNyJpSMCAbYuHZWu27avlLLdDhn74o=;
	h=Date:To:From:Subject:Message-Id; b=eZqMoZmB6d0gB56HekDxp638vsi+kEkWkZkjQFIC8BQul/fksl40r3xlTytHPPXz6iQRGt8+f6F1lHPCCBR1kD0U3BTbpKN3g/Cp9mBasUNIohwwtsD54wXIIwnp1dnHw8cEc7j9kJwZ7VWpu6kfQHzCephaY7pGnSnJx20mBe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtuqaQzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtuqaQzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E885C4CED2;
	Fri, 10 Jan 2025 00:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468148;
	bh=pCf6JHZ1+UNVQGNyJpSMCAbYuHZWu27avlLLdDhn74o=;
	h=Date:To:From:Subject:From;
	b=ZtuqaQzAaofzJ/wdkn55HX8jI/LiMtDlAGtPW/ApNaKxQeOw3UMtwyJ/9VmOLZgO5
	 EhsDDTvpy008CxfX7eCvAMnkEYgYkHwciWx0po8SK1fVNPLErvMHzqPWlBU9fRC1tt
	 +lMYDFpfJL2aH/WFzKwXDmpDlEgl5kFj56w1QLwA=
Date: Thu, 09 Jan 2025 16:15:46 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-kselftest_harness-fix-warnings.patch added to mm-unstable branch
Message-Id: <20250110001548.1E885C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: kselftest_harness: Fix warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-kselftest_harness-fix-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-kselftest_harness-fix-warnings.patch

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
Subject: selftests/mm: kselftest_harness: Fix warnings
Date: Thu, 9 Jan 2025 22:38:31 +0500

Found warnings through hmm-tests and mdwe_test.

Fix following warnings:
- Mark unused variable with unused attribute
- __EXPECT is causing types mismatch warnings when __exp is unsigned and
  _seen is equal to a constant number, __typeof__(_seen) returns signed
  type.

  hmm-tests.c: In function `hmm_anon_read':
  ../kselftest_harness.h:523:52: warning: comparison of integer expressions of different signedness: `long unsigned int' and `int' [-Wsign-compare]
    523 |         __EXPECT(expected, #expected, seen, #seen, !=, 1)
        |                                                    ^~
  ../kselftest_harness.h:759:21: note: in definition of macro `__EXPECT'
    759 |         if (!(__exp _t __seen)) { \
        |                     ^~
  hmm-tests.c:303:9: note: in expansion of macro `ASSERT_NE'
    303 |         ASSERT_NE(npages, 0);
        |         ^~~~~~~~~
- Mark variant as unused:
mdwe_test.c: In function `wrapper_prctl_flags':
../kselftest_harness.h:177:52: warning: unused parameter `variant' [-Wunused-parameter]
  177 |                 struct __fixture_variant_metadata *variant) \
      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
../kselftest_harness.h:152:25: note: in expansion of macro `__TEST_IMPL'
  152 | #define TEST(test_name) __TEST_IMPL(test_name, -1)
      |                         ^~~~~~~~~~~
mdwe_test.c:23:1: note: in expansion of macro `TEST'
   23 | TEST(prctl_flags)
      | ^~~~

Link: https://lkml.kernel.org/r/20250109173842.1142376-6-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest_harness.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/kselftest_harness.h~selftests-mm-kselftest_harness-fix-warnings
+++ a/tools/testing/selftests/kselftest_harness.h
@@ -174,7 +174,7 @@
 	static void test_name(struct __test_metadata *_metadata); \
 	static inline void wrapper_##test_name( \
 		struct __test_metadata *_metadata, \
-		struct __fixture_variant_metadata *variant) \
+		struct __fixture_variant_metadata __attribute__((unused)) *variant) \
 	{ \
 		_metadata->setup_completed = true; \
 		if (setjmp(_metadata->env) == 0) \
@@ -756,7 +756,7 @@
 	/* Avoid multiple evaluation of the cases */ \
 	__typeof__(_expected) __exp = (_expected); \
 	__typeof__(_seen) __seen = (_seen); \
-	if (!(__exp _t __seen)) { \
+	if (!(__exp _t (__typeof__(_expected)) __seen)) { \
 		/* Report with actual signedness to avoid weird output. */ \
 		switch (is_signed_type(__exp) * 2 + is_signed_type(__seen)) { \
 		case 0: { \
@@ -965,7 +965,7 @@ static inline void __test_check_assert(s
 }
 
 struct __test_metadata *__active_test;
-static void __timeout_handler(int sig, siginfo_t *info, void *ucontext)
+static void __timeout_handler(int sig, siginfo_t *info, void __attribute__((unused)) *ucontext)
 {
 	struct __test_metadata *t = __active_test;
 
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

