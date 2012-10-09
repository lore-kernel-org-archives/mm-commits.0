From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-build-zonelists-when-offlining-pages.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:07 -0700
Message-ID: <20121009181108.3128920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40119 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2JISLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:10 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so363267eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: build zonelists when offlining pages
has been removed from the -mm tree.  Its filename was
     memory-hotplug-build-zonelists-when-offlining-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: memory-hotplug: build zonelists when offlining pages

online_pages() does build_all_zonelists() and zone_pcp_update(), I think
offline_pages() should do it too.

When the zone has no memory to allocate, remove it from other nodes'
zonelists.  zone_batchsize() depends on zone's present pages, if zone's
present pages are changed, zone's pcp should be updated.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-build-zonelists-when-offlining-pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-build-zonelists-when-offlining-pages
+++ a/mm/memory_hotplug.c
@@ -970,8 +970,13 @@ repeat:
 
 	init_per_zone_wmark_min();
 
-	if (!populated_zone(zone))
+	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
+		mutex_lock(&zonelists_mutex);
+		build_all_zonelists(NULL, NULL);
+		mutex_unlock(&zonelists_mutex);
+	} else
+		zone_pcp_update(zone);
 
 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch

