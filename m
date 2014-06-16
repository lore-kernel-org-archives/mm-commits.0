From: akpm@linux-foundation.org
Subject: [nacked] mincore-apply-page-table-walker-on-do_mincore-fix.patch
 removed from -mm tree
Date: Mon, 16 Jun 2014 16:32:48 -0700
Message-ID: <539f7ea0.g4jF7hoEPyP+ebac%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaFPXcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, akpm@linux-foundation.org


The patch titled
     Subject: mincore-apply-page-table-walker-on-do_mincore-fix
has been removed from the -mm tree.  Its filename was
     mincore-apply-page-table-walker-on-do_mincore-fix.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mincore-apply-page-table-walker-on-do_mincore-fix

mm/mincore.c: In function 'do_mincore':
mm/mincore.c:166: warning: ISO C90 forbids mixed declarations and code

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix mm/mincore.c
--- a/mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix
+++ a/mm/mincore.c
@@ -151,32 +151,34 @@ static int mincore_pmd(pmd_t *pmd, unsig
  * all the arguments, we hold the mmap semaphore: we should
  * just return the amount of info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
+static long do_mincore(unsigned long addr, unsigned long pages,
+		       unsigned char *vec)
 {
 	struct vm_area_struct *vma;
-	unsigned long end;
 	int err;
-
-	vma = find_vma(current->mm, addr);
-	if (!vma || addr < vma->vm_start)
-		return -ENOMEM;
-
-	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
-
 	struct mm_walk mincore_walk = {
 		.pmd_entry = mincore_pmd,
 		.pte_entry = mincore_pte,
 		.pte_hole = mincore_hole,
 		.hugetlb_entry = mincore_hugetlb,
-		.mm = vma->vm_mm,
-		.vma = vma,
 		.private = vec,
 	};
+
+	vma = find_vma(current->mm, addr);
+	if (!vma || addr < vma->vm_start)
+		return -ENOMEM;
+	mincore_walk.vma = vma;
+	mincore_walk.mm = vma->vm_mm;
+
 	err = walk_page_vma(vma, &mincore_walk);
-	if (err < 0)
+	if (err < 0) {
 		return err;
-	else
+	} else {
+		unsigned long end;
+
+		end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 		return (end - addr) >> PAGE_SHIFT;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

