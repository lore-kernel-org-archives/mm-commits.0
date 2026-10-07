Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710092BDC1C
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334160; cv=none; b=jAoJDQFBdygyZrNKW+uHOOZ+Fwra/Xwqq2yyP02Ei4fX0Zyq/3uvPKSw2+an0A3xKvJ9LyoyVxeL0jeFrvW2U/ZlWClBFgDFEA3jZl2FQSMDAZbdXSzsVPrshB4LWbSB4C0AMHh8guFcDrDkT7890P1A62BIrm9tKY8wJ4b4tOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334160; c=relaxed/simple;
	bh=+Y6WL/SP3AFH3IcCVGBR0Su7EpjpgwQ34i/QYCAjtBE=;
	h=Date:To:From:Subject:Message-Id; b=fzJlWmVtN6yYWSYiok/MtawkwVlM9E6L8RI9Y7ljqYzE7FAXSeRcl8tNnIoV0u6Ym+ItIkU79yDpaIIdi5/CgF0+TQkQsZIVdDGDdPprP3XwUqY5BpjIM/ML8BH3Bbuj9E86BBbz4laWBbkd27wRffhfCegP0K01heWvnmNhJoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hK+qgFCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hK+qgFCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4571A1F0089B;
	Wed,  7 Oct 2026 00:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334159;
	bh=FRz3IGKkoptkbMZQ/4n2oTU+DmmG/saIpGBEwot1Xk0=;
	h=Date:To:From:Subject;
	b=hK+qgFCK5jhFOpFz6ZmeTQYxrLRAtHfWd1SXEld35UDaz8uv+yJH2davX4Vgu4MNX
	 czpAqRpplf9FCHmJMA7zAQM6wj5hWWhuLDBgMYu2YFscGIVXXEtZtBxO3Uiahs5gyH
	 Utih4ctvVM0K/2s4WyOWJFqtqNqfSMneWPOLmf0E=
Date: Tue, 06 Oct 2026 17:49:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-initialize-memory-sections-earlier.patch removed from -mm tree
Message-Id: <20261007004919.4571A1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: initialize memory sections earlier
has been removed from the -mm tree.  Its filename was
     mm-sparse-initialize-memory-sections-earlier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: initialize memory sections earlier
Date: Thu, 10 Sep 2026 14:32:48 +0800

Upcoming HugeTLB bootmem changes need sparsemem section metadata before
the HugeTLB bootmem allocation path runs.  The memory sections are
initialized from sparse_init(), which is called too late for that setup.

Move the code that initializes sparsemem section metadata for memblock
ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
bootmem setup.  Rename the helper to sparse_sections_init() so the new
caller describes the sparsemem-specific initialization step.

This is a preparatory change.

Link: https://lore.kernel.org/20260910063256.64386-10-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/mm_init.c |    1 +
 mm/sparse.c  |    9 +--------
 mm/sparse.h  |    2 ++
 3 files changed, 4 insertions(+), 8 deletions(-)

--- a/mm/mm_init.c~mm-sparse-initialize-memory-sections-earlier
+++ a/mm/mm_init.c
@@ -2642,6 +2642,7 @@ void __init mm_core_init_early(void)
 {
 	kho_memory_init_early();
 
+	sparse_sections_init();
 	free_area_init();
 
 	hugetlb_cma_reserve();
--- a/mm/sparse.c~mm-sparse-initialize-memory-sections-earlier
+++ a/mm/sparse.c
@@ -191,12 +191,7 @@ static void __init memory_present(int ni
 	}
 }
 
-/*
- * Mark all memblocks as present using memory_present().
- * This is a convenience function that is useful to mark all of the systems
- * memory as present during initialization.
- */
-static void __init memblocks_present(void)
+void __init sparse_sections_init(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -322,8 +317,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
--- a/mm/sparse.h~mm-sparse-initialize-memory-sections-earlier
+++ a/mm/sparse.h
@@ -59,6 +59,7 @@ static inline bool vmemmap_optimizable_o
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
@@ -104,6 +105,7 @@ static inline bool section_vmemmap_optim
 }
 #else
 static inline void sparse_init(void) {}
+static inline void sparse_sections_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


