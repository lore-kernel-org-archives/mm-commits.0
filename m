Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715E426C39E
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744905; cv=none; b=UJDWfPNL23ev7aGNef/xOlz8p4kg9HYD0sz3epdRSWHm9+wFuGv3j0/B7EsoO9xV0r3bzv6T7T2mJj81uIEtx7XUlzYbqvLXd8yG3wflqs/IlWy1DDWuHZc/o0bqdeq4qTTAQ3lQ5DYvC1alfUuZvjurnPqLJUvGt64to9xqNzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744905; c=relaxed/simple;
	bh=I2XHkXY/JncMxbvPaJgckze1Y8u+hVegzZh01wtIaGo=;
	h=Date:To:From:Subject:Message-Id; b=Wq7k/Tp7oJWx3Nfu2jImiknl1NsTPEG430cBmtbJNPEV3ethkb1GJPqowI+ap/M3tMZjdNaAoWyfzVdQ8PrnQWIo3eEqveuIi6n1LvT5IKNQ+97sUWK+xTHOc9BnQBaSX9rPQv8mL6SGeMekMMb4GVEFWpwgNGQ1CN53k+hytGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQHYy/sN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQHYy/sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41120C4CEF7;
	Sun, 29 Mar 2026 00:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744905;
	bh=I2XHkXY/JncMxbvPaJgckze1Y8u+hVegzZh01wtIaGo=;
	h=Date:To:From:Subject:From;
	b=pQHYy/sNuzAnh2ap49uUgPhmbv67jHtIt3ZJEanBVwizU/vx2cXXugMtLroebhIji
	 K0w30DyFRMxENTsxiZJfn+jP8SaSBBx2MGz+75/XnqyemjGrJK0RW+ZKgWq/sh0W0B
	 psZwno7O2H0aMmVDy/Bj5NAgQfhuz0GFY20WH5ic=
Date: Sat, 28 Mar 2026 17:41:44 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-is_pmd_order-helper.patch removed from -mm tree
Message-Id: <20260329004145.41120C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce is_pmd_order helper
has been removed from the -mm tree.  Its filename was
     mm-introduce-is_pmd_order-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm: introduce is_pmd_order helper
Date: Wed, 25 Mar 2026 05:40:19 -0600

In order to add mTHP support to khugepaged, we will often be checking if a
given order is (or is not) a PMD order.  Some places in the kernel already
use this check, so lets create a simple helper function to keep the code
clean and readable.

Link: https://lkml.kernel.org/r/20260325114022.444081-3-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 +++++
 mm/huge_memory.c        |    2 +-
 mm/khugepaged.c         |    6 +++---
 mm/memory.c             |    2 +-
 mm/mempolicy.c          |    2 +-
 mm/page_alloc.c         |    4 ++--
 mm/shmem.c              |    3 +--
 7 files changed, 14 insertions(+), 10 deletions(-)

--- a/include/linux/huge_mm.h~mm-introduce-is_pmd_order-helper
+++ a/include/linux/huge_mm.h
@@ -771,6 +771,11 @@ static inline bool pmd_is_huge(pmd_t pmd
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static inline bool is_pmd_order(unsigned int order)
+{
+	return order == HPAGE_PMD_ORDER;
+}
+
 static inline int split_folio_to_list_to_order(struct folio *folio,
 		struct list_head *list, int new_order)
 {
--- a/mm/huge_memory.c~mm-introduce-is_pmd_order-helper
+++ a/mm/huge_memory.c
@@ -4159,7 +4159,7 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (old_order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
--- a/mm/khugepaged.c~mm-introduce-is_pmd_order-helper
+++ a/mm/khugepaged.c
@@ -1540,7 +1540,7 @@ static enum scan_result try_collapse_pte
 	if (IS_ERR(folio))
 		return SCAN_PAGE_NULL;
 
-	if (folio_order(folio) != HPAGE_PMD_ORDER) {
+	if (!is_pmd_order(folio_order(folio))) {
 		result = SCAN_PAGE_COMPOUND;
 		goto drop_folio;
 	}
@@ -2023,7 +2023,7 @@ static enum scan_result collapse_file(st
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			goto out_unlock;
 		}
@@ -2351,7 +2351,7 @@ static enum scan_result hpage_collapse_s
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
 			 * PMD-sized THP implies that we can only try
--- a/mm/memory.c~mm-introduce-is_pmd_order-helper
+++ a/mm/memory.c
@@ -5435,7 +5435,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	if (folio_order(folio) != HPAGE_PMD_ORDER)
+	if (!is_pmd_order(folio_order(folio)))
 		return ret;
 	page = &folio->page;
 
--- a/mm/mempolicy.c~mm-introduce-is_pmd_order-helper
+++ a/mm/mempolicy.c
@@ -2449,7 +2449,7 @@ static struct page *alloc_pages_mpol(gfp
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
-	    order == HPAGE_PMD_ORDER && ilx != NO_INTERLEAVE_INDEX) {
+	    is_pmd_order(order) && ilx != NO_INTERLEAVE_INDEX) {
 		/*
 		 * For hugepage allocation and non-interleave policy which
 		 * allows the current node (or other explicitly preferred
--- a/mm/page_alloc.c~mm-introduce-is_pmd_order-helper
+++ a/mm/page_alloc.c
@@ -651,7 +651,7 @@ static inline unsigned int order_to_pind
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool movable;
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != HPAGE_PMD_ORDER);
+		VM_BUG_ON(!is_pmd_order(order));
 
 		movable = migratetype == MIGRATE_MOVABLE;
 
@@ -683,7 +683,7 @@ static inline bool pcp_allowed_order(uns
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(order))
 		return true;
 #endif
 	return false;
--- a/mm/shmem.c~mm-introduce-is_pmd_order-helper
+++ a/mm/shmem.c
@@ -5558,8 +5558,7 @@ static ssize_t thpsize_shmem_enabled_sto
 		spin_unlock(&huge_shmem_orders_lock);
 	} else if (sysfs_streq(buf, "inherit")) {
 		/* Do not override huge allocation policy with non-PMD sized mTHP */
-		if (shmem_huge == SHMEM_HUGE_FORCE &&
-		    order != HPAGE_PMD_ORDER)
+		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
 			return -EINVAL;
 
 		spin_lock(&huge_shmem_orders_lock);
_

Patches currently in -mm which might be from npache@redhat.com are


