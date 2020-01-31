From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 047/118] mm/memcontrol.c: cleanup some useless
 code
Date: Thu, 30 Jan 2020 22:13:42 -0800
Message-ID: <20200131061342.PDzXlfRhI%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGNn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:43 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pilgrimtao@gmail.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

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
