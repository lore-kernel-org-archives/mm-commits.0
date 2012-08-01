From: akpm@linux-foundation.org
Subject: [merged] netvm-propagate-page-pfmemalloc-to-skb.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:12 -0700
Message-ID: <20120801201613.3F1C420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62405 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2HAUQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:15 -0400
Received: by mail-ey0-f202.google.com with SMTP id o12so293269eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: netvm: propagate page->pfmemalloc to skb
has been removed from the -mm tree.  Its filename was
     netvm-propagate-page-pfmemalloc-to-skb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: netvm: propagate page->pfmemalloc to skb

The skb->pfmemalloc flag gets set to true iff during the slab allocation
of data in __alloc_skb that the the PFMEMALLOC reserves were used.  If the
packet is fragmented, it is possible that pages will be allocated from the
PFMEMALLOC reserve without propagating this information to the skb.  This
patch propagates page->pfmemalloc from pages allocated for fragments to
the skb.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/skbuff.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/skbuff.h~netvm-propagate-page-pfmemalloc-to-skb include/linux/skbuff.h
--- a/include/linux/skbuff.h~netvm-propagate-page-pfmemalloc-to-skb
+++ a/include/linux/skbuff.h
@@ -1247,6 +1247,17 @@ static inline void __skb_fill_page_desc(
 {
 	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
+	/*
+	 * Propagate page->pfmemalloc to the skb if we can. The problem is
+	 * that not all callers have unique ownership of the page. If
+	 * pfmemalloc is set, we check the mapping as a mapping implies
+	 * page->index is set (index and pfmemalloc share space).
+	 * If it's a valid mapping, we cannot use page->pfmemalloc but we
+	 * do not lose pfmemalloc information as the pages would not be
+	 * allocated using __GFP_MEMALLOC.
+	 */
+	if (page->pfmemalloc && !page->mapping)
+		skb->pfmemalloc	= true;
 	frag->page.p		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

