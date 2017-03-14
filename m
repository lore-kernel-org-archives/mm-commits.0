From: akpm@linux-foundation.org
Subject: +
 mm-compaction-ignore-block-suitable-after-check-large-free-page.patch added to -mm tree
Date: Tue, 14 Mar 2017 14:50:45 -0700
Message-ID: <58c865b5.bo0xm+fUsI26Wv2o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753117AbdCNVuw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2017 17:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, guohanjun@huawei.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: ignore block suitable after check large free page
has been added to the -mm tree.  Its filename is
     mm-compaction-ignore-block-suitable-after-check-large-free-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-ignore-block-suitable-after-check-large-free-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-ignore-block-suitable-after-check-large-free-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1003,9 +1003,6 @@ static bool suitable_migration_source(st
 static bool suitable_migration_target(struct compact_control *cc,
 							struct page *page)
 {
-	if (cc->ignore_block_suitable)
-		return true;
