From: akpm@linux-foundation.org
Subject: + mmap-einval-not-enomem-when-rejecting-vm_grows.patch added to -mm tree
Date: Tue, 06 Mar 2012 12:35:05 -0800
Message-ID: <20120306203505.B6E33A00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51667 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965229Ab2CFUfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 15:35:08 -0500
Received: by laai8 with SMTP id i8so205018laa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 12:35:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     Subject: mmap: EINVAL not ENOMEM when rejecting VM_GROWS
has been added to the -mm tree.  Its filename is
     mmap-einval-not-enomem-when-rejecting-vm_grows.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mmap: EINVAL not ENOMEM when rejecting VM_GROWS

Currently error is -ENOMEM when rejecting VM_GROWSDOWN|VM_GROWSUP
from shared anonymous: hoist the file case's -EINVAL up for both.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~mmap-einval-not-enomem-when-rejecting-vm_grows mm/mmap.c
--- a/mm/mmap.c~mmap-einval-not-enomem-when-rejecting-vm_grows
+++ a/mm/mmap.c
@@ -1289,8 +1289,9 @@ munmap_back:
 	vma->vm_pgoff = pgoff;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 
+	error = -EINVAL;	/* when rejecting VM_GROWSDOWN|VM_GROWSUP */
+
 	if (file) {
-		error = -EINVAL;
 		if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
 			goto free_vma;
 		if (vm_flags & VM_DENYWRITE) {
_
Subject: Subject: mmap: EINVAL not ENOMEM when rejecting VM_GROWS

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mmap-einval-not-enomem-when-rejecting-vm_grows.patch
linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
tmpfs-security-xattr-setting-on-inode-creation.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
ksm-clean-up-page_trans_compound_anon_split.patch
ksm-cleanup-introduce-ksm_check_mm.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix-2.patch
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
memcg-remove-pcg_file_mapped-fix-42.patch
prio_tree-debugging-patch.patch

