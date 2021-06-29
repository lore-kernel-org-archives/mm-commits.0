Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457CFC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FCDE61CE7
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhF2AhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhF2AhG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA5C61CDC;
        Tue, 29 Jun 2021 00:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926880;
        bh=Ux97QL0Jffk6fBp6AGRGOnIo8TkVsKexVyKBi8bgSCs=;
        h=Date:From:To:Subject:From;
        b=aYFiOxn+W5DjChxUV96J5nRegm67tF5l4hECHOiyGof7s6CwjiKS7DYFwM1zPjzEW
         GtCXJGWu3jnWBFE+WGDYlOSVMaYS+V4TD65TxCXB1oBmGuGRIZbzpt3JLVOOZyDRg0
         FlQeleXAr0DlStMVSfW88rRakOHn68S9I4bWSftk=
Date:   Mon, 28 Jun 2021 17:34:39 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix.patch removed
 from -mm tree
Message-ID: <20210629003439.Vw7qNIV-B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: introduce vm.percpu_pagelist_high_fraction -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix.patch

This patch was dropped because it was folded into mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: introduce vm.percpu_pagelist_high_fraction -fix

Vlastimil Babka pointed out that the documentation for
vm.percpu_pagelist_high_fraction is potentially misleading so fix it.

This is a fix to the mmotm patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch

Link: https://lkml.kernel.org/r/20210528151010.GQ30378@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -793,15 +793,16 @@ why oom happens. You can get snapshot.
 percpu_pagelist_high_fraction
 =============================
 
-This is the fraction of pages in each zone that are allocated for each
-per cpu page list.  The min value for this is 8.  It means that we do
-not allow more than 1/8th of pages in each zone to be allocated in any
-single per_cpu_pagelist.  This entry only changes the value of hot per
-cpu pagelists. User can specify a number like 100 to allocate 1/100th
-of each zone to each per cpu page list.
+This is the fraction of pages in each zone that are can be stored to
+per-cpu page lists. It is an upper boundary that is divided depending
+on the number of online CPUs. The min value for this is 8 which means
+that we do not allow more than 1/8th of pages in each zone to be stored
+on per-cpu page lists. This entry only changes the value of hot per-cpu
+page lists. A user can specify a number like 100 to allocate 1/100th of
+each zone between per-cpu lists.
 
-The batch value of each per cpu pagelist remains the same regardless of the
-value of the high fraction so allocation latencies are unaffected.
+The batch value of each per-cpu page list remains the same regardless of
+the value of the high fraction so allocation latencies are unaffected.
 
 The initial value is zero. Kernel uses this value to set the high pcp->high
 mark based on the low watermark for the zone and the number of local
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
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

