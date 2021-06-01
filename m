Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51878C4708F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 19:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376B06136E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 19:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhFATLf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 15:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhFATLe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 15:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D351F6135D;
        Tue,  1 Jun 2021 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622574592;
        bh=gkSzlYbYJXpr9ssVvNAz6Em27nZaz1OgSDqDlc8POOo=;
        h=Date:From:To:Subject:From;
        b=EPwSDG5Aj6X88qCqgEH1wbmfhHmB+2h3KlG5nkvOVNOdM7ahKHveiWIPmR+BGJ15R
         ArM8CylO3tkXYzOxJbc2XkVHFcvBOzEbMJZaevfH6s+2L/gps70Hws4vH3hzI8modL
         GVM4LQcnt8BP8AHHuHfS2vvszNSdOmtNJt8VZK/U=
Date:   Tue, 01 Jun 2021 12:09:51 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [withdrawn]
 mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust.patch
 removed from -mm tree
Message-ID: <20210601190951.0H6zz7TGc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap: add prototype for early_memremap_pgprot_adjust
has been removed from the -mm tree.  Its filename was
     mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/early_ioremap: add prototype for early_memremap_pgprot_adjust

make W=1 generates the following warning for mm/early_ioremap.c

mm/early_ioremap.c:34:24: warning: no previous prototype for `early_memremap_pgprot_adjust' [-Wmissing-prototypes]
 pgprot_t __init __weak early_memremap_pgprot_adjust(resource_size_t phys_addr,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

The weak functions that can be overridden by architectures are declared in
include/asm-generic/early_ioremap.h so add the prototype there.  The
asm/fixmap.h header is need for pgprot_t.

[akpm@linux-foundation.org: x86_64 asm/fixmap.h needs linux/threads.h for NR_CPUS]
Link: https://lkml.kernel.org/r/20210520084809.8576-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/early_ioremap.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/asm-generic/early_ioremap.h~mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust
+++ a/include/asm-generic/early_ioremap.h
@@ -3,6 +3,8 @@
 #define _ASM_EARLY_IOREMAP_H_
 
 #include <linux/types.h>
+#include <linux/threads.h>	/* x86 fixmap.h needs NR_CPUS */
+#include <asm/fixmap.h>
 
 /*
  * early_ioremap() and early_iounmap() are for temporary early boot-time
@@ -20,6 +22,14 @@ extern void early_iounmap(void __iomem *
 extern void early_memunmap(void *addr, unsigned long size);
 
 /*
+ * Weak function called by early_memremap and early_memremap_ro. It does
+ * nothing, but architectures may provide their own version to handle
+ * memory encryption.
+ */
+extern pgprot_t early_memremap_pgprot_adjust(resource_size_t phys_addr,
+					    unsigned long size, pgprot_t prot);
+
+/*
  * Weak function called by early_ioremap_reset(). It does nothing, but
  * architectures may provide their own version to do any needed cleanups.
  */
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

