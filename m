Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D1BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 21:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbiD1Vya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346159AbiD1Vy3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 17:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBA55FF2
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 14:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9832DB83036
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCC3C385AD;
        Thu, 28 Apr 2022 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651182626;
        bh=4hX0SRW3qV9mv/z6J/h2QZC3uwKF86QhV0CC9C/DJ+4=;
        h=Date:To:From:Subject:From;
        b=iVAn7yj0PJeMT34jfKmfaA7wsKaGAt9YEwE49yibhqyF0SuUUpFgI2DApJkUGQGw3
         RLGwlU+qOP6tJbwsXuYLWiFER7F65TBTAemv45hhYXkMdMOAGbKo/dkC1PfJVZh9xP
         M2B3U84ONebtxodduh8kw8EM+6LkdshvKIF/f9q0=
Date:   Thu, 28 Apr 2022 14:50:25 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        osalvador@suse.de, mhocko@kernel.org, linmiaohe@huawei.com,
        david@redhat.com, yuehaibing@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix.patch removed from -mm tree
Message-Id: <20220428215026.4BCC3C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix build warning without CONFIG_MEMORY_HOTREMOVE
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/memory_hotplug: fix build warning without CONFIG_MEMORY_HOTREMOVE

mm/memory_hotplug.c:1148:13: warning: `reset_node_present_pages' defined but not used [-Wunused-function]
 1148 | static void reset_node_present_pages(pg_data_t *pgdat)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~

reset_node_present_pages() now only used in node_reset_state(),move it
inside the ifdef block to fix this warning.

Link: https://lkml.kernel.org/r/20220408022402.29668-1-yuehaibing@huawei.com
Fixes: 0d540af7befe ("mm/memory_hotplug: reset node's state when empty during offline")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix
+++ a/mm/memory_hotplug.c
@@ -1146,16 +1146,6 @@ failed_addition:
 	return ret;
 }
 
-static void reset_node_present_pages(pg_data_t *pgdat)
-{
-	struct zone *z;
-
-	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		z->present_pages = 0;
-
-	pgdat->node_present_pages = 0;
-}
-
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_init_pgdat(int nid)
 {
@@ -1756,6 +1746,16 @@ static void node_states_clear_node(int n
 		node_clear_state(node, N_MEMORY);
 }
 
+static void reset_node_present_pages(pg_data_t *pgdat)
+{
+	struct zone *z;
+
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+		z->present_pages = 0;
+
+	pgdat->node_present_pages = 0;
+}
+
 static void node_reset_state(int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch

