Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E28C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC4EF61208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhKKCqm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCqm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D69A6103C;
        Thu, 11 Nov 2021 02:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598633;
        bh=V4mY0Vb/AnTOhEF4tbnGAKzuz7VFj7oVu0nU1S8BJ/c=;
        h=Date:From:To:Subject:From;
        b=iKdLkWaB6Wrf5DBFreTdhF0ZIrdbGhuKM6pGA1UB7cUH5jJWB4QkpwN/hWi614VJC
         y0bbJUATnzvVP4f5/EQhAga3oUxiFP16kkRzNC4p2XjkRNiFBe81sqq8/T1fMfylJS
         Jq0aq8HP14waZVMqRuLgJ0l1EApBljH3E89Up68k=
Date:   Wed, 10 Nov 2021 18:43:53 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        peterz@infradead.org, sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  [merged]
 mm-page_allocc-use-helper-function-zone_spans_pfn.patch removed from -mm
 tree
Message-ID: <20211111024353.wyNWU_RJD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: use helper function zone_spans_pfn()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-use-helper-function-zone_spans_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc.c: use helper function zone_spans_pfn()

Use helper function zone_spans_pfn() to check whether pfn is within a zone
to simplify the code slightly.

Link: https://lkml.kernel.org/r/20210902121242.41607-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-use-helper-function-zone_spans_pfn
+++ a/mm/page_alloc.c
@@ -1583,7 +1583,7 @@ static void __meminit init_reserved_page
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 		struct zone *zone = &pgdat->node_zones[zid];
 
-		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone))
+		if (zone_spans_pfn(zone, pfn))
 			break;
 	}
 	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


