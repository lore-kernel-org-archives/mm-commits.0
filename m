Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD3F2931F5
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 19:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601591; cv=none; b=izLRZ4dT0TUMo7CatH0M0cBbA2grRYDx4So2u2o/eCyjZ+TGWDhQbRM71/+d/eXx13YBu6kLhhvIcojyLGcZuZl/fiYPKoAx5ojWYW7ICWgSCZSaUzv3fDdH+lPeamR1G0D+fliCidVbkF7+Lf4X5tJzFyvDzCCmwVaMMvkB8K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601591; c=relaxed/simple;
	bh=DfmtRmIcDGmaHEDF+gPG5eLiaaCM3LXteOlMqF9exf8=;
	h=Date:To:From:Subject:Message-Id; b=HW5PrFJ+bOYoZag9960w/VWN0kYonnoEVzjRx9fBDZ8y/dxrfNzIgxvJdh6KwOciU3Je1Zu5vcIphsahVZ/WolQ5nPF1F9GYrXNfEmIBaFhEUhLrgSSHALehmG8B//hJ7Zgi6iuJ76x0iudy/vuE7od2OLZbAJtol6wufqY/4lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLkpB3og; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLkpB3og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277741F000E9;
	Mon, 24 Aug 2026 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787601590;
	bh=HKxzRDODZ+Jz0zUs0MPO6/y+/IFD24PHhWMISM6pBl0=;
	h=Date:To:From:Subject;
	b=MLkpB3ogQOMCgDFa72Hbjr/dbIO/v/tBv8kvjUt5GqJbV6JWBtrGw0Da6FK/+3RiE
	 +RGkm49Zb8CzOVgUIVUh8yZuQf1i3IGhcaLZremaUr7wP7ZFNEfvd4vSIRBHKuBxSa
	 0eQ127RatA6yV0tTay8+mYhIudBv7U1OD8OVq3Vo=
Date: Mon, 24 Aug 2026 12:59:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix.patch removed from -mm tree
Message-Id: <20260824195950.277741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix.patch

This patch was dropped because it was folded into mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch

------------------------------------------------------
From: Nico Pache (Red Hat) <nico.pache@linux.dev>
Subject: mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix
Date:   Fri Aug 21 04:27:18 2026 -0600

drop the trivial helper kerneldoc and inline marker per review

Link: https://lore.kernel.org/9038f552-926b-4c4c-b023-69271f45e3d5@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix
+++ a/mm/khugepaged.c
@@ -666,13 +666,7 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
-/*
- * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
- *
- * Return: true if recent access was observed through either the folio state
- * or the current PTE mapping.
- */
-static inline bool folio_pte_referenced(struct folio *folio,
+static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-fix-outdated-comments-fix.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

