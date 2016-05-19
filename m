From: akpm@linux-foundation.org
Subject: + mm-compact-fix-zoneindex-in-compact.patch added to -mm tree
Date: Thu, 19 May 2016 14:13:26 -0700
Message-ID: <573e2c76.d/FhS6/6XJT2FVEI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbcESVN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 17:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: puck.chen@hisilicon.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, suzhuangluan@hisilicon.com, tj@kernel.org, vbabka@suse.cz, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: fix zoneindex in kcompactd()
has been added to the -mm tree.  Its filename is
     mm-compact-fix-zoneindex-in-compact.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compact-fix-zoneindex-in-compact.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compact-fix-zoneindex-in-compact.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Feng <puck.chen@hisilicon.com>
Subject: mm/compaction.c: fix zoneindex in kcompactd()

While testing the kcompactd in my platform 3G MEM only DMA ZONE.  I found
the kcompactd never wakeup.  It seems the zoneindex has already minus 1
before.  So the traverse here should be <=.

Link: http://lkml.kernel.org/r/1463659121-84124-1-git-send-email-puck.chen@hisilicon.com
Fixes: accf62422b3a ("mm, kswapd: replace kswapd compaction with waking up kcompactd")
Signed-off-by: Chen Feng <puck.chen@hisilicon.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhuangluan Su <suzhuangluan@hisilicon.com>
Cc: Yiping Xu <xuyiping@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compact-fix-zoneindex-in-compact mm/compaction.c
--- a/mm/compaction.c~mm-compact-fix-zoneindex-in-compact
+++ a/mm/compaction.c
@@ -1862,7 +1862,7 @@ static bool kcompactd_node_suitable(pg_d
 	struct zone *zone;
 	enum zone_type classzone_idx = pgdat->kcompactd_classzone_idx;
 
-	for (zoneid = 0; zoneid < classzone_idx; zoneid++) {
+	for (zoneid = 0; zoneid <= classzone_idx; zoneid++) {
 		zone = &pgdat->node_zones[zoneid];
 
 		if (!populated_zone(zone))
_

Patches currently in -mm which might be from puck.chen@hisilicon.com are

mm-compact-fix-zoneindex-in-compact.patch

