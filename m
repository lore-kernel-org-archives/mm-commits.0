From: akpm@linux-foundation.org
Subject: [patch 086/108] mm, page_alloc: fix more premature OOM due
 to race with cpuset update
Date: Thu, 06 Jul 2017 15:39:56 -0700
Message-ID: <20170706223956.BFwJnnqrP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752649AbdGFWj6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, cl@linux.com, hughd@google.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, lizefan@huawei.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, sivanich@sgi.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: fix more premature OOM due to race with cpuset update

I would like to stress that this patchset aims to fix issues and cleanup
the code *within the existing documented semantics*, i.e.  patch 1 ignores
mempolicy restrictions if the set of allowed nodes has no intersection
with set of nodes allowed by cpuset.  I believe discussing potential
changes of the semantics can be better done once we have a baseline with
no known bugs of the current semantics.



I've recently summarized the cpuset/mempolicy issues in a LSF/MM proposal [1]
and the discussion itself [2]. I've been trying to rewrite the handling as
proposed, with the idea that changing semantics to make all mempolicies static
wrt cpuset updates (and discarding the relative and default modes) can be tried
on top, as there's a high risk of being rejected/reverted because somebody
might still care about the removed modes.

However I haven't yet figured out how to properly:

1) make mempolicies swappable instead of rebinding in place.  I thought
   mbind() already works that way and uses refcounting to avoid
   use-after-free of the old policy by a parallel allocation, but turns
   out true refcounting is only done for shared (shmem) mempolicies, and
   the actual protection for mbind() comes from mmap_sem.  Extending the
   refcounting means more overhead in allocator hot path.  Also swapping
   whole mempolicies means that we have to allocate the new ones, which
   can fail, and reverting of the partially done work also means
   allocating (note that mbind() doesn't care and will just leave part of
   the range updated and part not updated when returning -ENOMEM...).

2) make cpuset's task->mems_allowed also swappable (after converting it
   from nodemask to zonelist, which is the easy part) for mostly the same
   reasons.

The good news is that while trying to do the above, I've at least figured
out how to hopefully close the remaining premature OOM's, and do a buch of
cleanups on top, removing quite some of the code that was also supposed to
prevent the cpuset update races, but doesn't work anymore nowadays.  This
should fix the most pressing concerns with this topic and give us a better
baseline before either proceeding with the original proposal, or pushing a
change of semantics that removes the problem 1) above.  I'd be then fine
with trying to change the semantic first and rewrite later.

Patchset has been tested with the LTP cpuset01 stress test.

[1] https://lkml.kernel.org/r/4c44a589-5fd8-08d0-892c-e893bb525b71@suse.cz
[2] https://lwn.net/Articles/717797/
[3] https://marc.info/?l=linux-mm&m=149191957922828&w=2



This patch (of 6):

Commit e47483bca2cc ("mm, page_alloc: fix premature OOM when racing with
cpuset mems update") has fixed known recent regressions found by LTP's
cpuset01 testcase.  I have however found that by modifying the testcase to
use per-vma mempolicies via bind(2) instead of per-task mempolicies via
set_mempolicy(2), the premature OOM still happens and the issue is much
older.

The root of the problem is that the cpuset's mems_allowed and mempolicy's
nodemask can temporarily have no intersection, thus
get_page_from_freelist() cannot find any usable zone.  The current
semantic for empty intersection is to ignore mempolicy's nodemask and
honour cpuset restrictions.  This is checked in node_zonelist(), but the
racy update can happen after we already passed the check.  Such races
should be protected by the seqlock task->mems_allowed_seq, but it doesn't
work here, because 1) mpol_rebind_mm() does not happen under seqlock for
write, and doing so would lead to deadlock, as it takes mmap_sem for
write, while the allocation can have mmap_sem for read when it's taking
the seqlock for read.  And 2) the seqlock cookie of callers of
node_zonelist() (alloc_pages_vma() and alloc_pages_current()) is different
than the one of __alloc_pages_slowpath(), so there's still a potential
race window.

This patch fixes the issue by having __alloc_pages_slowpath() check for
empty intersection of cpuset and ac->nodemask before OOM or allocation
failure.  If it's indeed empty, the nodemask is ignored and allocation
retried, which mimics node_zonelist().  This works fine, because almost
all callers of __alloc_pages_nodemask are obtaining the nodemask via
node_zonelist().  The only exception is new_node_page() from hotplug,
where the potential violation of nodemask isn't an issue, as there's
already a fallback allocation attempt without any nodemask.  If there's a
future caller that needs to have its specific nodemask honoured over
task's cpuset restrictions, we'll have to e.g.  add a gfp flag for that.

Link: http://lkml.kernel.org/r/20170517081140.30654-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   51 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-more-premature-oom-due-to-race-with-cpuset-update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-more-premature-oom-due-to-race-with-cpuset-update
+++ a/mm/page_alloc.c
@@ -3677,6 +3677,39 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	return false;
 }
 
+static inline bool
+check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
+{
+	/*
+	 * It's possible that cpuset's mems_allowed and the nodemask from
+	 * mempolicy don't intersect. This should be normally dealt with by
+	 * policy_nodemask(), but it's possible to race with cpuset update in
+	 * such a way the check therein was true, and then it became false
+	 * before we got our cpuset_mems_cookie here.
+	 * This assumes that for all allocations, ac->nodemask can come only
+	 * from MPOL_BIND mempolicy (whose documented semantics is to be ignored
+	 * when it does not intersect with the cpuset restrictions) or the
+	 * caller can deal with a violated nodemask.
+	 */
+	if (cpusets_enabled() && ac->nodemask &&
+			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
+		ac->nodemask = NULL;
+		return true;
+	}
+
+	/*
+	 * When updating a task's mems_allowed or mempolicy nodemask, it is
+	 * possible to race with parallel threads in such a way that our
+	 * allocation can fail while the mask is being updated. If we are about
+	 * to fail, check if the cpuset changed during allocation and if so,
+	 * retry.
+	 */
+	if (read_mems_allowed_retry(cpuset_mems_cookie))
+		return true;
+
+	return false;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -3872,11 +3905,9 @@ retry:
 				&compaction_retries))
 		goto retry;
 
-	/*
-	 * It's possible we raced with cpuset update so the OOM would be
-	 * premature (see below the nopage: label for full explanation).
-	 */
-	if (read_mems_allowed_retry(cpuset_mems_cookie))
+
+	/* Deal with possible cpuset update races before we start OOM killing */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac))
 		goto retry_cpuset;
 
 	/* Reclaim has failed us, start killing things */
@@ -3897,14 +3928,8 @@ retry:
 	}
 
 nopage:
-	/*
-	 * When updating a task's mems_allowed or mempolicy nodemask, it is
-	 * possible to race with parallel threads in such a way that our
-	 * allocation can fail while the mask is being updated. If we are about
-	 * to fail, check if the cpuset changed during allocation and if so,
-	 * retry.
-	 */
-	if (read_mems_allowed_retry(cpuset_mems_cookie))
+	/* Deal with possible cpuset update races before we fail */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac))
 		goto retry_cpuset;
 
 	/*
_
