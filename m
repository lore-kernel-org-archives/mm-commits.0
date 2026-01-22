Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B5437AA83
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106393; cv=none; b=U2OAbFX92Erl3CQDu0OcfxhDJs8mHp4mbP2qOzI+mUffGKScXRoJPgWQXRte+XrDNrHyGZ4bDIcICxoKnsHUvtG4ObDDQVCXwUfpFRnlGUyjPVX4o2OKGHgfzeMdEpWASTLGdGzBoPghWoE4kSZ96711SskpD1mBNmGurXkZoIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106393; c=relaxed/simple;
	bh=AX7D/1NEJSVqh65EjyY7OR2EwxquXh1RlxjlcGftprk=;
	h=Date:To:From:Subject:Message-Id; b=JHFdvR0Rn96+rMJPL+ApWXijR1Jrw8ZsPyW6Fz+Se2HV1qfiuS009oknZevY/Nmyrsr3cMpAWs2qEAXrVpzb+cRIosurD+1ZBvwxgPed0g62Clt9cc7dqaueUC3qmNTo/XytB09svcQo33i08mRuJLZn/0x9VoC+v+u41AwOCvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pU23BNxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pU23BNxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65167C116C6;
	Thu, 22 Jan 2026 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106392;
	bh=AX7D/1NEJSVqh65EjyY7OR2EwxquXh1RlxjlcGftprk=;
	h=Date:To:From:Subject:From;
	b=pU23BNxaJD2wZ6bLfljUTaaa2NZ2pn9n6ySGs+RMBm6sUeKSrsB2+K2HlmbhX6hBh
	 WYgxttzSAfuRkE0EBsDeaZ2KTt6UUXY6f3gD9U4Uad/JNbKcGtgbi5kRUce3yfg2SP
	 xzMoYrC/WlRx9crLvH+V91MJAmQ7ygbYeXsLI1Jo=
Date: Thu, 22 Jan 2026 10:26:31 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-force_read-succeeded.patch added to mm-unstable branch
Message-Id: <20260122182632.65167C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check that FORCE_READ() succeeded
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-check-that-force_read-succeeded.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-force_read-succeeded.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: check that FORCE_READ() succeeded
Date: Thu, 22 Jan 2026 17:02:20 +0000

Many cow tests rely on FORCE_READ() to populate pages.  Introduce a helper
to make sure that the pages are actually populated, and fail otherwise.

Link: https://lkml.kernel.org/r/20260122170224.4056513-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   43 ++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-check-that-force_read-succeeded
+++ a/tools/testing/selftests/mm/cow.c
@@ -75,6 +75,18 @@ static bool range_is_swapped(void *addr,
 	return true;
 }
 
+static bool populate_page_checked(char *addr)
+{
+	bool ret;
+
+	FORCE_READ(*addr);
+	ret = pagemap_is_populated(pagemap_fd, addr);
+	if (!ret)
+		ksft_print_msg("Failed to populate page\n");
+
+	return ret;
+}
+
 struct comm_pipes {
 	int child_ready[2];
 	int parent_ready[2];
@@ -1549,8 +1561,10 @@ static void run_with_zeropage(non_anon_t
 	}
 
 	/* Read from the page to populate the shared zeropage. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1612,8 +1626,11 @@ static void run_with_huge_zeropage(non_a
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
+
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1680,10 @@ static void run_with_memfd(non_anon_test
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1738,10 @@ static void run_with_tmpfile(non_anon_te
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1794,10 @@ static void run_with_memfd_hugetlb(non_a
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(*mem);
-	FORCE_READ(*smem);
+	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
+		log_test_result(KSFT_FAIL);
+		goto munmap;
+	}
 
 	fn(mem, smem, hugetlbsize);
 munmap:
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-check-that-force_read-succeeded.patch
selftests-mm-introduce-helper-to-read-every-page.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

