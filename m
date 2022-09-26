Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04716C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 17:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiIZRDI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiIZRCv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 13:02:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7124BE8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 09:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91FFBB80B07
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 16:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A93C433C1;
        Mon, 26 Sep 2022 16:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664208281;
        bh=MMxbe301iVqAvgd+uFfDWhEj4hL+A3KKDmwPNG9KHlw=;
        h=Date:To:From:Subject:From;
        b=pSMqUGvgsDEKaFjzB1drfDCtgK/skar0pLIDmF2XkeVcD20aANjoVAKGl7jTTjuGL
         PWcW495nEhKqWgaiLsXPFgNUsuSJ7JJhfYK7AeEND/w6h1ZNpSVCcJZkcjDSLJcitm
         jj1sa4J+1KZtR2ziFNC4zi68fAIWthuVQZ542l1w=
Date:   Mon, 26 Sep 2022 09:04:39 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-deprecate-swapaccounting=0-mode.patch added to mm-unstable branch
Message-Id: <20220926160441.31A93C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: deprecate swapaccounting=0 mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-deprecate-swapaccounting=0-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-deprecate-swapaccounting=0-mode.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: deprecate swapaccounting=0 mode
Date: Mon, 26 Sep 2022 09:57:02 -0400

The swapaccounting= commandline option already does very little today.  To
close a trivial containment failure case, the swap ownership tracking part
of the swap controller has recently become mandatory (see commit
2d1c498072de ("mm: memcontrol: make swap tracking an integral part of
memory control") for details), which makes up the majority of the work
during swapout, swapin, and the swap slot map.

The only thing left under this flag is the page_counter operations and the
visibility of the swap control files in the first place, which are rather
meager savings.  There also aren't many scenarios, if any, where
controlling the memory of a cgroup while allowing it unlimited access to a
global swap space is a workable resource isolation strategy.

On the other hand, there have been several bugs and confusion around the
many possible swap controller states (cgroup1 vs cgroup2 behavior, memory
accounting without swap accounting, memcg runtime disabled).

This puts the maintenance overhead of retaining the toggle above its
practical benefits.  Deprecate it.

Link: https://lkml.kernel.org/r/20220926135704.400818-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/kernel-parameters.txt~mm-memcontrol-deprecate-swapaccounting=0-mode
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6036,12 +6036,6 @@
 			This parameter controls use of the Protected
 			Execution Facility on pSeries.
 
-	swapaccount=	[KNL]
-			Format: [0|1]
-			Enable accounting of swap in memory resource
-			controller if no parameter or 1 is given or disable
-			it if 0 is given (See Documentation/admin-guide/cgroup-v1/memory.rst)
-
 	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
 			Format: { <int> [,<int>] | force | noforce }
 			<int> -- Number of I/O TLB slabs
--- a/mm/memcontrol.c~mm-memcontrol-deprecate-swapaccounting=0-mode
+++ a/mm/memcontrol.c
@@ -88,22 +88,6 @@ static bool cgroup_memory_nosocket __ro_
 /* Kernel memory accounting disabled? */
 static bool cgroup_memory_nokmem __ro_after_init;
 
-/* Whether the swap controller is active */
-#ifdef CONFIG_MEMCG_SWAP
-static bool cgroup_memory_noswap __initdata;
-
-static DEFINE_STATIC_KEY_FALSE(memcg_swap_enabled_key);
-static inline bool memcg_swap_enabled(void)
-{
-	return static_branch_likely(&memcg_swap_enabled_key);
-}
-#else
-static inline bool memcg_swap_enabled(void)
-{
-	return false;
-}
-#endif
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
@@ -111,7 +95,7 @@ static DECLARE_WAIT_QUEUE_HEAD(memcg_cgw
 /* Whether legacy memory+swap accounting is active */
 static bool do_memsw_account(void)
 {
-	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg_swap_enabled();
+	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
@@ -7379,7 +7363,7 @@ void mem_cgroup_swapout(struct folio *fo
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg_swap_enabled() && memcg != swap_memcg) {
+	if (memcg != swap_memcg) {
 		if (!mem_cgroup_is_root(swap_memcg))
 			page_counter_charge(&swap_memcg->memsw, nr_entries);
 		page_counter_uncharge(&memcg->memsw, nr_entries);
@@ -7431,7 +7415,7 @@ int __mem_cgroup_try_charge_swap(struct
 
 	memcg = mem_cgroup_id_get_online(memcg);
 
-	if (memcg_swap_enabled() && !mem_cgroup_is_root(memcg) &&
+	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -7466,7 +7450,7 @@ void __mem_cgroup_uncharge_swap(swp_entr
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
-		if (memcg_swap_enabled() && !mem_cgroup_is_root(memcg)) {
+		if (!mem_cgroup_is_root(memcg)) {
 			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 				page_counter_uncharge(&memcg->swap, nr_pages);
 			else
@@ -7482,7 +7466,7 @@ long mem_cgroup_get_nr_swap_pages(struct
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (!memcg_swap_enabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
@@ -7499,7 +7483,7 @@ bool mem_cgroup_swap_full(struct folio *
 
 	if (vm_swap_full())
 		return true;
-	if (!memcg_swap_enabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (do_memsw_account())
 		return false;
 
 	memcg = folio_memcg(folio);
@@ -7519,10 +7503,9 @@ bool mem_cgroup_swap_full(struct folio *
 
 static int __init setup_swap_account(char *s)
 {
-	bool res;
-
-	if (!kstrtobool(s, &res))
-		cgroup_memory_noswap = !res;
+	pr_warn_once("The swapaccount= commandline option is deprecated. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
@@ -7791,24 +7774,11 @@ static struct cftype zswap_files[] = {
 };
 #endif /* CONFIG_MEMCG_KMEM && CONFIG_ZSWAP */
 
-/*
- * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
- * instead of a core_initcall(), this could mean cgroup_memory_noswap still
- * remains set to false even when memcg is disabled via "cgroup_disable=memory"
- * boot parameter. This may result in premature OOPS inside
- * mem_cgroup_get_nr_swap_pages() function in corner cases.
- */
 static int __init mem_cgroup_swap_init(void)
 {
-	/* No memory control -> no swap control */
 	if (mem_cgroup_disabled())
-		cgroup_memory_noswap = true;
-
-	if (cgroup_memory_noswap)
 		return 0;
 
-	static_branch_enable(&memcg_swap_enabled_key);
-
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
 	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
@@ -7816,6 +7786,6 @@ static int __init mem_cgroup_swap_init(v
 #endif
 	return 0;
 }
-core_initcall(mem_cgroup_swap_init);
+subsys_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_MEMCG_SWAP */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch
mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled.patch
mm-memcontrol-deprecate-swapaccounting=0-mode.patch
mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch
mm-memcontrol-drop-dead-config_memcg_swap-config-symbol.patch

