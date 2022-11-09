Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7C5C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiKIBiu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiKIBid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192F5B493
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE8E56181D
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431DFC433C1;
        Wed,  9 Nov 2022 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957905;
        bh=eT4vu/2cgDQ5tGjE7P/b35Mtq0N7BftKONNoGcogghE=;
        h=Date:To:From:Subject:From;
        b=LgNgk5Q7jQ8xW4bydS1jq7qZtnNL2xIc47pfaosJ7i/2WiEEnoJSa0fBh1XoY/uW0
         W8rCxHtoHh5TTQFFFKGCV+9XdfoKBQCaLUsI67Q3ct2ebXRtCg1U0HF15e+wASUWOz
         GdRiZ1dSGiUB6w2DEoSjpbfsVzuFMNuUdTMDi3rc=
Date:   Tue, 08 Nov 2022 17:38:24 -0800
To:     mm-commits@vger.kernel.org, tom.hromatka@oracle.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        kamalesh.babulal@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-use-mem_cgroup_is_root-helper.patch removed from -mm tree
Message-Id: <20221109013825.431DFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: use mem_cgroup_is_root() helper
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-mem_cgroup_is_root-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Subject: mm: memcontrol: use mem_cgroup_is_root() helper
Date: Fri, 30 Sep 2022 19:14:33 +0530

Replace the checks for memcg is root memcg, with mem_cgroup_is_root()
helper.

Link: https://lkml.kernel.org/r/20220930134433.338103-1-kamalesh.babulal@oracle.com
Signed-off-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tom Hromatka <tom.hromatka@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-mem_cgroup_is_root-helper
+++ a/mm/memcontrol.c
@@ -1219,7 +1219,7 @@ static void invalidate_reclaim_iterators
 	 * cgroup root (root_mem_cgroup). So we have to handle
 	 * dead_memcg from cgroup root separately.
 	 */
-	if (last != root_mem_cgroup)
+	if (!mem_cgroup_is_root(last))
 		__invalidate_reclaim_iterators(root_mem_cgroup,
 						dead_memcg);
 }
@@ -1243,7 +1243,7 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 	struct mem_cgroup *iter;
 	int ret = 0;
 
-	BUG_ON(memcg == root_mem_cgroup);
+	BUG_ON(mem_cgroup_is_root(memcg));
 
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
@@ -1272,7 +1272,7 @@ void lruvec_memcg_debug(struct lruvec *l
 	memcg = folio_memcg(folio);
 
 	if (!memcg)
-		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != root_mem_cgroup, folio);
+		VM_BUG_ON_FOLIO(!mem_cgroup_is_root(lruvec_memcg(lruvec)), folio);
 	else
 		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != memcg, folio);
 }
@@ -2036,7 +2036,7 @@ struct mem_cgroup *mem_cgroup_get_oom_gr
 	rcu_read_lock();
 
 	memcg = mem_cgroup_from_task(victim);
-	if (memcg == root_mem_cgroup)
+	if (mem_cgroup_is_root(memcg))
 		goto out;
 
 	/*
@@ -2995,7 +2995,7 @@ static struct obj_cgroup *__get_obj_cgro
 {
 	struct obj_cgroup *objcg = NULL;
 
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
@@ -7163,7 +7163,7 @@ void mem_cgroup_sk_alloc(struct sock *sk
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
-	if (memcg == root_mem_cgroup)
+	if (mem_cgroup_is_root(memcg))
 		goto out;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
 		goto out;
@@ -7298,7 +7298,7 @@ static struct mem_cgroup *mem_cgroup_id_
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
 		 */
-		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
+		if (WARN_ON_ONCE(mem_cgroup_is_root(memcg))) {
 			VM_BUG_ON(1);
 			break;
 		}
@@ -7462,7 +7462,7 @@ long mem_cgroup_get_nr_swap_pages(struct
 
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
 				      READ_ONCE(memcg->swap.max) -
 				      page_counter_read(&memcg->swap));
@@ -7484,7 +7484,7 @@ bool mem_cgroup_swap_full(struct folio *
 	if (!memcg)
 		return false;
 
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
@@ -7648,7 +7648,7 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 		return true;
 
 	original_memcg = get_mem_cgroup_from_objcg(objcg);
-	for (memcg = original_memcg; memcg != root_mem_cgroup;
+	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
 	     memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
 		unsigned long pages;
_

Patches currently in -mm which might be from kamalesh.babulal@oracle.com are


