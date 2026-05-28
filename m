Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9B933372A
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780006788; cv=none; b=rRD0SK+7R1bTg6aJyIdUtFxl41F7B+T0BcvJjLgoTaJ604y+CAW7uaPv6XKC0I351e6iaPS7yem2dqO1IFgR3fTpb/0oNHfJHJwtKhKzM5A8am8jzbaoURvl5DCexQ4JzhzNPt5q3azH8L3K8vSdSYnNbCyUkCCmCEMnpP84KbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780006788; c=relaxed/simple;
	bh=snwuubVSw6IBHWGTylf6gaj/rsWBNLSFqViBVBdC03Q=;
	h=Date:To:From:Subject:Message-Id; b=ZliRMmIUB08MvFA4k53cO9HFY4pQwlQBeevjhb6EFr4GGtlVtsqoZ+/BTdewfnSJC0/+ZsZIt1aSRv/5/gNHtA9Vz3F8veIIjkyxMwP+Koa9KeRiDbrIeMu+M556I9r8I0VIWhy0xN6uywsLN5/JDqXJ67jp2tI4zZCoBvx6aqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jM9/p3uh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jM9/p3uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6891F000E9;
	Thu, 28 May 2026 22:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780006786;
	bh=CE3H4TkFYylBXRG7ydoFL7YQKgxmMTz1lkYr684RKJk=;
	h=Date:To:From:Subject;
	b=jM9/p3uhVVj8+a/su2IGGIn+gX/oM5Mi8DMgmAfW++VnqMt9RrsrRq/1PPCdY69kC
	 uAElg6Yy6d0COY683ACFlhAoxvRKemxJ1f1rBICw7YDKvxFNBIJV4PNbzjP6GIEiYl
	 rdxLCF8xBYBZIK3nB89t5LtLovOf1YCwAVILdXrw=
Date: Thu, 28 May 2026 15:19:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,riel@surriel.com,richard.weiyang@gmail.com,osalvador@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access.patch added to mm-new branch
Message-Id: <20260528221946.CC6891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_vma_mapped_walk: use ptep_get_lockless() for lockless access
has been added to the -mm mm-new branch.  Its filename is
     mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-gup-cleanup-pgtable-entry-accessors.patch
mm-page_vma_mapped_walk-use-ptep_get_lockless-for-lockless-access.patch

