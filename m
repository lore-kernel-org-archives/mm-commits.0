From: akpm@linux-foundation.org
Subject: [patch 046/102] mm/compaction: ignore block suitable after
 check large free page
Date: Wed, 03 May 2017 14:53:54 -0700
Message-ID: <20170503215354.xYpavmX-F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECVyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guohanjun@huawei.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, xieyisheng1@huawei.com

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
