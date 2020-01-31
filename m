From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-some-useless-code.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:18:15 -0800
Message-ID: <20200131231815.Ztk7-Rl7m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgAaXSQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, pilgrimtao@gmail.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm/memcontrol.c: cleanup some useless code
has been removed from the -mm tree.  Its filename was
     mm-cleanup-some-useless-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kaitao Cheng <pilgrimtao@gmail.com>
Subject: mm/memcontrol.c: cleanup some useless code

Compound pages handling in mem_cgroup_migrate is more convoluted than
necessary.  The state is duplicated in compound variable and the same
could be achieved by PageTransHuge check which is trivial and
hpage_nr_pages is already PageTransHuge aware.

It is much simpler to just use hpage_nr_pages for nr_pages and replace the
local variable by PageTransHuge check directly

Link: http://lkml.kernel.org/r/20191210160450.3395-1-pilgrimtao@gmail.com
Signed-off-by: Kaitao Cheng <pilgrimtao@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-cleanup-some-useless-code
+++ a/mm/memcontrol.c
@@ -6633,7 +6633,6 @@ void mem_cgroup_migrate(struct page *old
 {
 	struct mem_cgroup *memcg;
 	unsigned int nr_pages;
-	bool compound;
 	unsigned long flags;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
@@ -6655,8 +6654,7 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	/* Force-charge the new page. The old one will be freed soon */
-	compound = PageTransHuge(newpage);
-	nr_pages = compound ? hpage_nr_pages(newpage) : 1;
+	nr_pages = hpage_nr_pages(newpage);
 
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
@@ -6666,7 +6664,8 @@ void mem_cgroup_migrate(struct page *old
 	commit_charge(newpage, memcg, false);
 
 	local_irq_save(flags);
-	mem_cgroup_charge_statistics(memcg, newpage, compound, nr_pages);
+	mem_cgroup_charge_statistics(memcg, newpage, PageTransHuge(newpage),
+			nr_pages);
 	memcg_check_events(memcg, newpage);
 	local_irq_restore(flags);
 }
_

Patches currently in -mm which might be from pilgrimtao@gmail.com are
