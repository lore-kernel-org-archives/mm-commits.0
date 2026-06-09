Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5096E2DB794
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968150; cv=none; b=kBdMUmr+kOz8eUbHtXj9QvCX+ZDc+VlnEtYveYoXq5uuIUXjRn4ORnOCZpH1cF/bkiNAXWmhzM0wN1Kh1jp4nYBNCQlmX4vvSMQ1JXl8GVahnJF/hEfPSNBsA8CwIp75d5LfGOdaxQMWflnh24/mPK0WRhmfvLfjwZYSv2hJ3AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968150; c=relaxed/simple;
	bh=V3OPwQzwaY3iLlvorLNPcAcGViF6nqaBnBz+6VWtnKQ=;
	h=Date:To:From:Subject:Message-Id; b=AZgfk003YYrX+EZChYZZB2jS00Z7gov3PLM3PEagSujrl7OWjbVHSqbCQRZvZ/2DgIB8Ai2hZg1zbewjuzfCWg51aNR7xsaukaH4CXlYv1qkq8op0/d1XQ2LWBzVT89gjolOMlskClvSpIQfUkkFsk8lq4Jni3ZJVi8MmbNFV9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xIb9PX/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xIb9PX/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234F01F00898;
	Tue,  9 Jun 2026 01:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968149;
	bh=lFR/1gh+i++VSzozBiDmDlwCpDV3AS5kMkhbP39C+Nw=;
	h=Date:To:From:Subject;
	b=xIb9PX/tllMPrPAhGxb9hD3eIi6uztK8gLvZ26uKwi9W2AIZK76BltHiWQjgh7K78
	 zm8sSeRS4ie2vpiSAufDQxUrINzkXjoyc2uIbb8qVCIGVqgsSQq1ChP86GGaXWsnyQ
	 2NNcmbjSHZnedJl3cz9T0f1m3M3Syj+XvkTyQGIs=
Date: Mon, 08 Jun 2026 18:22:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,riel@surriel.com,richard.weiyang@gmail.com,osalvador@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access.patch removed from -mm tree
Message-Id: <20260609012229.234F01F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_vma_mapped_walk: use ptep_get_lockless() for lockless access
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/page_vma_mapped_walk: use ptep_get_lockless() for lockless access
Date: Thu, 28 May 2026 09:55:07 +0200

When not holding the lock, there is a chance that the pte gets modified
under our feet, so we need to use the lockless API to make sure that the
entries remain consistent during the read."

Switch from ptep_get() to ptep_get_lockless() accessor for PTE reads when
no lock is taken.

[osalvador@suse.de: changelog addition]
  Link: https://lore.kernel.org/ahhNq0pFKvSKZQbR@localhost.localdomain
Link: https://lore.kernel.org/20260528075507.1821939-1-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access
+++ a/mm/page_vma_mapped.c
@@ -41,7 +41,7 @@ again:
 	if (!pvmw->pte)
 		return false;
 
-	ptent = ptep_get(pvmw->pte);
+	ptent = ptep_get_lockless(pvmw->pte);
 
 	if (pte_none(ptent)) {
 		return false;
@@ -183,6 +183,7 @@ bool page_vma_mapped_walk(struct page_vm
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long end;
 	spinlock_t *ptl;
+	pte_t pteval;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -310,7 +311,11 @@ next_pte:
 				goto restart;
 			}
 			pvmw->pte++;
-		} while (pte_none(ptep_get(pvmw->pte)));
+			if (!pvmw->ptl)
+				pteval = ptep_get_lockless(pvmw->pte);
+			else
+				pteval = ptep_get(pvmw->pte);
+		} while (pte_none(pteval));
 
 		if (!pvmw->ptl) {
 			spin_lock(ptl);
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


