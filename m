Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D003115BC
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 15:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777044552; cv=none; b=At89p00KgJxjVPwI6zpgtPujqjSmCj4zauZY3SWPenYQ+RPFab3xacOlj0HmHXbgvaw+cxt60YTBA559DV6hEvmG9l557J90D9NcxCPug9UwiaVAMLK8Y3rnYo9AAPw9oIrNBfNa85bm6W/9x1dY/AcRTUNLGv4eo4icJxMTBGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777044552; c=relaxed/simple;
	bh=cyP9rCmhyR8W9Ua1o14MMqAGjXa6zQi4Rdso9lkJLA4=;
	h=Date:To:From:Subject:Message-Id; b=fL9BF/DP4v9WESBHgklRYYCFAPZkuOmEL+gFCWWMmJMpNewG/fRHOBn6g+rHgJTMVjRK6715TLlWkLrbf6DK27NBZOJ/psXZuC4d1E0gyxbqnx6Cu2PrqY47vNx46NXmTMFNKUAA0tpjuCPFNFFRGNKmGDsjnQXAmwhUAI9fMnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GvLINQP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GvLINQP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A98EC19425;
	Fri, 24 Apr 2026 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777044551;
	bh=cyP9rCmhyR8W9Ua1o14MMqAGjXa6zQi4Rdso9lkJLA4=;
	h=Date:To:From:Subject:From;
	b=GvLINQP2rchd4XKLI+PIs/fkSQeoVfYNLPv4UdYU1REuU9HsqpR2WAhmFsMcVVF+z
	 Cga38huUrixe8wHT0K52oh+nnl/bVYUknqWnvOBoU8R+fvP4lhsK1Vtz4yV16SiBWr
	 CCjWcL8WyGezfCx7sST7TZMdclP86FeZZQKTrRms=
Date: Fri, 24 Apr 2026 08:29:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jason@zx2c4.com,jannh@google.com,david@kernel.org,broonie@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run-the-map_droppable-selftest.patch added to mm-new branch
Message-Id: <20260424152911.8A98EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run the MAP_DROPPABLE selftest
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-run-the-map_droppable-selftest.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run-the-map_droppable-selftest.patch

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: selftests/mm: run the MAP_DROPPABLE selftest
Date: Wed, 15 Apr 2026 20:39:39 -0700

The test was not being run by the selftest framework so it was never
noticed that it would fail with an assertion failure on configs without
support for MAP_DROPPABLE.  Update the test so that it is skipped instead
when MAP_DROPPABLE is not supported, and add it to the mmap category so
that the test is run by the framework.

Link: https://lore.kernel.org/20260416033939.49981-4-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/droppable.c    |    9 ++++++++-
 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/droppable.c~selftests-mm-run-the-map_droppable-selftest
+++ a/tools/testing/selftests/mm/droppable.c
@@ -26,7 +26,14 @@ int main(int argc, char *argv[])
 	ksft_set_plan(1);
 
 	alloc = mmap(0, alloc_size, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
-	assert(alloc != MAP_FAILED);
+	if (alloc == MAP_FAILED) {
+		if ((errno == EOPNOTSUPP) || (errno == EINVAL)) {
+			ksft_test_result_skip("MAP_DROPPABLE not supported\n");
+			exit(KSFT_SKIP);
+		}
+		ksft_test_result_fail("mmap error: %s\n", strerror(errno));
+		exit(KSFT_FAIL);
+	}
 	memset(alloc, 'A', alloc_size);
 	for (size_t i = 0; i < alloc_size; i += page_size)
 		assert(*(uint8_t *)(alloc + i));
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run-the-map_droppable-selftest
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -382,6 +382,7 @@ else
 fi
 
 CATEGORY="mmap" run_test ./map_populate
+CATEGORY="mmap" run_test ./droppable
 
 CATEGORY="mlock" run_test ./mlock-random-test
 
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch
selftests-mm-verify-droppable-mappings-cannot-be-locked.patch
selftests-mm-run-the-map_droppable-selftest.patch

