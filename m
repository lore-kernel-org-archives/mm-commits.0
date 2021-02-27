Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79480C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C44164F43
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhB0CaW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230081AbhB0CaD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F9364F1F;
        Sat, 27 Feb 2021 02:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392968;
        bh=e/3B41X+1/THICDVhMX7WWh/MSxMBofKCyB9MXPzPvA=;
        h=Date:From:To:Subject:From;
        b=kF76/x0cvBiyz2lavFpF/IzBY/84SUvElVSNTSNIe88xq92QFSaii0w/44RkZwjbE
         5zoOprEaGkKQwkdGBtt5Vlq5c3tZo67DW6GoaPWaTp3WcPA8P2HXJnsVxtO1y03IVy
         /74wpRh//7Gw8bVYKsZhIQYLHwW8nVywxlqrmuQk=
Date:   Fri, 26 Feb 2021 18:29:28 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
 removed from -mm tree
Message-ID: <20210227022928.3199Ft6ZF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: use helper function zone_end_pfn() to get end_pfn
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: use helper function zone_end_pfn() to get end_pfn

Commit 108bcc96ef70 ("mm: add & use zone_end_pfn() and zone_spans_pfn()")
introduced the helper zone_end_pfn() to calculate the zone end pfn.  But
update_pgdat_span() forgot to use it.

Use this helper and rename local variable zone_end_pfn to end_pfn to avoid
a naming conflict with the existing zone_end_pfn().

Link: https://lkml.kernel.org/r/20210127093211.37714-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn
+++ a/mm/memory_hotplug.c
@@ -493,20 +493,19 @@ static void update_pgdat_span(struct pgl
 
 	for (zone = pgdat->node_zones;
 	     zone < pgdat->node_zones + MAX_NR_ZONES; zone++) {
-		unsigned long zone_end_pfn = zone->zone_start_pfn +
-					     zone->spanned_pages;
+		unsigned long end_pfn = zone_end_pfn(zone);
 
 		/* No need to lock the zones, they can't change. */
 		if (!zone->spanned_pages)
 			continue;
 		if (!node_end_pfn) {
 			node_start_pfn = zone->zone_start_pfn;
-			node_end_pfn = zone_end_pfn;
+			node_end_pfn = end_pfn;
 			continue;
 		}
 
-		if (zone_end_pfn > node_end_pfn)
-			node_end_pfn = zone_end_pfn;
+		if (end_pfn > node_end_pfn)
+			node_end_pfn = end_pfn;
 		if (zone->zone_start_pfn < node_start_pfn)
 			node_start_pfn = zone->zone_start_pfn;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


