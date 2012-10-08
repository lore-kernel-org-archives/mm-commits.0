From: akpm@linux-foundation.org
Subject: [withdrawn] lib-radix-treec-suppress-warning.patch removed from -mm tree
Date: Mon, 08 Oct 2012 15:01:12 -0700
Message-ID: <20121008220114.8FA51100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35921 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab2JHWBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 18:01:16 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so530659vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 15:01:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/radix-tree.c: suppress warning
has been removed from the -mm tree.  Its filename was
     lib-radix-treec-suppress-warning.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/radix-tree.c: suppress warning

sparc64:

lib/radix-tree.c: In function `radix_tree_next_chunk':
lib/radix-tree.c:768: warning: comparison is always false due to limited range of data type



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~lib-radix-treec-suppress-warning lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-treec-suppress-warning
+++ a/lib/radix-tree.c
@@ -765,7 +765,7 @@ restart:
 		tag_bit  = offset % BITS_PER_LONG;
 		iter->tags = node->tags[tag][tag_long] >> tag_bit;
 		/* This never happens if RADIX_TREE_TAG_LONGS == 1 */
-		if (tag_long < RADIX_TREE_TAG_LONGS - 1) {
+		if (tag_long + 1 < RADIX_TREE_TAG_LONGS) {
 			/* Pick tags from next element */
 			if (tag_bit)
 				iter->tags |= node->tags[tag][tag_long + 1] <<
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

