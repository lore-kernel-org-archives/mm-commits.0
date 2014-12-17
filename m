From: akpm@linux-foundation.org
Subject: +
 task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch added to -mm tree
Date: Wed, 17 Dec 2014 14:31:18 -0800
Message-ID: <54920436.YvIS42TWAU9N1PJp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaLQWbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 17:31:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhelgaas@google.com, petrcermak@chromium.org, primiano@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
has been added to the -mm tree.  Its filename is
     task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch

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
Subject: task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix

clarify behaviour in documentation

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Petr Cermak <petrcermak@chromium.org>
Cc: Primiano Tucci <primiano@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 ++-
 fs/proc/task_mmu.c                 |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
+++ a/Documentation/filesystems/proc.txt
@@ -488,7 +488,8 @@ To clear the bits for the file mapped pa
 To clear the soft-dirty bit
     > echo 4 > /proc/PID/clear_refs
 
-To reset the peak resident set size ("high water mark")
+To reset the peak resident set size ("high water mark") to the process's
+current value:
     > echo 5 > /proc/PID/clear_refs
 
 Any other value written to /proc/PID/clear_refs will have no effect.
diff -puN fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
+++ a/fs/proc/task_mmu.c
@@ -859,7 +859,7 @@ static ssize_t clear_refs_write(struct f
 	if (type == CLEAR_REFS_MM_HIWATER_RSS) {
 		/*
 		 * Writing 5 to /proc/pid/clear_refs resets the peak resident
-		 * set size.
+		 * set size to this mm's current rss value.
 		 */
 		down_write(&mm->mmap_sem);
 		reset_mm_hiwater_rss(mm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
mailmap-update-akpm-osdlorg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

