From: akpm@linux-foundation.org
Subject: + dev-mem-make-size_inside_page-logic-straight.patch added to -mm tree
Date: Sun, 13 Sep 2009 16:47:21 -0700
Message-ID: <200909132347.n8DNlLe7031419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbZIMXsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 19:48:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com


The patch titled
     /dev/mem: make size_inside_page() logic straight
has been added to the -mm tree.  Its filename is
     dev-mem-make-size_inside_page-logic-straight.patch

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
Subject: /dev/mem: make size_inside_page() logic straight
From: Wu Fengguang <fengguang.wu@intel.com>

Also convert more size_inside_page() users.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-make-size_inside_page-logic-straight drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-make-size_inside_page-logic-straight
+++ a/drivers/char/mem.c
@@ -40,12 +40,9 @@ static inline unsigned long size_inside_
 {
 	unsigned long sz;
 
-	if (-start & (PAGE_SIZE - 1))
-		sz = -start & (PAGE_SIZE - 1);
-	else
-		sz = PAGE_SIZE;
+	sz = PAGE_SIZE - (start & (PAGE_SIZE - 1));
 
-	return min_t(unsigned long, sz, size);
+	return min(sz, size);
 }
 
 /*
@@ -140,9 +137,7 @@ static ssize_t read_mem(struct file * fi
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (p < PAGE_SIZE) {
-		sz = PAGE_SIZE - p;
-		if (sz > count) 
-			sz = count; 
+		sz = size_inside_page(p, count);
 		if (sz > 0) {
 			if (clear_user(buf, sz))
 				return -EFAULT;
@@ -203,9 +198,7 @@ static ssize_t write_mem(struct file * f
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (p < PAGE_SIZE) {
-		unsigned long sz = PAGE_SIZE - p;
-		if (sz > count)
-			sz = count;
+		sz = size_inside_page(p, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
@@ -414,15 +407,14 @@ static ssize_t read_kmem(struct file *fi
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 		/* we don't have page 0 mapped on sparc and m68k.. */
 		if (p < PAGE_SIZE && low_count > 0) {
-			size_t tmp = PAGE_SIZE - p;
-			if (tmp > low_count) tmp = low_count;
-			if (clear_user(buf, tmp))
+			sz = size_inside_page(p, low_count);
+			if (clear_user(buf, sz))
 				return -EFAULT;
-			buf += tmp;
-			p += tmp;
-			read += tmp;
-			low_count -= tmp;
-			count -= tmp;
+			buf += sz;
+			p += sz;
+			read += sz;
+			low_count -= sz;
+			count -= sz;
 		}
 #endif
 		while (low_count > 0) {
@@ -482,9 +474,7 @@ do_write_kmem(void *p, unsigned long rea
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (realp < PAGE_SIZE) {
-		unsigned long sz = PAGE_SIZE - realp;
-		if (sz > count)
-			sz = count;
+		sz = size_inside_page(realp, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
libfs-return-error-code-on-failed-attr-set.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
mm-do-batched-scans-for-mem_cgroup.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch
documentation-vm-gitignore-add-page-types.patch
page-types-add-feature-for-walking-process-address-space.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch

