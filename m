Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8679110F2;
	Sat, 14 Jun 2025 00:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859975; cv=none; b=HT5JTJAhpzoV0IKIxPsmiPP84BSUtQ8T408rSY65GlQduqdMqgw4D+K/OW7JJoQNyPwqYfNJiLbZRLGNrD1Lfz/RKxujVI5qDiDDeW50z0430/VXUyhNkUXytPHMqNM+/gBsNxlf/ZCdpcf4mf9pwgEAG5kzfF0sK9dHKeQX49c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859975; c=relaxed/simple;
	bh=IJc5ZHfOGeimAjOuGu5s+foh+4ke5TY1mqPm/hhKO7k=;
	h=Date:To:From:Subject:Message-Id; b=deUjtZAd6skbtNHZivEE73UPCwq9NEGOQCvju0GtuMa/k2TD+NxK3utMK2wlULXBUGzNBIzXkECXV387C/gWwU3Quz5uBLoZd56abI3l46T0wgQuaxnsOjQdBzqN/cQG485Itu/44a/Fy9wRR9BWIV6O1VyKCdBvGTp/SWoXT6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QiQPAGtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QiQPAGtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C31C4CEE3;
	Sat, 14 Jun 2025 00:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749859975;
	bh=IJc5ZHfOGeimAjOuGu5s+foh+4ke5TY1mqPm/hhKO7k=;
	h=Date:To:From:Subject:From;
	b=QiQPAGtO8ZdjKoGwSSsK3D6ZNBg7FCrrRHkdf24kY/2va9pgGI3OfgmImTjsjVqYK
	 3WMHgH5AdeMEi7ULUyjRylc5gjkO+bpxFHaom3WwLZnPUQDjQZ1ynhkXvTe9pX8IEo
	 8d3MbO08jh0Lqiao9sU9qh8Rf60MnucoAoGrq9Ug=
Date: Fri, 13 Jun 2025 17:12:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgg@nvidia.com,dev.jain@arm.com,dan.j.williams@intel.com,baolin.wang@linux.alibaba.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch added to mm-unstable branch
Message-Id: <20250614001255.04C31C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Fri, 13 Jun 2025 11:27:00 +0200

Patch series "mm/huge_memory: vmf_insert_folio_*() and
vmf_insert_pfn_pud() fixes", v3.

While working on improving vm_normal_page() and friends, I stumbled over
this issues: refcounted "normal" folios must not be marked using
pmd_special() / pud_special().  Otherwise, we're effectively telling the
system that these folios are no "normal", violating the rules we
documented for vm_normal_page().

Fortunately, there are not many pmd_special()/pud_special() users yet.  So
far there doesn't seem to be serious damage.

Tested using the ndctl tests ("ndctl:dax" suite).


This patch (of 3):

We set up the cache mode but ...  don't forward the updated pgprot to
insert_pfn_pud().

Only a problem on x86-64 PAT when mapping PFNs using PUDs that require a
special cachemode.

Fix it by using the proper pgprot where the cachemode was setup.

It is unclear in which configurations we would get the cachemode wrong:
through vfio seems possible.  Getting cachemodes wrong is usually ... 
bad.  As the fix is easy, let's backport it to stable.

Identified by code inspection.

Link: https://lkml.kernel.org/r/20250613092702.1943533-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250613092702.1943533-2-david@redhat.com
Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

