From: akpm@linux-foundation.org
Subject: + memcg-remove-redundant-message-at-swapon.patch added to -mm tree
Date: Wed, 18 Mar 2009 18:57:54 -0700
Message-ID: <200903190201.n2J21HPZ021425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbZCSCDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 22:03:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hugh@veritas.com


The patch titled
     memcg: remove redundant message at swapon
has been added to the -mm tree.  Its filename is
     memcg-remove-redundant-message-at-swapon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove redundant message at swapon
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It's pointed out that swap_cgroup's message at swapon() is nonsense.
Because

  * It can be calculated very easily if all necessary information is
    written in Kconfig.

  * It's not necessary to annoying people at every swapon().

In other view, now, memory usage per swp_entry is reduced to 2bytes from
8bytes(64bit) and I think it's reasonably small.

Reported-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig     |    2 ++
 mm/page_cgroup.c |    7 -------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN init/Kconfig~memcg-remove-redundant-message-at-swapon init/Kconfig
--- a/init/Kconfig~memcg-remove-redundant-message-at-swapon
+++ a/init/Kconfig
@@ -597,6 +597,8 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  is disabled by boot option, this will be automatically disabled and
 	  there will be no overhead from this. Even when you set this config=y,
 	  if boot option "noswapaccount" is set, swap will not be accounted.
+	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
+	  size is 4096bytes, 512k per 1Gbytes of swap.
 
 endif # CGROUPS
 
diff -puN mm/page_cgroup.c~memcg-remove-redundant-message-at-swapon mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-remove-redundant-message-at-swapon
+++ a/mm/page_cgroup.c
@@ -426,13 +426,6 @@ int swap_cgroup_swapon(int type, unsigne
 	}
 	mutex_unlock(&swap_cgroup_mutex);
 
-	printk(KERN_INFO
-		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
-		" and %ld bytes to hold mem_cgroup information per swap ents\n",
-		array_size, length * PAGE_SIZE);
-	printk(KERN_INFO
-	"swap_cgroup can be disabled by noswapaccount boot option.\n");
-
 	return 0;
 nomem:
 	printk(KERN_INFO "couldn't allocate enough memory for swap_cgroup.\n");
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
cgroup-css-id-support.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
devcgroup-avoid-using-cgroup_lock.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
memcg-remove-redundant-message-at-swapon.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch

