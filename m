From: akpm@linux-foundation.org
Subject: + mincore-apply-page-table-walker-on-do_mincore-fix.patch added
 to -mm tree
Date: Thu, 12 Jun 2014 15:04:54 -0700
Message-ID: <539a2406.ixAlquo9D3ssv2rM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaFLWEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 18:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, akpm@linux-foundation.org

Subject: + mincore-apply-page-table-walker-on-do_mincore-fix.patch added to -mm tree
To: akpm@linux-foundation.org,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 15:04:54 -0700


The patch titled
     Subject: mincore-apply-page-table-walker-on-do_mincore-fix
has been added to the -mm tree.  Its filename is
     mincore-apply-page-table-walker-on-do_mincore-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mincore-apply-page-table-walker-on-do_mincore-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mincore-apply-page-table-walker-on-do_mincore-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
x86-vdso-remove-one-final-use-of-htole16.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
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

