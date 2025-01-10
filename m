Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404F4D515
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468156; cv=none; b=T3mPknorSi1pBjcm76svwRZa2phpGyekjwN6gjtrrTglYiTc2iYBB6VG7ANQXfLEBeSpIYml9c6YueOoNQ+OO4rrDdSrMUg1FOATczBzjXygWcTvOs/e0jn/YbEsGxLqnTSb0U9VVjLAe6io0wZUIYgqU628jGO47xYNaioHc4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468156; c=relaxed/simple;
	bh=WyJVn60/b1TC+q3sK3qmSxL3w2GGFDyawdfMcMJwcKg=;
	h=Date:To:From:Subject:Message-Id; b=BUZlm7fFQPEdYvKA6sCnLsr9rgs5AaG1mB9iAZfBVXbWaCeYW3Ug1x7TFUyN8dumiK7mCprJ7M0+2bbUa6gzHG6+0EEDrDU/o8/qkSWndNSr1Sn1NVTtmIzaSTQGw5Y22dw+ToJlX6WVwW9/LH59grzLadlLHedr8bjhrXXh26k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rYp5xCU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rYp5xCU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3934C4CED2;
	Fri, 10 Jan 2025 00:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468155;
	bh=WyJVn60/b1TC+q3sK3qmSxL3w2GGFDyawdfMcMJwcKg=;
	h=Date:To:From:Subject:From;
	b=rYp5xCU4eRTOtcdMYmiM/+FdYegV9TzABv2oUV03k3Aa1Z7dfibExjdk+VS7uRith
	 uaswgedSJNQUl03yucli0XmDxkZJJhQst86PkgVVkw1xWhZcA3T2hMpWTbHqvU7xoO
	 U3w9AiND2AsxDBmrgFu52OSS4vaIXhAtARpr2KxA=
Date: Thu, 09 Jan 2025 16:15:55 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch added to mm-unstable branch
Message-Id: <20250110001555.C3934C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb-madvise: fix type mismatch issues
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch

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
Subject: selftests/mm: hugetlb-madvise: fix type mismatch issues
Date: Thu, 9 Jan 2025 22:38:35 +0500

Fix type mismatch warnings:
  hugetlb-madvise.c:30:25: warning: comparison of integer expressions of different signedness: `int' and `long unsigned int' [-Wsign-compare]
     30 |                 if (fhp != (exp_free)) {                                \
        |                         ^~
  hugetlb-madvise.c:114:9: note: in expansion of macro `validate_free_pages'
    114 |         validate_free_pages(free_hugepages - NR_HUGE_PAGES);
        |         ^~~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20250109173842.1142376-10-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-hugetlb-madvise-fix-type-mismatch-issues
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -26,7 +26,7 @@
 
 #define validate_free_pages(exp_free)					\
 	do {								\
-		int fhp = get_free_hugepages();				\
+		unsigned int fhp = get_free_hugepages();		\
 		if (fhp != (exp_free)) {				\
 			printf("Unexpected number of free huge "	\
 				"pages line %d\n", __LINE__);		\
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

