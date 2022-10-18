Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28577C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJRArd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJRArd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:47:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C41A286C6
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C18B819D9
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2486DC433D7;
        Tue, 18 Oct 2022 00:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666054048;
        bh=/yqaEyY9SKfatmRI5s0WhMQw2l08v5xM/7kldo2hqQ0=;
        h=Date:To:From:Subject:From;
        b=vbZPTaFW/HH1kT6PuzzKjTQmTzs7Y6bjN6vIEfqE+15iYXNPiuJn4iBYoSnl7phee
         8qa1xJw2U1bWfbYNCH6TYoNvngkIsyWcNTom2p9/Vmv2cOswwA+7cbYKg+PYNI5mP5
         63J4PtnqTpLXHWfQNqQAFCPIaeB/lafbl/37df4U=
Date:   Mon, 17 Oct 2022 17:47:27 -0700
To:     mm-commits@vger.kernel.org, tom.hromatka@oracle.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        kamalesh.babulal@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-use-mem_cgroup_is_root-helper.patch added to mm-unstable branch
Message-Id: <20221018004728.2486DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use mem_cgroup_is_root() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-use-mem_cgroup_is_root-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-use-mem_cgroup_is_root-helper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memcontrol-use-mem_cgroup_is_root-helper.patch

