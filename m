From: akpm@linux-foundation.org
Subject: + memory-hotplug-build-zonelists-when-offlining-pages.patch added to -mm tree
Date: Fri, 31 Aug 2012 16:25:18 -0700
Message-ID: <20120831232519.0B4DB200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63838 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HaXZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 19:25:21 -0400
Received: by eaac1 with SMTP id c1so175603eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 16:25:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com


The patch titled
     Subject: memory-hotplug: build zonelists when offlining pages
has been added to the -mm tree.  Its filename is
     memory-hotplug-build-zonelists-when-offlining-pages.patch

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
@@ -966,8 +966,13 @@ repeat:
 
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

memory-hotplug-build-zonelists-when-offlining-pages.patch

