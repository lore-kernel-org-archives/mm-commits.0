Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FA5216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188375; cv=none; b=hlTqXWLDXdp7a9ja57fFcjBe7vLbgJiVh+fSdo47ZW1GgsS0jsB+hQUYx2/Wjzq9iZ7R1UYx+Zx6gowgdvb3NVWCtV3soc8AQ2/+t0iv5qkFhLQBA94mtXlU0J8iLlL9Y2ZPNmXLkfmgmfex6KSRghccg1jDhPbG/rbdzxvMBp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188375; c=relaxed/simple;
	bh=Td3GKpP5ryz9PViyEc4EzcApYkUJXCp03hSkFnpKty0=;
	h=Date:To:From:Subject:Message-Id; b=vFJh8PPz+b2dGcwwj1zLcxa0QzJdo+jWKOrQDL+maxfx9wUXTcQnetKT/+i1pL4ea9mXdhnlMLib2WTTsmJoABNc/34dgNPncFkBva6StgmukTTms5T1VNHOnjsPZdqvxEC7bkw0PqlENaxjE0gBIHVLY4VVJkzQI/55jgWeTaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PMfD1tx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PMfD1tx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D57C4CEEC;
	Mon, 17 Mar 2025 05:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188375;
	bh=Td3GKpP5ryz9PViyEc4EzcApYkUJXCp03hSkFnpKty0=;
	h=Date:To:From:Subject:From;
	b=PMfD1tx6lwXllrIIhqsJZc7mmIWtFU2Vkkv6gZw+Lqzzhh2w7P6dTnvMduZ5YijPT
	 bkA9eppg23LS/EopW7IcAxi5vnytgzjP6AEphOewXQ356cwE4lQuNU6UUunTHR0Cs1
	 s9xZtXGFMiErQlRujEgiFvsxb40as3xeAw4Rd3U8=
Date: Sun, 16 Mar 2025 22:12:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-set-migratetype-for-bootmem-folios.patch removed from -mm tree
Message-Id: <20250317051255.96D57C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: set migratetype for bootmem folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-set-migratetype-for-bootmem-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: set migratetype for bootmem folios
Date: Fri, 28 Feb 2025 18:29:12 +0000

The pageblocks that back memblock allocated hugetlb folios might not have
the migrate type set, in the CONFIG_DEFERRED_STRUCT_PAGE_INIT case.

memblock allocated hugetlb folios might be given to the buddy allocator
eventually (if nr_hugepages is lowered), so make sure that the migrate
type for the pageblocks contained in them is set when initializing them. 
Set it to the default that memmap init also uses (MIGRATE_MOVABLE).

Link: https://lkml.kernel.org/r/20250228182928.2645936-12-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-set-migratetype-for-bootmem-folios
+++ a/mm/hugetlb.c
@@ -3266,6 +3266,26 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
 
+/*
+ * memblock-allocated pageblocks might not have the migrate type set
+ * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
+ * here.
+ *
+ * Note that this will not write the page struct, it is ok (and necessary)
+ * to do this on vmemmap optimized folios.
+ */
+static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
+							  struct hstate *h)
+{
+	unsigned long nr_pages = pages_per_huge_page(h), i;
+
+	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
+
+	for (i = 0; i < nr_pages; i += pageblock_nr_pages)
+		set_pageblock_migratetype(folio_page(folio, i),
+					  MIGRATE_MOVABLE);
+}
+
 static void __init prep_and_add_bootmem_folios(struct hstate *h,
 					struct list_head *folio_list)
 {
@@ -3287,6 +3307,7 @@ static void __init prep_and_add_bootmem_
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
+		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
 		__prep_account_new_huge_page(h, folio_nid(folio));
_

Patches currently in -mm which might be from fvdl@google.com are


