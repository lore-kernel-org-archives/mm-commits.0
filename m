Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEF2392829
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298466; cv=none; b=m3xUUGndbVCGEd8UIl/Fw07PmxiRXC6WgBh58BlV+54Gp/UiOFN0ghE5r0POxXUDQLXtu/VXC23F/SJDEP4CTXjqw02BKfgrkvWwwC6dEHQu9LGhsth+02D65GZPFSRbID4ZbtWnTpM+hn4GN3HmQdUg6LPsZVc3gUioVNa+8mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298466; c=relaxed/simple;
	bh=JcrLyEqXuFOe4rKDWqyINKO6T8vS2jY+g6F9A+4TPxA=;
	h=Date:To:From:Subject:Message-Id; b=VRNs5y1nacLiv3NgfcNrkhozJifsOto1mk6uDd6CfRsEoL+jT+z6Xjv3f7aM0N2WYR3ewKPr/5qn7KUWOtuPFFhN302ElfoHHgkydNu5HjUm1y1KzBwiQlskfDdOUoJiknJGoVBI6AYL0PkxPQBS5zGkprwJlvl40NQ7ezSFGHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FWhvWfSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FWhvWfSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B871F00A3A;
	Wed, 29 Jul 2026 04:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298465;
	bh=UCHeP3rwGOlZW/FYOGftH/OQv9w3thm1zmsTzq3/31A=;
	h=Date:To:From:Subject;
	b=FWhvWfSNZ+CCnuYLdzQ5FDawrq3sZaL8tYtYG7O6xAGstdMnpCq0DvGKcVmU3sLOn
	 v0Z7hiOW0yYZxw2LGBUuERXHoxaBpAD0v58HmO3cXk2OBIeSXDHrjt+MA8nCXegHi0
	 LYYKZJ/48ry1tAlDGEUv/P0J6XOL1MFwuZdO/UoY=
Date: Tue, 28 Jul 2026 21:14:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch removed from -mm tree
Message-Id: <20260729041425.44B871F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: remove set_pageblock_order() call from sparse_init()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: remove set_pageblock_order() call from sparse_init()
Date: Fri, 12 Jun 2026 11:58:54 +0800

free_area_init() already sets pageblock_order before sparse_init() runs
for CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, so sparse_init() does not need to
call set_pageblock_order() again.

With that call removed, set_pageblock_order() is only used in
mm/mm_init.c.  Make it static.

Link: https://lore.kernel.org/20260612035903.2468601-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 -
 mm/mm_init.c  |    4 ++--
 mm/sparse.c   |    3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-mm_init-remove-set_pageblock_order-call-from-sparse_init
+++ a/mm/internal.h
@@ -1435,7 +1435,6 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
-extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
--- a/mm/mm_init.c~mm-mm_init-remove-set_pageblock_order-call-from-sparse_init
+++ a/mm/mm_init.c
@@ -1496,7 +1496,7 @@ static inline void setup_usemap(struct z
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+static void __init set_pageblock_order(void)
 {
 	unsigned int order = PAGE_BLOCK_MAX_ORDER;
 
@@ -1522,7 +1522,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+static inline void __init set_pageblock_order(void)
 {
 }
 
--- a/mm/sparse.c~mm-mm_init-remove-set_pageblock_order-call-from-sparse_init
+++ a/mm/sparse.c
@@ -343,9 +343,6 @@ void __init sparse_init(void)
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
-	set_pageblock_order();
-
 	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
 		int nid = sparse_early_nid(__nr_to_section(pnum_end));
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

