Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABBA3DBD55
	for <mm-commits@vger.kernel.org>; Thu, 16 Jul 2026 23:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245596; cv=none; b=Tzz+og5gwgOzomVD/7QR+TTLzm2Qn/noNJXPDvLqZADVr/ZPvx9QTCMFPtx9iEGtIN08SPViwlWqwfKWDPABIxq2FZo3eVHFBD0mOZm9WLBDyJpyoWjq4O7j7/e8lZN7ZAORg6EkfvLPabRqVp+sxYRm0FiiBxC7L3kt7oiby5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245596; c=relaxed/simple;
	bh=17FmpiztJARz4Be61MdmpUDVFNHzp5EXERyLu421tTo=;
	h=Date:To:From:Subject:Message-Id; b=t6zWAcRmHLK4VMRQS1a9nMeDkVjdoouj80LKG3m8/ikG94ZyRxGQeSzMOtkl8ClYcltgH15u2Vzs6AJJ/757e/kmWJhgh+fn6vlH7P+kEQj0t8eug0S7sD7uCWkMHnixhyTGabfSWmdFhB3Wu9aiF5uMW4yU40fOqs0CxsfYs9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iDZ7WTkf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iDZ7WTkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B401F00A3A;
	Thu, 16 Jul 2026 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784245594;
	bh=IT9hSXuS6LzaokVuALrtwrzElRmJWgldcUVTCN0n+J8=;
	h=Date:To:From:Subject;
	b=iDZ7WTkfHmS26+yQqBqobytpLj2PH0K5doIwSbR2HrkL8+LRbDnU1nEMfCwGWCIMR
	 tOoFh5HjeWU+zttmETbIq97keX/o+Uhrs+QXLHi2tzZvgJqRUlB2Qjlwp/hfHs1PwX
	 QTjOvyfoHMf9PQ2qlYcEvn/Q8q2KFzFPdisqAt44=
Date: Thu, 16 Jul 2026 16:46:33 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch removed from -mm tree
Message-Id: <20260716234633.F2B401F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: remove bootmem_info leftovers
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb_vmemmap: remove bootmem_info leftovers
Date: Wed, 08 Jul 2026 16:11:03 +0200

We never set CONFIG_HAVE_BOOTMEM_INFO_NODE, so we can just switch to
free_reserved_page() and drop the register_page_bootmem_memmap() call.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-8-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-bootmem_info-leftovers
+++ a/mm/hugetlb_vmemmap.c
@@ -12,7 +12,6 @@
 
 #include <linux/pgtable.h>
 #include <linux/moduleparam.h>
-#include <linux/bootmem_info.h>
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
@@ -177,13 +176,13 @@ static int vmemmap_remap_range(unsigned
  * Free a vmemmap page. A vmemmap page can be allocated from the memblock
  * allocator or buddy allocator. If the PG_reserved flag is set, it means
  * that it allocated from the memblock allocator, just free it via the
- * free_bootmem_page(). Otherwise, use __free_page().
+ * free_reserved_page(). Otherwise, use __free_page().
  */
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
 		memmap_boot_pages_add(-1);
-		free_bootmem_page(page);
+		free_reserved_page(page);
 	} else {
 		memmap_pages_add(-1);
 		__free_page(page);
@@ -641,9 +640,6 @@ static void __hugetlb_vmemmap_optimize_f
 			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
-					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_PAGES);
 			continue;
 		}
 
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

