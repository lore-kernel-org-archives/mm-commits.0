From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:46 -0700
Message-ID: <55f08e4a.vYMYhhTELkbhA3XW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbbIITxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix comments in zone_spanned_pages_in_node() and zone_spanned_pages_in_node()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: memory-hotplug: fix comments in zone_spanned_pages_in_node() and zone_spanned_pages_in_node()

When hot adding a node from add_memory(), we will add memblock first, so
the node is not empty.  But when called from cpu_up(), the node should be
empty.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>\
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-comment-in-zone_spanned_pages_in_node-and-zone_spanned_pages_in_node
+++ a/mm/page_alloc.c
@@ -5085,7 +5085,7 @@ static unsigned long __meminit zone_span
 {
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	/* When hotadd a new node, the node should be empty */
+	/* When hotadd a new node from cpu_up(), the node should be empty */
 	if (!node_start_pfn && !node_end_pfn)
 		return 0;
 
@@ -5152,7 +5152,7 @@ static unsigned long __meminit zone_abse
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	/* When hotadd a new node, the node should be empty */
+	/* When hotadd a new node from cpu_up(), the node should be empty */
 	if (!node_start_pfn && !node_end_pfn)
 		return 0;
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


