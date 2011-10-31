From: akpm@linux-foundation.org
Subject: [folded] mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:47:37 -0700
Message-ID: <201110312347.p9VNlbSx022689@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1JaXrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix
has been removed from the -mm tree.  Its filename was
     mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch

This patch was dropped because it was folded into mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix

add comment

Cc: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/mlock.c~mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix mm/mlock.c
--- a/mm/mlock.c~mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix
+++ a/mm/mlock.c
@@ -112,6 +112,11 @@ void munlock_vma_page(struct page *page)
 		if (!isolate_lru_page(page)) {
 			int ret = SWAP_AGAIN;
 
+			/*
+			 * Optimization: if the page was mapped just once,
+			 * that's our mapping and we don't need to check all the
+			 * other vmas.
+			 */
 			if (page_mapcount(page) > 1)
 				ret = try_to_munlock(page);
 			/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization.patch
mm-neaten-warn_alloc_failed.patch
debug-pagealloc-add-support-for-highmem-pages.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

