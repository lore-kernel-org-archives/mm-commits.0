From: akpm@linux-foundation.org
Subject: [merged] mm-highmem-simplify-is_highmem.patch removed from -mm
 tree
Date: Fri, 20 May 2016 14:04:53 -0700
Message-ID: <573f7bf5.ecuUQ8e2MI4uCD2/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbcETVEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chanho.min@lge.com, dan.j.williams@intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: simplify is_highmem()
has been removed from the -mm tree.  Its filename was
     mm-highmem-simplify-is_highmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: mm/highmem: simplify is_highmem()

is_highmem() can be simplified by use of is_highmem_idx().  This patch
removes redundant code and will make it easier to maintain if the zone
policy is changed or a new zone is added.

(akpm: saves me 25 bytes of text per is_highmem() callsite)

Signed-off-by: Chanho Min <chanho.min@lge.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/mmzone.h~mm-highmem-simplify-is_highmem include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-highmem-simplify-is_highmem
+++ a/include/linux/mmzone.h
@@ -828,10 +828,7 @@ static inline int is_highmem_idx(enum zo
 static inline int is_highmem(struct zone *zone)
 {
 #ifdef CONFIG_HIGHMEM
-	int zone_off = (char *)zone - (char *)zone->zone_pgdat->node_zones;
-	return zone_off == ZONE_HIGHMEM * sizeof(*zone) ||
-	       (zone_off == ZONE_MOVABLE * sizeof(*zone) &&
-		zone_movable_is_highmem());
+	return is_highmem_idx(zone_idx(zone));
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from chanho.min@lge.com are


