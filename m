From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch removed from -mm
 tree
Date: Thu, 02 Jan 2014 12:56:25 -0800
Message-ID: <52c5d279.fJcpo/VmHQmlNjN8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaABU4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jan 2014 15:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de, hughd@google.com, aarcange@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 02 Jan 2014 12:56:25 -0800


The patch titled
     Subject: mm-munlock-fix-deadlock-in-__munlock_pagevec-fix
has been removed from the -mm tree.  Its filename was
     mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch

This patch was dropped because it was folded into mm-munlock-fix-deadlock-in-__munlock_pagevec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-munlock-fix-deadlock-in-__munlock_pagevec-fix

Cc: <stable@vger.kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/mlock.c~mm-munlock-fix-deadlock-in-__munlock_pagevec-fix mm/mlock.c
--- a/mm/mlock.c~mm-munlock-fix-deadlock-in-__munlock_pagevec-fix
+++ a/mm/mlock.c
@@ -344,12 +344,9 @@ skip_munlock:
 	spin_unlock_irq(&zone->lru_lock);
 
 	/* Now we can release pins of pages that we are not munlocking */
-	for (i = 0; i < pagevec_count(&pvec_putback); i++) {
-		put_page(pvec_putback.pages[i]);
-	}
+	pagevec_release(&pvec_putback);
 
 	/* Phase 2: page munlock */
-	pagevec_init(&pvec_putback, 0);
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

