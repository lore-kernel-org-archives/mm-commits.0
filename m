From: akpm@linux-foundation.org
Subject: +
 mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch added to
 -mm tree
Date: Thu, 20 Aug 2015 15:30:50 -0700
Message-ID: <55d6551a.7oerSj/bSGBN+lyL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbHTWav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Aug 2015 18:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unify checks in alloc_pages_node() and __alloc_pages_node()
has been added to the -mm tree.  Its filename is
     mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch

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
Subject: mm: unify checks in alloc_pages_node() and __alloc_pages_node()

Perform the same debug checks in alloc_pages_node() as are done in
__alloc_pages_node(), by making the former function a wrapper of the
latter one.

In addition to better diagnostics in DEBUG_VM builds for situations which
have been already fatal (e.g.  out-of-bounds node id), there are two
visible changes for potential existing buggy callers of
alloc_pages_node():

- calling alloc_pages_node() with any negative nid (e.g. due to arithmetic
  overflow) was treated as passing NUMA_NO_NODE and fallback to local node was
  applied. This will now be fatal.
- calling alloc_pages_node() with an offline node will now be checked for
  DEBUG_VM builds. Since it's not fatal if the node has been previously online,
  and this patch may expose some existing buggy callers, change the VM_BUG_ON
  in __alloc_pages_node() to VM_WARN_ON.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node
+++ a/include/linux/gfp.h
@@ -310,23 +310,23 @@ __alloc_pages(gfp_t gfp_mask, unsigned i
 static inline struct page *
 __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES || !node_online(nid));
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	VM_WARN_ON(!node_online(nid));
 
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
 /*
  * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
- * prefer the current CPU's node.
+ * prefer the current CPU's node. Otherwise node must be valid and online.
  */
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	/* Unknown node is current node */
-	if (nid < 0)
+	if (nid == NUMA_NO_NODE)
 		nid = numa_node_id();
 
-	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
+	return __alloc_pages_node(nid, gfp_mask, order);
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-rename-and-move-get-set_freepage_migratetype-v2.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch
mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch
mm-use-numa_mem_id-in-alloc_pages_node.patch

