From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch added
 to -mm tree
Date: Thu, 14 Aug 2014 14:58:09 -0700
Message-ID: <53ed30f1.GdRSs7+OQCVEcs8s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:34606 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaHNV6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:58:10 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so421665oac.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:58:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch

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
Subject: fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes

WARNING: Missing a blank line after declarations
#50: FILE: fs/proc/task_mmu.c:135:
+	struct mm_struct *mm = priv->mm;
+	release_task_mempolicy(priv);

ERROR: spaces required around that '?' (ctx:VxW)
#86: FILE: fs/proc/task_mmu.c:220:
+	next = (vma != tail_vma)? tail_vma: NULL;
 	                        ^

ERROR: spaces required around that ':' (ctx:VxW)
#86: FILE: fs/proc/task_mmu.c:220:
+	next = (vma != tail_vma)? tail_vma: NULL;
 	                                  ^

total: 2 errors, 1 warnings, 65 lines checked

./patches/fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes
+++ a/fs/proc/task_mmu.c
@@ -132,6 +132,7 @@ static void release_task_mempolicy(struc
 static void vma_stop(struct proc_maps_private *priv)
 {
 	struct mm_struct *mm = priv->mm;
+
 	release_task_mempolicy(priv);
 	up_read(&mm->mmap_sem);
 	mmput(mm);
@@ -217,7 +218,7 @@ static void *m_next(struct seq_file *m,
 	if (vma && (vma != tail_vma) && vma->vm_next)
 		return vma->vm_next;
 
-	next = (vma != tail_vma)? tail_vma: NULL;
+	next = (vma != tail_vma) ? tail_vma : NULL;
 	if (!next)
 		vma_stop(priv);
 	return next;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-gpu-drm-nouveau-fix-build.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

