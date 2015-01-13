From: akpm@linux-foundation.org
Subject: + mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
 added to -mm tree
Date: Tue, 13 Jan 2015 14:32:43 -0800
Message-ID: <54b59d0b.cn2MP1gAkIYdnkrl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbAMWco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 17:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix
has been added to the -mm tree.  Its filename is
     mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch

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
Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix mm/memory.c
--- a/mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix
+++ a/mm/memory.c
@@ -2958,8 +2958,8 @@ static int do_cow_fault(struct mm_struct
 			page_cache_release(fault_page);
 		} else {
 			/*
-			 * DAX doesn't have a page to lock, so it uses
-			 * i_mmap_lock()
+			 * The fault handler has no page to lock, so it holds
+			 * i_mmap_lock for read to protect against truncate.
 			 */
 			i_mmap_unlock_read(&vma->vm_file->f_mapping);
 		}
@@ -2973,11 +2973,11 @@ static int do_cow_fault(struct mm_struct
 		unlock_page(fault_page);
 		page_cache_release(fault_page);
 	} else {
-			/*
-			 * DAX doesn't have a page to lock, so it uses
-			 * i_mmap_lock()
-			 */
-			i_mmap_unlock_read(&vma->vm_file->f_mapping);
+		/*
+		 * The fault handler has no page to lock, so it holds
+		 * i_mmap_lock for read to protect against truncate.
+		 */
+		i_mmap_unlock_read(&vma->vm_file->f_mapping);
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
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
dax-add-dax_zero_page_range-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

