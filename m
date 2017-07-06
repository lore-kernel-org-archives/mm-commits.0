From: akpm@linux-foundation.org
Subject: [patch 091/108] mm, mempolicy: don't check cpuset seqlock
 where it doesn't matter
Date: Thu, 06 Jul 2017 15:40:13 -0700
Message-ID: <20170706224013.7BynLSmLR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36976 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdGFWkO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, cl@linux.com, hughd@google.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, lizefan@huawei.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, sivanich@sgi.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, mempolicy: don't check cpuset seqlock where it doesn't matter

Two wrappers of __alloc_pages_nodemask() are checking
task->mems_allowed_seq themselves to retry allocation that has raced with
a cpuset update.  This has been shown to be ineffective in preventing
premature OOM's which can happen in __alloc_pages_slowpath() long before
it returns back to the wrappers to detect the race at that level. 
Previous patches have made __alloc_pages_slowpath() more robust, so we can
now simply remove the seqlock checking in the wrappers to prevent further
wrong impression that it can actually help.

Link: http://lkml.kernel.org/r/20170517081140.30654-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-dont-check-cpuset-seqlock-where-it-doesnt-matter mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-dont-check-cpuset-seqlock-where-it-doesnt-matter
+++ a/mm/mempolicy.c
@@ -1898,12 +1898,9 @@ alloc_pages_vma(gfp_t gfp, int order, st
 	struct mempolicy *pol;
 	struct page *page;
 	int preferred_nid;
-	unsigned int cpuset_mems_cookie;
 	nodemask_t *nmask;
 
-retry_cpuset:
 	pol = get_vma_policy(vma, addr);
-	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (pol->mode == MPOL_INTERLEAVE) {
 		unsigned nid;
@@ -1945,8 +1942,6 @@ retry_cpuset:
 	page = __alloc_pages_nodemask(gfp, order, preferred_nid, nmask);
 	mpol_cond_put(pol);
 out:
-	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
-		goto retry_cpuset;
 	return page;
 }
 
@@ -1964,23 +1959,15 @@ out:
  *	Allocate a page from the kernel page pool.  When not in
  *	interrupt context and apply the current process NUMA policy.
  *	Returns NULL when no page can be allocated.
- *
- *	Don't call cpuset_update_task_memory_state() unless
- *	1) it's ok to take cpuset_sem (can WAIT), and
- *	2) allocating for current task (not interrupt).
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
 	struct page *page;
-	unsigned int cpuset_mems_cookie;
 
 	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
 		pol = get_task_policy(current);
 
-retry_cpuset:
-	cpuset_mems_cookie = read_mems_allowed_begin();
-
 	/*
 	 * No reference counting needed for current->mempolicy
 	 * nor system default_policy
@@ -1992,9 +1979,6 @@ retry_cpuset:
 				policy_node(gfp, pol, numa_node_id()),
 				policy_nodemask(gfp, pol));
 
-	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
-		goto retry_cpuset;
