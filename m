From: akpm@linux-foundation.org
Subject: [folded-merged] mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:56:03 -0700
Message-ID: <20130429215603.F04775A41FA@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:53247 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab3D2V4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:56:05 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so110607vbe.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:56:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch

This patch was dropped because it was folded into mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix

use pr_err_ratelimited()

Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/page_io.c~mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix mm/page_io.c
--- a/mm/page_io.c~mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix
+++ a/mm/page_io.c
@@ -244,10 +244,8 @@ int __swap_writepage(struct page *page,
 			 */
 			set_page_dirty(page);
 			ClearPageReclaim(page);
-			if (printk_ratelimit()) {
-				pr_err("Write-error on dio swapfile (%Lu)\n",
-					(unsigned long long)page_file_offset(page));
-			}
+			pr_err_ratelimited("Write error on dio swapfile (%Lu)\n",
+				(unsigned long long)page_file_offset(page));
 		}
 		end_page_writeback(page);
 		return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-speedup-in-__early_pfn_to_nid.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
resource-add-release_mem_region_adjustable.patch
mm-madvise-complete-input-validation-before-taking-lock.patch
clear_refs-sanitize-accepted-commands-declaration.patch
memcg-add-memorypressure_level-events.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

