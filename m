From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-ignore-block-suitable-after-check-large-free-page.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:11:12 -0700
Message-ID: <20170504191112.XumWpFKyt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753018AbdEDTLP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:11:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guohanjun@huawei.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, xieyisheng1@huawei.com


The patch titled
     Subject: mm/compaction: ignore block suitable after check large free page
has been removed from the -mm tree.  Its filename was
     mm-compaction-ignore-block-suitable-after-check-large-free-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/compaction: ignore block suitable after check large free page

By reviewing code, I find that if the migrate target is a large free page
and we ignore suitable, it may splite large target free page into smaller
block which is not good for defrag.  So move the ignore block suitable
after check large free page.

As Vlastimil pointed out in RFC version that this patch is just based on
logical analyses which might be better for future-proofing the function
and it is most likely won't have any visible effect right now, for direct
compaction shouldn't have to be called if there's a >=pageblock_order page
already available.

Link: http://lkml.kernel.org/r/1489490743-5364-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-ignore-block-suitable-after-check-large-free-page mm/compaction.c
--- a/mm/compaction.c~mm-compaction-ignore-block-suitable-after-check-large-free-page
+++ a/mm/compaction.c
@@ -992,9 +992,6 @@ isolate_migratepages_range(struct compac
 static bool suitable_migration_target(struct compact_control *cc,
 							struct page *page)
 {
-	if (cc->ignore_block_suitable)
-		return true;
