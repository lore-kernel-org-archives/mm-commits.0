From: akpm@linux-foundation.org
Subject: +
 daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch added to -mm tree
Date: Tue, 13 Jan 2015 14:39:18 -0800
Message-ID: <54b59e96.bJSSNpWb7DQOd5vK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbAMWjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 17:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2
has been added to the -mm tree.  Its filename is
     daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch

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
Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2

email->code comments

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2 fs/dax.c
--- a/fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2
+++ a/fs/dax.c
@@ -353,6 +353,10 @@ static int do_dax_fault(struct vm_area_s
 		}
 		size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		if (unlikely(vmf->pgoff >= size)) {
+			/*
+			 * We have a struct page covering a hole in the file
+			 * from a read fault and we've raced with a truncate
+			 */
 			error = -EIO;
 			goto unlock_page;
 		}
@@ -360,7 +364,7 @@ static int do_dax_fault(struct vm_area_s
 
 	error = get_block(inode, block, &bh, 0);
 	if (!error && (bh.b_size < PAGE_SIZE))
-		error = -EIO;
+		error = -EIO;		/* fs corruption? */
 	if (error)
 		goto unlock_page;
 
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
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
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

