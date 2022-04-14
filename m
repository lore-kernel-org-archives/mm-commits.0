Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89857C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 02:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbiDNChi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 22:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiDNChh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 22:37:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48952229A
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 19:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4602361CAB
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 02:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845DDC385A3;
        Thu, 14 Apr 2022 02:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649903713;
        bh=hqQsQQfz+L+tih4o3xjdjhoiUnp++T2jDLM/YiWXoGo=;
        h=Date:To:From:Subject:From;
        b=biExy4uQwtwpnCQZRcgttQpJUQtYTGf3SrL+rOnQ9wHCziOnIPJ3zAKZ+n3zVYKj3
         9QZDfGqiB/jpoSQVl3VJPTD7uUfblUtLn8mqpvi2KveA9DRCljN6mYsDiV2RalCQJc
         aF3KGQPJU1PgyQlvyslaZUGcSZgaO6q9gRIuij9U=
Date:   Wed, 13 Apr 2022 19:35:12 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        osalvador@suse.de, mhocko@kernel.org, linmiaohe@huawei.com,
        david@redhat.com, yuehaibing@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix.patch added to -mm tree
Message-Id: <20220414023513.845DDC385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix build warning without CONFIG_MEMORY_HOTREMOVE
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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


--- a/mm/memory_hotplug.c~mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix
+++ a/mm/memory_hotplug.c
@@ -1145,16 +1145,6 @@ failed_addition:
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
@@ -1755,6 +1745,16 @@ static void node_states_clear_node(int n
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

mm-memory_hotplug-reset-nodes-state-when-empty-during-offline-fix.patch

