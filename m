Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A140C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjJYXtQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A1BD47
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70793C433C7;
        Wed, 25 Oct 2023 23:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277717;
        bh=mS5CeQYSJKYKkbZ1foJ7EjE4TFgCRwX4mve7ypulBzM=;
        h=Date:To:From:Subject:From;
        b=j2KXQVXDil6E9hjXWrRDyqaNqD9MCj/mf3T76CmY28hl1rZ9ohT33uvRbJZ2QZSb+
         MIT7qOnNVLZFzr6Qlgivt9AEXy6wDTxRO5qxN57IsEtB+I3Mq5gZUXe6UiNLiCviRa
         3dpwzq16fJBijKORYtIdczBQhAse6PtanT7R1O1g=
Date:   Wed, 25 Oct 2023 16:48:36 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-folio_last_cpupid-in-__split_huge_page_tail.patch removed from -mm tree
Message-Id: <20231025234837.70793C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: use folio_last_cpupid() in __split_huge_page_tail()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-folio_last_cpupid-in-__split_huge_page_tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use folio_last_cpupid() in __split_huge_page_tail()
Date: Wed, 18 Oct 2023 22:07:52 +0800

Convert to use folio_last_cpupid() in __split_huge_page_tail().

Link: https://lkml.kernel.org/r/20231018140806.2783514-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_last_cpupid-in-__split_huge_page_tail
+++ a/mm/huge_memory.c
@@ -2514,7 +2514,7 @@ static void __split_huge_page_tail(struc
 	if (page_is_idle(head))
 		set_page_idle(page_tail);
 
-	page_cpupid_xchg_last(page_tail, page_cpupid_last(head));
+	page_cpupid_xchg_last(page_tail, folio_last_cpupid(folio));
 
 	/*
 	 * always add to the tail because some iterators expect new
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


