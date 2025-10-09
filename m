Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7872AE97
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 00:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759970690; cv=none; b=ioZc78qMQxAAHi7ziQGZ8mQqdzH12BF961XXnRre2xI80A4rqMjT6UQx81VMztQ6w8URTK7QCQ09F5Pxg9CVsZHpaezGOBnWk1BG1HLG+ibNSPM3uGrFu1NPvCNyqiI+dDdUK1pRs/rCCTVzDY4Ulom2uQzNKy//CpkC2HWQLbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759970690; c=relaxed/simple;
	bh=ztQEvCY8md/cLVn2RrsoI1dpQAH6KY/3U3yfjplxEwM=;
	h=Date:To:From:Subject:Message-Id; b=WIgTIpX8iWVUOI0B6cX8HOJgNIS2TdaortE5UlTjJCUwYEaoKMHFA79F/jS5+vTLzUWBcHTdmdh9Q0BKVd+hDtqDTyICzCI3Ye70aUHml7iS5RohXy5o3SQn5o0I+q3B4zWNpKbYwfIOXnL+uT7tmyCGtPO+JXDcsujLhTUQ3M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZuYWHhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZuYWHhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ABDC4CEE7;
	Thu,  9 Oct 2025 00:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759970690;
	bh=ztQEvCY8md/cLVn2RrsoI1dpQAH6KY/3U3yfjplxEwM=;
	h=Date:To:From:Subject:From;
	b=FZuYWHhWAxxQAVI4xkEy4U75NwVqJxNtL9O76imgstOMlrCTgvFCWhmpCJND3GnC9
	 MPyH2Rj3PQpWFdtartSxZ4kQBbHt+2EUcBgCEzjPAvbg7AMAdgBYCbc/BRHkb0cBkL
	 63Z1de2ibOhgdyoBQQL2O/iP49sG2mM96zjiH9P0=
Date: Wed, 08 Oct 2025 17:44:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios.patch added to mm-new branch
Message-Id: <20251009004449.E6ABDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use VM_WARN_ON_FOLIO instead of VM_BUG_ON_FOLIO for non-anon folios
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios.patch

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
mm-khugepaged-optimize-pte-scanning-with-if-else-if-else-if-chain.patch
mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios.patch
mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper.patch

