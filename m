Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1CA2C21D8
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490031; cv=none; b=RqD0aFKjZ9hIWOEn5nGCdeCct6NW8Nz2DEaGD0SE9ssAaB5vBcuA/jas4UY6F4st0IzYPMdQNwvAWGLtQkGIcuU6PBPwTKtCYBRocRSVx7CHmxbWyeOXV925ctPtO6OUfvRdY9dN0NWoKG82owFycW8AIP/YF73Y+Ziy41PN8Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490031; c=relaxed/simple;
	bh=udU8jCZ5H9miBluEz4WNwuAGmjeB1KyI5jw56LZHyZ8=;
	h=Date:To:From:Subject:Message-Id; b=SN2C5sHxkQD2eqFy9FDKY0FC/YCzPRo2MoaebjkfyHreV2CmXa4mmXJOcu7zGRtOCkcrbFFJ+M6PJFyi9ebQHdjyasPaHfXeJqXgDL/CHETmPfmP842qAu4HlZlnq26jYzW+Bc+31qbCMkPSUthx3N77pV51GRiGFf3r1JA94ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdgTqkSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdgTqkSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F82C4CEE7;
	Sun, 21 Sep 2025 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490031;
	bh=udU8jCZ5H9miBluEz4WNwuAGmjeB1KyI5jw56LZHyZ8=;
	h=Date:To:From:Subject:From;
	b=NdgTqkSaCoSFV8XDiwo1S+AmsE9i0A3ba5cokYd2s+YfGYN55xAYVTJOwM02HWt75
	 yFZ56GPxraJls2lOFXSuH9qELbTkF/CzpR4+B4eC/lnPg9SkI9lNW1LTh4zpJDZt8x
	 +m+YWWXLotV/4eDt/vz4HFabdt5Mcfvk+WLhVVac=
Date: Sun, 21 Sep 2025 14:27:10 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch removed from -mm tree
Message-Id: <20250921212711.71F82C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: enable khugepaged anonymous collapse on non-writable regions
has been removed from the -mm tree.  Its filename was
     mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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

mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch

