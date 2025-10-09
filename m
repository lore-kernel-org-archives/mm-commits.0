Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7380153BE9
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 01:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759972089; cv=none; b=FQ919PxLUhscblaDrMJVREdKmb4YK6mvvfdno4k+WQ28EwXEzV7QHZAhw8ud9Za5PDsJ96CRQev3kRPJax1q0/QzQucLrY6//uRJdD9q8aUqARN3tQUIiF6Vvk7x9A3a9HsFs4CHuZCqd9mBzqfW7SCMqZL5m+UNI8cv/PzwkQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759972089; c=relaxed/simple;
	bh=tj2Rfm9fe4GUzBXwxtlVt/HxgzoDpBq8FsGiO/DSDN0=;
	h=Date:To:From:Subject:Message-Id; b=Gn3PGe0oyhzZBVaGZaWdjN8dm/8OjxMmaLw8q1S0D3PLzdRRKOh7o2+3oJf68aBPb22NjleNfXUUjqfHH2PKWNTJ7ACaVbormoqc0/jEGNBi40+INFW+oCdwYGSf4vu2xegd+QqzEG5Pw/kCty1vmqmz7UISDnRfh9OmjaBMN9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o9cGDE7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o9cGDE7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F79EC4CEE7;
	Thu,  9 Oct 2025 01:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759972089;
	bh=tj2Rfm9fe4GUzBXwxtlVt/HxgzoDpBq8FsGiO/DSDN0=;
	h=Date:To:From:Subject:From;
	b=o9cGDE7usgoYZH+WwTrTFNh3e3LScHw7Gm4rDSBjgGhPY+bjgydPu6p/zybZvC1Zz
	 LEQTbEVk/LF46xT4odNlIWFWF24HW5a7jI9wOVSFscnxD854BaXcRBY9kK1ycVWace
	 78PVW81HYCCfdpIqK1jAztkpycGz0lev91uGIEXs=
Date: Wed, 08 Oct 2025 18:08:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20251009010809.0F79EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes
Date: Wed Oct  8 06:04:39 PM PDT 2025

WARNING: else is not generally useful after a break or return
#81: FILE: mm/khugepaged.c:574:
+			return PTE_CHECK_CONTINUE;
+		} else {

WARNING: else is not generally useful after a break or return
#110: FILE: mm/khugepaged.c:603:
+			return PTE_CHECK_CONTINUE;
+		} else {

total: 0 errors, 2 warnings, 290 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes
+++ a/mm/khugepaged.c
@@ -571,11 +571,10 @@ static inline int thp_collapse_check_pte
 		    (!cc->is_khugepaged ||
 		     *none_or_zero <= khugepaged_max_ptes_none)) {
 			return PTE_CHECK_CONTINUE;
-		} else {
-			*scan_result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-			return PTE_CHECK_FAIL;
 		}
+		*scan_result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+		return PTE_CHECK_FAIL;
 	} else if (!pte_present(pte)) {
 		if (!unmapped) {
 			*scan_result = SCAN_PTE_NON_PRESENT;
@@ -600,11 +599,10 @@ static inline int thp_collapse_check_pte
 				return PTE_CHECK_FAIL;
 			}
 			return PTE_CHECK_CONTINUE;
-		} else {
-			*scan_result = SCAN_EXCEED_SWAP_PTE;
-			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-			return PTE_CHECK_FAIL;
 		}
+		*scan_result = SCAN_EXCEED_SWAP_PTE;
+		count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+		return PTE_CHECK_FAIL;
 	} else if (pte_uffd_wp(pte)) {
 		/*
 		 * Don't collapse the page if any of the small PTEs are
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch

