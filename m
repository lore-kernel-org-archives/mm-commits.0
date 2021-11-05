Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1642C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB65611C4
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhKEUmy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKEUmw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5674460FBF;
        Fri,  5 Nov 2021 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144812;
        bh=8zmJ95KZQvysgWDXL5evRtpUL+lSnaX+NEczWmElFno=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j/4GhRGOxKDq6ojiiUiV8HWRO+GCCI/4pasOY0LG9E/M7Uv7dwbDDmPoeRkn8MTko
         TURB6Y74ZrSg5QvCt8Fl7DwQ1ujzXc4Fg1eKO0FzH39xtWaEUhfzI3p4fUyI0C98Iu
         nfxC9ByXNA8KMPxHSUqPXu3ZE7pL2ajL8P+ZF3Ms=
Date:   Fri, 05 Nov 2021 13:40:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 106/262] mm/page_alloc.c: use helper function
 zone_spans_pfn()
Message-ID: <20211105204011.W9Nu5EuuH%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
