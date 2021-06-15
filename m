Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AB2C2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 03:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17FEA613F1
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 03:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFODHe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 23:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhFODHb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 23:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE0A9613BF;
        Tue, 15 Jun 2021 03:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623726327;
        bh=FKxpxdIm0tX+7jVaBF3UL+yA+L/oUsSWiLZpJRWWYio=;
        h=Date:From:To:Subject:From;
        b=k0TdeC738+6iAISFbdthPOgv/dY9N9hJhNRjNgWjcPrg6/vjzDcPDaxiFqux4NbI/
         xADgpzVnLUWeMxETLoMn/vt5w5N+6NbENBcY5eHzmeG60NnD49VmHQGWOgDhOojBZU
         kgJ1Yo21VpxYU+44D+iOco7l15fA5VxuyCKKHZIE=
Date:   Mon, 14 Jun 2021 20:05:26 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, iamjoonsoo.kim@lge.com, idryomov@gmail.com,
        linmiaohe@huawei.com, mgorman@techsingularity.net,
        mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, willy@infradead.org, ying.huang@intel.com
Subject:  +
 swap-check-mapping_empty-for-swap-cache-before-being-freed.patch added to
 -mm tree
Message-ID: <20210615030526.frLVuMucI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: check mapping_empty() for swap cache before being freed
has been added to the -mm tree.  Its filename is
     swap-check-mapping_empty-for-swap-cache-before-being-freed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/swap-check-mapping_empty-for-swap-cache-before-being-freed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/swap-check-mapping_empty-for-swap-cache-before-being-freed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-swap-remove-unnecessary-smp_rmb-in-swap_type_to_swap_info.patch
mm-free-idle-swap-cache-page-after-cow.patch
swap-check-mapping_empty-for-swap-cache-before-being-freed.patch

