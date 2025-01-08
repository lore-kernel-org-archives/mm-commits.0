Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E2179FE;
	Wed,  8 Jan 2025 04:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736312194; cv=none; b=Zm5OjXxX7D7LL57VYz5Wsztf7TJXm77g+TX+9e2A/mokaSNE+Dppmix6PdNbOkeZW2jzzopIw9cVkH5e2jMni5XcEeBY386ps3cDGw1e7IJbNChi4RmG/XSMCnPxGDq7Yueg8VuKiyfADyeaoNiPFc2zFPhMWG6e3W3Zn2RlegM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736312194; c=relaxed/simple;
	bh=EJEQeDR8sZhwrFU5EAN0BuvYUQBwoEmgfNPtmkukAq4=;
	h=Date:To:From:Subject:Message-Id; b=MkVZWd8JTyAT9FEWZDSKx8+kclpvzxeP6jrqmZIkDrL8BiFaV3rMGeXWfaW0omg8b92N0rVJ7pM1qnWby09Z/PwIB/+E1hayAXV7QfN3s05k5QJZJr5xJHgKYF+tcmlJS4AJqskWKNwLuAnsk/9xNPICV9bPQ9nck1YtM+LNb0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YWfD3syZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YWfD3syZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8E3C4CED0;
	Wed,  8 Jan 2025 04:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736312194;
	bh=EJEQeDR8sZhwrFU5EAN0BuvYUQBwoEmgfNPtmkukAq4=;
	h=Date:To:From:Subject:From;
	b=YWfD3syZz6u5G2i4JoW9lkf/0O6ldRq4yql2tNeYshLQKSHYsk1/3qcBIHnxKy2Na
	 ZxbBUVC6KvhNPKl8ZYvrc2/szPNmrB84jlJGS5YaMD6cDylm1yK4gZzyNINQV65O6D
	 AKMIlVV9ZwEVD7G6/5KAoctBfeXDf5Tjii0vLKjk=
Date: Tue, 07 Jan 2025 20:56:33 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,stable@vger.kernel.org,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-set-allocated-memory-to-non-zero-content-in-cow-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20250108045634.7F8E3C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: set allocated memory to non-zero content in cow test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-set-allocated-memory-to-non-zero-content-in-cow-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-set-allocated-memory-to-non-zero-content-in-cow-test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: set allocated memory to non-zero content in cow test
Date: Tue, 7 Jan 2025 14:25:53 +0000

After commit b1f202060afe ("mm: remap unused subpages to shared zeropage
when splitting isolated thp"), cow test cases involving swapping out THPs
via madvise(MADV_PAGEOUT) started to be skipped due to the subsequent
check via pagemap determining that the memory was not actually swapped
out.  Logs similar to this were emitted:

   ...

   # [RUN] Basic COW after fork() ... with swapped-out, PTE-mapped THP (16 kB)
   ok 2 # SKIP MADV_PAGEOUT did not work, is swap enabled?
   # [RUN] Basic COW after fork() ... with single PTE of swapped-out THP (16 kB)
   ok 3 # SKIP MADV_PAGEOUT did not work, is swap enabled?
   # [RUN] Basic COW after fork() ... with swapped-out, PTE-mapped THP (32 kB)
   ok 4 # SKIP MADV_PAGEOUT did not work, is swap enabled?

   ...

The commit in question introduces the behaviour of scanning THPs and if
their content is predominantly zero, it splits them and replaces the pages
which are wholly zero with the zero page.  These cow test cases were
getting caught up in this.

So let's avoid that by filling the contents of all allocated memory with
a non-zero value. With this in place, the tests are passing again.

Link: https://lkml.kernel.org/r/20250107142555.1870101-1-ryan.roberts@arm.com
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-set-allocated-memory-to-non-zero-content-in-cow-test
+++ a/tools/testing/selftests/mm/cow.c
@@ -758,7 +758,7 @@ static void do_run_with_base_page(test_f
 	}
 
 	/* Populate a base page. */
-	memset(mem, 0, pagesize);
+	memset(mem, 1, pagesize);
 
 	if (swapout) {
 		madvise(mem, pagesize, MADV_PAGEOUT);
@@ -824,12 +824,12 @@ static void do_run_with_thp(test_fn fn,
 	 * Try to populate a THP. Touch the first sub-page and test if
 	 * we get the last sub-page populated automatically.
 	 */
-	mem[0] = 0;
+	mem[0] = 1;
 	if (!pagemap_is_populated(pagemap_fd, mem + thpsize - pagesize)) {
 		ksft_test_result_skip("Did not get a THP populated\n");
 		goto munmap;
 	}
-	memset(mem, 0, thpsize);
+	memset(mem, 1, thpsize);
 
 	size = thpsize;
 	switch (thp_run) {
@@ -1012,7 +1012,7 @@ static void run_with_hugetlb(test_fn fn,
 	}
 
 	/* Populate an huge page. */
-	memset(mem, 0, hugetlbsize);
+	memset(mem, 1, hugetlbsize);
 
 	/*
 	 * We need a total of two hugetlb pages to handle COW/unsharing
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-clear-uffd-wp-pte-pmd-state-on-mremap.patch
selftests-mm-set-allocated-memory-to-non-zero-content-in-cow-test.patch
selftests-mm-add-fork-cow-guard-page-test-fix.patch
selftests-mm-introduce-uffd-wp-mremap-regression-test.patch

