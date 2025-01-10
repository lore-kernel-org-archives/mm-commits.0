Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9C6D515
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468158; cv=none; b=GfqejB92hgZvO7rLbITyt5bsRKd/i5lamhwj9yIzk6STue7XJcqhfFrUyDUzCc3LDpeI8AHwRuOHXdDoGzJfVLAkOpHwIM1MNVTppjsxblazzlAT7iCkD7VzcEDBTzWjkaDYng9RyrCkWlVplVR9ehUVwTOaruGtEe1VOS4uxgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468158; c=relaxed/simple;
	bh=yNEGJ7d4YhXdrvcm9g6CDXg31tOqoByR/uEvTUjXqfQ=;
	h=Date:To:From:Subject:Message-Id; b=IjrN5hEniwng4aajbpr7JINzvAqYteaL193lG3T/4WPV+OSXvPdLTlS2dgSFNsmFyopvam3KFSYiz1e9SWVE6Xm+7shQf5HrgYLaLL5mIiu3eclTr+zwcnV0sPX47Con097DvOGOJJAKVerFjOFRKD67FotW+vmukKBsFnQFznI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OvTp7+Cb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OvTp7+Cb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B75C4CED2;
	Fri, 10 Jan 2025 00:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468157;
	bh=yNEGJ7d4YhXdrvcm9g6CDXg31tOqoByR/uEvTUjXqfQ=;
	h=Date:To:From:Subject:From;
	b=OvTp7+CbUvBqHNIRr4FB8RL5AjqmLGuL8JY7NkEVZmjO6x5gndewLWKZoP7udPeRX
	 dm34+Bt57ehsrGbjn1iEVZ+uQ0/mNvj3I0llvm+vDWnQMM/WQd+Y/f3tTtz0IDHLE+
	 iIc52Oz/0EOPilE1nnhwSlGzt5moeYdpdyYrAaMI=
Date: Thu, 09 Jan 2025 16:15:57 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001557.A8B75C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugepage-vmemmap: fix type mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch

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
Subject: selftests/mm: hugepage-vmemmap: fix type mismatch warnings
Date: Thu, 9 Jan 2025 22:38:36 +0500

Fix type mismatch warnings.

Link: https://lkml.kernel.org/r/20250109173842.1142376-11-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-vmemmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugepage-vmemmap.c~selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -51,7 +51,8 @@ static unsigned long virt_to_pfn(void *a
 
 static int check_page_flags(unsigned long pfn)
 {
-	int fd, i;
+	int fd;
+	unsigned int i;
 	unsigned long pageflags;
 
 	fd = open("/proc/kpageflags", O_RDONLY);
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

