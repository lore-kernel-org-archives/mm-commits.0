From: akpm@linux-foundation.org
Subject: [merged] cgroup-fix-memory-accounting-scalability-in-shrink_page_list.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:54 -0700
Message-ID: <20120801201855.4303F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49185 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2HAUS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:57 -0400
Received: by mail-fa0-f74.google.com with SMTP id 25so342033fat.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: gix memory accounting scalability in shrink_page_list
has been removed from the -mm tree.  Its filename was
     cgroup-fix-memory-accounting-scalability-in-shrink_page_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: memcg: gix memory accounting scalability in shrink_page_list

I noticed in a multi-process parallel files reading benchmark I ran on a 8
socket machine, throughput slowed down by a factor of 8 when I ran the
benchmark within a cgroup container.  I traced the problem to the
following code path (see below) when we are trying to reclaim memory from
file cache.  The res_counter_uncharge function is called on every page
that's reclaimed and created heavy lock contention.  The patch below
allows the reclaimed pages to be uncharged from the resource counter in
batch and recovered the regression.

Tim

     40.67%           usemem  [kernel.kallsyms]                   [k] _raw_spin_lock
                      |
                      --- _raw_spin_lock
                         |
                         |--92.61%-- res_counter_uncharge
                         |          |
                         |          |--100.00%-- __mem_cgroup_uncharge_common
                         |          |          |
                         |          |          |--100.00%-- mem_cgroup_uncharge_cache_page
                         |          |          |          __remove_mapping
                         |          |          |          shrink_page_list
                         |          |          |          shrink_inactive_list
                         |          |          |          shrink_mem_cgroup_zone
                         |          |          |          shrink_zone
                         |          |          |          do_try_to_free_pages
                         |          |          |          try_to_free_pages
                         |          |          |          __alloc_pages_nodemask
                         |          |          |          alloc_pages_current

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~cgroup-fix-memory-accounting-scalability-in-shrink_page_list mm/vmscan.c
--- a/mm/vmscan.c~cgroup-fix-memory-accounting-scalability-in-shrink_page_list
+++ a/mm/vmscan.c
@@ -687,6 +687,7 @@ static unsigned long shrink_page_list(st
 
 	cond_resched();
 
+	mem_cgroup_uncharge_start();
 	while (!list_empty(page_list)) {
 		enum page_references references;
 		struct address_space *mapping;
@@ -953,6 +954,7 @@ keep:
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
+	mem_cgroup_uncharge_end();
 	*ret_nr_dirty += nr_dirty;
 	*ret_nr_writeback += nr_writeback;
 	return nr_reclaimed;
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

origin.patch

