Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839E0C6FA8B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiIPUGk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiIPUGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B39B7288
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA26862D75
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD48C433C1;
        Fri, 16 Sep 2022 20:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358796;
        bh=aDkQ7cldfhGalr5mBfS9EdyynlTHoaNJM9N7ps9W4GE=;
        h=Date:To:From:Subject:From;
        b=Hb1xFqD11Zxtu8fnLxkio/O7/Iviny6FSt3wMI6Kp4dxzV3tKkXeyWRltS56MlzBY
         Jz5/b6cFjhz+2Quw7EcIu4Bsmdqr66HqNcJsvUB/c27BR4Gd7FS8cxkmnNPYJcOuj/
         j67sE/5s03EaQpMu4NJwdlcP9wjiilNQCvnlTjtE=
Date:   Fri, 16 Sep 2022 13:06:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-zone_pcp_update-static.patch added to mm-unstable branch
Message-Id: <20220916200636.4CD48C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make zone_pcp_update() static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-zone_pcp_update-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-zone_pcp_update-static.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: make zone_pcp_update() static
Date: Fri, 16 Sep 2022 15:22:43 +0800

Since commit b92ca18e8ca5 ("mm/page_alloc: disassociate the pcp->high from
pcp->batch"), zone_pcp_update() is only used in mm/page_alloc.c.  Move
zone_pcp_update() up to avoid forward declaration and then make it static.
No functional change intended.

Link: https://lkml.kernel.org/r/20220916072257.9639-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 -
 mm/page_alloc.c |   22 +++++++++++-----------
 2 files changed, 11 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-page_alloc-make-zone_pcp_update-static
+++ a/mm/internal.h
@@ -367,7 +367,6 @@ extern int user_min_free_kbytes;
 extern void free_unref_page(struct page *page, unsigned int order);
 extern void free_unref_page_list(struct list_head *list);
 
-extern void zone_pcp_update(struct zone *zone, int cpu_online);
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
--- a/mm/page_alloc.c~mm-page_alloc-make-zone_pcp_update-static
+++ a/mm/page_alloc.c
@@ -7235,6 +7235,17 @@ void __meminit setup_zone_pageset(struct
 }
 
 /*
+ * The zone indicated has a new number of managed_pages; batch sizes and percpu
+ * page high values need to be recalculated.
+ */
+static void zone_pcp_update(struct zone *zone, int cpu_online)
+{
+	mutex_lock(&pcp_batch_high_lock);
+	zone_set_pageset_high_and_batch(zone, cpu_online);
+	mutex_unlock(&pcp_batch_high_lock);
+}
+
+/*
  * Allocate per cpu pagesets and initialize them.
  * Before this call only boot pagesets were available.
  */
@@ -9466,17 +9477,6 @@ void free_contig_range(unsigned long pfn
 EXPORT_SYMBOL(free_contig_range);
 
 /*
- * The zone indicated has a new number of managed_pages; batch sizes and percpu
- * page high values need to be recalculated.
- */
-void zone_pcp_update(struct zone *zone, int cpu_online)
-{
-	mutex_lock(&pcp_batch_high_lock);
-	zone_set_pageset_high_and_batch(zone, cpu_online);
-	mutex_unlock(&pcp_batch_high_lock);
-}
-
-/*
  * Effectively disable pcplists for the zone by setting the high limit to 0
  * and draining all cpus. A concurrent page freeing on another CPU that's about
  * to put the page on pcplist will either finish before the drain and the page
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

