From: akpm@linux-foundation.org
Subject: [folded] debug-pagealloc-add-support-for-highmem-pages-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:45:50 -0700
Message-ID: <201110312345.p9VNjoUw007000@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42714 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1JaXpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: debug-pagealloc-add-support-for-highmem-pages-fix
has been removed from the -mm tree.  Its filename was
     debug-pagealloc-add-support-for-highmem-pages-fix.patch

This patch was dropped because it was folded into debug-pagealloc-add-support-for-highmem-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: debug-pagealloc-add-support-for-highmem-pages-fix

remove unneeded preempt_disable/enable

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug-pagealloc.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/debug-pagealloc.c~debug-pagealloc-add-support-for-highmem-pages-fix mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~debug-pagealloc-add-support-for-highmem-pages-fix
+++ a/mm/debug-pagealloc.c
@@ -23,14 +23,11 @@ static inline bool page_poison(struct pa
 
 static void poison_page(struct page *page)
 {
-	void *addr;
+	void *addr = kmap_atomic(page);
 
-	preempt_disable();
-	addr = kmap_atomic(page);
 	set_page_poison(page);
 	memset(addr, PAGE_POISON, PAGE_SIZE);
 	kunmap_atomic(addr);
-	preempt_enable();
 }
 
 static void poison_pages(struct page *page, int n)
@@ -82,12 +79,10 @@ static void unpoison_page(struct page *p
 	if (!page_poison(page))
 		return;
 
-	preempt_disable();
 	addr = kmap_atomic(page);
 	check_poison_mem(addr, PAGE_SIZE);
 	clear_page_poison(page);
 	kunmap_atomic(addr);
-	preempt_enable();
 }
 
 static void unpoison_pages(struct page *page, int n)
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
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

