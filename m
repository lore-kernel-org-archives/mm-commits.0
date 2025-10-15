Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34DE1E7C18
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760489869; cv=none; b=j600PxaPwD/h6DA2Lc1D+TEVc4DVNnZC8xvfh9+SPETZ6yDTuLM7+P/f5wswmKLW1a0j7cYsiidP0IwVqXwe5Kkn7kIrJ7g6qicEEO61WjAEWsW1PC6oUAUnTNWrcRcJBOXGRpCiX1nJbf0J4nbtOX0WWcICFTld6yRVgHXNBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760489869; c=relaxed/simple;
	bh=URaAJkUTyovIfvHGZjfIXeBL37OhSAbuPZOpluTKX+8=;
	h=Date:To:From:Subject:Message-Id; b=kBbH2Jr3+cj2IAbuUpVo5sBlI85/aVslXmQcsnfyHO/YZfN6GXV+LX1xtFbvg063X4Il+XPxYby706YzNf0Lv/vU2TPw48jEyyCWCegILJSwGcXO1lCj1OS5twYd0ZUnL/6t6456EFdgtqpt1eX2QIra4U0Pd+FMFw0gO27hTRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YuoEIYbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YuoEIYbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2E3C4CEF1;
	Wed, 15 Oct 2025 00:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760489869;
	bh=URaAJkUTyovIfvHGZjfIXeBL37OhSAbuPZOpluTKX+8=;
	h=Date:To:From:Subject:From;
	b=YuoEIYbPi4CJQ9+a/c9j5nrJLB5aM5tow5UFqxqruxQPkoHgFc2T0eyjmCXYXzP1C
	 0cqYae2/Wxqkj+Vj2YdQZdawh7MCxaAHIUeWHgSo52x0vE8Q4uzGDKi+W1j+KKilnT
	 DVUCKYIhgoCkGN5PZHVlIUP4ovQMGkPovEXMyGxU=
Date: Tue, 14 Oct 2025 17:57:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20251015005749.3E2E3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch

This patch was dropped because an updated version will be issued

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
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch

