From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch removed from -mm
 tree
Date: Thu, 08 Jan 2015 14:29:31 -0800
Message-ID: <54af04cb.3+ysX1SWeULnAU31%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbbAHW3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2015 17:29:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koct9i@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prevent-endless-growth-of-anon_vma-hierarchy-fix
has been removed from the -mm tree.  Its filename was
     mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch

This patch was dropped because it was folded into mm-prevent-endless-growth-of-anon_vma-hierarchy.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prevent-endless-growth-of-anon_vma-hierarchy-fix

fix typo, per Rik

Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-prevent-endless-growth-of-anon_vma-hierarchy-fix mm/rmap.c
--- a/mm/rmap.c~mm-prevent-endless-growth-of-anon_vma-hierarchy-fix
+++ a/mm/rmap.c
@@ -244,9 +244,10 @@ static inline void unlock_anon_vma_root(
  * If dst->anon_vma is NULL this function tries to find and reuse existing
  * anon_vma which has no vmas and only one child anon_vma. This prevents
  * degradation of anon_vma hierarchy to endless linear chain in case of
- * constantly forking task. In other hand anon_vma with more than one child
- * isn't reused even if was no alive vma, thus rmap walker has a good chance
- * to avoid scanning whole hieraryhy when it searches where page is mapped.
+ * constantly forking task. On the other hand, an anon_vma with more than one
+ * child isn't reused even if there was no alive vma, thus rmap walker has a
+ * good chance of avoiding scanning the whole hierarchy when it searches where
+ * page is mapped.
  */
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
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
livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

