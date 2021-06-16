Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B533C48BE5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29EBC613CD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhFPXY0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234547AbhFPXYZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 19:24:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6FB4613B9;
        Wed, 16 Jun 2021 23:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623885739;
        bh=PwlXYoBE+O3OLVE6HfyNSqV/34zW7EIgdoJTM3qODag=;
        h=Date:From:To:Subject:From;
        b=kVFLYRXEhadHlaZur+LICgo2+Vc4/ZmJey3DH4bhhqNJ3y+i2bxDv4Ea8IsuRtUcY
         xw/9qx8mHpM7VG/nGuHjaiUoiovq4JA3d8c11WAhI5bv4EzK5Lo30ob2TMHegfBGOV
         HuceN/Vg/YbrUBESl14XyaAOBbB1susomgGS15qU=
Date:   Wed, 16 Jun 2021 16:22:18 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@intel.com, feng.tang@intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes.patch
 added to -mm tree
Message-ID: <20210616232218.2qQ5yhs3-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: split pcp->high across all online CPUs for cpuless nodes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: split pcp->high across all online CPUs for cpuless nodes

Dave Hansen reported the following about Feng Tang's tests on a machine
with persistent memory onlined as a DRAM-like device.

  Feng Tang tossed these on a "Cascade Lake" system with 96 threads and
  ~512G of persistent memory and 128G of DRAM.  The PMEM is in "volatile
  use" mode and being managed via the buddy just like the normal RAM.

  The PMEM zones are big ones:

        present  65011712 = 248 G
        high       134595 = 525 M

  The PMEM nodes, of course, don't have any CPUs in them.

  With your series, the pcp->high value per-cpu is 69584 pages or about
  270MB per CPU.  Scaled up by the 96 CPU threads, that's ~26GB of
  worst-case memory in the pcps per zone, or roughly 10% of the size of
  the zone.

This should not cause a problem as such although it could trigger reclaim
due to pages being stored on per-cpu lists for CPUs remote to a node.  It
is not possible to treat cpuless nodes exactly the same as normal nodes
but the worst-case scenario can be mitigated by splitting pcp->high across
all online CPUs for cpuless memory nodes.

Link: https://lkml.kernel.org/r/20210616110743.GK30378@techsingularity.net
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Tang, Feng" <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes
+++ a/mm/page_alloc.c
@@ -6765,7 +6765,7 @@ static int zone_highsize(struct zone *zo
 {
 #ifdef CONFIG_MMU
 	int high;
-	int nr_local_cpus;
+	int nr_split_cpus;
 	unsigned long total_pages;
 
 	if (!percpu_pagelist_high_fraction) {
@@ -6788,10 +6788,14 @@ static int zone_highsize(struct zone *zo
 	 * Split the high value across all online CPUs local to the zone. Note
 	 * that early in boot that CPUs may not be online yet and that during
 	 * CPU hotplug that the cpumask is not yet updated when a CPU is being
-	 * onlined.
+	 * onlined. For memory nodes that have no CPUs, split pcp->high across
+	 * all online CPUs to mitigate the risk that reclaim is triggered
+	 * prematurely due to pages stored on pcp lists.
 	 */
-	nr_local_cpus = max(1U, cpumask_weight(cpumask_of_node(zone_to_nid(zone)))) + cpu_online;
-	high = total_pages / nr_local_cpus;
+	nr_split_cpus = cpumask_weight(cpumask_of_node(zone_to_nid(zone))) + cpu_online;
+	if (!nr_split_cpus)
+		nr_split_cpus = num_online_cpus();
+	high = total_pages / nr_split_cpus;
 
 	/*
 	 * Ensure high is at least batch*4. The multiple is based on the
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix.patch
mm-page_alloc-move-free_the_page.patch
mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch
mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

