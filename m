From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch removed from
 -mm tree
Date: Wed, 11 Feb 2015 15:17:16 -0800
Message-ID: <54dbe2fc.QJPQJJPTv0PVxuiz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbBKXRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-allocate-transparent-hugepages-on-local-node-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch

This patch was dropped because it was folded into mm-thp-allocate-transparent-hugepages-on-local-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-allocate-transparent-hugepages-on-local-node-fix

fix comment, add CONFIG_TRANSPARENT_HUGEPAGE dependency

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node-fix
+++ a/mm/mempolicy.c
@@ -2030,6 +2030,7 @@ retry_cpuset:
 	return page;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /**
  * alloc_hugepage_vma: Allocate a hugepage for a VMA
  * @gfp:
@@ -2057,7 +2058,7 @@ retry_cpuset:
  * all allocations for pages that will be mapped into
  * user space. Returns NULL when no page can be allocated.
  *
- * Should be called with the mm_sem of the vma hold.
+ * Should be called with vma->vm_mm->mmap_sem held.
  *
  */
 struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
@@ -2099,6 +2100,7 @@ alloc_with_fallback:
 	 */
 	return alloc_pages_vma(gfp, order, vma, addr, node);
 }
+#endif
 
 /**
  * 	alloc_pages_current - Allocate pages.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

