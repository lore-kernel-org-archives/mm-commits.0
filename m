Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC125684
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183066; cv=none; b=Ef5AP9YnijM1W2MHYE5aB6y2ee0NBopwVrscyKnkPCEbf6b/A+nTKPL5hDZvhk9wWRw6HKKLcFiRdY67zLxSNzPp33FSlXjgGnpHHcqL1NCFo8HiyPWA2q4rf28PPCTveQuPUtBUCDMX46nTHTRxHJ/CpJoz1lH/eRUGKaSDkXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183066; c=relaxed/simple;
	bh=v0FKscKlHCLZaFCtbVOEQ7SwSVcgSVuPtkIfrhW8+E0=;
	h=Date:To:From:Subject:Message-Id; b=LmChFLuRBBeBGWajtR6ALccvCwuiPm07odGxXYByrnddjT4k4K6OxRU+geMM77faWVbdFbZk/cfbEHO1UJ+qkVPw78Yzun5lx+rEUo24F6XntyJph2UawYEXwLoQ+0H2YVhO+uRcLhU5sNBcA1kGd6Vt184dxBdRzAKvuCbi3cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myuxvTWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myuxvTWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAE5C4CED6;
	Sat, 22 Feb 2025 00:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183066;
	bh=v0FKscKlHCLZaFCtbVOEQ7SwSVcgSVuPtkIfrhW8+E0=;
	h=Date:To:From:Subject:From;
	b=myuxvTWixpkxqTk/8PLH531izlw4JPvaawozWfJeWUyuoZANZOkZdDqtz6fVGcfhL
	 veQLZo8PfgLTLSFpMSZ2wtMpBjHrqQ9Aa4nUKh/XLnCJR6OpleQRqqw1Ksuj38Tgkk
	 jF0ARWJt+xH7spuQBzu6s/DNIxPpTvyiPw+WA1vI=
Date: Fri, 21 Feb 2025 16:11:05 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch added to mm-unstable branch
Message-Id: <20250222001106.4EAE5C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip uffd-wp-mremap if userfaultfd not available
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip uffd-wp-mremap if userfaultfd not available
Date: Fri, 21 Feb 2025 18:25:43 +0000

It's obvious that this should fail in that case, but still, save the
reader the effort of figuring out that they've run into this by just
SKIPping

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-4-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-wp-mremap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -182,7 +182,10 @@ static void test_one_folio(size_t size,
 
 	/* Register range for uffd-wp. */
 	if (userfaultfd_open(&features)) {
-		ksft_test_result_fail("userfaultfd_open() failed\n");
+		if (errno == ENOENT)
+			ksft_test_result_skip("userfaultfd not available\n");
+		else
+			ksft_test_result_fail("userfaultfd_open() failed\n");
 		goto out;
 	}
 	if (uffd_register(uffd, mem, size, false, true, false)) {
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

