Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8563E647
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 01:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744247208; cv=none; b=ZnAZst+o8VNIHKFxsREbaeSAth5gCu0CyiifBKQeLkfkwGV5VgwOWnD6kUyr/ZRuZ5BbBjpzjv98YYDLtXdJ0dMK4xHqzSUzVRWEs6JDxUl2q7dN/tssHF55Lx0CYGv2Xmo60D+XZR1B1UGziPzk1ma46i/GDn9xhp+vO5DVV90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744247208; c=relaxed/simple;
	bh=xle4OhDZzGoOoYsTGa1hiDCpKfWzEzsCxzz+LYXghO0=;
	h=Date:To:From:Subject:Message-Id; b=B0jMeBHF2SLq6aSlaobfZXmYgp/ydXafxU/w0IKLJytmcXrb/ezIa6+o1/bfXAo7vxNaJGERGa1Xi2DR3AQ2dJmXoby3a9Iap8ixDXPcCCP/+ZP4gc8bRmb66Iykm9xgOF5fJJdr4Zf1pEM8NJ0O/Myaw5ifjjffGX0JsMTUmr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SV7WVYB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SV7WVYB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F7DC4CEE2;
	Thu, 10 Apr 2025 01:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744247208;
	bh=xle4OhDZzGoOoYsTGa1hiDCpKfWzEzsCxzz+LYXghO0=;
	h=Date:To:From:Subject:From;
	b=SV7WVYB4FgaHQT4YboaNrcwtKeIT0g5fwu72yqk72MAP2jxkXfT0XhFueZOWbdESV
	 C8PaqeimZ0lhvoIsTW1GZZYBsY6o2a3xtk8mbSzQpVBo+7Imq9S79dmaRdalKhwaHt
	 9MMi7kzQ65ApKbR/toq7chwXtEhmaSkPhh2nKJ1Y=
Date: Wed, 09 Apr 2025 18:06:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-compiler-wmaybe-uninitialized-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410010648.31F7DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix compiler -Wmaybe-uninitialized warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-compiler-wmaybe-uninitialized-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-compiler-wmaybe-uninitialized-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: selftests/mm: fix compiler -Wmaybe-uninitialized warning
Date: Wed, 9 Apr 2025 15:20:06 +0530

Following build warning comes up for cow test as 'transferred' variable has
not been initialized. Fix the warning via zero init for the variable.

  CC       cow
cow.c: In function `do_test_vmsplice_in_parent':
cow.c:365:61: warning: `transferred' may be used uninitialized [-Wmaybe-uninitialized]
  365 |                 cur = read(fds[0], new + total, transferred - total);
      |                                                 ~~~~~~~~~~~~^~~~~~~
cow.c:296:29: note: `transferred' was declared here
  296 |         ssize_t cur, total, transferred;
      |                             ^~~~~~~~~~~
  CC       compaction_test
  CC       gup_longterm

Link: https://lkml.kernel.org/r/20250409095006.1422620-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-fix-compiler-wmaybe-uninitialized-warning
+++ a/tools/testing/selftests/mm/cow.c
@@ -293,7 +293,7 @@ static void do_test_vmsplice_in_parent(c
 		.iov_base = mem,
 		.iov_len = size,
 	};
-	ssize_t cur, total, transferred;
+	ssize_t cur, total, transferred = 0;
 	struct comm_pipes comm_pipes;
 	char *old, *new;
 	int ret, fds[2];
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

selftests-mm-fix-compiler-wmaybe-uninitialized-warning.patch
mm-ptdump-split-note_page-into-level-specific-callbacks.patch
mm-ptdump-split-effective_prot-into-level-specific-callbacks.patch
arm64-mm-define-ptdesc_t.patch

