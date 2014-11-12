From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch
 added to -mm tree
Date: Wed, 12 Nov 2014 13:28:43 -0800
Message-ID: <5463d10b.8E67CamorxeKni9q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaKLV2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 16:28:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: reset node present pages when hot-adding a new pgdat
has been added to the -mm tree.  Its filename is
     mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mem-hotplug: reset node present pages when hot-adding a new pgdat

When memory is hot-added, all the memory is in offline state.  So clear
   all zones' present_pages because they will be updated in online_pages()
   and offline_pages().  Otherwise, /proc/zoneinfo will corrupt:

When the memory of node2 is offline:
# cat /proc/zoneinfo
......
Node 2, zone   Movable
......
        spanned  8388608
        present  8388608
        managed  0

When we online memory on node2:
# cat /proc/zoneinfo
......
Node 2, zone   Movable
......
        spanned  8388608
        present  16777216
        managed  8388608

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>	[3.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN mm/memory_hotplug.c~mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat
+++ a/mm/memory_hotplug.c
@@ -1067,6 +1067,16 @@ out:
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+static void reset_node_present_pages(pg_data_t *pgdat)
+{
+	struct zone *z;
+
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+		z->present_pages = 0;
+
+	pgdat->node_present_pages = 0;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
@@ -1105,6 +1115,13 @@ static pg_data_t __ref *hotadd_new_pgdat
 	 */
 	reset_node_managed_pages(pgdat);
 
+	/*
+	 * When memory is hot-added, all the memory is in offline state. So
+	 * clear all zones' present_pages because they will be updated in
+	 * online_pages() and offline_pages().
+	 */
+	reset_node_present_pages(pgdat);
+
 	return pgdat;
 }
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat.patch
mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch
memblock-refactor-functions-to-set-clear-memblock_hotplug.patch

