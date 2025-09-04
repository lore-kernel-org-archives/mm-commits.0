Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248A43208
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 00:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944535; cv=none; b=erpDnRrkMr0ckbOeWnaGyvow7V99TKuYyO4B3vfzRJQi48/pFjUG3qzYNXeiTpAWk0E+lyoHU+Ad7SKXbnUk9C7pAttErYDoV8brxnPk89IOUjW3cIYDIlkw/hU5Is/sIVs6Wk71mBqrsK0T1A1bwhzzTrg3htL3k9zhRt6JIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944535; c=relaxed/simple;
	bh=mshX0888SAQSNA6z2eKmQ1e4lo4A9kEwBPYdD4CINc0=;
	h=Date:To:From:Subject:Message-Id; b=Jx2VntndXVHlcJM7w+THnqZXRO+LoL17xIy0sVBBdiENNQE/NW216bwn7baMGEbwaalRqcw0xIAZRjrM0kpw2JxaQjPA+xyL1xB7PPl1X5Hko86bfvnd4w7xpy7qR6f/BA9c+6ZYiLfMQXp380Bc9y2VREC9CiUprlRdyAEhhUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b1s4VIeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b1s4VIeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF238C4CEE7;
	Thu,  4 Sep 2025 00:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944534;
	bh=mshX0888SAQSNA6z2eKmQ1e4lo4A9kEwBPYdD4CINc0=;
	h=Date:To:From:Subject:From;
	b=b1s4VIeJkT4MAAQwa2XZU2j+SEg2CpEDFuRd4vRnRAd0kg3GHbQ0IqJQtCaYAw3gQ
	 mO/jFhGD7ELmkq88L/QbDW9kkfVjJ/iKGPRBIFl+ek44y5yqNaFCHGoKMXFjhZ6vLI
	 zXpZ4iib4We+FiJ93JRhzqeoMWplIIX9Lu/DCjkc=
Date: Wed, 03 Sep 2025 17:08:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch removed from -mm tree
Message-Id: <20250904000854.BF238C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch

This patch was dropped because it was folded into mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix
Date: Tue Aug 26 07:55:56 PM PDT 2025

fix whitespace, per everyone

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix
+++ a/mm/khugepaged.c
@@ -1417,8 +1417,8 @@ static int hpage_collapse_scan_pmd(struc
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
-								     _address)))
+		     folio_test_referenced(folio) ||
+		     mmu_notifier_test_young(vma->vm_mm, _address)))
 			referenced++;
 	}
 	if (!writable) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch

