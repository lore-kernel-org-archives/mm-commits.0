From: akpm@linux-foundation.org
Subject: + mm-drop-vm_total_pages.patch added to -mm tree
Date: Sat, 20 Jun 2020 15:55:14 -0700
Message-ID: <20200620225514.uyL12%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgFTWzP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 18:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, richard.weiyang@gmail.com, minchan@kernel.org, mhocko@suse.com, hannes@cmpxchg.org, david@redhat.com


The patch titled
     Subject: mm: remove vm_total_pages
has been added to the -mm tree.  Its filename is
     mm-drop-vm_total_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-vm_total_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-vm_total_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove vm_total_pages

The global variable "vm_total_pages" is a relic from older days.  There is
only a single user that reads the variable - build_all_zonelists() - and
the first thing it does is update it.

Use a local variable in build_all_zonelists() instead and remove the
global variable.

Link: http://lkml.kernel.org/r/20200619132410.23859-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/memory_hotplug.c  |    3 ---
 mm/page-writeback.c  |    6 ++----
 mm/page_alloc.c      |    2 ++
 mm/vmscan.c          |    5 -----
 5 files changed, 4 insertions(+), 13 deletions(-)

--- a/include/linux/swap.h~mm-drop-vm_total_pages
+++ a/include/linux/swap.h
@@ -372,7 +372,6 @@ extern unsigned long mem_cgroup_shrink_n
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
-extern unsigned long vm_total_pages;
 
 extern unsigned long reclaim_pages(struct list_head *page_list);
 #ifdef CONFIG_NUMA
--- a/mm/memory_hotplug.c~mm-drop-vm_total_pages
+++ a/mm/memory_hotplug.c
@@ -844,8 +844,6 @@ int __ref online_pages(unsigned long pfn
 	kswapd_run(nid);
 	kcompactd_run(nid);
 
-	vm_total_pages = nr_free_pagecache_pages();
-
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_ONLINE, &arg);
@@ -1595,7 +1593,6 @@ static int __ref __offline_pages(unsigne
 		kcompactd_stop(node);
 	}
 
-	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
--- a/mm/page_alloc.c~mm-drop-vm_total_pages
+++ a/mm/page_alloc.c
@@ -5919,6 +5919,8 @@ build_all_zonelists_init(void)
  */
 void __ref build_all_zonelists(pg_data_t *pgdat)
 {
+	unsigned long vm_total_pages;
+
 	if (system_state == SYSTEM_BOOTING) {
 		build_all_zonelists_init();
 	} else {
--- a/mm/page-writeback.c~mm-drop-vm_total_pages
+++ a/mm/page-writeback.c
@@ -2076,13 +2076,11 @@ static int page_writeback_cpu_online(uns
  * Called early on to tune the page writeback dirty limits.
  *
  * We used to scale dirty pages according to how total memory
- * related to pages that could be allocated for buffers (by
- * comparing nr_free_buffer_pages() to vm_total_pages.
+ * related to pages that could be allocated for buffers.
  *
  * However, that was when we used "dirty_ratio" to scale with
  * all memory, and we don't do that any more. "dirty_ratio"
- * is now applied to total non-HIGHPAGE memory (by subtracting
- * totalhigh_pages from vm_total_pages), and as such we can't
+ * is now applied to total non-HIGHPAGE memory, and as such we can't
  * get into the old insane situation any more where we had
  * large amounts of dirty pages compared to a small amount of
  * non-HIGHMEM memory.
--- a/mm/vmscan.c~mm-drop-vm_total_pages
+++ a/mm/vmscan.c
@@ -170,11 +170,6 @@ struct scan_control {
  * From 0 .. 200.  Higher means more swappy.
  */
 int vm_swappiness = 60;
-/*
- * The total number of pages which are beyond the high watermark within all
- * zones.
- */
-unsigned long vm_total_pages;
 
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
_

Patches currently in -mm which might be from david@redhat.com are

mm-drop-vm_total_pages.patch
mm-page_alloc-drop-nr_free_pagecache_pages.patch
