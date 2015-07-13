From: akpm@linux-foundation.org
Subject: +
 mm-page-refine-the-calculation-of-highest-possible-node-id.patch added to
 -mm tree
Date: Mon, 13 Jul 2015 14:37:16 -0700
Message-ID: <55a42f8c.Q8qfYn3YfVRx98F8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbGMVhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, akpm@linux-foundation.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: refine the calculation of highest possible node id
has been added to the -mm tree.  Its filename is
     mm-page-refine-the-calculation-of-highest-possible-node-id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-refine-the-calculation-of-highest-possible-node-id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-refine-the-calculation-of-highest-possible-node-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: refine the calculation of highest possible node id

nr_node_ids records the highest possible node id, which is calculated by
scanning the bitmap node_states[N_POSSIBLE].  Current implementation scan
the bitmap from the beginning, which will scan the whole bitmap.

This patch reverses the order by scanning from the end with
find_last_bit().

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page-refine-the-calculation-of-highest-possible-node-id mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-refine-the-calculation-of-highest-possible-node-id
+++ a/mm/page_alloc.c
@@ -5448,11 +5448,9 @@ void __paginginit free_area_init_node(in
  */
 void __init setup_nr_node_ids(void)
 {
-	unsigned int node;
-	unsigned int highest = 0;
+	unsigned int highest;
 
-	for_each_node_mask(node, node_possible_map)
-		highest = node;
+	highest = find_last_bit(node_possible_map.bits, MAX_NUMNODES);
 	nr_node_ids = highest + 1;
 }
 #endif
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

mm-memblock-warn_on-when-nid-differs-from-overlap-region.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch

