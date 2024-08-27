Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CC819DF58
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801579; cv=none; b=LUsBzXC2gOAbhwjhSh9IlVRzf3qW+KM2MGDuMU+GTmPP2VAB/axz+AIvPbkv0cPWAepU+nFBdkjVVo0r3eFRSbNKPB+4C3oW/IkNMMJdAGuqEDXA556x0uGPOC6nVvx7GmlradvafN0vkPZRVgJz5n7Tgts+UnzCSW1KcaF/SMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801579; c=relaxed/simple;
	bh=KEin0lsk+MqiRjmmgZaHRCE2KppPLsxIgOs6dOVf0u8=;
	h=Date:To:From:Subject:Message-Id; b=m0JBX4P0xYnR1J7tKQmLEQ4jV9W0K+uGm5M8M1KWS71Thdy8fPer9CkMk4mh++UrCBHxC8CVWqyB9xHmKlDxszukQxN92WdkpnVBf9nXMocPw/c4wEoTRBrb0LRtn1jjADF6IfESLJeiQaDuF/DS+7iurT6BTbNZuwCn4zd3ddo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQleHJyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQleHJyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B35C4FF64;
	Tue, 27 Aug 2024 23:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801578;
	bh=KEin0lsk+MqiRjmmgZaHRCE2KppPLsxIgOs6dOVf0u8=;
	h=Date:To:From:Subject:From;
	b=nQleHJynX3eSWUQJKra6ivNtX+usBtXg/lzSKYDL4tZv8PbBJXckzl6PzKVGGjBBe
	 09lw8LtYQOtPWUf+21+iEv+5RCRbIsGX0y/wTwmygHSQe3sUHOPJ6ZpRrIE42vN4S6
	 UBCAYFu6bfx2q29CXg0Rk5E+nfo2uPiZ8cgamAhQ=
Date: Tue, 27 Aug 2024 16:32:58 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-cleanup-__pycache__-with-make-clean.patch added to mm-unstable branch
Message-Id: <20240827233258.A8B35C4FF64@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: cleanup __pycache__/ with 'make clean'
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-cleanup-__pycache__-with-make-clean.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-cleanup-__pycache__-with-make-clean.patch

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
Subject: selftests/damon: cleanup __pycache__/ with 'make clean'
Date: Mon, 26 Aug 2024 20:03:29 -0700

Python-based tests creates __pycache__/ directory.  Remove it with 'make
clean' by defining it as EXTRA_CLEAN.

Link: https://lkml.kernel.org/r/20240827030336.7930-3-sj@kernel.org
Fixes: b5906f5f7359 ("selftests/damon: add a test for update_schemes_tried_regions sysfs command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-cleanup-__pycache__-with-make-clean
+++ a/tools/testing/selftests/damon/Makefile
@@ -25,4 +25,6 @@ TEST_PROGS += debugfs_target_ids_pid_lea
 TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 
+EXTRA_CLEAN = __pycache__
+
 include ../lib.mk
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

