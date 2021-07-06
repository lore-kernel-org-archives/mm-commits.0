Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA59C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ECBA61C7B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhGFTNu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231779AbhGFTNt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DE561C72;
        Tue,  6 Jul 2021 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598670;
        bh=CCcp3cj4xp1DTHb2Okx9eqVwCVQRVntzSdbYls8v2EA=;
        h=Date:From:To:Subject:From;
        b=WDRx15inTOR2zmm647ZpO27Is8GqwcHgNhk/78EFntxmlO+m9KppAs535FstxohVv
         yeGNBCAyNz1TXyfFjPJsqrdJ4AeQTRw8tKv9JNkVOdpK4womadWQUK+NayCkWhXu4z
         0t7lSt84/KBKxDm7wclvbiycL6HyAP+XepwkBMUU=
Date:   Tue, 06 Jul 2021 12:11:10 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, iamjoonsoo.kim@lge.com, idryomov@gmail.com,
        linmiaohe@huawei.com, mgorman@techsingularity.net,
        mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 swap-check-mapping_empty-for-swap-cache-before-being-freed.patch removed
 from -mm tree
Message-ID: <20210706191110.2ljZoXjfH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: check mapping_empty() for swap cache before being freed
has been removed from the -mm tree.  Its filename was
     swap-check-mapping_empty-for-swap-cache-before-being-freed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap: check mapping_empty() for swap cache before being freed

To check whether all pages and shadow entries in swap cache has been
removed before swap cache is freed.

Link: https://lkml.kernel.org/r/20210608005121.511140-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c~swap-check-mapping_empty-for-swap-cache-before-being-freed
+++ a/mm/swap_state.c
@@ -693,7 +693,12 @@ int init_swap_address_space(unsigned int
 
 void exit_swap_address_space(unsigned int type)
 {
-	kvfree(swapper_spaces[type]);
+	int i;
+	struct address_space *spaces = swapper_spaces[type];
+
+	for (i = 0; i < nr_swapper_spaces[type]; i++)
+		VM_WARN_ON_ONCE(!mapping_empty(&spaces[i]));
+	kvfree(spaces);
 	nr_swapper_spaces[type] = 0;
 	swapper_spaces[type] = NULL;
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are


