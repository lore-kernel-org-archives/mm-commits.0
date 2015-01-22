From: akpm@linux-foundation.org
Subject: +
 revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch added to -mm tree
Date: Thu, 22 Jan 2015 15:31:08 -0800
Message-ID: <54c1883c.nggJapt2H20jYxdb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbAVXbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:31:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range
has been added to the -mm tree.  Its filename is
     revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch

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
Subject: revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/pagewalk.c~revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range mm/pagewalk.c
--- a/mm/pagewalk.c~revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range
+++ a/mm/pagewalk.c
@@ -197,10 +197,7 @@ int walk_page_range(unsigned long addr,
 			 */
 			if ((vma->vm_start <= addr) &&
 			    (vma->vm_flags & VM_PFNMAP)) {
-				if (walk->pte_hole)
-					err = walk->pte_hole(addr, next, walk);
-				if (err)
-					break;
+				next = vma->vm_end;
 				pgd = pgd_offset(walk->mm, next);
 				continue;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

