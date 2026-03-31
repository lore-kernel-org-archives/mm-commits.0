Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAF63A3821
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 23:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775001178; cv=none; b=ULxG3mKzW6IX4WraXWYNp8NgHAsA6vlBaiODgmbkEy0hj2Nk7Is/xVfmJP4yZcMdkfrMyfIqmQqxcBavmHWcgCQbWEDzT6qyNE8lgrzCGAK+Hc5nD//rGdoyvyzMZsEVotMDFfN1sVBF8xFlF7wG2hfOjxO0csgd4WD9tEk4eys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775001178; c=relaxed/simple;
	bh=uZnIk8Fk6owOgVVJi1BYxoFznQAW6liNYVMRwZtUD5U=;
	h=Date:To:From:Subject:Message-Id; b=UWDsDmwdOHC8/iFYk41y/exC0kMzD4rPMqVuN/E+zsF9ltvbTxMRXvkvCy31BoP79e92NXJJcdHT43WWy88ilBfS1EONdbT+GGXUm/ao+YhLRY9ixUscGheYOKLjMKHxPGxhzlCngdj09TUEZOtIdYFn8WJ8EK3aDiCRsKW+ehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TmU3dTta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TmU3dTta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD187C19423;
	Tue, 31 Mar 2026 23:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775001177;
	bh=uZnIk8Fk6owOgVVJi1BYxoFznQAW6liNYVMRwZtUD5U=;
	h=Date:To:From:Subject:From;
	b=TmU3dTtanvnpPl3M1WUjbKFaHZhkRqU7Bqvcto3Xy7O3jlc/mR3iIlTcCWYW+2ed2
	 Tap/5wZHQwnJw7D33ejxuW4dvXdS9x1Hg1d5K8dPQshT/CEI51L0bxqpx7XVw68G/q
	 IZiEg4t6Rvljc5kgMvDNuGGcB6w0JRX/Jq4xbxQk=
Date: Tue, 31 Mar 2026 16:52:57 -0700
To: mm-commits@vger.kernel.org,liwang@redhat.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20260331235257.AD187C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes
Date: Tue Mar 31 04:51:23 PM PDT 2026

ERROR: code indent should use tabs where possible
#94: FILE: tools/testing/selftests/mm/hugetlb_dio.c:48:
+^I^I^I        unsigned int end_off, unsigned int align)$

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -45,7 +45,7 @@ static int get_dio_alignment(int fd)
 }
 
 static bool check_dio_alignment(unsigned int start_off,
-			        unsigned int end_off, unsigned int align)
+				unsigned int end_off, unsigned int align)
 {
 	unsigned int writesize = end_off - start_off;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch
selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

