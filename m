From: akpm@linux-foundation.org
Subject: [folded] ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch removed from -mm tree
Date: Thu, 31 Mar 2011 11:16:41 -0700
Message-ID: <201103311815.p2VIFb3I019910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758902Ab1CaSPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, chrisw@sous-sol.org, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
has been removed from the -mm tree.  Its filename was
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch

This patch was dropped because it was folded into ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c    |    5 +++--
 mm/memory.c |    2 ++
 mm/rmap.c   |    6 ++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/ksm.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix mm/ksm.c
--- a/mm/ksm.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
+++ a/mm/ksm.c
@@ -883,7 +883,6 @@ static int try_to_merge_one_page(struct 
 	 */
 	if (write_protect_page(vma, page, &orig_pte) == 0) {
 		if (!kpage) {
-			long mapcount = page_mapcount(page);
 			/*
 			 * While we hold page lock, upgrade page from
 			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
@@ -891,10 +890,12 @@ static int try_to_merge_one_page(struct 
 			 */
 			set_page_stable_node(page, NULL);
 			mark_page_accessed(page);
-			if (mapcount)
+#ifdef CONFIG_KSM
+			if (page_mapcount(page))
 				add_zone_page_state(page_zone(page),
 						    NR_KSM_PAGES_SHARING,
 						    mapcount);
+#endif
 			err = 0;
 		} else if (pages_identical(page, kpage))
 			err = replace_page(vma, page, kpage, orig_pte);
diff -puN mm/memory.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix mm/memory.c
--- a/mm/memory.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
+++ a/mm/memory.c
@@ -719,8 +719,10 @@ copy_one_pte(struct mm_struct *dst_mm, s
 			rss[MM_ANONPAGES]++;
 		else
 			rss[MM_FILEPAGES]++;
+#ifdef CONFIG_KSM
 		if (PageKsm(page)) /* follows page_dup_rmap() */
 			inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
+#endif
 	}
 
 out_set_pte:
diff -puN mm/rmap.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix mm/rmap.c
--- a/mm/rmap.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
+++ a/mm/rmap.c
@@ -909,11 +909,12 @@ void do_page_add_anon_rmap(struct page *
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 	}
+#ifdef CONFIG_KSM
 	if (unlikely(PageKsm(page))) {
 		__inc_zone_page_state(page, NR_KSM_PAGES_SHARING);
 		return;
 	}
-
+#endif
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (first)
@@ -971,9 +972,10 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+#ifdef CONFIG_KSM
 	if (PageKsm(page))
 		__dec_zone_page_state(page, NR_KSM_PAGES_SHARING);
-
+#endif
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

