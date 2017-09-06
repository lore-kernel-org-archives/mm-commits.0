From: akpm@linux-foundation.org
Subject: [patch 018/119] mm/memory_hotplug: just build zonelist for
 newly added node
Date: Wed, 06 Sep 2017 16:19:33 -0700
Message-ID: <20170906231933.iIS9g2rR_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdIFXTf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, liuj97@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memory_hotplug: just build zonelist for newly added node

9adb62a5df9c0fbef7 ("mm/hotplug: correctly setup fallback zonelists when
creating new pgdat") tries to build the correct zonelist for a newly added
node, while it is not necessary to rebuild it for already exist nodes.

In build_zonelists(), it will iterate on nodes with memory.  For a newly
added node, it will have memory until node_states_set_node() is called in
online_pages().

This patch avoids rebuilding the zonelists for already existing nodes.

build_zonelists_node() uses managed_zone(zone) checks, so it should not
include empty zones anyway.  So effectively we avoid some pointless
work under stop_machine().

[akpm@linux-foundation.org: tweak comment text]
[akpm@linux-foundation.org: coding-style tweak, per Vlastimil]
Link: http://lkml.kernel.org/r/20170626035822.50155-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-memory_hotplug-just-build-zonelist-for-new-added-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-just-build-zonelist-for-new-added-node
+++ a/mm/page_alloc.c
@@ -5282,14 +5282,18 @@ static int __build_all_zonelists(void *d
 	memset(node_load, 0, sizeof(node_load));
 #endif
 
+	/*
+	 * This node is hotadded and no memory is yet present.   So just
+	 * building zonelists is fine - no need to touch other nodes.
+	 */
 	if (self && !node_online(self->node_id)) {
 		build_zonelists(self);
-	}
