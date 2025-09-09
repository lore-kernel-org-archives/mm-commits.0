Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5E2459CF
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757383934; cv=none; b=VgwU0ksXXyx03ko9TpO6bj3bDXfmttzhKgHQxROcQp9QfepMbs0hhYYbgI/+jlna8Ygh7MxoBUZT5+sOYAJKEqvmswc1LLH7VmKIBGOegIh1Ps5zm4z4DthtizyaJUv6q0FxB8xf6yng3CnUTVw+DxcTjJe/wdxNh+cyogZZ5qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757383934; c=relaxed/simple;
	bh=BM4m9rrfWliEXqdZiJYp6ncrupUa7PMjiyIvv9Owb4c=;
	h=Date:To:From:Subject:Message-Id; b=Qd1nDE7UxX9AbOiPZHikqCSCNpTUW7/1Von0QLmNpgbRPjChdwVjmQFtAicrY16jPw9RboonfxvuFs7AGObNQb6QN/etM6Fy5X0R1n0ri+UfzN6FSHdvizj7+XUxsnX2L+oSiDlRESLePdun4x2h2EfoF6Py97aTEI0TMcvSuTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MZ/V4UWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MZ/V4UWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92601C4CEF1;
	Tue,  9 Sep 2025 02:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757383933;
	bh=BM4m9rrfWliEXqdZiJYp6ncrupUa7PMjiyIvv9Owb4c=;
	h=Date:To:From:Subject:From;
	b=MZ/V4UWuIM8ENokKdCa8OxEhs4SLVwatupx9n+EO6UOGvCOrHQ0oanwd/VB+eYMmp
	 nBpAFPxDn45SS8qgxQcYBn8sbRdSKS/7O3H61gBDtDsKlVogCiXqZrhu4YJ82RYhvr
	 y1LdgDABvCtDAS7wZ+uoZxe+WJyqIrR82LkrSvpw=
Date: Mon, 08 Sep 2025 19:12:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch added to mm-new branch
Message-Id: <20250909021213.92601C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enable khugepaged anonymous collapse on non-writable regions
has been added to the -mm mm-new branch.  Its filename is
     mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: enable khugepaged anonymous collapse on non-writable regions
Date: Mon, 8 Sep 2025 13:20:27 +0530

Patch series "Expand scope of khugepaged anonymous collapse", v2.

Currently khugepaged does not collapse an anonymous region which does not
have a single writable pte.  This is wasteful since a region mapped with
non-writable ptes, for example, non-writable VMAs mapped by the
application, won't benefit from THP collapse.

An additional consequence of this constraint is that MADV_COLLAPSE does
not perform a collapse on a non-writable VMA, and this restriction is
nowhere to be found on the manpage - the restriction itself sounds wrong
to me since the user knows the protection of the memory it has mapped, so
collapsing read-only memory via madvise() should be a choice of the user
which shouldn't be overridden by the kernel.

Therefore, remove this constraint.

On an arm64 bare metal machine, comparing with vanilla 6.17-rc2, an
average of 5% improvement is seen on some mmtests benchmarks, particularly
hackbench, with a maximum improvement of 12%.  In the following table, (I)
denotes statistically significant improvement, (R) denotes statistically
significant regression.

+-------------------------+--------------------------------+---------------+
| mmtests/hackbench       | process-pipes-1 (seconds)      |        -0.06% |
|                         | process-pipes-4 (seconds)      |        -0.27% |
|                         | process-pipes-7 (seconds)      |   (I) -12.13% |
|                         | process-pipes-12 (seconds)     |    (I) -5.32% |
|                         | process-pipes-21 (seconds)     |    (I) -2.87% |
|                         | process-pipes-30 (seconds)     |    (I) -3.39% |
|                         | process-pipes-48 (seconds)     |    (I) -5.65% |
|                         | process-pipes-79 (seconds)     |    (I) -6.74% |
|                         | process-pipes-110 (seconds)    |    (I) -6.26% |
|                         | process-pipes-141 (seconds)    |    (I) -4.99% |
|                         | process-pipes-172 (seconds)    |    (I) -4.45% |
|                         | process-pipes-203 (seconds)    |    (I) -3.65% |
|                         | process-pipes-234 (seconds)    |    (I) -3.45% |
|                         | process-pipes-256 (seconds)    |    (I) -3.47% |
|                         | process-sockets-1 (seconds)    |         2.13% |
|                         | process-sockets-4 (seconds)    |         1.02% |
|                         | process-sockets-7 (seconds)    |        -0.26% |
|                         | process-sockets-12 (seconds)   |        -1.24% |
|                         | process-sockets-21 (seconds)   |         0.01% |
|                         | process-sockets-30 (seconds)   |        -0.15% |
|                         | process-sockets-48 (seconds)   |         0.15% |
|                         | process-sockets-79 (seconds)   |         1.45% |
|                         | process-sockets-110 (seconds)  |        -1.64% |
|                         | process-sockets-141 (seconds)  |    (I) -4.27% |
|                         | process-sockets-172 (seconds)  |         0.30% |
|                         | process-sockets-203 (seconds)  |        -1.71% |
|                         | process-sockets-234 (seconds)  |        -1.94% |
|                         | process-sockets-256 (seconds)  |        -0.71% |
|                         | thread-pipes-1 (seconds)       |         0.66% |
|                         | thread-pipes-4 (seconds)       |         1.66% |
|                         | thread-pipes-7 (seconds)       |        -0.17% |
|                         | thread-pipes-12 (seconds)      |    (I) -4.12% |
|                         | thread-pipes-21 (seconds)      |    (I) -2.13% |
|                         | thread-pipes-30 (seconds)      |    (I) -3.78% |
|                         | thread-pipes-48 (seconds)      |    (I) -5.77% |
|                         | thread-pipes-79 (seconds)      |    (I) -5.31% |
|                         | thread-pipes-110 (seconds)     |    (I) -6.12% |
|                         | thread-pipes-141 (seconds)     |    (I) -4.00% |
|                         | thread-pipes-172 (seconds)     |    (I) -3.01% |
|                         | thread-pipes-203 (seconds)     |    (I) -2.62% |
|                         | thread-pipes-234 (seconds)     |    (I) -2.00% |
|                         | thread-pipes-256 (seconds)     |    (I) -2.30% |
|                         | thread-sockets-1 (seconds)     |     (R) 2.39% |
+-------------------------+--------------------------------+---------------+

+-------------------------+------------------------------------------------+
| mmtests/sysbench-mutex  | sysbenchmutex-1 (usec)         |        -0.02% |
|                         | sysbenchmutex-4 (usec)         |        -0.02% |
|                         | sysbenchmutex-7 (usec)         |         0.00% |
|                         | sysbenchmutex-12 (usec)        |         0.12% |
|                         | sysbenchmutex-21 (usec)        |        -0.40% |
|                         | sysbenchmutex-30 (usec)        |         0.08% |
|                         | sysbenchmutex-48 (usec)        |         2.59% |
|                         | sysbenchmutex-79 (usec)        |        -0.80% |
|                         | sysbenchmutex-110 (usec)       |        -3.87% |
|                         | sysbenchmutex-128 (usec)       |    (I) -4.46% |
+-------------------------+--------------------------------+---------------+


This patch (of 2):

Currently khugepaged does not collapse an anonymous region which does not
have a single writable pte.  This is wasteful since a region mapped with
non-writable ptes, for example, non-writable VMAs mapped by the
application, won't benefit from THP collapse.

An additional consequence of this constraint is that MADV_COLLAPSE does
not perform a collapse on a non-writable VMA, and this restriction is
nowhere to be found on the manpage - the restriction itself sounds wrong
to me since the user knows the protection of the memory it has mapped, so
collapsing read-only memory via madvise() should be a choice of the user
which shouldn't be overridden by the kernel.

Therefore, remove this restriction by not honouring SCAN_PAGE_RO.

Link: https://lkml.kernel.org/r/20250908075028.38431-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250908075028.38431-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions
+++ a/mm/khugepaged.c
@@ -676,9 +676,7 @@ next:
 			writable = true;
 	}
 
-	if (unlikely(!writable)) {
-		result = SCAN_PAGE_RO;
-	} else if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->is_khugepaged && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struc
 		     mmu_notifier_test_young(vma->vm_mm, _address)))
 			referenced++;
 	}
-	if (!writable) {
-		result = SCAN_PAGE_RO;
-	} else if (cc->is_khugepaged &&
+	if (cc->is_khugepaged &&
 		   (!referenced ||
 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
@@ -2830,7 +2826,6 @@ handle_result:
 		case SCAN_PMD_NULL:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
-		case SCAN_PAGE_RO:
 		case SCAN_LACK_REFERENCED_PAGE:
 		case SCAN_PAGE_NULL:
 		case SCAN_PAGE_COUNT:
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch
selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-before-the-test.patch
mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch
mm-drop-all-references-of-writable-and-scan_page_ro.patch

