From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately.patch added
 to -mm tree
Date: Sat, 07 Mar 2020 14:10:09 -0800
Message-ID: <20200307221009.RDy83btH_%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgCGWKL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 17:10:11 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jcline@redhat.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, rppt@linux.ibm.com, vbabka@suse.cz, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm, thp: track fallbacks due to failed memcg charges separately
has been added to the -mm tree.  Its filename is
     mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: track fallbacks due to failed memcg charges separately

The thp_fault_fallback and thp_file_fallback vmstats are incremented if
either the hugepage allocation fails through the page allocator or the
hugepage charge fails through mem cgroup.

This patch leaves this field untouched but adds two new fields,
thp_{fault,file}_fallback_charge, which is incremented only when the mem
cgroup charge fails.

This distinguishes between attempted hugepage allocations that fail due to
fragmentation (or low memory conditions) and those that fail due to mem
cgroup limits.  That can be used to determine the impact of fragmentation
on the system by excluding faults that failed due to memcg usage.

Link: http://lkml.kernel.org/r/alpine.DEB.2.21.2003061422070.7412@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jeremy Cline <jcline@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   10 ++++++++++
 include/linux/vm_event_item.h              |    3 +++
 mm/huge_memory.c                           |    2 ++
 mm/shmem.c                                 |    4 +++-
 mm/vmstat.c                                |    2 ++
 5 files changed, 20 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -310,6 +310,11 @@ thp_fault_fallback
 	is incremented if a page fault fails to allocate
 	a huge page and instead falls back to using small pages.
 
+thp_fault_fallback_charge
+	is incremented if a page fault fails to charge a huge page and
+	instead falls back to using small pages even though the
+	allocation was successful.
+
 thp_collapse_alloc_failed
 	is incremented if khugepaged found a range
 	of pages that should be collapsed into one huge page but failed
@@ -323,6 +328,11 @@ thp_file_fallback
 	is incremented if a file huge page is attempted to be allocated
 	but fails and instead falls back to using small pages.
 
+thp_file_fallback_charge
+	is incremented if a file huge page cannot be charged and instead
+	falls back to using small pages even though the allocation was
+	successful.
+
 thp_file_mapped
 	is incremented every time a file huge page is mapped into
 	user address space.
--- a/include/linux/vm_event_item.h~mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately
+++ a/include/linux/vm_event_item.h
@@ -73,10 +73,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		THP_FAULT_ALLOC,
 		THP_FAULT_FALLBACK,
+		THP_FAULT_FALLBACK_CHARGE,
 		THP_COLLAPSE_ALLOC,
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_FILE_ALLOC,
 		THP_FILE_FALLBACK,
+		THP_FILE_FALLBACK_CHARGE,
 		THP_FILE_MAPPED,
 		THP_SPLIT_PAGE,
 		THP_SPLIT_PAGE_FAILED,
@@ -117,6 +119,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 #define THP_FILE_ALLOC ({ BUILD_BUG(); 0; })
 #define THP_FILE_FALLBACK ({ BUILD_BUG(); 0; })
+#define THP_FILE_FALLBACK_CHARGE ({ BUILD_BUG(); 0; })
 #define THP_FILE_MAPPED ({ BUILD_BUG(); 0; })
 #endif
 
--- a/mm/huge_memory.c~mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately
+++ a/mm/huge_memory.c
@@ -597,6 +597,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, gfp, &memcg, true)) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
+		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
 		return VM_FAULT_FALLBACK;
 	}
 
@@ -1420,6 +1421,7 @@ alloc:
 			put_page(page);
 		ret |= VM_FAULT_FALLBACK;
 		count_vm_event(THP_FAULT_FALLBACK);
+		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
 		goto out;
 	}
 
--- a/mm/shmem.c~mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately
+++ a/mm/shmem.c
@@ -1871,8 +1871,10 @@ alloc_nohuge:
 	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg,
 					    PageTransHuge(page));
 	if (error) {
-		if (PageTransHuge(page))
+		if (PageTransHuge(page)) {
 			count_vm_event(THP_FILE_FALLBACK);
+			count_vm_event(THP_FILE_FALLBACK_CHARGE);
+		}
 		goto unacct;
 	}
 	error = shmem_add_to_page_cache(page, mapping, hindex,
--- a/mm/vmstat.c~mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately
+++ a/mm/vmstat.c
@@ -1256,10 +1256,12 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	"thp_fault_alloc",
 	"thp_fault_fallback",
+	"thp_fault_fallback_charge",
 	"thp_collapse_alloc",
 	"thp_collapse_alloc_failed",
 	"thp_file_alloc",
 	"thp_file_fallback",
+	"thp_file_fallback_charge",
 	"thp_file_mapped",
 	"thp_split_page",
 	"thp_split_page_failed",
_

Patches currently in -mm which might be from rientjes@google.com are

mm-shmem-add-vmstat-for-hugepage-fallback.patch
mm-thp-track-fallbacks-due-to-failed-memcg-charges-separately.patch
