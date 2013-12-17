From: akpm@linux-foundation.org
Subject: + mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 16:34:41 -0800
Message-ID: <52af9c21.UOXujQj5M5Qe5qOk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3LQAem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 19:34:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, akpm@linux-foundation.org

Subject: + mm-munlock-fix-potential-race-with-thp-page-split-fix.patch added to -mm tree
To: akpm@linux-foundation.org,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 16:34:41 -0800


The patch titled
     Subject: mm-munlock-fix-potential-race-with-thp-page-split-fix
has been added to the -mm tree.  Its filename is
     mm-munlock-fix-potential-race-with-thp-page-split-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-fix-potential-race-with-thp-page-split-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-munlock-fix-potential-race-with-thp-page-split-fix

avoid a coding-style ugly

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-munlock-fix-potential-race-with-thp-page-split-fix mm/mlock.c
--- a/mm/mlock.c~mm-munlock-fix-potential-race-with-thp-page-split-fix
+++ a/mm/mlock.c
@@ -97,9 +97,9 @@ void mlock_vma_page(struct page *page)
 static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
 {
 	if (PageLRU(page)) {
-		struct lruvec *lruvec = mem_cgroup_page_lruvec(page,
-				page_zone(page));
+		struct lruvec *lruvec;
 
+		lruvec = mem_cgroup_page_lruvec(page, page_zone(page));
 		if (getpage)
 			get_page(page);
 		ClearPageLRU(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
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
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

