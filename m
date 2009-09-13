From: akpm@linux-foundation.org
Subject: + dev-mem-remove-redundant-parameter-from-do_write_kmem.patch added to -mm tree
Date: Sun, 13 Sep 2009 16:47:26 -0700
Message-ID: <200909132347.n8DNlQQ0031645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459AbZIMXsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 19:48:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com


The patch titled
     /dev/mem: remove redundant parameter from do_write_kmem()
has been added to the -mm tree.  Its filename is
     dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

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
Subject: /dev/mem: remove redundant parameter from do_write_kmem()
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-remove-redundant-parameter-from-do_write_kmem drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-remove-redundant-parameter-from-do_write_kmem
+++ a/drivers/char/mem.c
@@ -463,7 +463,7 @@ static ssize_t read_kmem(struct file *fi
 
 
 static inline ssize_t
-do_write_kmem(void *p, unsigned long realp, const char __user * buf,
+do_write_kmem(unsigned long p, const char __user *buf,
 	      size_t count, loff_t *ppos)
 {
 	ssize_t written, sz;
@@ -472,12 +472,11 @@ do_write_kmem(void *p, unsigned long rea
 	written = 0;
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
-	if (realp < PAGE_SIZE) {
-		sz = size_inside_page(realp, count);
+	if (p < PAGE_SIZE) {
+		sz = size_inside_page(p, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
-		realp += sz;
 		count -= sz;
 		written += sz;
 	}
@@ -486,14 +485,14 @@ do_write_kmem(void *p, unsigned long rea
 	while (count > 0) {
 		char *ptr;
 
-		sz = size_inside_page(realp, count);
+		sz = size_inside_page(p, count);
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
 		 * uncached, then it must also be accessed uncached
 		 * by the kernel or data corruption may occur
 		 */
-		ptr = xlate_dev_kmem_ptr(p);
+		ptr = xlate_dev_kmem_ptr((char *)p);
 
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
@@ -504,7 +503,6 @@ do_write_kmem(void *p, unsigned long rea
 		}
 		buf += sz;
 		p += sz;
-		realp += sz;
 		count -= sz;
 		written += sz;
 	}
@@ -528,7 +526,7 @@ static ssize_t write_kmem(struct file * 
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-		wrote = do_write_kmem((void *)p, p, buf, to_write, ppos);
+		wrote = do_write_kmem(p, buf, to_write, ppos);
 		if (wrote != to_write)
 			return wrote;
 		p += wrote;
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

