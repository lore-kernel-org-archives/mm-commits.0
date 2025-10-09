Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E862AE97
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 00:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759970688; cv=none; b=d/AbTWX2PXeZ8EhFcv0naX4UEksspRat2nf0r6MZJtychCJBPaCr2pyt5VnLua+KVU7WXbsunBDai4SLcWxBdu+9HY2pFiUqnDUv6F749zWhUNfFH20QX+r+dr/qYJnJw6vUmiwRUM1jIqknwxCEUosHkcbBO9ACcVHHpyuwcqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759970688; c=relaxed/simple;
	bh=x9Tz2nuRSQZF2RU9HT093SfLdtaTjS49GgXPs3iQJr0=;
	h=Date:To:From:Subject:Message-Id; b=kS49U9dcxUtftur+VLDSvjfzjU7+N404PgzSA5nXWA95dWZXmsv2R4hZAoQ4CW53/ANleuPWsGFrCNXqBA4x76+Xsh57Z+0jrCDSgEfYO59IwA7r9WBq3xllfWYyXmusPA15FIDG/1qV5RPewPKRTPBVftwgZWeqqAqreI3rnbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uL8uh+No; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uL8uh+No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8435C4CEE7;
	Thu,  9 Oct 2025 00:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759970688;
	bh=x9Tz2nuRSQZF2RU9HT093SfLdtaTjS49GgXPs3iQJr0=;
	h=Date:To:From:Subject:From;
	b=uL8uh+NoKjvOps7UWfG3N2iPPIU9a4oLf2Mt5hSRHC9GrYXPv++ubbwiuRzVbCQDl
	 8nHQpOPYiMagGP6OKAdNRPDMcSlWRgKLbYmBel+8EjtGodOax/NhbrQL136AJZi65B
	 nbV8SD+Ufv9bLt4qsJqbXIUY/uuuARjJcqlPQtZ8=
Date: Wed, 08 Oct 2025 17:44:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-optimize-pte-scanning-with-if-else-if-else-if-chain.patch added to mm-new branch
Message-Id: <20251009004447.D8435C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-optimize-pte-scanning-with-if-else-if-else-if-chain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-optimize-pte-scanning-with-if-else-if-else-if-chain.patch

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
Subject: mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
Date: Wed, 8 Oct 2025 12:37:46 +0800

Patch series "refactor and merge PTE scanning logic", v3.

This series cleans up the almost-duplicated PTE scanning logic in the
collapse path.

The first one is a preparatory step that refactors both loops to use
a single if-else-if-else-if chain for checking disjoint PTEs.

The second one replaces VM_BUG_ON_FOLIO() with a more graceful
VM_WARN_ON_FOLIO() for handling non-anonymous folios.

The last one then extracts the common logic into a shared helper.


This patch (of 3):

As pointed out by Dev, the PTE checks for disjoint conditions in the
scanning loops can be optimized.  is_swap_pte, (pte_none && is_zero_pfn),
and pte_uffd_wp are mutually exclusive.

This patch refactors the loops in both __collapse_huge_page_isolate() and
hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
instead of separate if blocks.  While at it, the redundant pte_present()
check before is_zero_pfn() is also removed.

Also, this is a preparatory step to make it easier to merge the
almost-duplicated scanning logic in these two functions, as suggested by
David.

Link: https://lkml.kernel.org/r/20251008043748.45554-1-lance.yang@linux.dev
Link: https://lkml.kernel.org/r/20251008043748.45554-2-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-optimize-pte-scanning-with-if-else-if-else-if-chain
+++ a/mm/khugepaged.c
@@ -548,8 +548,7 @@ static int __collapse_huge_page_isolate(
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || (pte_present(pteval) &&
-				is_zero_pfn(pte_pfn(pteval)))) {
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
@@ -560,12 +559,10 @@ static int __collapse_huge_page_isolate(
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out;
 			}
-		}
-		if (!pte_present(pteval)) {
+		} else if (!pte_present(pteval)) {
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			result = SCAN_PTE_UFFD_WP;
 			goto out;
 		}
@@ -1321,8 +1318,7 @@ static int hpage_collapse_scan_pmd(struc
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				goto out_unmap;
 			}
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
 			 * PTEs are armed with uffd write protection.
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch
mm-khugepaged-optimize-pte-scanning-with-if-else-if-else-if-chain.patch
mm-khugepaged-use-vm_warn_on_folio-instead-of-vm_bug_on_folio-for-non-anon-folios.patch
mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper.patch

