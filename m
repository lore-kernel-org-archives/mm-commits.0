Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D2AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355121AbiCYBgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357459AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D28C12D0
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91EA3608C1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5024C340EE;
        Fri, 25 Mar 2022 01:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171964;
        bh=1cwPqBwrel579wpSyRcP4YNu56Ip03n4hfDfXCaIoVE=;
        h=Date:To:From:Subject:From;
        b=LEMaBq+UuwQ1rQMb7JYT8GxkkXGvIMsUW3KIOnh1KiT3rjI756WZRdyRZ5YmCsVTV
         ocNXJWpPRS7NUOaegIgfWMnxCbeXfDtjGX7PXn4nvBcZ9OOPeHVxmiAVV7Jbs5UZpT
         +uQiMLI8Fy2DHDAdyC+Qwljn2CX4jQm2lXBbdWiU=
Date:   Thu, 24 Mar 2022 18:32:43 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch removed from -mm tree
Message-Id: <20220325013243.E5024C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: avoid calling zone_intersects() for ZONE_NORMAL
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: avoid calling zone_intersects() for ZONE_NORMAL

If zid reaches ZONE_NORMAL, the caller will always get the NORMAL zone no
matter what zone_intersects() returns.  So we can save some possible cpu
cycles by avoid calling zone_intersects() for ZONE_NORMAL.

Link: https://lkml.kernel.org/r/20220207133643.23427-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal
+++ a/mm/memory_hotplug.c
@@ -823,7 +823,7 @@ static struct zone *default_kernel_zone_
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	int zid;
 
-	for (zid = 0; zid <= ZONE_NORMAL; zid++) {
+	for (zid = 0; zid < ZONE_NORMAL; zid++) {
 		struct zone *zone = &pgdat->node_zones[zid];
 
 		if (zone_intersects(zone, start_pfn, nr_pages))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

