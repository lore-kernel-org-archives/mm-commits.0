From: akpm@linux-foundation.org
Subject: [folded] mm-fix-slab-page-flags-corruption-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:45:08 -0700
Message-ID: <20120529214508.EEF6BA021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36460 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2E2VpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:45:11 -0400
Received: by bkty5 with SMTP id y5so263715bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:45:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, abhide@nicira.com, cl@linux.com, penberg@cs.helsinki.fi, pshelar@nicira.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-slab-page-flags-corruption-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-slab-page-flags-corruption-fix.patch

This patch was dropped because it was folded into mm-fix-slab-page-flags-corruption.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-slab-page-flags-corruption-fix

tweak comment text, fix comment layout, fix label indenting

Cc: Amey Bhide <abhide@nicira.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/swap.c~mm-fix-slab-page-flags-corruption-fix mm/swap.c
--- a/mm/swap.c~mm-fix-slab-page-flags-corruption-fix
+++ a/mm/swap.c
@@ -83,13 +83,14 @@ static void put_compound_page(struct pag
 			   get_page_unless_zero(page_head))) {
 			unsigned long flags;
 
-			/* THP can not break up slab pages, avoid taking
-			 * compound_lock(). Slab prefer non atomic bit ops
-			 * on page->flags for better performance. In particular
-			 * slab_unlock() in slub used to be a hot path
-			 * item. It is still hot on arches that do not support
-			 * this_cpu_cmpxchg_double. */
-
+			/*
+			 * THP can not break up slab pages so avoid taking
+			 * compound_lock().  Slab performs non-atomic bit ops
+			 * on page->flags for better performance.  In particular
+			 * slab_unlock() in slub used to be a hot path.  It is
+			 * still hot on arches that do not support
+			 * this_cpu_cmpxchg_double().
+			 */
 			if (PageSlab(page_head)) {
 				if (PageTail(page)) {
 					if (put_page_testzero(page_head))
@@ -110,10 +111,10 @@ static void put_compound_page(struct pag
 			if (unlikely(!PageTail(page))) {
 				/* __split_huge_page_refcount run before us */
 				compound_unlock_irqrestore(page_head, flags);
-			skip_lock:
+skip_lock:
 				if (put_page_testzero(page_head))
 					__put_single_page(page_head);
-			out_put_single:
+out_put_single:
 				if (put_page_testzero(page))
 					__put_single_page(page);
 				return;
@@ -134,7 +135,7 @@ static void put_compound_page(struct pag
 			VM_BUG_ON(atomic_read(&page->_count) != 0);
 			compound_unlock_irqrestore(page_head, flags);
 
-			skip_lock_tail:
+skip_lock_tail:
 			if (put_page_testzero(page_head)) {
 				if (PageHead(page_head))
 					__put_compound_page(page_head);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
tmpfs-support-seek_data-and-seek_hole.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup-fix.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

