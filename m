From: akpm@linux-foundation.org
Subject: + mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch added to -mm tree
Date: Fri, 16 Jan 2015 12:31:21 -0800
Message-ID: <54b97519.ki9CMvWY3p0RKdnm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbbAPUbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jan 2015 15:31:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3
has been added to the -mm tree.  Its filename is
     mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch

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
Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3

bah

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3 mm/memory.c
--- a/mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3
+++ a/mm/memory.c
@@ -2898,7 +2898,7 @@ static int do_cow_fault(struct mm_struct
 			 * DAX doesn't have a page to lock, so it uses
 			 * i_mmap_lock()
 			 */
-			i_mmap_unlock_read(&vma->vm_file->f_mapping);
+			i_mmap_unlock_read(vma->vm_file->f_mapping);
 		}
 		goto uncharge_out;
 	}
@@ -2914,7 +2914,7 @@ static int do_cow_fault(struct mm_struct
 			 * DAX doesn't have a page to lock, so it uses
 			 * i_mmap_lock()
 			 */
-			i_mmap_unlock_read(&vma->vm_file->f_mapping);
+			i_mmap_unlock_read(vma->vm_file->f_mapping);
 	}
 	return ret;
 uncharge_out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
dax-add-dax_zero_page_range-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

