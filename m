Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACD1DDA8
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468152; cv=none; b=drp38WOIE1aVkaNxgRYMUj2GRo/One+a38yWl4ZNXSjQvXXivaI0ei2sJBYMNmLZxAFgGWJQQOytKO+QrZJf4uCd4XFmdFbqwcMLzopTVJ51JUPPj8QVZKJzb2kdAurLZfzx0/rJ3GxlgLAk25W7qnyF/JWeRjakl0WTZN+PEfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468152; c=relaxed/simple;
	bh=db/aud/YRd1yE/xjk/6bJS+b9bhgKFn/6F2Ts0flOJg=;
	h=Date:To:From:Subject:Message-Id; b=un4Xv1G7msWr/9ZVnGogii7LjHsUak5gMqFnT7X0xPYlxvK8ZwR7McG3puUHrtRlQlP9tPLrU44IKl57n4xw99+l5xxQcg2fyleCNdsXWFBUbU0/ldJ62dSCfM5ZmB2vD71+U8v4d5uZMr62uqKcWy1J8HMhY5HLIm9yZ+DIfwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DCTwoP2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DCTwoP2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0350CC4CED2;
	Fri, 10 Jan 2025 00:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468152;
	bh=db/aud/YRd1yE/xjk/6bJS+b9bhgKFn/6F2Ts0flOJg=;
	h=Date:To:From:Subject:From;
	b=DCTwoP2/SYCU3R+TjOVGXoacUpBiWrIIRdqWj+hmjcWhcCPjw6jatPO8lp1/Szeoy
	 61W7oGBB17DhvI3fkCvwnhbw5plXunDgdA7VsgKLehbnygxCe6Y7nuCeOPNoYZLJ9M
	 730R/V4ePknauYjlM4HjxLk9dupJ9YqpvJNlYN9A=
Date: Thu, 09 Jan 2025 16:15:51 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hmm-tests-remove-always-false-expressions.patch added to mm-unstable branch
Message-Id: <20250110001552.0350CC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hmm-tests: remove always false expressions
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hmm-tests-remove-always-false-expressions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hmm-tests-remove-always-false-expressions.patch

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
Subject: selftests/mm: hmm-tests: remove always false expressions
Date: Thu, 9 Jan 2025 22:38:33 +0500

As default_hsize is unsigned, it is always greater than equal to zero.
Remove expression which is checking if it is less than 0.

Link: https://lkml.kernel.org/r/20250109173842.1142376-8-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-hmm-tests-remove-always-false-expressions
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -796,7 +796,7 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	int ret;
 
 	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
-	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
+	if (default_hsize*1024 < default_hsize)
 		SKIP(return, "Huge page size could not be determined");
 	default_hsize = default_hsize*1024; /* KB to B */
 
@@ -1579,7 +1579,7 @@ TEST_F(hmm, compound)
 	/* Skip test if we can't allocate a hugetlbfs page. */
 
 	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
-	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
+	if (default_hsize*1024 < default_hsize)
 		SKIP(return, "Huge page size could not be determined");
 	default_hsize = default_hsize*1024; /* KB to B */
 
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

