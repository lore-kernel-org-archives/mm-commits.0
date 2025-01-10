Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63324D51C
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468154; cv=none; b=ohgtTfvpmy/J7ZNtd5P7ELUeB1rLBsvU53RHtumxinMPJAiVivuucEjPy9R6r6C2CmVHiI3OLern1sOKrW55A3+ciRJ9Q83KGY2fIHI2MxKhwohfuj310yZaApeoXSPsKKckr4zV0G4eGN550nuKEjyZylVnKJf0joEdRDDLyM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468154; c=relaxed/simple;
	bh=W3ziIdTOt+C4FvEFErGCIDGXtNj/LGg9r5UVmyQED9I=;
	h=Date:To:From:Subject:Message-Id; b=AxAPmNHE4I5bzXyEeb/HNCk0wLiMbUGXtbGsdyYzecdhQzgfMtct3SS7/4hBdIT0kZUmIHshsdpQ7AJQ+UbwoF6XZsTq6RO7t/ccjeE4TChq/uBlRQk7/QaUyGPUqGuWf099tHmljUGSm8iflf9hvSxDLD0Gjm+lel8Jsgo4wm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gtnkVGEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gtnkVGEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7EEC4CED3;
	Fri, 10 Jan 2025 00:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468154;
	bh=W3ziIdTOt+C4FvEFErGCIDGXtNj/LGg9r5UVmyQED9I=;
	h=Date:To:From:Subject:From;
	b=gtnkVGEbBZ/ED3GF1IQ6C0ipYoz7KYoWdqC6nxL8nlEsHc6//nOzV7O61yKpCkq6O
	 laesYaxC5Wa0GzUf+A7udE56ua4HudM/txn0zji4mPwkyr9o6rMohTEG2jiQhvdapE
	 MUwiGD330oEIF8STLhB0pQi3B8xuqOciTgcDMye0=
Date: Thu, 09 Jan 2025 16:15:53 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-guard-pages-fix-type-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001553.DF7EEC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: guard-pages: fix type mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-guard-pages-fix-type-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-guard-pages-fix-type-mismatch-warnings.patch

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
Subject: selftests/mm: guard-pages: fix type mismatch warnings
Date: Thu, 9 Jan 2025 22:38:34 +0500

Fix type mismatch warnings.

Link: https://lkml.kernel.org/r/20250109173842.1142376-9-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-pages.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/guard-pages.c~selftests-mm-guard-pages-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/guard-pages.c
@@ -142,7 +142,7 @@ TEST_F(guard_pages, basic)
 	const unsigned long NUM_PAGES = 10;
 	const unsigned long page_size = self->page_size;
 	char *ptr;
-	int i;
+	unsigned int i;
 
 	ptr = mmap(NULL, NUM_PAGES * page_size, PROT_READ | PROT_WRITE,
 		   MAP_PRIVATE | MAP_ANON, -1, 0);
@@ -1044,7 +1044,7 @@ TEST_F(guard_pages, fork_cow)
 	const unsigned long page_size = self->page_size;
 	char *ptr;
 	pid_t pid;
-	int i;
+	unsigned int i;
 
 	/* Map 10 pages. */
 	ptr = mmap(NULL, 10 * page_size, PROT_READ | PROT_WRITE,
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

