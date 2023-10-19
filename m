Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150BBCDB465
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 16:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjJSQ1k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQ1j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2023 12:27:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA789B
        for <mm-commits@vger.kernel.org>; Thu, 19 Oct 2023 09:27:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A844C433C9;
        Thu, 19 Oct 2023 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697732857;
        bh=PFo3vBufxrWwi0s+2CApDjCWtorzTFMDDcJTrbd2i0E=;
        h=Date:To:From:Subject:From;
        b=N+pP/5p/4oIxwhrZk1uEu3ImROHgXmYbyK6keg4bDnavrexWbJhk3VFjVf637zqAW
         12CYIZzX4DPYAx/cSDMon9g22njXx44qDZL4yqfMuMxfHANq5UVls5xtR3f35OR7pO
         CaLRZ3L93jzkdKtnSGEZOExxLqDKt3lzpnmBx1zI=
Date:   Thu, 19 Oct 2023 09:27:36 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, rppt@kernel.org,
        osalvador@suse.de, mingo@kernel.org, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org, david@redhat.com,
        aneesh.kumar@linux.ibm.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch added to mm-unstable branch
Message-Id: <20231019162737.5A844C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: drop memoryless node from fallback lists
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memory_hotplug: drop memoryless node from fallback lists
Date: Thu, 19 Oct 2023 18:43:55 +0800

In offline_pages(), if a node becomes memoryless, we will clear its
N_MEMORY state by calling node_states_clear_node().  But we do this after
rebuilding the zonelists by calling build_all_zonelists(), which will
cause this memoryless node to still be in the fallback list of other
nodes.  This will incur some runtime overhead.

To drop memoryless node from fallback lists in this case, just call
node_states_clear_node() before calling build_all_zonelists().

Link: https://lkml.kernel.org/r/9f1dbe7ee1301c7163b2770e32954ff5e3ecf2c4.1697711415.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-memoryless-node-from-fallback-lists
+++ a/mm/memory_hotplug.c
@@ -2012,12 +2012,16 @@ int __ref offline_pages(unsigned long st
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
+	/*
+	 * Make sure to mark the node as memory-less before rebuilding the zone
+	 * list. Otherwise this node would still appear in the fallback lists.
+	 */
+	node_states_clear_node(node, &arg);
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
 	}
 
-	node_states_clear_node(node, &arg);
 	if (arg.status_change_nid >= 0) {
 		kcompactd_stop(node);
 		kswapd_stop(node);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-page_alloc-skip-memoryless-nodes-entirely.patch
mm-memory_hotplug-drop-memoryless-node-from-fallback-lists.patch

