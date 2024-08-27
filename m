Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A03E1D2795
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801577; cv=none; b=NAlGD5y14xUR3KKP+bfxtCRO/6oqSo6oftMLnue6TWbs2cBSQJQAnWdp1qpszrGeZLZlM46KrOO1bZd82ynfHVEoudugbeDIdfDBcAiFWTNkbhtVW7cJD8K/t2gUZhjTKSjGg6pL/Wre/LQBneM5cpOxAE1LDbYZZsIMtWNlb/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801577; c=relaxed/simple;
	bh=VDHvlM5iv+8O2sj2oPi/OsDsxxqAL4O7qW5uzgYaooE=;
	h=Date:To:From:Subject:Message-Id; b=avCuWqPYd1DwVFdbFRI60KuILKLrK4eOI9yGsgwXbzZBZTIEs50hbiyo6I5TXrDXztitEHRloGwaxxevx52AjMcWA9xmGDtSxcD2qXUa3SECm3NGAFSy8bdFKMjI2pUajm6pr6QkOnvm/54dt+RoIbDuCb/3+v42FNGeGMAm4D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2EeZ0iwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2EeZ0iwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31FEC4FF5E;
	Tue, 27 Aug 2024 23:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801576;
	bh=VDHvlM5iv+8O2sj2oPi/OsDsxxqAL4O7qW5uzgYaooE=;
	h=Date:To:From:Subject:From;
	b=2EeZ0iwcE23CMFO7tTEAeC5+TyxOLS709ZgAev7qkFWSHGeM/uCyT0hsMy6OTkXKI
	 L4iL2EHd7utzHMcT8Ld7vtreqErobY3BFyFVxjguMIGvn0Dx5YOMrPvqzu33XZn9ga
	 pYoX9NUiM2JonExq6gFriN0lPaFEhBx7JWLSIltc=
Date: Tue, 27 Aug 2024 16:32:56 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-access_memory_even-to-gitignore.patch added to mm-unstable branch
Message-Id: <20240827233256.D31FEC4FF5E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add access_memory_even to .gitignore
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-access_memory_even-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-access_memory_even-to-gitignore.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add access_memory_even to .gitignore
Date: Mon, 26 Aug 2024 20:03:28 -0700

Patch series "misc fixups for DAMON {self,kunit} tests".

This patchset is for minor fixups of DAMON selftests and kunit tests. 
First three patches make DAMON selftests more cleanly maintained (patches
1 and 2) without unnecessary warnings (patch 3).  Following six patches
remove unnecessary test case (patch 4), handle configs combinations that
can make tests fail (patches 5-7), reorganize the test files following the
new guideline (patch 8), and add reference kunitconfig for DAMON kunit
tests (patch 9).


This patch (of 9):

DAMON selftests build access_memory_even, but its not on the .gitignore
list.  Add it to make 'git status' output cleaner.

Link: https://lkml.kernel.org/r/20240827030336.7930-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240827030336.7930-2-sj@kernel.org
Fixes: commit c94df805c774 ("selftests/damon: implement a program for even-numbered memory regions access")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-add-access_memory_even-to-gitignore
+++ a/tools/testing/selftests/damon/.gitignore
@@ -3,3 +3,4 @@ huge_count_read_write
 debugfs_target_ids_read_before_terminate_race
 debugfs_target_ids_pid_leak
 access_memory
+access_memory_even
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch

