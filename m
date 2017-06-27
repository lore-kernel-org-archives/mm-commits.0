From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch
 added to -mm tree
Date: Tue, 27 Jun 2017 12:18:16 -0700
Message-ID: <5952af78.Ea34cTKUkmwrQlFr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752963AbdF0TSR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2017 15:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, liuj97@gmail.com, mhocko@suse.com, qiuxishi@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: just build zonelist for newly added node
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memory_hotplug: just build zonelist for newly added node

9adb62a5df9c0fbef7 ("mm/hotplug: correctly setup fallback zonelists when
creating new pgdat") tries to build the correct zonelist for a newly added
node, while it is not necessary to rebuild it for already exist nodes.

In build_zonelists(), it will iterate on nodes with memory.  For a newly
added node, it will have memory until node_states_set_node() is called in
online_pages().

This patch avoids rebuilding the zonelists for already existing nodes.

Link: http://lkml.kernel.org/r/20170626035822.50155-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-memory_hotplug-just-build-zonelist-for-new-added-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-just-build-zonelist-for-new-added-node
+++ a/mm/page_alloc.c
@@ -5205,15 +5205,17 @@ static int __build_all_zonelists(void *d
 	memset(node_load, 0, sizeof(node_load));
 #endif
 
-	if (self && !node_online(self->node_id)) {
+	/* This node is hotadded and no memory preset yet.
+	 * So just build zonelists is fine, no need to touch other nodes.
+	 */
+	if (self && !node_online(self->node_id))
 		build_zonelists(self);
-	}
+	else
+		for_each_online_node(nid) {
+			pg_data_t *pgdat = NODE_DATA(nid);
 
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
