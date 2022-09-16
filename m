Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572DAECAAD8
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiIPUHY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiIPUHB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:07:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543EDB8A45
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 004BBB82930
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02C7C433D6;
        Fri, 16 Sep 2022 20:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358817;
        bh=13oquKsJSYy0RRqh4rQmGevm65B2scs79d0X7YQPpes=;
        h=Date:To:From:Subject:From;
        b=PLFgkIb2KkHE0Q2rGbFcJZERQ672He2mG8g6EC6/sRQcXvOiXMauXfbXBFZuBjxj0
         CNcOdYI2QfjHcNYjXoINn5j1E5s8mdS/oDHYHfEScdLMqLvuYN9haXpG7fqdk+1THA
         i6KVfDoH4xGbLWChuRLYk67VoJ32g9yhDOMzYYts=
Date:   Fri, 16 Sep 2022 13:06:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-helper-macro-sz_1km.patch added to mm-unstable branch
Message-Id: <20220916200657.A02C7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use helper macro SZ_1{K,M}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-helper-macro-sz_1km.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-helper-macro-sz_1km.patch

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
Subject: mm/page_alloc: use helper macro SZ_1{K,M}
Date: Fri, 16 Sep 2022 15:22:53 +0800

Use helper macro SZ_1K and SZ_1M to do the size conversion.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220916072257.9639-13-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-helper-macro-sz_1km
+++ a/mm/page_alloc.c
@@ -7048,7 +7048,7 @@ static int zone_batchsize(struct zone *z
 	 * size is striking a balance between allocation latency
 	 * and zone lock contention.
 	 */
-	batch = min(zone_managed_pages(zone) >> 10, (1024 * 1024) / PAGE_SIZE);
+	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
 	batch /= 4;		/* We effectively *= 4 below */
 	if (batch < 1)
 		batch = 1;
@@ -8523,8 +8523,8 @@ void __init mem_init_print_info(void)
 #endif
 		")\n",
 		K(nr_free_pages()), K(physpages),
-		codesize >> 10, datasize >> 10, rosize >> 10,
-		(init_data_size + init_code_size) >> 10, bss_size >> 10,
+		codesize / SZ_1K, datasize / SZ_1K, rosize / SZ_1K,
+		(init_data_size + init_code_size) / SZ_1K, bss_size / SZ_1K,
 		K(physpages - totalram_pages() - totalcma_pages),
 		K(totalcma_pages)
 #ifdef	CONFIG_HIGHMEM
@@ -9049,8 +9049,8 @@ void *__init alloc_large_system_hash(con
 		numentries -= arch_reserved_kernel_pages();
 
 		/* It isn't necessary when PAGE_SIZE >= 1MB */
-		if (PAGE_SHIFT < 20)
-			numentries = round_up(numentries, (1<<20)/PAGE_SIZE);
+		if (PAGE_SIZE < SZ_1M)
+			numentries = round_up(numentries, SZ_1M / PAGE_SIZE);
 
 #if __BITS_PER_LONG > 32
 		if (!high_limit) {
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

