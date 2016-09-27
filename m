From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-use-nodes-that-contain-memory-as-mask-in-new_node_page.patch
 added to -mm tree
Date: Tue, 27 Sep 2016 15:07:09 -0700
Message-ID: <57eaed8d.jsvNqvcRh8NfPZzb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47299 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752586AbcI0WHK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 18:07:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhong@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, jallen@linux.vnet.ibm.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, penguin-kernel@i-love.sakura.ne.jp, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: use nodes that contain memory as mask in new_node_page()
has been added to the -mm tree.  Its filename is
     mem-hotplug-use-nodes-that-contain-memory-as-mask-in-new_node_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-use-nodes-that-contain-memory-as-mask-in-new_node_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-use-nodes-that-contain-memory-as-mask-in-new_node_page.patch

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
Subject: mem-hotplug: use nodes that contain memory as mask in new_node_page()

9bb627be47a5 ("mem-hotplug: don't clear the only node in new_node_page()")
prevents allocating from an empty nodemask, but as David points out, it is
still wrong.  As node_online_map may include memoryless nodes, only
allocating from these nodes is meaningless.

This patch uses node_states[N_MEMORY] mask to prevent the above case.

Fixes: 9bb627be47a5 ("mem-hotplug: don't clear the only node in new_node_page()")
Fixes: 394e31d2ceb4 ("mem-hotplug: alloc new page from a nearest neighbor node when mem-offline")
Link: http://lkml.kernel.org/r/1474447117.28370.6.camel@TP420
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memory_hotplug.c~mem-hotplug-use-nodes-that-contain-memory-as-mask-in-new_node_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-use-nodes-that-contain-memory-as-mask-in-new_node_page
+++ a/mm/memory_hotplug.c
@@ -1555,8 +1555,8 @@ static struct page *new_node_page(struct
 {
 	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 	int nid = page_to_nid(page);
-	nodemask_t nmask = node_online_map;
-	struct page *new_page;
+	nodemask_t nmask = node_states[N_MEMORY];
+	struct page *new_page = NULL;
 
 	/*
 	 * TODO: allocate a destination hugepage from a nearest neighbor node,
@@ -1567,14 +1567,14 @@ static struct page *new_node_page(struct
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					next_node_in(nid, nmask));
 
-	if (nid != next_node_in(nid, nmask))
-		node_clear(nid, nmask);
+	node_clear(nid, nmask);
 
 	if (PageHighMem(page)
 	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
 
-	new_page = __alloc_pages_nodemask(gfp_mask, 0,
+	if (!nodes_empty(nmask))
+		new_page = __alloc_pages_nodemask(gfp_mask, 0,
 					node_zonelist(nid, gfp_mask), &nmask);
 	if (!new_page)
 		new_page = __alloc_pages(gfp_mask, 0,
_

Patches currently in -mm which might be from zhong@linux.vnet.ibm.com are

mem-hotplug-use-nodes-that-contain-memory-as-mask-in-new_node_page.patch

