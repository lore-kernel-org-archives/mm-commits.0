From: akpm@linux-foundation.org
Subject: +
 mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
 added to -mm tree
Date: Mon, 09 Dec 2013 14:59:51 -0800
Message-ID: <52a64b67.px2Ja8B5D4IcfjEH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3LIW7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 17:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,stable@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 14:59:51 -0800


The patch titled
     Subject: mm: memcg: do not allow task about to OOM kill to bypass the limit
has been added to the -mm tree.  Its filename is
     mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: do not allow task about to OOM kill to bypass the limit

4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully") allowed tasks that already entered a memcg OOM condition to
bypass the memcg limit on subsequent allocation attempts hoping this would
expedite finishing the page fault and executing the kill.

David Rientjes is worried that this breaks memcg isolation guarantees and
since there is no evidence that the bypass actually speeds up fault
processing just change it so that these subsequent charge attempts fail
outright.  The notable exception being __GFP_NOFAIL charges which are
required to bypass the limit regardless.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-bt: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit
+++ a/mm/memcontrol.c
@@ -2694,7 +2694,7 @@ static int __mem_cgroup_try_charge(struc
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
-		goto bypass;
+		goto nomem;
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch
mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

