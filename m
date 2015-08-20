From: akpm@linux-foundation.org
Subject: + mm-use-numa_mem_id-in-alloc_pages_node.patch added to -mm tree
Date: Thu, 20 Aug 2015 15:30:52 -0700
Message-ID: <55d6551c.Fu24tXfYjWb1Fixb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbbHTWax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Aug 2015 18:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use numa_mem_id() in alloc_pages_node()
has been added to the -mm tree.  Its filename is
     mm-use-numa_mem_id-in-alloc_pages_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-numa_mem_id-in-alloc_pages_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-numa_mem_id-in-alloc_pages_node.patch

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
Subject: mm: use numa_mem_id() in alloc_pages_node()

alloc_pages_node() might fail when called with NUMA_NO_NODE and
__GFP_THISNODE on a CPU belonging to a memoryless node.  To make the
local-node fallback more robust and prevent such situations, use
numa_mem_id(), which was introduced for similar scenarios in the slab
context.

Suggested-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-use-numa_mem_id-in-alloc_pages_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-use-numa_mem_id-in-alloc_pages_node
+++ a/include/linux/gfp.h
@@ -318,13 +318,14 @@ __alloc_pages_node(int nid, gfp_t gfp_ma
 
 /*
  * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
- * prefer the current CPU's node. Otherwise node must be valid and online.
+ * prefer the current CPU's closest node. Otherwise node must be valid and
+ * online.
  */
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
 	if (nid == NUMA_NO_NODE)
-		nid = numa_node_id();
+		nid = numa_mem_id();
 
 	return __alloc_pages_node(nid, gfp_mask, order);
 }
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

