Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2867B2153F1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188226; cv=none; b=YYxSRsa7pZKcASJpT/C8DA7wmMe6etbVAFccx0X5W5Um0eYICkK/23ApjtuUz0uAf2KuBNb8gBwdPI2tKoWkclADi5JCqapXbugTKGs7VBzp65zAZe+CUU66df7SBtS0kgIBo5FJ2OqWf3BgV+2TNL/k1EzpzTMuF9LPmhliQgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188226; c=relaxed/simple;
	bh=Gznm1p3/vp1XJDvALHVfjfGUoc26ZSFyF7uJ/tTe8bg=;
	h=Date:To:From:Subject:Message-Id; b=EsBUFeKGrfsEVCRCg/2wRoFbEs6QnfeAO29T6tV5bytwL0VRVZc7h/OWAzMkD4lNqABCu7/1l+uFhSv/4AAXTBN4UYZ9bWAA5+XQJcytyGp49dj+g6Idz3irTrikmCyQRlcw5bK9rYX701tNwMYpFKL0AukMVgYuRzETgLkZfHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n3c7tnJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n3c7tnJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C72C4CEED;
	Mon, 17 Mar 2025 05:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188225;
	bh=Gznm1p3/vp1XJDvALHVfjfGUoc26ZSFyF7uJ/tTe8bg=;
	h=Date:To:From:Subject:From;
	b=n3c7tnJDNVSPHE/V5yCRYtC51bGnvDPq9C6st+CcUjfpEncABUHbm+PEqhQ8ipGff
	 60eGqsG2za9LwTsA23UJ804g3lNWZNut3Z52219E/7Zp4dHtl5tDsYBNziTNcl8zln
	 zFgFtgtuxpwLXiNfjisGKeSTFa+65n8f3/ln9rPU=
Date: Sun, 16 Mar 2025 22:10:25 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,dev.jain@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-thuge-gen-test-name-uniqueness.patch removed from -mm tree
Message-Id: <20250317051025.92C72C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix thuge-gen test name uniqueness
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-thuge-gen-test-name-uniqueness.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: fix thuge-gen test name uniqueness
Date: Tue, 04 Feb 2025 22:53:43 +0000

The thuge-gen test_mmap() and test_shmget() tests are repeatedly run for a
variety of sizes but always report the result of their test with the same
name, meaning that automated sysetms running the tests are unable to
distinguish between the various tests.  Add the supplied sizes to the
logged test names to distinguish between runs.

My test automation was getting pretty confused about what was going on
- the test names are a pretty important external interface.

Link: https://lkml.kernel.org/r/20250204-kselftest-mm-fix-dups-v1-1-6afe417ef4bb@kernel.org
Fixes: b38bd9b2c448 ("selftests/mm: thuge-gen: conform to TAP format output")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-fix-thuge-gen-test-name-uniqueness
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -127,7 +127,7 @@ void test_mmap(unsigned long size, unsig
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s mmap\n", __func__);
+			 "%s mmap %lu\n", __func__, size);
 
 	if (munmap(map, size * NUM_PAGES))
 		ksft_exit_fail_msg("%s: unmap %s\n", __func__, strerror(errno));
@@ -165,7 +165,7 @@ void test_shmget(unsigned long size, uns
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s: mmap\n", __func__);
+			 "%s: mmap %lu\n", __func__, size);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
 }
_

Patches currently in -mm which might be from broonie@kernel.org are


