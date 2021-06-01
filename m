Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D43BC47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 04:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A9061364
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 04:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhFAEpw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 00:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAEpv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 00:45:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B8F361186;
        Tue,  1 Jun 2021 04:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622522649;
        bh=FkceylToxtRQNalh0Y8bPsyaPbDv+Jzqi+ijJSSE9Bs=;
        h=Date:From:To:Subject:From;
        b=YsktNCDkAJB93vHihuYJx0mQt5qajzjVrgef7YJjQ8YeF+u8a6cgpCSGXE+oUTcvo
         3f/jVtWjagjAKBa8LPoFmV8fy6TN+lOSKzj7e06xjr9zWbxod1AbBzuaT8z4frI7JV
         KQ8V7XVonSlXyqo7dZevHuHXfX/kmLMGjgPIh6Ek=
Date:   Mon, 31 May 2021 21:44:08 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  + mmmemory_hotplug-drop-unneeded-locking-fix.patch added
 to -mm tree
Message-ID: <20210601044408.Ygs_iaqpD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmmemory_hotplug-drop-unneeded-locking-fix
has been added to the -mm tree.  Its filename is
     mmmemory_hotplug-drop-unneeded-locking-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmemory_hotplug-drop-unneeded-locking-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmemory_hotplug-drop-unneeded-locking-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmmemory_hotplug-drop-unneeded-locking-fix

remove now-unused locals

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-drop-unneeded-locking-fix
+++ a/mm/memory_hotplug.c
@@ -397,7 +397,7 @@ void __ref remove_pfn_range_from_zone(st
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	unsigned long pfn, cur_nr_pages, flags;
+	unsigned long pfn, cur_nr_pages;
 
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
@@ -630,7 +630,6 @@ void __ref move_pfn_range_to_zone(struct
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-	unsigned long flags;
 
 	clear_zone_contiguous(zone);
 
@@ -727,8 +726,6 @@ struct zone *zone_for_pfn_range(int onli
  */
 void adjust_present_page_count(struct zone *zone, long nr_pages)
 {
-	unsigned long flags;
-
 	zone->present_pages += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-rename-the-global-section-array-to-mem_sections-fix.patch
mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
mm-rmap-make-try_to_unmap-void-function-fix.patch
mm-rmap-make-try_to_unmap-void-function-fix-fix.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

