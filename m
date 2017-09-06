From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch removed from
 -mm tree
Date: Wed, 06 Sep 2017 16:04:00 -0700
Message-ID: <59b07ee0./ye9rmTIwA97ftgY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdIFXEB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:04:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch

This patch was dropped because it was folded into mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix

"mm, vmscan: do not loop on too_many_isolated for ever" has added an
interruptible sleep into shrink_inactive_list when we have isolated too
many pages. Andrew has noticed that we used to sleep in uninterruptible
sleep previously (in congestion_wait) and that changing that is wrong
for at least two reasons
	- waiting task would not participate in the load average anymore
	- task with a pending signal will not sleep and bail out
	  immediately
While none of those issues are critical in any way but they are
unnecessary. The interruptible sleep was more an oversight than a
deliberate decision. Fix this by using msleep instead.

Link: http://lkml.kernel.org/r/20170724065048.GB25221@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix
+++ a/mm/vmscan.c
@@ -1750,7 +1750,7 @@ shrink_inactive_list(unsigned long nr_to
 			return 0;
 
 		/* wait a bit for the reclaimer. */
-		schedule_timeout_interruptible(HZ/10);
+		msleep(100);
 		stalled = true;
 
 		/* We are about to die and free our memory. Return now. */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
mm-oom-do-not-rely-on-tif_memdie-for-memory-reserves-access.patch
mm-replace-tif_memdie-checks-by-tsk_is_oom_victim.patch

