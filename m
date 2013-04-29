From: akpm@linux-foundation.org
Subject: [folded-merged] mm-madvise-complete-input-validation-before-taking-lock-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:53:02 -0700
Message-ID: <20130429215302.D08315A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45832 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3D2VxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:53:04 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so193583yha.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:53:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, linux@rasmusvillemoes.dk, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-complete-input-validation-before-taking-lock-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-complete-input-validation-before-taking-lock-fix.patch

This patch was dropped because it was folded into mm-madvise-complete-input-validation-before-taking-lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-complete-input-validation-before-taking-lock-fix

s/out_plug/out/, per David

Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/madvise.c~mm-madvise-complete-input-validation-before-taking-lock-fix mm/madvise.c
--- a/mm/madvise.c~mm-madvise-complete-input-validation-before-taking-lock-fix
+++ a/mm/madvise.c
@@ -509,14 +509,14 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 		/* Still start < end. */
 		error = -ENOMEM;
 		if (!vma)
-			goto out_plug;
+			goto out;
 
 		/* Here start < (end|vma->vm_end). */
 		if (start < vma->vm_start) {
 			unmapped_error = -ENOMEM;
 			start = vma->vm_start;
 			if (start >= end)
-				goto out_plug;
+				goto out;
 		}
 
 		/* Here vma->vm_start <= start < (end|vma->vm_end) */
@@ -527,19 +527,19 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
 		error = madvise_vma(vma, &prev, start, tmp, behavior);
 		if (error)
-			goto out_plug;
+			goto out;
 		start = tmp;
 		if (prev && start < prev->vm_end)
 			start = prev->vm_end;
 		error = unmapped_error;
 		if (start >= end)
-			goto out_plug;
+			goto out;
 		if (prev)
 			vma = prev->vm_next;
 		else	/* madvise_remove dropped mmap_sem */
 			vma = find_vma(current->mm, start);
 	}
-out_plug:
+out:
 	blk_finish_plug(&plug);
 	if (write)
 		up_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-speedup-in-__early_pfn_to_nid.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
resource-add-release_mem_region_adjustable.patch
mm-madvise-complete-input-validation-before-taking-lock.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

