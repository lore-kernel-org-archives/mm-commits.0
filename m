Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4158212C54C
	for <mm-commits@vger.kernel.org>; Thu,  7 Mar 2024 20:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709842542; cv=none; b=hcPHxkeHT6KIRQPZ4w9lmYPJkjqKZtPnPN4OiX3x5eWlliL7n17aZvkIwqwTvWOETQYO4OFKn/PgCm0IC1N+FeZzzZ1bbC9BisOJBXK0z/hezn8MkdBV22aRZ/Y1DNkC2qbisdvsMtmrz+swFe2FgHgEYtEeVaw05jbsQKAfYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709842542; c=relaxed/simple;
	bh=xwb3FvzNHSQWZ2h9A2osxq2lG0p2DnB9zK2CqFqLNTc=;
	h=Date:To:From:Subject:Message-Id; b=hzI88AVaOZlHbQKjUxl7nnAil3z/xndqMWUkdQAKR1TkhCVmlSXQwxMDXKDxmNAeeU8Q5C7UYCKS+5sZg3+DTTMZDcoRAlNouzvOK44qWBcKDvGywrLBy/U1/C2lMCXXI+ATTr6c7RQ9NQFpnro0occr9oLAE0kgqGHDY3IzMCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jjtEZmaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jjtEZmaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B68BC433C7;
	Thu,  7 Mar 2024 20:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709842540;
	bh=xwb3FvzNHSQWZ2h9A2osxq2lG0p2DnB9zK2CqFqLNTc=;
	h=Date:To:From:Subject:From;
	b=jjtEZmawZheOT0GWOCAFo8zEMHJZvGRT+rt+TR10HJqME/5z+7FlOKgV2+Y9BKJKw
	 RKpNCgvk0JbWQeryl5i66kFIrZNtw4Styxj/DdB5HPyAsLPCHmZMr8BOQMYKwnMb7C
	 WoTQE8XEORgp/MSZ9G/acrbeGkdMDVG322HH+5+4=
Date: Thu, 07 Mar 2024 12:15:39 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,muchun.song@linux.dev,ben@decadent.org.uk,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch added to mm-unstable branch
Message-Id: <20240307201540.7B68BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: dont fail testsuite due to a lack of hugepages
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch

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
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: dont fail testsuite due to a lack of hugepages
Date: Wed, 6 Mar 2024 15:37:12 -0700

Patch series "selftests/mm: Improve Hugepage Test Handling in MM
Selftests", v2.

This series addresses issues related to hugepage requirements in the MM
selftests, ensuring tests are skipped rather than failing when the
necessary hugepage count is not met.

This adjustment allows for a more graceful handling for systems with
insufficient hugepages, preventing unnecessary test failures and improving
the overall robustness of the test suite.


This patch (of 3):

On systems that have large core counts and large page sizes, but limited
memory, the userfaultfd test hugepage requirement is too large.

Exiting early due to missing one test's requirements is a rather
aggressive strategy, and prevents a lot of other tests from running. 
Remove the early exit to prevent this.

Link: https://lkml.kernel.org/r/20240306223714.320681-1-npache@redhat.com
Link: https://lkml.kernel.org/r/20240306223714.320681-2-npache@redhat.com
Fixes: ee00479d6702 ("selftests: vm: Try harder to allocate huge pages")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -175,7 +175,6 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_K
 	if [ "$freepgs" -lt "$needpgs" ]; then
 		printf "Not enough huge pages available (%d < %d)\n" \
 		       "$freepgs" "$needpgs"
-		exit 1
 	fi
 else
 	echo "no hugetlbfs support in kernel?"
_

Patches currently in -mm which might be from npache@redhat.com are

selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch
selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch
selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch

