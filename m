From: akpm@linux-foundation.org
Subject: + dev-mem-remove-the-written-variable-in-write_kmem-fix.patch added to -mm tree
Date: Mon, 14 Sep 2009 01:33:28 -0700
Message-ID: <200909140833.n8E8XSjG016977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586AbZINId1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 04:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com


The patch titled
     dev-mem-remove-the-written-variable-in-write_kmem-fix
has been added to the -mm tree.  Its filename is
     dev-mem-remove-the-written-variable-in-write_kmem-fix.patch

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
Subject: dev-mem-remove-the-written-variable-in-write_kmem-fix
From: Wu Fengguang <fengguang.wu@intel.com>

> @@ -547,20 +541,20 @@ static ssize_t write_kmem(struct file *
>  		if (!kbuf)
>  			return wrote ? wrote : -ENOMEM;
>  		while (count > 0) {
> -			int len = size_inside_page(p, count);
> +			unsigned long sz = size_inside_page(p, count);
>
> -			written = copy_from_user(kbuf, buf, len);
> -			if (written) {
> +			sz = copy_from_user(kbuf, buf, sz);

Sorry, it introduced a bug: the "sz" will be zero in normal,

> +			if (sz) {
>  				if (wrote + virtr)
>  					break;
>  				free_page((unsigned long)kbuf);
>  				return -EFAULT;
>  			}
> -			len = vwrite(kbuf, (char *)p, len);
> +			sz = vwrite(kbuf, (char *)p, sz);

and get passed to vwrite here.

This patch fixes it, the new var "n" will be used in another bug
fixing patch following this one.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-remove-the-written-variable-in-write_kmem-fix drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-remove-the-written-variable-in-write_kmem-fix
+++ a/drivers/char/mem.c
@@ -542,9 +542,10 @@ static ssize_t write_kmem(struct file * 
 			return wrote ? wrote : -ENOMEM;
 		while (count > 0) {
 			unsigned long sz = size_inside_page(p, count);
+			unsigned long n;
 
-			sz = copy_from_user(kbuf, buf, sz);
-			if (sz) {
+			n = copy_from_user(kbuf, buf, sz);
+			if (n) {
 				if (wrote + virtr)
 					break;
 				free_page((unsigned long)kbuf);
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
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch
documentation-vm-gitignore-add-page-types.patch
page-types-add-feature-for-walking-process-address-space.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch

