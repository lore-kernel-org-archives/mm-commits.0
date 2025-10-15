Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFB11917FB
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760489867; cv=none; b=P0u7uNyYudatwdg7nVMlaOWNpOiHWqtDiFfY0EJFCHvyAHWk+kwr8Wi3o5kPsGl7WEGGJ6ICycdb2SDC27ujRMTeCJX4VLHPmvA/fXVG1fmGPde6/Z8ypqIGmljhUH4wLQr0rhgwIL1BRVQLTqEq2kgVwzdkhI30Z0peYloZ0eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760489867; c=relaxed/simple;
	bh=QYh76b2EFrP3curBBLNA0VDJ/TK0pVeS/cPq0KRAzIo=;
	h=Date:To:From:Subject:Message-Id; b=iUTBtSrOoL7OVWM4xrjDkfFaesmUBHzvfBdpC64bRTq29AnR17a5QEEPUULR10GwVKrkAmC2laqNh6yQm/bwYyI4EBpB2Iig/XjQ9jaXNNSqiW6IDRvI5RFzUHqId8tdyF6N5vBdRuIiegFs3RToZfkoYuj8VQI1jDOjcx9G+co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OPou1FJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OPou1FJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EF6C4CEE7;
	Wed, 15 Oct 2025 00:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760489866;
	bh=QYh76b2EFrP3curBBLNA0VDJ/TK0pVeS/cPq0KRAzIo=;
	h=Date:To:From:Subject:From;
	b=OPou1FJdhxNfO5IBErpeohqT6v8vnjRxz0+q2zE4iyLBhbA6CkdX7cNPNVCDV8Mnc
	 0Z4bXBpX5W9t5v1wai/t8E8uYglDEVWFJmYOar0acEod4Zd+TYdSUzPdRoNjrPnVmQ
	 uiN79fvcJiHYxb7jQLfD6t6KRCI8DE5UWVamF474=
Date: Tue, 14 Oct 2025 17:57:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios.patch removed from -mm tree
Message-Id: <20251015005746.95EF6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: use VM_WARN_ON_FOLIO instead of VM_BUG_ON_FOLIO for non-anon folios
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/khugepaged: use VM_WARN_ON_FOLIO instead of VM_BUG_ON_FOLIO for non-anon folios
Date: Wed, 8 Oct 2025 12:37:47 +0800

As Zi pointed out, we should avoid crashing the kernel for conditions that
can be handled gracefully.  Encountering a non-anonymous folio in an
anonymous VMA is a bug, but a warning is sufficient.

This patch changes the VM_BUG_ON_FOLIO(!folio_test_anon(folio)) to a
VM_WARN_ON_FOLIO() in both __collapse_huge_page_isolate() and
hpage_collapse_scan_pmd(), and then aborts the scan with SCAN_PAGE_ANON.

Making more of the scanning logic common between hpage_collapse_scan_pmd()
and __collapse_huge_page_isolate(), as suggested by Dev.

Link: https://lkml.kernel.org/r/20251008043748.45554-3-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios
+++ a/mm/khugepaged.c
@@ -573,7 +573,11 @@ static int __collapse_huge_page_isolate(
 		}
 
 		folio = page_folio(page);
-		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_FOLIO(true, folio);
+			result = SCAN_PAGE_ANON;
+			goto out;
+		}
 
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
@@ -1340,6 +1344,7 @@ static int hpage_collapse_scan_pmd(struc
 		folio = page_folio(page);
 
 		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_FOLIO(true, folio);
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
 		}
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch
mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper.patch

