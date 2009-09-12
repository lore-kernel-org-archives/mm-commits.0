From: akpm@linux-foundation.org
Subject: + dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch added to -mm tree
Date: Fri, 11 Sep 2009 17:06:00 -0700
Message-ID: <200909120006.n8C060MC023411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252AbZILAGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 20:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com


The patch titled
     /dev/mem: cleanup unxlate_dev_mem_ptr() calls
has been added to the -mm tree.  Its filename is
     dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch

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
Subject: /dev/mem: cleanup unxlate_dev_mem_ptr() calls
From: Wu Fengguang <fengguang.wu@intel.com>

No behaviour change.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls
+++ a/drivers/char/mem.c
@@ -131,6 +131,7 @@ static ssize_t read_mem(struct file * fi
 			size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
+	unsigned long ret;
 	ssize_t read, sz;
 	char *ptr;
 
@@ -169,12 +170,10 @@ static ssize_t read_mem(struct file * fi
 		if (!ptr)
 			return -EFAULT;
 
-		if (copy_to_user(buf, ptr, sz)) {
-			unxlate_dev_mem_ptr(p, ptr);
-			return -EFAULT;
-		}
-
+		ret = copy_to_user(buf, ptr, sz);
 		unxlate_dev_mem_ptr(p, ptr);
+		if (ret)
+			return -EFAULT;
 
 		buf += sz;
 		p += sz;
@@ -232,16 +231,14 @@ static ssize_t write_mem(struct file * f
 		}
 
 		copied = copy_from_user(ptr, buf, sz);
+		unxlate_dev_mem_ptr(p, ptr);
 		if (copied) {
 			written += sz - copied;
-			unxlate_dev_mem_ptr(p, ptr);
 			if (written)
 				break;
 			return -EFAULT;
 		}
 
-		unxlate_dev_mem_ptr(p, ptr);
-
 		buf += sz;
 		p += sz;
 		count -= sz;
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

