Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079C7C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjFIXeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjFIXcx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC5E3AB2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8D7F65CD2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AF4C433EF;
        Fri,  9 Jun 2023 23:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353403;
        bh=BWF3gMJsrUWh6NuUQjHCD/yw/3nWzYmf8LU8ox5XUzc=;
        h=Date:To:From:Subject:From;
        b=0Zk2T2SDZe6y0y75cxW12GyiD1B2EK8QbgFw3Mw014gCYbxbiQU7FhCnPl9S4fKJf
         h0XR7oOYJZtpDy5h9Cyl83I5vLxdY2is0/PKbjVmhKSgKHh1FO2imxfdX9Le/9MjdP
         XGYv3c3koaIdJj7gvVDWHpdCpWe0mT0GFO1MLWTU=
Date:   Fri, 09 Jun 2023 16:30:02 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@kernel.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-move-set_pageblock_order-to-free_area_init.patch removed from -mm tree
Message-Id: <20230609233003.08AF4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: move set_pageblock_order() to free_area_init()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-move-set_pageblock_order-to-free_area_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: move set_pageblock_order() to free_area_init()
Date: Thu, 1 Jun 2023 06:35:35 +0000

pageblock_order only needs to be set once, there is no need to initialize
it in every zone/node.

Link: https://lkml.kernel.org/r/20230601063536.26882-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-move-set_pageblock_order-to-free_area_init
+++ a/mm/mm_init.c
@@ -1585,7 +1585,6 @@ static void __init free_area_init_core(s
 		if (!size)
 			continue;
 
-		set_pageblock_order();
 		setup_usemap(zone);
 		init_currently_empty_zone(zone, zone->zone_start_pfn, size);
 	}
@@ -1852,6 +1851,8 @@ void __init free_area_init(unsigned long
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
+	set_pageblock_order();
+
 	for_each_node(nid) {
 		pg_data_t *pgdat;
 
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

