Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA3A21CA00
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 20:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760648212; cv=none; b=VOZA1JMA0pnx7gRafV9Yuv6K46Plf9qafB9DZF6YJ2QLQsBK6mQfnhzgfWeRzH5nPPdnSicJhlT8deG5m5FF3vHRlMOFbS4uN5bkRkRYnl808ffJloeiLv9PT2mbhGZXgasgik+jczxosWZvOreYbiKu2QD6hpdRCr6Q5/Tr7Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760648212; c=relaxed/simple;
	bh=RlbnOfXno+qT+1PDU4TD+GhXynJCAb9zkTkd9aexMnA=;
	h=Date:To:From:Subject:Message-Id; b=itlAof0Jl1r7LGCpuK9GaZLskYVn1i9H1mpxSOaVpEWRtuhdjx0OSQ6+/RV1xkOeX08N8ZlZHzaCWVrncFlSV3YtaRnB5w3iNtX/0y3u1rcG35MzCj72CY7+v6dlVAnVvCEHyxjlW82oWPKrnR2bs64+IlD1HLbMakwoNpV6fPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wj1raO3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wj1raO3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB86AC4CEF1;
	Thu, 16 Oct 2025 20:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760648211;
	bh=RlbnOfXno+qT+1PDU4TD+GhXynJCAb9zkTkd9aexMnA=;
	h=Date:To:From:Subject:From;
	b=wj1raO3PtjDG5T5ow9VUGCy8VPqpW3yQdzPLAoNAVRhn/pJyaQqqJLqWvKwxFJhO4
	 mCKm4Q+LtSQLkfAqfe2ZaLkgx/p854zc3WItCmsgf2sBwXue7KpBgRRfh8NmA8LCWI
	 QylwcaWImo7iNoK8cwDJx6qd1SnmTrj631LVWYe0=
Date: Thu, 16 Oct 2025 13:56:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch added to mm-new branch
Message-Id: <20251016205651.AB86AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: guard is_zero_pfn() calls with pte_present()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch

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
Subject: mm/khugepaged: guard is_zero_pfn() calls with pte_present()
Date: Thu, 16 Oct 2025 11:36:43 +0800

A non-present entry, like a swap PTE, contains completely different data
(swap type and offset).  pte_pfn() doesn't know this, so if we feed it a
non-present entry, it will spit out a junk PFN.

What if that junk PFN happens to match the zeropage's PFN by sheer chance?
While really unlikely, this would be really bad if it did.

So, let's fix this potential bug by ensuring all calls to is_zero_pfn() in
khugepaged.c are properly guarded by a pte_present() check.

Link: https://lkml.kernel.org/r/20251016033643.10848-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present
+++ a/mm/khugepaged.c
@@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte
 		pte_t pteval = ptep_get(_pte);
 		unsigned long pfn;
 
-		if (pte_none(pteval))
+		if (!pte_present(pteval))
 			continue;
 		pfn = pte_pfn(pteval);
 		if (is_zero_pfn(pfn))
@@ -690,9 +690,10 @@ static void __collapse_huge_page_copy_su
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
-			if (is_zero_pfn(pte_pfn(pteval))) {
+			if (!pte_none(pteval)) {
 				/*
 				 * ptl mostly unnecessary.
 				 */
@@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte
 		unsigned long src_addr = address + i * PAGE_SIZE;
 		struct page *src_page;
 
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			clear_user_highpage(page, src_addr);
 			continue;
 		}
@@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struc
 				goto out_unmap;
 			}
 		}
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch

