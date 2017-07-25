From: akpm@linux-foundation.org
Subject: + mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
 added to -mm tree
Date: Tue, 25 Jul 2017 15:53:38 -0700
Message-ID: <5977cbf2.cLYk4ulczkF0BRSr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdGYWxj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 18:53:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch

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
@@ -1749,7 +1749,7 @@ shrink_inactive_list(unsigned long nr_to
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
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch

