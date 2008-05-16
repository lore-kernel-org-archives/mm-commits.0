From: akpm@linux-foundation.org
Subject: - memory_hotplug-check-for-walk_memory_resource-failure-in-online_pages.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:19 -0700
Message-ID: <200805162253.m4GMrJJR003126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757917AbYEPWxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, clameter@sgi.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kmannth@us.ibm.com, pj@sgi.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory_hotplug: check for walk_memory_resource() failure in online_pages()
has been removed from the -mm tree.  Its filename was
     memory_hotplug-check-for-walk_memory_resource-failure-in-online_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_hotplug: check for walk_memory_resource() failure in online_pages()
From: Geoff Levand <geoffrey.levand@am.sony.com>

Add a check to online_pages() to test for failure of
walk_memory_resource().  This fixes a condition where a failure
of walk_memory_resource() can lead to online_pages() returning
success without the requested pages being onlined.

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Keith Mannthey <kmannth@us.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory_hotplug-check-for-walk_memory_resource-failure-in-online_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-check-for-walk_memory_resource-failure-in-online_pages
+++ a/mm/memory_hotplug.c
@@ -404,8 +404,15 @@ int online_pages(unsigned long pfn, unsi
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
-	walk_memory_resource(pfn, nr_pages, &onlined_pages,
+	ret = walk_memory_resource(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
+	if (ret) {
+		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
+			nr_pages, pfn);
+		memory_notify(MEM_CANCEL_ONLINE, &arg);
+		return ret;
+	}
+
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.com are

origin.patch

