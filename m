From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-highidx-argument-type.patch added to -mm tree
Date: Thu, 15 Jan 2015 14:49:26 -0800
Message-ID: <54b843f6.bKeeLGhT41m9Gwxc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbbAOWt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 17:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, suleiman@google.com, vbabka@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix highidx argument type
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-highidx-argument-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-highidx-argument-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-highidx-argument-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: mm/vmscan: fix highidx argument type

for_each_zone_zonelist_nodemask wants an enum zone_type argument, but is
passed gfp_t:

mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask
mm/vmscan.c:2658:9: warning: incorrect type in argument 2 (different base types)
mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask

convert argument to the correct type.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-highidx-argument-type mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-highidx-argument-type
+++ a/mm/vmscan.c
@@ -2656,7 +2656,7 @@ static bool throttle_direct_reclaim(gfp_
 	 * should make reasonable progress.
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					gfp_mask, nodemask) {
+					gfp_zone(gfp_mask), nodemask) {
 		if (zone_idx(zone) > ZONE_NORMAL)
 			continue;
 
_

Patches currently in -mm which might be from mst@redhat.com are

origin.patch
mm-vmscan-fix-highidx-argument-type.patch
linux-next.patch

