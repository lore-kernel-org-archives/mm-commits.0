Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4840A3911C3;
	Wed, 29 Jul 2026 04:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298456; cv=none; b=WaKmyetm4j8Uh7UH54+sI6mErn2YQYvC/naEcbnOaxwSU5oFzoQ4/L09bOxeURNllU7qwavu4FRF/qeoRS2O8fbGt91EHM2W8dUTJ0xWuTQaTInoKHMaw8K3r6iMRbVaniS+AtNpr6N5X60AldGNyqqShcqtNc2SBwZ9+ljq9Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298456; c=relaxed/simple;
	bh=K/bx864sppo5mwFTa33mat5T/BCtRYu/9qxF/9N7fjA=;
	h=Date:To:From:Subject:Message-Id; b=W74plfuo0g28rqX9uApXlOjeuqKr3jNKWiwJdJef1y7OKsjdGFBW4lbglzGxTrNhh+zERa2e0u3hUiBLwHmMQwCELMK7kl8Y8VUYbfDfbQu9Ne3HcugLlcWYbJZRsQPIEYkwOEFW4kLXQypUxBlSzEjrqD2t5bRkptlJtE3FI/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LklS/uyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LklS/uyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2F81F00A3A;
	Wed, 29 Jul 2026 04:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298455;
	bh=Smp6hNCS30/clkzritDkINq5S2hfZmtC2OMwYo5U9wo=;
	h=Date:To:From:Subject;
	b=LklS/uyFu2na8d6sQX6DEcdy5uJDYVRTCiR2z3QkQt4nbyx55EVjfb5xMTegJ0Ht4
	 vnY7QwQkiKwWB54OJkJ1tZAz3wZlowf8qv7ITyWlwcOKRP3EhlF2NIiUmYRvApd5Go
	 Vit0sB/SJkkEwOlSBYB1vvkzxJg2XOYRkuColJ6s=
Date: Tue, 28 Jul 2026 21:14:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,stable@vger.kernel.org,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch removed from -mm tree
Message-Id: <20260729041415.1F2F81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: fix __hugetlb_vmemmap_optimize_folios()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb_vmemmap: fix __hugetlb_vmemmap_optimize_folios()
Date: Fri, 12 Jun 2026 11:58:46 +0800

__hugetlb_vmemmap_optimize_folios() uses incorrect arguments when handling
bootmem HugeTLB folios.

The section number passed to register_page_bootmem_memmap() is derived
from the vmemmap virtual address of folio->page instead of the folio PFN,
so the bootmem memmap metadata can be registered against the wrong
section.  The helper is also given HUGETLB_VMEMMAP_RESERVE_SIZE even
though it expects a page count, not a size in bytes.  In addition, the
write-protect range is based on pages_per_huge_page(h), which does not
cover the full HugeTLB vmemmap area and can leave part of the shared tail
vmemmap mapping writable.

Fix the section lookup to use folio_pfn(folio), use
HUGETLB_VMEMMAP_RESERVE_PAGES when registering the reserved memmap pages,
and use hugetlb_vmemmap_size(h) for the write-protect range.

Link: https://lore.kernel.org/20260612035903.2468601-3-songmuchun@bytedance.com
Fixes: 752fe17af693 ("mm/hugetlb: add pre-HVO framework")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Frank van der Linden <fvdl@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios
+++ a/mm/hugetlb_vmemmap.c
@@ -635,12 +635,12 @@ static void __hugetlb_vmemmap_optimize_f
 			 * mirrored tail page structs RO.
 			 */
 			spfn = (unsigned long)&folio->page;
-			epfn = spfn + pages_per_huge_page(h);
+			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
+			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
 					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+					HUGETLB_VMEMMAP_RESERVE_PAGES);
 			continue;
 		}
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

