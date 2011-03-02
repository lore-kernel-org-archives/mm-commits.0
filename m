From: akpm@linux-foundation.org
Subject: + ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch added to -mm tree
Date: Wed, 02 Mar 2011 13:57:17 -0800
Message-ID: <201103022232.p22MW4kw005044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758024Ab1CBWcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2011 17:32:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, chrisw@sous-sol.org, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix
has been added to the -mm tree.  Its filename is
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -893,11 +893,12 @@ void do_page_add_anon_rmap(struct page *
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
@@ -955,9 +956,10 @@ void page_add_file_rmap(struct page *pag
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

cpuset-add-a-missing-unlock-in-cpuset_write_resmask-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

