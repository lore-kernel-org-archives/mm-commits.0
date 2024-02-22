Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846FA17BC7
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708643753; cv=none; b=hbE422RA57Xzf0Uk1QYuVwgN+ShybzoQvhjjxALaiGtov2gp4Ob6F+TNYtaBYobfKXGFM4LnIy1FYArrKTiGPv32aEgw+Gc2rKV9KukEnBOxupCibfnXNb4I0j4vgZKSsMeAm4Z8ob9GSlsZEzfnkMM4kQljDPcetnUSR8zNWfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708643753; c=relaxed/simple;
	bh=9zDmgnWp+NUIOuDz3B0JA9jAC5w6wuVV9BpzdoVOkjY=;
	h=Date:To:From:Subject:Message-Id; b=TmQ2t4k+5H/8k92dehmgSwBvooh9s72sWqTBQhoZXvmzkTGH7tT7NAJUkr1WtaBr1rFXZYsZ3oHWETH++YQmElt/vZ7hyk79cs5Mtp0Kah01s5Xzjb3sE+Uz3AvTC2t6WWfbeviaSA3k6KBGtxEDs5V10PQQbzfmAjTNlvM/kBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BL2v78Z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BL2v78Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BA8C433C7;
	Thu, 22 Feb 2024 23:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708643752;
	bh=9zDmgnWp+NUIOuDz3B0JA9jAC5w6wuVV9BpzdoVOkjY=;
	h=Date:To:From:Subject:From;
	b=BL2v78Z+nt5vNO+2ZOMMIANkcO+168C2fvlC4IdyE1/LhFtPn4o0k1l19UH/uJoTY
	 XKnBJN71YrMqKSEb4LVEKkrjPlxGkaayyUqLzFCbkaj2XvvMztbnYjjdA8mueALAL7
	 ldS2qPP8OQ7kdRUOXHVh2HTK13WAKRe0gJB7f8ZM=
Date: Thu, 22 Feb 2024 15:15:52 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-add-zswapin-and-no-zswap-tests-fix.patch removed from -mm tree
Message-Id: <20240222231552.D8BA8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: add zswapin and no zswap tests (fix)
has been removed from the -mm tree.  Its filename was
     selftests-add-zswapin-and-no-zswap-tests-fix.patch

This patch was dropped because it was folded into selftests-add-zswapin-and-no-zswap-tests.patch

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

