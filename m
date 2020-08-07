Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B265FC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 920C02177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781248;
	bh=TWdGH2iD3gJ1mjv8ERqfAFtuk1gCjJcVcJxU+ZVQQQg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iYOUPIIuN9WZ0a7IWqxKaGFa7d2gIS7nwiJr+lCWTDDlCIE7BhXe++27wsnXRGnLD
	 ZSW7ntN5DhAM9ly2cGamQI5AsZ23afBisOJEtgckbVdFsLR7AlrhhGJGw0U22hfd7r
	 ePaHpGM3eV6P58YuXaMwic2LbS8o5qnUEftN2eMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGGUs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgHGGUs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D9D9221E5;
        Fri,  7 Aug 2020 06:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781247;
        bh=TWdGH2iD3gJ1mjv8ERqfAFtuk1gCjJcVcJxU+ZVQQQg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xcHNkCb0WZg+8ob1gUfThBIUT9bnqUtxe1f99Q9v+9U2K7cG4vSgWvbihl6+q/LTp
         c/LAwDUAiZ2nO1u388Sedo14OO08UZMBjvOq1FljHu8V0MURW5bWIc/PRF3VqUaleO
         7Q2nTxyboYcfBY3YS0lnkaMp6fWsAAGIPSg3JnfI=
Date:   Thu, 06 Aug 2020 23:20:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        tj@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 066/163] mm: memcontrol: decouple reference
 counting from page accounting
Message-ID: <20200807062045.cn7WdkUEx%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: decouple reference counting from page accounting

The reference counting of a memcg is currently coupled directly to how
many 4k pages are charged to it.  This doesn't work well with Roman's new
slab controller, which maintains pools of objects and doesn't want to keep
an extra balance sheet for the pages backing those objects.

This unusual refcounting design (reference counts usually track pointers
to an object) is only for historical reasons: memcg used to not take any
css references and simply stalled offlining until all charges had been
reparented and the page counters had dropped to zero.  When we got rid of
the reparenting requirement, the simple mechanical translation was to take
a reference for every charge.

More historical context can be found in commit e8ea14cc6ead ("mm:
memcontrol: take a css reference for each charged page"), commit
64f219938941 ("mm: memcontrol: remove obsolete kmemcg pinning tricks") and
commit b2052564e66d ("mm: memcontrol: continue cache reclaim from offlined
groups").

The new slab controller exposes the limitations in this scheme, so let's
switch it to a more idiomatic reference counting model based on actual
kernel pointers to the memcg:

- The per-cpu stock holds a reference to the memcg its caching

- User pages hold a reference for their page->mem_cgroup. Transparent
  huge pages will no longer acquire tail references in advance, we'll
  get them if needed during the split.

- Kernel pages hold a reference for their page->mem_cgroup

- Pages allocated in the root cgroup will acquire and release css
  references for simplicity. css_get() and css_put() optimize that.

- The current memcg_charge_slab() already hacked around the per-charge
  references; this change gets rid of that as well.

- tcp accounting will handle reference in mem_cgroup_sk_{alloc,free}

Roman:
1) Rebased on top of the current mm tree: added css_get() in
   mem_cgroup_charge(), dropped mem_cgroup_try_charge() part
2) I've reformatted commit references in the commit log to make
   checkpatch.pl happy.

[hughd@google.com: remove css_put_many() from __mem_cgroup_clear_mc()]
  Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2007302011450.2347@eggly.anvils
Link: http://lkml.kernel.org/r/20200623174037.3951353-6-guro@fb.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   39 +++++++++++++++++++++------------------
 mm/slab.h       |    2 --
 2 files changed, 21 insertions(+), 20 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-decouple-reference-counting-from-page-accounting
+++ a/mm/memcontrol.c
@@ -2094,13 +2094,17 @@ static void drain_stock(struct memcg_sto
 {
 	struct mem_cgroup *old = stock->cached;
 
+	if (!old)
+		return;
+
 	if (stock->nr_pages) {
 		page_counter_uncharge(&old->memory, stock->nr_pages);
 		if (do_memsw_account())
 			page_counter_uncharge(&old->memsw, stock->nr_pages);
-		css_put_many(&old->css, stock->nr_pages);
 		stock->nr_pages = 0;
 	}
+
+	css_put(&old->css);
 	stock->cached = NULL;
 }
 
@@ -2136,6 +2140,7 @@ static void refill_stock(struct mem_cgro
 	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached != memcg) { /* reset if necessary */
 		drain_stock(stock);
+		css_get(&memcg->css);
 		stock->cached = memcg;
 	}
 	stock->nr_pages += nr_pages;
@@ -2594,12 +2599,10 @@ force:
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
-	css_get_many(&memcg->css, nr_pages);
 
 	return 0;
 
 done_restock:
-	css_get_many(&memcg->css, batch);
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
@@ -2657,8 +2660,6 @@ static void cancel_charge(struct mem_cgr
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
-
-	css_put_many(&memcg->css, nr_pages);
 }
 #endif
 
@@ -2966,6 +2967,7 @@ int __memcg_kmem_charge_page(struct page
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
+			return 0;
 		}
 	}
 	css_put(&memcg->css);
@@ -2988,12 +2990,11 @@ void __memcg_kmem_uncharge_page(struct p
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 	__memcg_kmem_uncharge(memcg, nr_pages);
 	page->mem_cgroup = NULL;
+	css_put(&memcg->css);
 
 	/* slab pages do not have PageKmemcg flag set */
 	if (PageKmemcg(page))
 		__ClearPageKmemcg(page);
-
-	css_put_many(&memcg->css, nr_pages);
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
@@ -3005,13 +3006,16 @@ void __memcg_kmem_uncharge_page(struct p
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
+	struct mem_cgroup *memcg = head->mem_cgroup;
 	int i;
 
 	if (mem_cgroup_disabled())
 		return;
 
-	for (i = 1; i < HPAGE_PMD_NR; i++)
-		head[i].mem_cgroup = head->mem_cgroup;
+	for (i = 1; i < HPAGE_PMD_NR; i++) {
+		css_get(&memcg->css);
+		head[i].mem_cgroup = memcg;
+	}
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -5452,7 +5456,10 @@ static int mem_cgroup_move_account(struc
 	 */
 	smp_mb();
 
-	page->mem_cgroup = to; 	/* caller should have done css_get */
+	css_get(&to->css);
+	css_put(&from->css);
+
+	page->mem_cgroup = to;
 
 	__unlock_page_memcg(from);
 
@@ -5673,8 +5680,6 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.to))
 			page_counter_uncharge(&mc.to->memory, mc.moved_swap);
 
-		css_put_many(&mc.to->css, mc.moved_swap);
-
 		mc.moved_swap = 0;
 	}
 	memcg_oom_recover(from);
@@ -6502,6 +6507,7 @@ int mem_cgroup_charge(struct page *page,
 	if (ret)
 		goto out_put;
 
+	css_get(&memcg->css);
 	commit_charge(page, memcg);
 
 	local_irq_disable();
@@ -6556,9 +6562,6 @@ static void uncharge_batch(const struct
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
-
-	if (!mem_cgroup_is_root(ug->memcg))
-		css_put_many(&ug->memcg->css, ug->nr_pages);
 }
 
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
@@ -6596,6 +6599,7 @@ static void uncharge_page(struct page *p
 
 	ug->dummy_page = page;
 	page->mem_cgroup = NULL;
+	css_put(&ug->memcg->css);
 }
 
 static void uncharge_list(struct list_head *page_list)
@@ -6701,8 +6705,8 @@ void mem_cgroup_migrate(struct page *old
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
-	css_get_many(&memcg->css, nr_pages);
 
+	css_get(&memcg->css);
 	commit_charge(newpage, memcg);
 
 	local_irq_save(flags);
@@ -6939,8 +6943,7 @@ void mem_cgroup_swapout(struct page *pag
 	mem_cgroup_charge_statistics(memcg, page, -nr_entries);
 	memcg_check_events(memcg, page);
 
-	if (!mem_cgroup_is_root(memcg))
-		css_put_many(&memcg->css, nr_entries);
+	css_put(&memcg->css);
 }
 
 /**
--- a/mm/slab.h~mm-memcontrol-decouple-reference-counting-from-page-accounting
+++ a/mm/slab.h
@@ -402,9 +402,7 @@ static __always_inline int memcg_charge_
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages << PAGE_SHIFT);
 
-	/* transer try_charge() page references to kmem_cache */
 	percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
-	css_put_many(&memcg->css, nr_pages);
 out:
 	css_put(&memcg->css);
 	return ret;
_
