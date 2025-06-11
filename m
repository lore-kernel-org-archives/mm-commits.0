Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73139282FA;
	Wed, 11 Jun 2025 23:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749683057; cv=none; b=iykcZyugbO3x/y8iwTPqYYV2LABbKGyXMFELhgvqeyl6y49V9WPlfq5/thgAc/E57bxoSBY/CLAQj/GYG2RXM9FrLX4em37rBsS5Nq3x2hru+EHlMcTEm/zTIZqCIWrmXwXZr+uIaWPXj7K5qnDYXzhqtWUL2ZAXeEHEPH9TOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749683057; c=relaxed/simple;
	bh=TBnYkL1UXs3zv9Kgn3wZaaxz541Ume5n/ShzvRcO7/s=;
	h=Date:To:From:Subject:Message-Id; b=ZE9ZQCUQ3SEFnrC+LLNDKpMSL5KCYjTYNin2khF+CAFHHJDcjJqnOS7S2Z1z04GvwmeCAc7rwdliP29NDIwzKLbgyOFsxD2bsJHDb6YD5nYg1uLwIXvHKx0Dl8pgt/Kjk833DyEPtN8rR+ubci+ajG+4yujtLBsXKmwo0mM+ff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oNV6ma48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oNV6ma48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2423C4CEE3;
	Wed, 11 Jun 2025 23:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749683054;
	bh=TBnYkL1UXs3zv9Kgn3wZaaxz541Ume5n/ShzvRcO7/s=;
	h=Date:To:From:Subject:From;
	b=oNV6ma48aS6FgEJBXlhNNiRJ/gAIkbV3GMXu1sw8MiP1bb+szOzE0QyxIwXQiWs7M
	 RMRxvC//e2tqhvHOmjpnrqsnG+bSWub7eJ/g/YnY5fRYqyN1TKpbx8PVGKoA7e02HL
	 +ACL0BhTV3csi/HFBrtYI9trSHjG8ld61DDl3qOg=
Date: Wed, 11 Jun 2025 16:04:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,dan.j.williams@intel.com,baolin.wang@linux.alibaba.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch added to mm-new branch
Message-Id: <20250611230414.D2423C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
Date: Wed, 11 Jun 2025 14:06:52 +0200

Patch series "mm/huge_memory: vmf_insert_folio_*() and
vmf_insert_pfn_pud() fixes", v2.

While working on improving vm_normal_page() and friends, I stumbled over
this issues: refcounted "normal" pages must not be marked using
pmd_special() / pud_special().

Fortunately, so far there doesn't seem to be serious damage.


This patch (of 3):

We setup the cache mode but ...  don't forward the updated pgprot to
insert_pfn_pud().

Only a problem on x86-64 PAT when mapping PFNs using PUDs that require a
special cachemode.

Fix it by using the proper pgprot where the cachemode was setup.

Identified by code inspection.

Link: https://lkml.kernel.org/r/20250611120654.545963-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250611120654.545963-2-david@redhat.com
Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud
+++ a/mm/huge_memory.c
@@ -1516,10 +1516,9 @@ static pud_t maybe_pud_mkwrite(pud_t pud
 }
 
 static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, pfn_t pfn, bool write)
+		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgprot_t prot = vma->vm_page_prot;
 	pud_t entry;
 
 	if (!pud_none(*pud)) {
@@ -1581,7 +1580,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	pfnmap_setup_cachemode_pfn(pfn_t_to_pfn(pfn), &pgprot);
 
 	ptl = pud_lock(vma->vm_mm, vmf->pud);
-	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
+	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
@@ -1625,7 +1624,7 @@ vm_fault_t vmf_insert_folio_pud(struct v
 		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
 	}
 	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
-		write);
+		       vma->vm_page_prot, write);
 	spin_unlock(ptl);
 
 	return VM_FAULT_NOPAGE;
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-revert-mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch
mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch

