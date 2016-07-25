From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-alloc-new-page-from-a-nearest-neighbor-node-when-mem-offline.patch added to -mm tree
Date: Mon, 25 Jul 2016 13:52:53 -0700
Message-ID: <57967c25.4PWEFsKlGLVrcOjC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcGYUwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 16:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: alloc new page from a nearest neighbor node when mem-offline
has been added to the -mm tree.  Its filename is
     mem-hotplug-alloc-new-page-from-a-nearest-neighbor-node-when-mem-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-alloc-new-page-from-a-nearest-neighbor-node-when-mem-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-alloc-new-page-from-a-nearest-neighbor-node-when-mem-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mem-hotplug: alloc new page from a nearest neighbor node when mem-offline

If we offline a node, alloc the new page from a nearest neighbor node
instead of the current node or other remote nodes, because re-migrate is a
waste of time and the distance of the remote nodes is often very large.

Also use GFP_HIGHUSER_MOVABLE to alloc new page if the zone is
movable zone or highmem zone.

Link: http://lkml.kernel.org/r/5795E18B.5060302@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff -puN mm/memory_hotplug.c~mem-hotplug-alloc-new-page-from-a-nearest-neighbor-node-when-mem-offline mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-alloc-new-page-from-a-nearest-neighbor-node-when-mem-offline
+++ a/mm/memory_hotplug.c
@@ -1548,6 +1548,37 @@ static unsigned long scan_movable_pages(
 	return 0;
 }
 
+static struct page *new_node_page(struct page *page, unsigned long private,
+		int **result)
+{
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+	int nid = page_to_nid(page);
+	nodemask_t nmask = node_online_map;
+	struct page *new_page;
+
+	/*
+	 * TODO: allocate a destination hugepage from a nearest neighbor node,
+	 * accordance with memory policy of the user process if possible. For
+	 * now as a simple work-around, we use the next node for destination.
+	 */
+	if (PageHuge(page))
+		return alloc_huge_page_node(page_hstate(compound_head(page)),
+					next_node_in(nid, nmask));
+
+	node_clear(nid, nmask);
+	if (PageHighMem(page)
+	    || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
+		gfp_mask |= __GFP_HIGHMEM;
+
+	new_page = __alloc_pages_nodemask(gfp_mask, 0,
+					node_zonelist(nid, gfp_mask), &nmask);
+	if (!new_page)
+		new_page = __alloc_pages(gfp_mask, 0,
+					node_zonelist(nid, gfp_mask));
+
+	return new_page;
+}
+
 #define NR_OFFLINE_AT_ONCE_PAGES	(256)
 static int
 do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
@@ -1611,11 +1642,8 @@ do_migrate_range(unsigned long start_pfn
 			goto out;
 		}
 
-		/*
-		 * alloc_migrate_target should be improooooved!!
-		 * migrate_pages returns # of failed pages.
-		 */
-		ret = migrate_pages(&source, alloc_migrate_target, NULL, 0,
+		/* Allocate a new page from the nearest neighbor node */
+		ret = migrate_pages(&source, new_node_page, NULL, 0,
 					MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret)
 			putback_movable_pages(&source);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mem-hotplug-use-gfp_highuser_movable-in-alloc_migrate_target.patch
mem-hotplug-alloc-new-page-from-a-nearest-neighbor-node-when-mem-offline.patch

