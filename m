From: akpm@linux-foundation.org
Subject: [merged]
 mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch
 removed from -mm tree
Date: Mon, 17 Nov 2014 12:51:00 -0800
Message-ID: <546a5fb4.KMjghsyIUox+b7t1%akpm__9910.62686448476$1416257478$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaKQUvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:51:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: reset node present pages when hot-adding a new pgdat
has been removed from the -mm tree.  Its filename was
     mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

memblock-refactor-functions-to-set-clear-memblock_hotplug.patch

