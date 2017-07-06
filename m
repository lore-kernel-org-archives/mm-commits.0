From: akpm@linux-foundation.org
Subject: [patch 044/108] mm, memory_hotplug: use node instead of
 zone in can_online_high_movable
Date: Thu, 06 Jul 2017 15:37:38 -0700
Message-ID: <20170706223738.1cDy5WRkJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbdGFWhk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: use node instead of zone in can_online_high_movable

The primary purpose of this helper is to query the node state so use the
node id directly.  This is a preparatory patch for later changes.

This shouldn't introduce any functional change

Link: http://lkml.kernel.org/r/20170515085827.16474-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable
+++ a/mm/memory_hotplug.c
@@ -941,15 +941,15 @@ static int online_pages_range(unsigned l
  * When CONFIG_MOVABLE_NODE, we permit onlining of a node which doesn't have
  * normal memory.
  */
-static bool can_online_high_movable(struct zone *zone)
+static bool can_online_high_movable(int nid)
 {
 	return true;
 }
 #else /* CONFIG_MOVABLE_NODE */
 /* ensure every online node has NORMAL memory */
-static bool can_online_high_movable(struct zone *zone)
+static bool can_online_high_movable(int nid)
 {
-	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+	return node_state(nid, N_NORMAL_MEMORY);
 }
 #endif /* CONFIG_MOVABLE_NODE */
 
@@ -1083,7 +1083,7 @@ int __ref online_pages(unsigned long pfn
 
 	if ((zone_idx(zone) > ZONE_NORMAL ||
 	    online_type == MMOP_ONLINE_MOVABLE) &&
-	    !can_online_high_movable(zone))
+	    !can_online_high_movable(pfn_to_nid(pfn)))
 		return -EINVAL;
 
 	if (online_type == MMOP_ONLINE_KERNEL) {
_
