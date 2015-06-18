From: akpm@linux-foundation.org
Subject: + mm-thp-respect-mpol_preferred-policy-with-non-local-node.patch
 added to -mm tree
Date: Thu, 18 Jun 2015 11:30:11 -0700
Message-ID: <55830e33.t2yt2C1pAKqrZu2w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbbFRSaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jun 2015 14:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: respect MPOL_PREFERRED policy with non-local node
has been added to the -mm tree.  Its filename is
     mm-thp-respect-mpol_preferred-policy-with-non-local-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-respect-mpol_preferred-policy-with-non-local-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-respect-mpol_preferred-policy-with-non-local-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, thp: respect MPOL_PREFERRED policy with non-local node

Since commit 077fcf116c8c ("mm/thp: allocate transparent hugepages on
local node"), we handle THP allocations on page fault in a special way -
for non-interleave memory policies, the allocation is only attempted on
the node local to the current CPU, if the policy's nodemask allows the
node.

This is motivated by the assumption that THP benefits cannot offset the
cost of remote accesses, so it's better to fallback to base pages on the
local node (which might still be available, while huge pages are not due
to fragmentation) than to allocate huge pages on a remote node.

The nodemask check prevents us from violating e.g.  MPOL_BIND policies
where the local node is not among the allowed nodes.  However, the current
implementation can still give surprising results for the MPOL_PREFERRED
policy when the preferred node is different than the current CPU's local
node.

In such case we should honor the preferred node and not use the local
node, which is what this patch does.  If hugepage allocation on the
preferred node fails, we fall back to base pages and don't try other
nodes, with the same motivation as is done for the local node hugepage
allocations.  The patch also moves the MPOL_INTERLEAVE check around to
simplify the hugepage specific test.

The difference can be demonstrated using in-tree transhuge-stress test on
the following 2-node machine where half memory on one node was occupied to
show the difference.

> numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 24 25 26 27 28 29 30 31 32 33 34 35
node 0 size: 7878 MB
node 0 free: 3623 MB
node 1 cpus: 12 13 14 15 16 17 18 19 20 21 22 23 36 37 38 39 40 41 42 43 44 45 46 47
node 1 size: 8045 MB
node 1 free: 7818 MB
node distances:
node   0   1
  0:  10  21
  1:  21  10

Before the patch:
> numactl -p0 -C0 ./transhuge-stress
transhuge-stress: 2.197 s/loop, 0.276 ms/page,   7249.168 MiB/s 7962 succeed,    0 failed, 1786 different pages

> numactl -p0 -C12 ./transhuge-stress
transhuge-stress: 2.962 s/loop, 0.372 ms/page,   5376.172 MiB/s 7962 succeed,    0 failed, 3873 different pages

Number of successful THP allocations corresponds to free memory on node 0 in
the first case and node 1 in the second case, i.e. -p parameter is ignored and
cpu binding "wins".

After the patch:
> numactl -p0 -C0 ./transhuge-stress
transhuge-stress: 2.183 s/loop, 0.274 ms/page,   7295.516 MiB/s 7962 succeed,    0 failed, 1760 different pages

> numactl -p0 -C12 ./transhuge-stress
transhuge-stress: 2.878 s/loop, 0.361 ms/page,   5533.638 MiB/s 7962 succeed,    0 failed, 1750 different pages

> numactl -p1 -C0 ./transhuge-stress
transhuge-stress: 4.628 s/loop, 0.581 ms/page,   3440.893 MiB/s 7962 succeed,    0 failed, 3918 different pages

The -p parameter is respected regardless of cpu binding.

> numactl -C0 ./transhuge-stress
transhuge-stress: 2.202 s/loop, 0.277 ms/page,   7230.003 MiB/s 7962 succeed,    0 failed, 1750 different pages

> numactl -C12 ./transhuge-stress
transhuge-stress: 3.020 s/loop, 0.379 ms/page,   5273.324 MiB/s 7962 succeed,    0 failed, 3916 different pages

Without -p parameter, hugepage restriction to CPU-local node works as before.

Fixes: 077fcf116c8c ("mm/thp: allocate transparent hugepages on local node")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff -puN mm/mempolicy.c~mm-thp-respect-mpol_preferred-policy-with-non-local-node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-respect-mpol_preferred-policy-with-non-local-node
+++ a/mm/mempolicy.c
@@ -1972,35 +1972,41 @@ retry_cpuset:
 	pol = get_vma_policy(vma, addr);
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
-	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage &&
-					pol->mode != MPOL_INTERLEAVE)) {
+	if (pol->mode == MPOL_INTERLEAVE) {
+		unsigned nid;
+
+		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
+		mpol_cond_put(pol);
+		page = alloc_page_interleave(gfp, order, nid);
+		goto out;
+	}
+
+	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
+		int hpage_node = node;
+
 		/*
 		 * For hugepage allocation and non-interleave policy which
-		 * allows the current node, we only try to allocate from the
-		 * current node and don't fall back to other nodes, as the
-		 * cost of remote accesses would likely offset THP benefits.
+		 * allows the current node (or other explicitly preferred
+		 * node) we only try to allocate from the current/preferred
+		 * node and don't fall back to other nodes, as the cost of
+		 * remote accesses would likely offset THP benefits.
 		 *
 		 * If the policy is interleave, or does not allow the current
 		 * node in its nodemask, we allocate the standard way.
 		 */
+		if (pol->mode == MPOL_PREFERRED &&
+						!(pol->flags & MPOL_F_LOCAL))
+			hpage_node = pol->v.preferred_node;
+
 		nmask = policy_nodemask(gfp, pol);
-		if (!nmask || node_isset(node, *nmask)) {
+		if (!nmask || node_isset(hpage_node, *nmask)) {
 			mpol_cond_put(pol);
-			page = alloc_pages_exact_node(node,
+			page = alloc_pages_exact_node(hpage_node,
 						gfp | __GFP_THISNODE, order);
 			goto out;
 		}
 	}
 
-	if (pol->mode == MPOL_INTERLEAVE) {
-		unsigned nid;
-
-		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
-		mpol_cond_put(pol);
-		page = alloc_page_interleave(gfp, order, nid);
-		goto out;
-	}
-
 	nmask = policy_nodemask(gfp, pol);
 	zl = policy_zonelist(gfp, pol, node);
 	mpol_cond_put(pol);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
mm-thp-respect-mpol_preferred-policy-with-non-local-node.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
linux-next.patch
mm-provide-new-get_vaddr_frames-helper.patch
media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns.patch
vb2-provide-helpers-for-mapping-virtual-addresses.patch
media-vb2-convert-vb2_dma_sg_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_dc_get_userptr-to-use-frame-vector.patch
media-vb2-remove-unused-functions.patch
drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch

