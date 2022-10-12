Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736FCC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJLW6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJLW60 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423CF12587A
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D96A7B81CB0
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98456C433D6;
        Wed, 12 Oct 2022 22:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615467;
        bh=hsZBTspqY92UxFVyWvAfx2QNcyzV3HSLQ+atb4cY8EA=;
        h=Date:To:From:Subject:From;
        b=BnHTLJr1q/GnWbq52C8zv0+eyW+BEZAvuUE3L//l4HGlpmZZvko6w15w2+VTTX7nv
         ez/tDa3NYc5WlIg5z/1ydy0F301fIBT6A8XEEKMDMIAmKzT1KfxAO7c+Di0TYiTVQI
         a186usgYG2jnDTjEjiU46t5LH2IPNqjlgVQyqubk=
Date:   Wed, 12 Oct 2022 15:57:46 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        linmiaohe@huawei.com, laoar.shao@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page.patch removed from -mm tree
Message-Id: <20221012225747.98456C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: fix incorrect PGFREE and PGALLOC for high-order page
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/page_alloc: fix incorrect PGFREE and PGALLOC for high-order page
Date: Thu, 6 Oct 2022 10:15:40 +0000

PGFREE and PGALLOC represent the number of freed and allocated pages.  So
the page order must be considered.

Link: https://lkml.kernel.org/r/20221006101540.40686-1-laoar.shao@gmail.com
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-incorrect-pgfree-and-pgalloc-for-high-order-page
+++ a/mm/page_alloc.c
@@ -3446,7 +3446,7 @@ static void free_unref_page_commit(struc
 	int pindex;
 	bool free_high;
 
-	__count_vm_event(PGFREE);
+	__count_vm_events(PGFREE, 1 << order);
 	pindex = order_to_pindex(migratetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
@@ -3803,7 +3803,7 @@ static struct page *rmqueue_pcplist(stru
 	pcp_spin_unlock_irqrestore(pcp, flags);
 	pcp_trylock_finish(UP_flags);
 	if (page) {
-		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
+		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
 	}
 	return page;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


