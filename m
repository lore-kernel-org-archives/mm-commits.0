Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E182253EE
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027570; cv=none; b=SsPI9uMcHFpXCnLSiupmWYXnRpit6NnKIBW5/4lKn2asjVz3VqsqullmE0l/e/w2lSYn5qP5f0gqNnFz5t6lCFLIKc5kHcRVcmxJgbwNdyKYglPdS3I/gGfHWGdHk0i6taIN3wQOeICk5L81YO9oYrKaRnlRYwowujV3SHET0lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027570; c=relaxed/simple;
	bh=/4W5wFLhNC/HHXjgEfWh0oNqPHhQdR+7+R5nASAzWCI=;
	h=Date:To:From:Subject:Message-Id; b=dBcum6EtBpsl/BRi/J1bzX56eGtSx4/7wgPXheMHacIVRlvBVY0lC2B7AXKHdUB1Ab5xtpulMJk6S5qLpC1+jFf0+kK8rdpGcgZvigSCrrS72w9+RRHGUp1QPfVuQEXmAvu4ALPzwYucWP/Ap3jTwqjvY4Rqt2uReMItT45tAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zeCA2QMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zeCA2QMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2BF1F00899;
	Fri, 29 May 2026 04:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027569;
	bh=Y7+6DZd3DDP2QdIaeY2/8VZNvQhsPkvhWpSlPucS9gM=;
	h=Date:To:From:Subject;
	b=zeCA2QMBMWq2I0VRU0s+necVW7cMh4xEJmrf8j6pNWZZm0Tof8n7v3dW5QkCOa8Z1
	 kSq+SzlYOhC+xffMMBLZOq7Zv382zsvfJ472n1Rt+dnOAk0F9It/1od/EcRWwiYSO4
	 CKGB4XI2SZmbqbkZ02lG0wUC51Q2Fd89CJusBMwI=
Date: Thu, 28 May 2026 21:06:09 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,peterx@redhat.com,kevin.brodsky@arm.com,jhubbard@nvidia.com,jgg@ziepe.ca,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@kernel.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-cleanup-pgtable-entry-accessors.patch removed from -mm tree
Message-Id: <20260529040609.AA2BF1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: cleanup pgtable entry accessors
has been removed from the -mm tree.  Its filename was
     mm-gup-cleanup-pgtable-entry-accessors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/gup: cleanup pgtable entry accessors
Date: Tue, 21 Apr 2026 07:17:54 +0200

PMD and PUD entries revalidation has the same semantics as PTE entry
revalidation.  Convert the remaining direct entry dereferences to the
corresponding accessors.

The PTE validation in gup_fast_pte_range() is inconsistent with the prior
value acquisition in the sense that it drops the lockless access
semantics.

Use the lockless accessor not only for the PTE, but also for the PMD
validation, which is likewise inconsistent with the prior value
acquisition in gup_fast_pmd_range().

Link: https://lore.kernel.org/20260421051754.1691221-1-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-cleanup-pgtable-entry-accessors
+++ a/mm/gup.c
@@ -2865,8 +2865,8 @@ static int gup_fast_pte_range(pmd_t pmd,
 		if (!folio)
 			goto pte_unmap;
 
-		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
-		    unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
+		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
+		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2942,7 +2942,7 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	if (!folio)
 		return 0;
 
-	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
+	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get_lockless(pmdp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2985,7 +2985,7 @@ static int gup_fast_pud_leaf(pud_t orig,
 	if (!folio)
 		return 0;
 
-	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
+	if (unlikely(pud_val(orig) != pud_val(pudp_get(pudp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access.patch

