From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:43:49 -0700
Message-ID: <52321975.wo5Wz4pr2GsOgFNI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3ILTnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cody@linux.vnet.ibm.com, qiuxishi@huawei.com

Subject: [merged] mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch removed from -mm tree
To: qiuxishi@huawei.com,cody@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:49 -0700


The patch titled
     Subject: mm: use zone_is_initialized() instead of if(zone->wait_table)
has been removed from the -mm tree.  Its filename was
     mm-use-zone_is_initialized-instead-of-ifzone-wait_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use zone_is_initialized() instead of if(zone->wait_table)

Use "zone_is_initialized()" instead of "if (zone->wait_table)".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-use-zone_is_initialized-instead-of-ifzone-wait_table mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-use-zone_is_initialized-instead-of-ifzone-wait_table
+++ a/mm/memory_hotplug.c
@@ -194,7 +194,7 @@ void register_page_bootmem_info_node(str
 
 	zone = &pgdat->node_zones[0];
 	for (; zone < pgdat->node_zones + MAX_NR_ZONES - 1; zone++) {
-		if (zone->wait_table) {
+		if (zone_is_initialized(zone)) {
 			nr_pages = zone->wait_table_hash_nr_entries
 				* sizeof(wait_queue_head_t);
 			nr_pages = PAGE_ALIGN(nr_pages) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch

