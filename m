Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43E5C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F8E61493
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhD3F6a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3F6a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2791961481;
        Fri, 30 Apr 2021 05:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762262;
        bh=CVygRMJMVjbtBB9iV5JsCBarACgAEvSl7vSpKN/RK0s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mD+p13TQrkRzXGtLEgtmC2+121MQReoVmaVbeEWo6bKB5KfUrDjZ6l2cwx+Vpuprt
         hSei9jNk6P/ye9mqmvGryJ9Fbvi8a3HlXPuLI6zmuKklJQDOJ37P0u7lNWGfGUUTQE
         V5ipOXgQU2I82b+YAIYORl3kYVxHiNpVlNCaz0Js=
Date:   Thu, 29 Apr 2021 22:57:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arjunroy@google.com, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mgorman@suse.de, mm-commits@vger.kernel.org, peterx@redhat.com,
        peterz@infradead.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, will@kernel.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 088/178] NUMA balancing: reduce TLB flush via
 delaying mapping on hint page fault
Message-ID: <20210430055741.u1pjk2j5l%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: NUMA balancing: reduce TLB flush via delaying mapping on hint page fault

With NUMA balancing, in hint page fault handler, the faulting page will be
migrated to the accessing node if necessary.  During the migration, TLB
will be shot down on all CPUs that the process has run on recently. 
Because in the hint page fault handler, the PTE will be made accessible
before the migration is tried.  The overhead of TLB shooting down can be
high, so it's better to be avoided if possible.  In fact, if we delay
mapping the page until migration, that can be avoided.  This is what this
patch doing.

For the multiple threads applications, it's possible that a page is
accessed by multiple threads almost at the same time.  In the original
implementation, because the first thread will install the accessible PTE
before migrating the page, the other threads may access the page directly
before the page is made inaccessible again during migration.  While with
the patch, the second thread will go through the page fault handler too. 
And because of the PageLRU() checking in the following code path,

  migrate_misplaced_page()
    numamigrate_isolate_page()
      isolate_lru_page()

the migrate_misplaced_page() will return 0, and the PTE will be made
accessible in the second thread.

This will introduce a little more overhead.  But we think the possibility
for a page to be accessed by the multiple threads at the same time is low,
and the overhead difference isn't too large.  If this becomes a problem in
some workloads, we need to consider how to reduce the overhead.

To test the patch, we run a test case as follows on a 2-socket Intel
server (1 NUMA node per socket) with 128GB DRAM (64GB per socket).

1. Run a memory eater on NUMA node 1 to use 40GB memory before running
   pmbench.

2. Run pmbench (normal accessing pattern) with 8 processes, and 8
   threads per process, so there are 64 threads in total.  The
   working-set size of each process is 8960MB, so the total working-set
   size is 8 * 8960MB = 70GB.  The CPU of all pmbench processes is bound
   to node 1.  The pmbench processes will access some DRAM on node 0.

3. After the pmbench processes run for 10 seconds, kill the memory
   eater.  Now, some pages will be migrated from node 0 to node 1 via
   NUMA balancing.

Test results show that, with the patch, the pmbench throughput (page
accesses/s) increases 5.5%.  The number of the TLB shootdowns interrupts
reduces 98% (from ~4.7e7 to ~9.7e5) with about 9.2e6 pages (35.8GB)
migrated.  From the perf profile, it can be found that the CPU cycles
spent by try_to_unmap() and its callees reduces from 6.02% to 0.47%.  That
is, the CPU cycles spent by TLB shooting down decreases greatly.

Link: https://lkml.kernel.org/r/20210408132236.1175607-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Matthew Wilcox" <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   54 +++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

--- a/mm/memory.c~numa-balancing-reduce-tlb-flush-via-delaying-mapping-on-hint-page-fault
+++ a/mm/memory.c
@@ -4125,29 +4125,17 @@ static vm_fault_t do_numa_page(struct vm
 		goto out;
 	}
 
-	/*
-	 * Make it present again, Depending on how arch implementes non
-	 * accessible ptes, some can allow access by kernel mode.
-	 */
-	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
+	/* Get the normal PTE  */
+	old_pte = ptep_get(vmf->pte);
 	pte = pte_modify(old_pte, vma->vm_page_prot);
-	pte = pte_mkyoung(pte);
-	if (was_writable)
-		pte = pte_mkwrite(pte);
-	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
-	update_mmu_cache(vma, vmf->address, vmf->pte);
 
 	page = vm_normal_page(vma, vmf->address, pte);
-	if (!page) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
-	}
+	if (!page)
+		goto out_map;
 
 	/* TODO: handle PTE-mapped THP */
-	if (PageCompound(page)) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
-	}
+	if (PageCompound(page))
+		goto out_map;
 
 	/*
 	 * Avoid grouping on RO pages in general. RO pages shouldn't hurt as
@@ -4157,7 +4145,7 @@ static vm_fault_t do_numa_page(struct vm
 	 * pte_dirty has unpredictable behaviour between PTE scan updates,
 	 * background writeback, dirty balancing and application behaviour.
 	 */
-	if (!pte_write(pte))
+	if (!was_writable)
 		flags |= TNF_NO_GROUP;
 
 	/*
@@ -4171,23 +4159,45 @@ static vm_fault_t do_numa_page(struct vm
 	page_nid = page_to_nid(page);
 	target_nid = numa_migrate_prep(page, vma, vmf->address, page_nid,
 			&flags);
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (target_nid == NUMA_NO_NODE) {
 		put_page(page);
-		goto out;
+		goto out_map;
 	}
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
 	/* Migrate to the requested node */
 	if (migrate_misplaced_page(page, vma, target_nid)) {
 		page_nid = target_nid;
 		flags |= TNF_MIGRATED;
-	} else
+	} else {
 		flags |= TNF_MIGRATE_FAIL;
+		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
+		spin_lock(vmf->ptl);
+		if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte))) {
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
+			goto out;
+		}
+		goto out_map;
+	}
 
 out:
 	if (page_nid != NUMA_NO_NODE)
 		task_numa_fault(last_cpupid, page_nid, 1, flags);
 	return 0;
+out_map:
+	/*
+	 * Make it present again, depending on how arch implements
+	 * non-accessible ptes, some can allow access by kernel mode.
+	 */
+	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
+	pte = pte_modify(old_pte, vma->vm_page_prot);
+	pte = pte_mkyoung(pte);
+	if (was_writable)
+		pte = pte_mkwrite(pte);
+	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
+	update_mmu_cache(vma, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	goto out;
 }
 
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
_
