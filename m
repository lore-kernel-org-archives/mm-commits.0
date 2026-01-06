Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC29535580B
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720489; cv=none; b=Ru0Z0jKwfeRYIRnlaN0qE2HBdLTHCm7iPMHFp0mUd8Dnap8i6vVgDl8vDJB0cNqMU7AlgCtBzwEL2ldp5SbhbCaYCvavpuAJXbHMpTb2PQWlay789Xpvvx5v4DJR3w6jBD4FprPgbRMZzq1EPjkeZ791ZekAlLz34SJdNfJoutg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720489; c=relaxed/simple;
	bh=dhUofWTOhUeBdfwBDtzxRpAfTg9UpU+/KJzBvAzjzVs=;
	h=Date:To:From:Subject:Message-Id; b=oby+KeB9PYrTKy/w19fGGx8j9h5Tcuq0Hf4B1xp9YE/ux5RSFmtn4ohMpStQr8dFq8g0Qkpnt8fm8yeHBgf6n5uGm40vFftl5sg0Hcd+xkRhv0ffjOl24wi1uKca/M3cdQ1ZoIeUgePlt9jzD2bSNVfsmfEfuIHDAIOSqcBXyqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fi/a4R/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fi/a4R/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A857BC116C6;
	Tue,  6 Jan 2026 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767720488;
	bh=dhUofWTOhUeBdfwBDtzxRpAfTg9UpU+/KJzBvAzjzVs=;
	h=Date:To:From:Subject:From;
	b=Fi/a4R/drrajKOBOr2eN6nj9VuhtXxIIaOWOhKK67ouwZz24zac1/Hu6Th8Ico1ez
	 bJHYAHNIRe5y3zvdTSs5U/4a7iIJMK/WNmi4gIfaMu78xAlwdAo7lvltHVXf7SvoEQ
	 PBZeuicBUNi1AL89/HtxuTcDl9PARE29sH1uB1AY=
Date: Tue, 06 Jan 2026 09:28:08 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,Liam.Howlett@oracle.com,liam.howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch added to mm-hotfixes-unstable branch
Message-Id: <20260106172808.A857BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: fix gup_longterm for unknown fs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: fix gup_longterm for unknown fs
Date: Tue, 6 Jan 2026 15:45:47 +0000

Commit 66bce7afbaca ("selftests/mm: fix test result reporting in
gup_longterm") introduced a small bug causing unknown filesystems to
always result in a test failure.

This is because do_test() was updated to use a common reporting path, but
this case appears to have been missed.

This is problematic for e.g.  virtme-ng which uses an overlayfs file
system, causing gup_longterm to appear to fail each time due to a test
count mismatch:

	# Planned tests != run tests (50 != 46)
	# Totals: pass:24 fail:0 xfail:0 xpass:0 skip:22 error:0

The fix is to simply change the return into a break.

Link: https://lkml.kernel.org/r/20260106154547.214907-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~tools-testing-selftests-fix-gup_longterm-for-unknown-fs
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -179,7 +179,7 @@ static void do_test(int fd, size_t size,
 		if (rw && shared && fs_is_unknown(fs_type)) {
 			ksft_print_msg("Unknown filesystem\n");
 			result = KSFT_SKIP;
-			return;
+			break;
 		}
 		/*
 		 * R/O pinning or pinning in a private mapping is always
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch
tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch

