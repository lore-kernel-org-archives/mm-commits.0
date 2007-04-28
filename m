From: akpm@linux-foundation.org
Subject: - i386-make-compat_vdso-runtime-selectable-fix.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:20 -0700
Message-ID: <200704281055.l3SAtKVw020170@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965746AbXD1KzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     fix i386 get_gate_vma oops
has been removed from the -mm tree.  Its filename was
     i386-make-compat_vdso-runtime-selectable-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix i386 get_gate_vma oops
From: Hugh Dickins <hugh@veritas.com>

Fix oops from i386-make-compat_vdso-runtime-selectable.patch.

Even mingetty at system startup finds it easy to trigger an oops
while reading /proc/PID/maps: though it has a good hold on the mm
itself, that cannot stop exit_mm() from resetting tsk->mm to NULL.

(It is usually show_map()'s call to get_gate_vma() which oopses,
and I expect we could change that to check priv->tail_vma instead;
but no matter, even m_start()'s call just after get_task_mm() is racy.)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/sysenter.c~i386-make-compat_vdso-runtime-selectable-fix arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~i386-make-compat_vdso-runtime-selectable-fix
+++ a/arch/i386/kernel/sysenter.c
@@ -326,8 +326,10 @@ const char *arch_vma_name(struct vm_area
 
 struct vm_area_struct *get_gate_vma(struct task_struct *tsk)
 {
+	struct mm_struct *mm = tsk->mm;
+
 	/* Check to see if this task was created in compat vdso mode */
-	if (tsk->mm->context.vdso == (void *)VDSO_HIGH_BASE)
+	if (mm && mm->context.vdso == (void *)VDSO_HIGH_BASE)
 		return &gate_vma;
 	return NULL;
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

ia64-race-flushing-icache-in-do_no_page-path.patch
git-drm.patch
scsi-fix-config_scsi_wait_scan=m.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slub-core.patch
mm-madvise-avoid-exclusive-mmap_sem.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
madv_free-lazytlb-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
