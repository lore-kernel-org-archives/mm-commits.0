From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-unused-zone_type-variable-from-__remove_zone.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:24:46 -0700
Message-ID: <20170711192446.a76pcgdBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933703AbdGKTYr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: remove unused local zone_type from __remove_zone()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-zone_type-variable-from-__remove_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/memory_hotplug.c: remove unused local zone_type from __remove_zone()

__remove_zone() sets up up zone_type, but never uses it for anything. 
This does not cause a warning, due to the (necessary) use of
-Wno-unused-but-set-variable.  However, it's noise, so just delete it.

Link: http://lkml.kernel.org/r/20170624043421.24465-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-remove-unused-zone_type-variable-from-__remove_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove-unused-zone_type-variable-from-__remove_zone
+++ a/mm/memory_hotplug.c
@@ -580,11 +580,8 @@ static void __remove_zone(struct zone *z
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nr_pages = PAGES_PER_SECTION;
-	int zone_type;
 	unsigned long flags;
 
-	zone_type = zone - pgdat->node_zones;
