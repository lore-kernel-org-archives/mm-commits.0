From: akpm@linux-foundation.org
Subject: + mem-hotplug-dont-clear-the-only-node-in-new_node_page.patch
 added to -mm tree
Date: Tue, 06 Sep 2016 13:38:02 -0700
Message-ID: <57cf292a.zBot/pgYKZBA0Fh3%akpm__17705.9956281029$1473194292$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59725 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933688AbcIFUiD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2016 16:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhong@linux.vnet.ibm.com, jallen@linux.vnet.ibm.com, qiuxishi@huawei.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: Don't clear the only node in new_node_page()
has been added to the -mm tree.  Its filename is
     mem-hotplug-dont-clear-the-only-node-in-new_node_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-dont-clear-the-only-node-in-new_node_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-dont-clear-the-only-node-in-new_node_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: mem-hotplug: Don't clear the only node in new_node_page()

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
Cc: <stable@vger.kernel.org>	[4.7.x]
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

Patches currently in -mm which might be from zhong@linux.vnet.ibm.com are

mem-hotplug-dont-clear-the-only-node-in-new_node_page.patch

