Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95572C6FA8B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 20:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiIUU1M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiIUU1L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 16:27:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEADA4077
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 13:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F2F961D93
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 20:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AA8C433D6;
        Wed, 21 Sep 2022 20:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663792028;
        bh=F/A+763NwYFqCRVa5Kk1QCRFytNmbVbyjP4aI2E8+48=;
        h=Date:To:From:Subject:From;
        b=w1ZdPok1i8FnDhUYrskxRzVdr2ikrvmHQr7c81TQ+urXcUIn7Cx4TJugpxgvtuqhz
         4e/fF9V3SKV+8e29gpoifvNVhj+/nGpFpEnIN64DMN56n4vPRAxCG+aylkl3kprHMa
         9GJAF77+l4vLSTnAtSCOJrGT/xThFFOfk9IALPUo=
Date:   Wed, 21 Sep 2022 13:27:07 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-make-cgroup_memory_noswap-a-static-key.patch added to mm-unstable branch
Message-Id: <20220921202708.A3AA8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make cgroup_memory_noswap a static key
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-make-cgroup_memory_noswap-a-static-key.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-make-cgroup_memory_noswap-a-static-key.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm: memcontrol: make cgroup_memory_noswap a static key
Date: Tue, 20 Sep 2022 02:06:34 +0800

cgroup_memory_noswap is used in many hot path, so make it a static key
to lower the kernel overhead.

Using 8G of ZRAM as SWAP, benchmark using `perf stat -d -d -d --repeat 100`
with the following code snip in a non-root cgroup:

   #include <stdio.h>
   #include <string.h>
   #include <linux/mman.h>
   #include <sys/mman.h>
   #define MB 1024UL * 1024UL
   int main(int argc, char **argv){
      void *p = mmap(NULL, 8000 * MB, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
      memset(p, 0xff, 8000 * MB);
      madvise(p, 8000 * MB, MADV_PAGEOUT);
      memset(p, 0xff, 8000 * MB);
      return 0;
   }

Before:
          7,021.43 msec task-clock                #    0.967 CPUs utilized            ( +-  0.03% )
             4,010      context-switches          #  573.853 /sec                     ( +-  0.01% )
                 0      cpu-migrations            #    0.000 /sec
         2,052,057      page-faults               #  293.661 K/sec                    ( +-  0.00% )
    12,616,546,027      cycles                    #    1.805 GHz                      ( +-  0.06% )  (39.92%)
       156,823,666      stalled-cycles-frontend   #    1.25% frontend cycles idle     ( +-  0.10% )  (40.25%)
       310,130,812      stalled-cycles-backend    #    2.47% backend cycles idle      ( +-  4.39% )  (40.73%)
    18,692,516,591      instructions              #    1.49  insn per cycle
                                                  #    0.01  stalled cycles per insn  ( +-  0.04% )  (40.75%)
     4,907,447,976      branches                  #  702.283 M/sec                    ( +-  0.05% )  (40.30%)
        13,002,578      branch-misses             #    0.26% of all branches          ( +-  0.08% )  (40.48%)
     7,069,786,296      L1-dcache-loads           #    1.012 G/sec                    ( +-  0.03% )  (40.32%)
       649,385,847      L1-dcache-load-misses     #    9.13% of all L1-dcache accesses  ( +-  0.07% )  (40.10%)
     1,485,448,688      L1-icache-loads           #  212.576 M/sec                    ( +-  0.15% )  (39.49%)
        31,628,457      L1-icache-load-misses     #    2.13% of all L1-icache accesses  ( +-  0.40% )  (39.57%)
         6,667,311      dTLB-loads                #  954.129 K/sec                    ( +-  0.21% )  (39.50%)
         5,668,555      dTLB-load-misses          #   86.40% of all dTLB cache accesses  ( +-  0.12% )  (39.03%)
               765      iTLB-loads                #  109.476 /sec                     ( +- 21.81% )  (39.44%)
         4,370,351      iTLB-load-misses          # 214320.09% of all iTLB cache accesses  ( +-  1.44% )  (39.86%)
       149,207,254      L1-dcache-prefetches      #   21.352 M/sec                    ( +-  0.13% )  (40.27%)

           7.25869 +- 0.00203 seconds time elapsed  ( +-  0.03% )

After:
          6,576.16 msec task-clock                #    0.953 CPUs utilized            ( +-  0.10% )
             4,020      context-switches          #  605.595 /sec                     ( +-  0.01% )
                 0      cpu-migrations            #    0.000 /sec
         2,052,056      page-faults               #  309.133 K/sec                    ( +-  0.00% )
    11,967,619,180      cycles                    #    1.803 GHz                      ( +-  0.36% )  (38.76%)
       161,259,240      stalled-cycles-frontend   #    1.38% frontend cycles idle     ( +-  0.27% )  (36.58%)
       253,605,302      stalled-cycles-backend    #    2.16% backend cycles idle      ( +-  4.45% )  (34.78%)
    19,328,171,892      instructions              #    1.65  insn per cycle
                                                  #    0.01  stalled cycles per insn  ( +-  0.10% )  (31.46%)
     5,213,967,902      branches                  #  785.461 M/sec                    ( +-  0.18% )  (30.68%)
        12,385,170      branch-misses             #    0.24% of all branches          ( +-  0.26% )  (34.13%)
     7,271,687,822      L1-dcache-loads           #    1.095 G/sec                    ( +-  0.12% )  (35.29%)
       649,873,045      L1-dcache-load-misses     #    8.93% of all L1-dcache accesses  ( +-  0.11% )  (41.41%)
     1,950,037,608      L1-icache-loads           #  293.764 M/sec                    ( +-  0.33% )  (43.11%)
        31,365,566      L1-icache-load-misses     #    1.62% of all L1-icache accesses  ( +-  0.39% )  (45.89%)
         6,767,809      dTLB-loads                #    1.020 M/sec                    ( +-  0.47% )  (48.42%)
         6,339,590      dTLB-load-misses          #   95.43% of all dTLB cache accesses  ( +-  0.50% )  (46.60%)
               736      iTLB-loads                #  110.875 /sec                     ( +-  1.79% )  (48.60%)
         4,314,836      iTLB-load-misses          # 518653.73% of all iTLB cache accesses  ( +-  0.63% )  (42.91%)
       144,950,156      L1-dcache-prefetches      #   21.836 M/sec                    ( +-  0.37% )  (41.39%)

           6.89935 +- 0.00703 seconds time elapsed  ( +-  0.10% )

The performance is clearly better. There is no significant hotspot
improvement according to perf report, as there are quite a few
callers of memcg_swap_enabled and do_memsw_account (which calls
memcg_swap_enabled). Many pieces of minor optimizations resulted
in lower overhead for the branch predictor, and bettter performance.

Link: https://lkml.kernel.org/r/20220919180634.45958-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memcontrol.c~mm-memcontrol-make-cgroup_memory_noswap-a-static-key
+++ a/mm/memcontrol.c
@@ -90,9 +90,18 @@ static bool cgroup_memory_nokmem __ro_af
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-static bool cgroup_memory_noswap __ro_after_init;
+static bool cgroup_memory_noswap __initdata;
+
+static DEFINE_STATIC_KEY_FALSE(memcg_swap_enabled_key);
+static inline bool memcg_swap_enabled(void)
+{
+	return static_branch_likely(&memcg_swap_enabled_key);
+}
 #else
-#define cgroup_memory_noswap		1
+static inline bool memcg_swap_enabled(void)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -102,7 +111,7 @@ static DECLARE_WAIT_QUEUE_HEAD(memcg_cgw
 /* Whether legacy memory+swap accounting is active */
 static bool do_memsw_account(void)
 {
-	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
+	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg_swap_enabled();
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
@@ -7370,7 +7379,7 @@ void mem_cgroup_swapout(struct folio *fo
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (!cgroup_memory_noswap && memcg != swap_memcg) {
+	if (memcg_swap_enabled() && memcg != swap_memcg) {
 		if (!mem_cgroup_is_root(swap_memcg))
 			page_counter_charge(&swap_memcg->memsw, nr_entries);
 		page_counter_uncharge(&memcg->memsw, nr_entries);
@@ -7422,7 +7431,7 @@ int __mem_cgroup_try_charge_swap(struct
 
 	memcg = mem_cgroup_id_get_online(memcg);
 
-	if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg) &&
+	if (memcg_swap_enabled() && !mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -7454,7 +7463,7 @@ void __mem_cgroup_uncharge_swap(swp_entr
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
-		if (!cgroup_memory_noswap && !mem_cgroup_is_root(memcg)) {
+		if (memcg_swap_enabled() && !mem_cgroup_is_root(memcg)) {
 			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 				page_counter_uncharge(&memcg->swap, nr_pages);
 			else
@@ -7470,7 +7479,7 @@ long mem_cgroup_get_nr_swap_pages(struct
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!memcg_swap_enabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return nr_swap_pages;
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
 		nr_swap_pages = min_t(long, nr_swap_pages,
@@ -7487,7 +7496,7 @@ bool mem_cgroup_swap_full(struct folio *
 
 	if (vm_swap_full())
 		return true;
-	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!memcg_swap_enabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
 	memcg = folio_memcg(folio);
@@ -7795,6 +7804,8 @@ static int __init mem_cgroup_swap_init(v
 	if (cgroup_memory_noswap)
 		return 0;
 
+	static_branch_enable(&memcg_swap_enabled_key);
+
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
 	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-use-memcg_kmem_enabled-in-count_objcg_event.patch
mm-memcontrol-make-cgroup_memory_noswap-a-static-key.patch

