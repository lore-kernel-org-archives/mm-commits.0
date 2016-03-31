From: akpm@linux-foundation.org
Subject: + mm-highmem-simplify-is_highmem.patch added to -mm tree
Date: Thu, 31 Mar 2016 15:39:28 -0700
Message-ID: <56fda720.gcYKHhCVeMGETEo1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630AbcCaWj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 18:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chanho.min@lge.com, dan.j.williams@intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: simplify is_highmem()
has been added to the -mm tree.  Its filename is
     mm-highmem-simplify-is_highmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-simplify-is_highmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-simplify-is_highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-highmem-simplify-is_highmem.patch

