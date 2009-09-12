From: akpm@linux-foundation.org
Subject: + dev-mem-introduce-size_inside_page.patch added to -mm tree
Date: Fri, 11 Sep 2009 17:05:58 -0700
Message-ID: <200909120005.n8C05wOc023393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700AbZILAGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 20:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com


The patch titled
     /dev/mem: introduce size_inside_page()
has been added to the -mm tree.  Its filename is
     dev-mem-introduce-size_inside_page.patch

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
Subject: /dev/mem: introduce size_inside_page()
From: Wu Fengguang <fengguang.wu@intel.com>

Introduce size_inside_page() to replace duplicate /dev/mem code.

Also apply it to /dev/kmem, whose alignment logic was buggy.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   60 +++++++++++++------------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-introduce-size_inside_page drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-introduce-size_inside_page
+++ a/drivers/char/mem.c
@@ -35,6 +35,19 @@
 # include <linux/efi.h>
 #endif
 
+static inline unsigned long size_inside_page(unsigned long start,
+					     unsigned long size)
+{
+	unsigned long sz;
+
+	if (-start & (PAGE_SIZE - 1))
+		sz = -start & (PAGE_SIZE - 1);
+	else
+		sz = PAGE_SIZE;
+
+	return min_t(unsigned long, sz, size);
+}
+
 /*
  * Architectures vary in how they handle caching for addresses
  * outside of main memory.
@@ -142,15 +155,7 @@ static ssize_t read_mem(struct file * fi
 #endif
 
 	while (count > 0) {
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-p & (PAGE_SIZE - 1))
-			sz = -p & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
-
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, count))
 			return -EPERM;
@@ -209,15 +214,7 @@ static ssize_t write_mem(struct file * f
 #endif
 
 	while (count > 0) {
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-p & (PAGE_SIZE - 1))
-			sz = -p & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
-
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
 			return -EPERM;
@@ -430,15 +427,7 @@ static ssize_t read_kmem(struct file *fi
 		}
 #endif
 		while (low_count > 0) {
-			/*
-			 * Handle first page in case it's not aligned
-			 */
-			if (-p & (PAGE_SIZE - 1))
-				sz = -p & (PAGE_SIZE - 1);
-			else
-				sz = PAGE_SIZE;
-
-			sz = min_t(unsigned long, sz, low_count);
+			sz = size_inside_page(p, low_count);
 
 			/*
 			 * On ia64 if a page has been mapped somewhere as
@@ -462,10 +451,8 @@ static ssize_t read_kmem(struct file *fi
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
-			int len = count;
+			int len = size_inside_page(p, count);
 
-			if (len > PAGE_SIZE)
-				len = PAGE_SIZE;
 			len = vread(kbuf, (char *)p, len);
 			if (!len)
 				break;
@@ -510,15 +497,8 @@ do_write_kmem(void *p, unsigned long rea
 
 	while (count > 0) {
 		char *ptr;
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-realp & (PAGE_SIZE - 1))
-			sz = -realp & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
 
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(realp, count);
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
@@ -578,10 +558,8 @@ static ssize_t write_kmem(struct file * 
 		if (!kbuf)
 			return wrote ? wrote : -ENOMEM;
 		while (count > 0) {
-			int len = count;
+			int len = size_inside_page(p, count);
 
-			if (len > PAGE_SIZE)
-				len = PAGE_SIZE;
 			written = copy_from_user(kbuf, buf, len);
 			if (written) {
 				if (wrote + virtr)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
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
documentation-vm-gitignore-add-page-types.patch
page-types-add-feature-for-walking-process-address-space.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch

