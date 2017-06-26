From: akpm@linux-foundation.org
Subject: + mm-remove-unused-zone_type-variable-from-__remove_zone.patch
 added to -mm tree
Date: Mon, 26 Jun 2017 16:14:00 -0700
Message-ID: <59519538.SlJFXEKj/RCzy+xc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbdFZXOB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 19:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: remove unused local zone_type from __remove_zone()
has been added to the -mm tree.  Its filename is
     mm-remove-unused-zone_type-variable-from-__remove_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unused-zone_type-variable-from-__remove_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unused-zone_type-variable-from-__remove_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/memory_hotplug.c: remove unused local zone_type from __remove_zone()

__remove_zone() sets up up zone_type, but never uses it for anything. 
This does not cause a warning, due to the (necessary) use of
-Wno-unused-but-set-variable.  However, it's noise, so just delete it.

Link: http://lkml.kernel.org/r/20170624043421.24465-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
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
