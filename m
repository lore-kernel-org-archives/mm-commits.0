From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 017/166] mm, shmem: add vmstat for hugepage
 fallback
Date: Mon, 06 Apr 2020 20:04:25 -0700
Message-ID: <20200407030425.YAiEft_gq%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDE1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:27 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, jcline@redhat.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, rppt@linux.ibm.com, torvalds@linux-foundation.org, vbabka@suse.cz, yang.shi@linux.alibaba.com

From: David Rientjes <rientjes@google.com>
Subject: mm, shmem: add vmstat for hugepage fallback

The existing thp_fault_fallback indicates when thp attempts to allocate a
hugepage but fails, or if the hugepage cannot be charged to the mem cgroup
hierarchy.

Extend this to shmem as well.  Adds a new thp_file_fallback to complement
thp_file_alloc that gets incremented when a hugepage is attempted to be
allocated but fails, or if it cannot be charged to the mem cgroup
hierarchy.

Additionally, remove the check for CONFIG_TRANSPARENT_HUGE_PAGECACHE from
shmem_alloc_hugepage() since it is only called with this configuration
option.

Link: http://lkml.kernel.org/r/alpine.DEB.2.21.2003061421240.7412@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jeremy Cline <jcline@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    4 ++++
 include/linux/vm_event_item.h              |    2 ++
 mm/shmem.c                                 |   10 ++++++----
 mm/vmstat.c                                |    1 +
 4 files changed, 13 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-vmstat-for-hugepage-fallback
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -319,6 +319,10 @@ thp_file_alloc
 	is incremented every time a file huge page is successfully
 	allocated.
 
+thp_file_fallback
+	is incremented if a file huge page is attempted to be allocated
+	but fails and instead falls back to using small pages.
+
 thp_file_mapped
 	is incremented every time a file huge page is mapped into
 	user address space.
--- a/include/linux/vm_event_item.h~mm-shmem-add-vmstat-for-hugepage-fallback
+++ a/include/linux/vm_event_item.h
@@ -76,6 +76,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_COLLAPSE_ALLOC,
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_FILE_ALLOC,
+		THP_FILE_FALLBACK,
 		THP_FILE_MAPPED,
 		THP_SPLIT_PAGE,
 		THP_SPLIT_PAGE_FAILED,
@@ -115,6 +116,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 #define THP_FILE_ALLOC ({ BUILD_BUG(); 0; })
+#define THP_FILE_FALLBACK ({ BUILD_BUG(); 0; })
 #define THP_FILE_MAPPED ({ BUILD_BUG(); 0; })
 #endif
 
--- a/mm/shmem.c~mm-shmem-add-vmstat-for-hugepage-fallback
+++ a/mm/shmem.c
@@ -1472,9 +1472,6 @@ static struct page *shmem_alloc_hugepage
 	pgoff_t hindex;
 	struct page *page;
 
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
-		return NULL;
-
 	hindex = round_down(index, HPAGE_PMD_NR);
 	if (xa_find(&mapping->i_pages, &hindex, hindex + HPAGE_PMD_NR - 1,
 								XA_PRESENT))
@@ -1486,6 +1483,8 @@ static struct page *shmem_alloc_hugepage
 	shmem_pseudo_vma_destroy(&pvma);
 	if (page)
 		prep_transhuge_page(page);
+	else
+		count_vm_event(THP_FILE_FALLBACK);
 	return page;
 }
 
@@ -1871,8 +1870,11 @@ alloc_nohuge:
 
 	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg,
 					    PageTransHuge(page));
-	if (error)
+	if (error) {
+		if (PageTransHuge(page))
+			count_vm_event(THP_FILE_FALLBACK);
 		goto unacct;
+	}
 	error = shmem_add_to_page_cache(page, mapping, hindex,
 					NULL, gfp & GFP_RECLAIM_MASK);
 	if (error) {
--- a/mm/vmstat.c~mm-shmem-add-vmstat-for-hugepage-fallback
+++ a/mm/vmstat.c
@@ -1259,6 +1259,7 @@ const char * const vmstat_text[] = {
 	"thp_collapse_alloc",
 	"thp_collapse_alloc_failed",
 	"thp_file_alloc",
+	"thp_file_fallback",
 	"thp_file_mapped",
 	"thp_split_page",
 	"thp_split_page_failed",
_
