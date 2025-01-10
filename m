Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F927D515
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468170; cv=none; b=rA5S4PavnVgucsKjij6PLfHLAAwjAVYzR3aaUzUL54+/4nGgnhLldQPS8E/BZKtGyceC4BgfBD/EnF6N+cfN5TgAfqAr9yO9UFlMTvCiHp9AP1dI+jmQ8WYoN8PmVuq7OsAiNrVeZP9vE/ugbKZpzBHHJ1B3RwSam4RJCdljcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468170; c=relaxed/simple;
	bh=6/g3IhTmkcrLLiTFHTiHYIOYSuBlnUESfJ0GoDKK8QM=;
	h=Date:To:From:Subject:Message-Id; b=X+LSlYUJFPzRXh24+SAMWbkO4ZLwR4Ky+aQTsyf7Pfs0QHehjAAyv0WA4J9i2hvTRhlBhfKp1d7FclCjIYAkZjzEZHjqOjk9y/UtDraxiORzRxh3Z8laOV1XGPZOJd+KGM/ArCnHmIW7Ux5YyYRV52ydcLSLNj3DNmTq8wvhkpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPyIXXuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPyIXXuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB44C4CED2;
	Fri, 10 Jan 2025 00:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468170;
	bh=6/g3IhTmkcrLLiTFHTiHYIOYSuBlnUESfJ0GoDKK8QM=;
	h=Date:To:From:Subject:From;
	b=QPyIXXuRRGmYj8SNv295PTRscrDUJqnpBsUmnOHBHFeXY4+r7wKpDpygvl15otKNc
	 qfl7CziY4fErJD+JSaFD25r01BoevG5COmCuuGWVe+rpTp6ozQSmi8LtRP7OlQ5ajC
	 gT5lWUsvnahOR/WL9M7vmpqOFD34g7LrA0s+xP6A=
Date: Thu, 09 Jan 2025 16:16:09 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-makefile-add-the-compiler-flags.patch added to mm-unstable branch
Message-Id: <20250110001609.EDB44C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: Makefile: add the compiler flags
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-makefile-add-the-compiler-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-makefile-add-the-compiler-flags.patch

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
Subject: selftests/mm: Makefile: add the compiler flags
Date: Thu, 9 Jan 2025 22:38:42 +0500

Add the compiler flags to catch warnings during development.

Link: https://lkml.kernel.org/r/20250109173842.1142376-17-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-makefile-add-the-compiler-flags
+++ a/tools/testing/selftests/mm/Makefile
@@ -34,6 +34,7 @@ endif
 MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS += -Wunreachable-code -Wunused -Wunused-parameter -Wunused-function -Wunused-variable
 LDLIBS = -lrt -lpthread -lm
 
 # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
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

