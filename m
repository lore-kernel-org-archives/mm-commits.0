From: akpm@linux-foundation.org
Subject: + mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch added to -mm tree
Date: Mon, 11 Apr 2011 14:27:31 -0700
Message-ID: <201104112127.p3BLRVXT002173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170Ab1DKV1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 17:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, minchan.kim@gmail.com, riel@redhat.com, y-goto@jp.fujitsu.com


The patch titled
     mm, mem-hotplug: fix section mismatch. setup_per_zone_inactive_ratio() should be __meminit.
has been added to the -mm tree.  Its filename is
     mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch

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
Subject: mm, mem-hotplug: fix section mismatch. setup_per_zone_inactive_ratio() should be __meminit.
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Commit bce7394a3e ("page-allocator: reset wmark_min and inactive ratio of
zone when hotplug happens") introduced invalid section references.  Now,
setup_per_zone_inactive_ratio() is marked __init and then it can't be
referenced from memory hotplug code.

This patch marks it as __meminit and also marks caller as __ref.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 mm/page_alloc.c     |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit
+++ a/mm/memory_hotplug.c
@@ -400,7 +400,7 @@ static int online_pages_range(unsigned l
 }
 
 
-int online_pages(unsigned long pfn, unsigned long nr_pages)
+int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
@@ -795,7 +795,7 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
-static int offline_pages(unsigned long start_pfn,
+static int __ref offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
 	unsigned long pfn, nr_pages, expire;
diff -puN mm/page_alloc.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit mm/page_alloc.c
--- a/mm/page_alloc.c~mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit
+++ a/mm/page_alloc.c
@@ -5066,7 +5066,7 @@ void setup_per_zone_wmarks(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void calculate_zone_inactive_ratio(struct zone *zone)
+void __meminit calculate_zone_inactive_ratio(struct zone *zone)
 {
 	unsigned int gb, ratio;
 
@@ -5080,7 +5080,7 @@ void calculate_zone_inactive_ratio(struc
 	zone->inactive_ratio = ratio;
 }
 
-static void __init setup_per_zone_inactive_ratio(void)
+static void __meminit setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

