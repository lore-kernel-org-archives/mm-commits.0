Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9273F1F
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708637425; cv=none; b=pd11I+guAiAB4uY9UvlnudN9sPoxqn05wtVBDtj7YP8HOYj/I3DSYgd4y2eQq1VQTcYZL1rEDZHc/oY86I54TkjUk8GKdPOvzx/CDAtGjg0Vwn2s0KGlKn5KtMfLgbLpciw/dgppisTXesG4pXo4ZG/OgjIsPApY4d8ky3i1wSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708637425; c=relaxed/simple;
	bh=9TV+IBPmV8xRrf8wPVyFIazHSN5tik0RxuSvIGFawGI=;
	h=Date:To:From:Subject:Message-Id; b=saJcP8j9aNPHq4SZM1RKe4OalQCJve/cwymiSuJJ0I4c0+33HesnNz3tthxt5YT8XeupNRYe7rcpk1l8lqZdLVfpjVVgUAFf01yi5Xl4YP35CYXFMD/f4EZToLOnCbC/K2uhdpgvSS6ElhScWSD+jrk8wx7sICZSQguFvL6JhE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BtJFzyGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BtJFzyGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678C3C433F1;
	Thu, 22 Feb 2024 21:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708637424;
	bh=9TV+IBPmV8xRrf8wPVyFIazHSN5tik0RxuSvIGFawGI=;
	h=Date:To:From:Subject:From;
	b=BtJFzyGsJtGwWJz5go1LmYaGemldB9Aac0/TYCLxZccwHUu+hc5qJUpSKzmK8zC2k
	 fpl5HBSNcC1+xMdxdcINWRIi7JdJ8jjqE1XVl2X/INFP/LdHGsrV4AMn/16+sRoSXx
	 VNO52R5bLqIHziXcj6SJquWJwnvB9QElUWJ2vhMg=
Date: Thu, 22 Feb 2024 13:30:23 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-add-zswapin-and-no-zswap-tests-fix.patch added to mm-unstable branch
Message-Id: <20240222213024.678C3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: add zswapin and no zswap tests (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-add-zswapin-and-no-zswap-tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-add-zswapin-and-no-zswap-tests-fix.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: selftests: add zswapin and no zswap tests (fix)
Date: Wed, 21 Feb 2024 20:31:32 -0800

Remove redundant "set up" comment and add check to ensure enough data is
swapped out (in swapin test) and zswapped-in.

Link: https://lkml.kernel.org/r/20240222043132.616320-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-add-zswapin-and-no-zswap-tests-fix
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -71,7 +71,7 @@ static int allocate_and_read_bytes(const
 	for (int i = 0; i < size; i += 4095)
 		mem[i] = 'a';
 
-	/* go through the allocated memory to (z)swap in and out pages */
+	/* Go through the allocated memory to (z)swap in and out pages */
 	for (int i = 0; i < size; i += 4095) {
 		if (mem[i] != 'a')
 			ret = -1;
@@ -184,8 +184,8 @@ static int test_swapin_nozswap(const cha
 		goto out;
 	}
 
-	if (swap_peak == 0) {
-		ksft_print_msg("pages should be swapped out\n");
+	if (swap_peak < MB(24)) {
+		ksft_print_msg("at least 24MB of memory should be swapped out\n");
 		goto out;
 	}
 
@@ -215,7 +215,6 @@ static int test_zswapin(const char *root
 	char *test_group;
 	long zswpin;
 
-	/* Set up */
 	test_group = cg_name(root, "zswapin_test");
 	if (!test_group)
 		goto out;
@@ -236,8 +235,8 @@ static int test_zswapin(const char *root
 		goto out;
 	}
 
-	if (zswpin == 0) {
-		ksft_print_msg("zswpin should not be 0\n");
+	if (zswpin < MB(24) / PAGE_SIZE) {
+		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
 
@@ -260,7 +259,6 @@ static int test_no_invasive_cgroup_shrin
 	size_t control_allocation_size = MB(10);
 	char *control_allocation, *wb_group = NULL, *control_group = NULL;
 
-	/* Set up */
 	wb_group = setup_test_group_1M(root, "per_memcg_wb_test1");
 	if (!wb_group)
 		return KSFT_FAIL;
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch
selftests-add-zswapin-and-no-zswap-tests-fix.patch

