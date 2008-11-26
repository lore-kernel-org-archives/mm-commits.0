From: akpm@linux-foundation.org
Subject: + swapfile-remove-surplus-whitespace.patch added to -mm tree
Date: Tue, 25 Nov 2008 17:23:27 -0800
Message-ID: <200811260123.mAQ1NRgx008495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbYKZBX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:23:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     swapfile: remove surplus whitespace
has been added to the -mm tree.  Its filename is
     swapfile-remove-surplus-whitespace.patch

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
Subject: swapfile: remove surplus whitespace
From: Hugh Dickins <hugh@veritas.com>

Remove trailing whitespace from swapfile.c, and odd swap_show() alignment.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/swapfile.c~swapfile-remove-surplus-whitespace mm/swapfile.c
--- a/mm/swapfile.c~swapfile-remove-surplus-whitespace
+++ a/mm/swapfile.c
@@ -92,7 +92,7 @@ static inline unsigned long scan_swap_ma
 	unsigned long offset, last_in_cluster;
 	int latency_ration = LATENCY_LIMIT;
 
-	/* 
+	/*
 	 * We try to cluster swap pages by allocating them sequentially
 	 * in swap.  Once we've allocated SWAPFILE_CLUSTER pages this
 	 * way, however, we resort to first-free allocation, starting
@@ -269,7 +269,7 @@ bad_nofile:
 	printk(KERN_ERR "swap_free: %s%08lx\n", Bad_file, entry.val);
 out:
 	return NULL;
-}	
+}
 
 static int swap_entry_free(struct swap_info_struct *p, unsigned long offset)
 {
@@ -736,10 +736,10 @@ static int try_to_unuse(unsigned int typ
 			break;
 		}
 
-		/* 
+		/*
 		 * Get a page for the entry, using the existing swap
 		 * cache page if there is one.  Otherwise, get a clean
-		 * page and read the swap into it. 
+		 * page and read the swap into it.
 		 */
 		swap_map = &si->swap_map[i];
 		entry = swp_entry(type, i);
@@ -1202,7 +1202,7 @@ asmlinkage long sys_swapoff(const char _
 	char * pathname;
 	int i, type, prev;
 	int err;
-	
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -1395,12 +1395,12 @@ static int swap_show(struct seq_file *sw
 	file = ptr->swap_file;
 	len = seq_path(swap, &file->f_path, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%u\t%u\t%d\n",
-		       len < 40 ? 40 - len : 1, " ",
-		       S_ISBLK(file->f_path.dentry->d_inode->i_mode) ?
+			len < 40 ? 40 - len : 1, " ",
+			S_ISBLK(file->f_path.dentry->d_inode->i_mode) ?
 				"partition" : "file\t",
-		       ptr->pages << (PAGE_SHIFT - 10),
-		       ptr->inuse_pages << (PAGE_SHIFT - 10),
-		       ptr->prio);
+			ptr->pages << (PAGE_SHIFT - 10),
+			ptr->inuse_pages << (PAGE_SHIFT - 10),
+			ptr->prio);
 	return 0;
 }
 
@@ -1556,7 +1556,7 @@ asmlinkage long sys_swapon(const char __
 		error = -EINVAL;
 		goto bad_swap;
 	}
-	
+
 	switch (swap_header_version) {
 	case 1:
 		printk(KERN_ERR "version 0 swap is no longer supported. "
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
make-get_user_pages-interruptible.patch
make-get_user_pages-interruptible-update.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

