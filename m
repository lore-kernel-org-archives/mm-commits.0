Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657BEE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjJDURg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjJDURd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A050BF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD410C433CA;
        Wed,  4 Oct 2023 20:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450650;
        bh=qHfayeZGklMJ/NU+8YVAWTj09C2m4MyTtsAmk/Bzhn8=;
        h=Date:To:From:Subject:From;
        b=wU94rZfnTDZ4yMorA7f78xst/6NcR02Z6YXF4u8NGKI0SvQHAS4C6CEhyQjHY8KAd
         O6a4zoHQ/VOJCVDMsVgSxChwJlBpXFi2p47/oswgXMc24PwHpjoxkuUJh4zbue43rc
         QkydNhUnBZ/RUBCFBUxC15qeWHAsfRyhQlPBr/1c=
Date:   Wed, 04 Oct 2023 13:17:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-improve-comment-of-is_via_compact_memory.patch removed from -mm tree
Message-Id: <20231004201729.DD410C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: improve comment of is_via_compact_memory
has been removed from the -mm tree.  Its filename was
     mm-compaction-improve-comment-of-is_via_compact_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: improve comment of is_via_compact_memory
Date: Fri, 1 Sep 2023 23:51:40 +0800

We do proactive compaction with order == -1 via
1. /proc/sys/vm/compact_memory
2. /sys/devices/system/node/nodex/compact
3. /proc/sys/vm/compaction_proactiveness
Add missed situation in which order == -1.

Link: https://lkml.kernel.org/r/20230901155141.249860-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-improve-comment-of-is_via_compact_memory
+++ a/mm/compaction.c
@@ -2065,8 +2065,10 @@ static isolate_migrate_t isolate_migrate
 }
 
 /*
- * order == -1 is expected when compacting via
- * /proc/sys/vm/compact_memory
+ * order == -1 is expected when compacting proactively via
+ * 1. /proc/sys/vm/compact_memory
+ * 2. /sys/devices/system/node/nodex/compact
+ * 3. /proc/sys/vm/compaction_proactiveness
  */
 static inline bool is_via_compact_memory(int order)
 {
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

