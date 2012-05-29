From: akpm@linux-foundation.org
Subject: [folded] mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:42:37 -0700
Message-ID: <20120529214237.B377EA021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56292 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2E2Vmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:42:39 -0400
Received: by yhgm50 with SMTP id m50so515805yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:42:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujtisu.com, kosaki.motohiro@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch

This patch was dropped because it was folded into mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix

s/mlock_vma_newpage/mlock_vma_newpage/, per Minchan.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 mm/vmscan.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix mm/internal.h
--- a/mm/internal.h~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
+++ a/mm/internal.h
@@ -164,7 +164,7 @@ static inline void munlock_vma_pages_all
  * to determine if it's being mapped into a LOCKED vma.
  * If so, mark page as mlocked.
  */
-static inline int mlock_vma_newpage(struct vm_area_struct *vma,
+static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 				    struct page *page)
 {
 	VM_BUG_ON(PageLRU(page));
@@ -223,7 +223,7 @@ extern unsigned long vma_address(struct 
 				 struct vm_area_struct *vma);
 #endif
 #else /* !CONFIG_MMU */
-static inline int mlock_vma_newpage(struct vm_area_struct *v, struct page *p)
+static inline int mlocked_vma_newpage(struct vm_area_struct *v, struct page *p)
 {
 	return 0;
 }
diff -puN mm/vmscan.c~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
+++ a/mm/vmscan.c
@@ -3321,7 +3321,7 @@ int page_evictable(struct page *page, st
 	if (mapping_unevictable(page_mapping(page)))
 		return 0;
 
-	if (PageMlocked(page) || (vma && mlock_vma_newpage(vma, page)))
+	if (PageMlocked(page) || (vma && mlocked_vma_newpage(vma, page)))
 		return 0;
 
 	return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
tmpfs-support-seek_data-and-seek_hole-fix.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption-fix.patch
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

