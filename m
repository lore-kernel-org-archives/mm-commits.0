Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E4633939D;
	Fri, 31 Jul 2026 02:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465826; cv=none; b=n/m2LanZrZS/Dbvi1QTvdXx3v0e7IXYjCl1uLDxmCnkp/5vKqARVtXcnD0fKgi2rV9pJ8Tg4Pmi7EYEonNifbmQIL83dcl9Na9/TuR+ErhL6tREnj0PksTHzHH2ZV6J9826ifVB4solkOKvEUH4hqd1K0eA4M6gcnQKsCNflOaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465826; c=relaxed/simple;
	bh=WId8NBvxWpV5hHaTRraHy0VjUSbwyoh3U2i3fjGoSf4=;
	h=Date:To:From:Subject:Message-Id; b=lvnLkHvxS1x1DvzkxbdLpnmqsNJz+ts74l3jZNsN1hik42qmbfOHmldhlMDEb/FWfJDZuvqki0ats4l7jHveU+Ql/f7LtFHEwEO8e994bIqZLslCVRKWTsdUwdJjaQZ9guLsKU2ix1qd384xqp8Orvt9IdyphrTtqyZJg5rQSxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dpdPF+uB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dpdPF+uB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08411F000E9;
	Fri, 31 Jul 2026 02:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465821;
	bh=TGs6fJmtyc61wug9Cl4qAXmUaCf9bO7owyoAN6Kf2h8=;
	h=Date:To:From:Subject;
	b=dpdPF+uBx4q+ppvDdRMDSgS5WBQVHnsymeWJx5srLhWMNOcCrZlXlY6tXYfmAyYwb
	 IpnGZOu5BEdyquKfxv9CmvcaCXSukUb3vTHU1mF1wPg5sA9h+nGLEKwEXss8aWZmte
	 sPywhZUNyVNtcRP2bv5/95gGdOHic2cUEjkzEGHY=
Date: Thu, 30 Jul 2026 19:43:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,will@kernel.org,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,rcampbell@nvidia.com,rakie.kim@sk.com,pfalcato@suse.de,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jpoimboe@kernel.org,joshua.hahnjy@gmail.com,j-nomura@ce.jp.nec.com,jannh@google.com,harry@kernel.org,gourry@gourry.net,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,byungchul@sk.com,apopple@nvidia.com,anshuman.khandual@arm.com,ak@linux.intel.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch removed from -mm tree
Message-Id: <20260731024341.B08411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_vma_mapped: use huge_ptep_get() for hugetlb
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Fri, 3 Jul 2026 11:41:58 +0000

check_pte() is the final validation step in page_vma_mapped_walk().  It
reads pvmw->pte with ptep_get() to decide whether the entry maps the PFN
range being walked.  For hugetlb VMAs, that pointer refers to a hugetlb
entry.

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Link: https://lore.kernel.org/20260703114202.365553-6-dev.jain@arm.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jun'ichi "Nick" Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb
+++ a/mm/page_vma_mapped.c
@@ -107,7 +107,13 @@ again:
 static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 {
 	unsigned long pfn;
-	pte_t ptent = ptep_get(pvmw->pte);
+	pte_t ptent;
+
+	if (is_vm_hugetlb_page(pvmw->vma))
+		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
+				      pvmw->pte);
+	else
+		ptent = ptep_get(pvmw->pte);
 
 	if (pvmw->flags & PVMW_MIGRATION) {
 		const softleaf_t entry = softleaf_from_pte(ptent);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_poisoned_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

