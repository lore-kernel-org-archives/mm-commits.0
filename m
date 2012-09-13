From: akpm@linux-foundation.org
Subject: + mm-enable-config_compaction-by-default.patch added to -mm tree
Date: Thu, 13 Sep 2012 15:39:52 -0700
Message-ID: <20120913223953.32FAB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58427 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2IMWj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 18:39:56 -0400
Received: by bkcjc3 with SMTP id jc3so82824bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 15:39:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, aquini@redhat.com, mel@csn.ul.ie


The patch titled
     Subject: mm: enable CONFIG_COMPACTION by default
has been added to the -mm tree.  Its filename is
     mm-enable-config_compaction-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: enable CONFIG_COMPACTION by default

Now that lumpy reclaim has been removed, compaction is the only way left
to free up contiguous memory areas.  It is time to just enable
CONFIG_COMPACTION by default.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rafael Aquini <aquini@redhat.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~mm-enable-config_compaction-by-default mm/Kconfig
--- a/mm/Kconfig~mm-enable-config_compaction-by-default
+++ a/mm/Kconfig
@@ -191,6 +191,7 @@ config SPLIT_PTLOCK_CPUS
 # support for memory compaction
 config COMPACTION
 	bool "Allow for memory compaction"
+	def_bool y
 	select MIGRATION
 	depends on MMU
 	help
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-enable-config_compaction-by-default.patch

