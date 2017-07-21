From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch added to -mm tree
Date: Fri, 21 Jul 2017 12:12:13 -0700
Message-ID: <5972520d.B/DjbK114j5nW2N+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754431AbdGUTMO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 15:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: remove explicit build_all_zonelists from try_online_node
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: remove explicit build_all_zonelists from try_online_node

try_online_node calls hotadd_new_pgdat which already calls
build_all_zonelists.  So the additional call is redundant.  Even though
hotadd_new_pgdat will only initialize zonelists of the new node this is
the right thing to do because such a node doesn't have any memory so other
zonelists would ignore all the zones from this node anyway.

Link: http://lkml.kernel.org/r/20170721143915.14161-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node
+++ a/mm/memory_hotplug.c
@@ -1085,13 +1085,6 @@ int try_online_node(int nid)
 	node_set_online(nid);
 	ret = register_one_node(nid);
 	BUG_ON(ret);
-
-	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
-		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL);
-		mutex_unlock(&zonelists_mutex);
-	}
