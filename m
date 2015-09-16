From: akpm@linux-foundation.org
Subject: + revert-mm-make-sure-all-file-vmas-have-vm_ops-set.patch added
 to -mm tree
Date: Wed, 16 Sep 2015 15:06:56 -0700
Message-ID: <55f9e800.WHkr2z6h1j7+JjNo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbbIPWG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Sep 2015 18:06:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, oleg@redhat.com, will.deacon@arm.com, wshuman3@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm: make sure all file VMAs have ->vm_ops set"
has been added to the -mm tree.  Its filename is
     revert-mm-make-sure-all-file-vmas-have-vm_ops-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-make-sure-all-file-vmas-have-vm_ops-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-make-sure-all-file-vmas-have-vm_ops-set.patch

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
Subject: revert "mm: make sure all file VMAs have ->vm_ops set"

Revert 6dc296e7df4c "mm: make sure all file VMAs have ->vm_ops set".

Will Deacon reports that it "causes some mmap regressions in LTP, which
appears to use a MAP_PRIVATE mmap of /dev/zero as a way to get anonymous
pages in some of its tests (specifically mmap10 [1])".

William Shuman reports Oracle crashes.

So revert the patch while we work out what to do.

Reported-by: William Shuman <wshuman3@gmail.com>
Reported-by: Will Deacon <will.deacon@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/mmap.c~revert-mm-make-sure-all-file-vmas-have-vm_ops-set mm/mmap.c
--- a/mm/mmap.c~revert-mm-make-sure-all-file-vmas-have-vm_ops-set
+++ a/mm/mmap.c
@@ -612,8 +612,6 @@ static unsigned long count_vma_pages_ran
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
-	WARN_ONCE(vma->vm_file && !vma->vm_ops, "missing vma->vm_ops");
-
 	/* Update tracking information for the gap following the new vma. */
 	if (vma->vm_next)
 		vma_gap_update(vma->vm_next);
@@ -1639,12 +1637,6 @@ unsigned long mmap_region(struct file *f
 		 */
 		WARN_ON_ONCE(addr != vma->vm_start);
 
-		/* All file mapping must have ->vm_ops set */
-		if (!vma->vm_ops) {
-			static const struct vm_operations_struct dummy_ops = {};
-			vma->vm_ops = &dummy_ops;
-		}
-
 		addr = vma->vm_start;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
maintainers-update-ltp-mailing-list-fix.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
revert-mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

