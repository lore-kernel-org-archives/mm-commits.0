From: akpm@linux-foundation.org
Subject: [patch 01/20] mem-hotplug: don't clear the only node in
 new_node_page()
Date: Mon, 19 Sep 2016 14:43:52 -0700
Message-ID: <57e05c18.ws10JDxbNC9guuiS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52781 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbcISVnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 17:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhong@linux.vnet.ibm.com, jallen@linux.vnet.ibm.com, qiuxishi@huawei.com, vbabka@suse.cz

From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: mem-hotplug: don't clear the only node in new_node_page()

394e31d2c ("mem-hotplug: alloc new page from a nearest neighbor node when
mem-offline") introduced new_node_page() for memory hotplug.

In new_node_page(), the nid is cleared before calling
__alloc_pages_nodemask().  But if it is the only node of the system, and
the first round allocation fails, it will not be able to get memory from
an empty nodemask, and will trigger oom.

The patch checks whether it is the last node on the system, and if it is, then
don't clear the nid in the nodemask.

Fixes: 394e31d2ceb4 ("mem-hotplug: alloc new page from a nearest neighbor node when mem-offline")
Link: http://lkml.kernel.org/r/1473044391.4250.19.camel@TP420
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Reported-by: John Allen <jallen@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mem-hotplug-dont-clear-the-only-node-in-new_node_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-dont-clear-the-only-node-in-new_node_page
+++ a/mm/memory_hotplug.c
@@ -1567,7 +1567,9 @@ static struct page *new_node_page(struct
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					next_node_in(nid, nmask));
 
-	node_clear(nid, nmask);
+	if (nid != next_node_in(nid, nmask))
+		node_clear(nid, nmask);
+
 	if (PageHighMem(page)
 	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
_
