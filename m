From: akpm@linux-foundation.org
Subject: + cgroup-fix-memory-accounting-scalability-in-shrink_page_list.patch added to -mm tree
Date: Mon, 23 Jul 2012 16:36:53 -0700
Message-ID: <20120723233654.4CC775C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49172 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2GWXg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 19:36:57 -0400
Received: by bkcjc3 with SMTP id jc3so348534bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 16:36:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz


The patch titled
     Subject: memcg: gix memory accounting scalability in shrink_page_list
has been added to the -mm tree.  Its filename is
     cgroup-fix-memory-accounting-scalability-in-shrink_page_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: memcg: gix memory accounting scalability in shrink_page_list

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

origin.patch
cgroup-fix-memory-accounting-scalability-in-shrink_page_list.patch

