Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC7CECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiILDek (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiILDc5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2F928E3D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCC41B80C6D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FCCC433C1;
        Mon, 12 Sep 2022 03:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953420;
        bh=SQpUNWzsXn0zQmgWnoKrKQQccfsr9gOP8flTWa/F7I4=;
        h=Date:To:From:Subject:From;
        b=XTQEPCgy2tnkL93zgeLGvXpd+3MGdLpItCAzS50Efg0K39orSQGQ4M1j30x5ofkvn
         ijNX0yjW8/bxLsbBUQKW45SlbpBqbTPNOLcVHUky5IEcGfoDDbfnJnz4STKAQEcWt7
         eZKpaZBSK/4RSOPAkDTkVGTyHBLzTVeBzfqvNR9c=
Date:   Sun, 11 Sep 2022 20:30:17 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        zuoze1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-delete-a-redundant-parameter-of-rmqueue_pcplist.patch removed from -mm tree
Message-Id: <20220912033020.77FCCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc.c: delete a redundant parameter of rmqueue_pcplist
has been removed from the -mm tree.  Its filename was
     mm-delete-a-redundant-parameter-of-rmqueue_pcplist.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zezuo <zuoze1@huawei.com>
Subject: mm/page_alloc.c: delete a redundant parameter of rmqueue_pcplist
Date: Wed, 31 Aug 2022 01:34:04 +0000

The gfp_flags parameter is not used in rmqueue_pcplist, so directly delete
this parameter.

Link: https://lkml.kernel.org/r/20220831013404.3360714-1-zuoze1@huawei.com
Signed-off-by: zezuo <zuoze1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-delete-a-redundant-parameter-of-rmqueue_pcplist
+++ a/mm/page_alloc.c
@@ -3779,8 +3779,7 @@ struct page *__rmqueue_pcplist(struct zo
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			gfp_t gfp_flags, int migratetype,
-			unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3841,7 +3840,7 @@ struct page *rmqueue(struct zone *prefer
 		if (!IS_ENABLED(CONFIG_CMA) || alloc_flags & ALLOC_CMA ||
 				migratetype != MIGRATE_MOVABLE) {
 			page = rmqueue_pcplist(preferred_zone, zone, order,
-					gfp_flags, migratetype, alloc_flags);
+					migratetype, alloc_flags);
 			if (likely(page))
 				goto out;
 		}
_

Patches currently in -mm which might be from zuoze1@huawei.com are


