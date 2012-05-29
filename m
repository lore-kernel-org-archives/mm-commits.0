From: akpm@linux-foundation.org
Subject: [folded] tmpfs-support-seek_data-and-seek_hole-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:44:37 -0700
Message-ID: <20120529214437.AD912A021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56088 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2E2Voj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:44:39 -0400
Received: by were53 with SMTP id e53so266105wer.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:44:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs-support-seek_data-and-seek_hole-fix
has been removed from the -mm tree.  Its filename was
     tmpfs-support-seek_data-and-seek_hole-fix.patch

This patch was dropped because it was folded into tmpfs-support-seek_data-and-seek_hole.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tmpfs-support-seek_data-and-seek_hole-fix

fix warning with CONFIG_TMPFS=n

mm/shmem.c:444: warning: 'shmem_seek_hole_data' defined but not used

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  100 +++++++++++++++++++++++++--------------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff -puN mm/shmem.c~tmpfs-support-seek_data-and-seek_hole-fix mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-seek_data-and-seek_hole-fix
+++ a/mm/shmem.c
@@ -439,56 +439,6 @@ void shmem_unlock_mapping(struct address
 }
 
 /*
- * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
- */
-static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
-				    pgoff_t index, pgoff_t end, int origin)
-{
-	struct page *page;
-	struct pagevec pvec;
-	pgoff_t indices[PAGEVEC_SIZE];
-	bool done = false;
-	int i;
-
-	pagevec_init(&pvec, 0);
-	pvec.nr = 1;		/* start small: we may be there already */
-	while (!done) {
-		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-					pvec.nr, pvec.pages, indices);
-		if (!pvec.nr) {
-			if (origin == SEEK_DATA)
-				index = end;
-			break;
-		}
-		for (i = 0; i < pvec.nr; i++, index++) {
-			if (index < indices[i]) {
-				if (origin == SEEK_HOLE) {
-					done = true;
-					break;
-				}
-				index = indices[i];
-			}
-			page = pvec.pages[i];
-			if (page && !radix_tree_exceptional_entry(page)) {
-				if (!PageUptodate(page))
-					page = NULL;
-			}
-			if (index >= end ||
-			    (page && origin == SEEK_DATA) ||
-			    (!page && origin == SEEK_HOLE)) {
-				done = true;
-				break;
-			}
-		}
-		shmem_deswap_pagevec(&pvec);
-		pagevec_release(&pvec);
-		pvec.nr = PAGEVEC_SIZE;
-		cond_resched();
-	}
-	return index;
-}
-
-/*
  * Remove range of pages and swap entries from radix tree, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
  */
@@ -1724,6 +1674,56 @@ static ssize_t shmem_file_splice_read(st
 	return error;
 }
 
+/*
+ * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
+ */
+static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
+				    pgoff_t index, pgoff_t end, int origin)
+{
+	struct page *page;
+	struct pagevec pvec;
+	pgoff_t indices[PAGEVEC_SIZE];
+	bool done = false;
+	int i;
+
+	pagevec_init(&pvec, 0);
+	pvec.nr = 1;		/* start small: we may be there already */
+	while (!done) {
+		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
+					pvec.nr, pvec.pages, indices);
+		if (!pvec.nr) {
+			if (origin == SEEK_DATA)
+				index = end;
+			break;
+		}
+		for (i = 0; i < pvec.nr; i++, index++) {
+			if (index < indices[i]) {
+				if (origin == SEEK_HOLE) {
+					done = true;
+					break;
+				}
+				index = indices[i];
+			}
+			page = pvec.pages[i];
+			if (page && !radix_tree_exceptional_entry(page)) {
+				if (!PageUptodate(page))
+					page = NULL;
+			}
+			if (index >= end ||
+			    (page && origin == SEEK_DATA) ||
+			    (!page && origin == SEEK_HOLE)) {
+				done = true;
+				break;
+			}
+		}
+		shmem_deswap_pagevec(&pvec);
+		pagevec_release(&pvec);
+		pvec.nr = PAGEVEC_SIZE;
+		cond_resched();
+	}
+	return index;
+}
+
 static loff_t shmem_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct address_space *mapping;
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

