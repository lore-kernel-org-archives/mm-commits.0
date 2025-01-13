Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239098248C;
	Mon, 13 Jan 2025 03:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737462; cv=none; b=HJpuUcdqCcrcmVNzoyQmfe5/UNOPeIWsjn1p7ScOfi/Sc61Bu7VLLEUYiLtyjperfhiZ+TAevscV5txzQXKSaMAd+pT1Hg+WjXshyn/s2an5QUjQpTT8rl0Q/cZ2K9u5MBZMjMqE04Z/esaXHOL+1uUHTWyg4FF6+NR2peuS23M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737462; c=relaxed/simple;
	bh=LLanx9awTKxAntm7FNekdHQIDtPgRWLDoeB/XvE5LAg=;
	h=Date:To:From:Subject:Message-Id; b=po4m5GCIDgeHCpiePa+oG0CIhTUvZjXQjGObHvurXRK+jxoLybouKk5Lvd33oCOqggswQEBhbodbyS5swl4vjioOkjUw06+MvHEuhdqT4S9nu3slrcnIBNfL74NjjR4FCNMyDFg60Tl/jj28mOeQklNWNNQtUt0uIGNMwhsPvBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NmTDMXoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NmTDMXoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE50DC4CEDF;
	Mon, 13 Jan 2025 03:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737462;
	bh=LLanx9awTKxAntm7FNekdHQIDtPgRWLDoeB/XvE5LAg=;
	h=Date:To:From:Subject:From;
	b=NmTDMXoZU35EnflqJMiFPTrG3w3qu8o9y/ahj4RF4H7Z17076nmA1QKHFIpFyMSFt
	 9IOJ3CzL6035/gG6cGXvWZcvQ13DzdUbPVyuIzMPbWKOMFcrqUFhC/OmqZNR5Jj9q9
	 J4BTfKw4mL1WcvF81FdOqS+jo2TSaWTRDWtshbnA=
Date: Sun, 12 Jan 2025 19:04:21 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,stable@vger.kernel.org,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-set-allocated-memory-to-non-zero-content-in-cow-test.patch removed from -mm tree
Message-Id: <20250113030421.EE50DC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: set allocated memory to non-zero content in cow test
has been removed from the -mm tree.  Its filename was
     selftests-mm-set-allocated-memory-to-non-zero-content-in-cow-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-add-fork-cow-guard-page-test-fix.patch
selftests-mm-introduce-uffd-wp-mremap-regression-test.patch

