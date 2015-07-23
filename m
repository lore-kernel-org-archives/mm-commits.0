From: akpm@linux-foundation.org
Subject: + x86-mpx-do-not-set-vm_ops-on-mpx-vmas.patch added to -mm tree
Date: Thu, 23 Jul 2015 12:27:08 -0700
Message-ID: <55b1400c.UVgxyn/+HuiEC2zk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbGWT1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, luto@amacapital.net, minchan@kernel.org, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mpx: do not set ->vm_ops on mpx VMAs
has been added to the -mm tree.  Its filename is
     x86-mpx-do-not-set-vm_ops-on-mpx-vmas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mpx-do-not-set-vm_ops-on-mpx-vmas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mpx-do-not-set-vm_ops-on-mpx-vmas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86, mpx: do not set ->vm_ops on mpx VMAs

MPX setups private anonymous mapping, but uses vma->vm_ops too.  This can
confuse core VM, as it relies on vm->vm_ops to distinguish file VMAs from
anonymous.

As a result we will get SIGBUS, because handle_pte_fault() thinks it's
file VMA without vm_ops->fault and it doesn't know how to handle the
situation properly.

Let's fix that by not setting ->vm_ops.

We don't really need ->vm_ops here: MPX VMA can be detected with VM_MPX
flag.  And vma_merge() will not merge MPX VMA with non-MPX VMA, because
->vm_flags won't match.

The only thing left is name of VMA.  I'm not sure if it's part of ABI, or
we can just drop it.  The patch keep it by providing arch_vma_name() on
x86.

Build tested only.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mmap.c |    7 +++++++
 arch/x86/mm/mpx.c  |   20 +-------------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff -puN arch/x86/mm/mmap.c~x86-mpx-do-not-set-vm_ops-on-mpx-vmas arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~x86-mpx-do-not-set-vm_ops-on-mpx-vmas
+++ a/arch/x86/mm/mmap.c
@@ -126,3 +126,10 @@ void arch_pick_mmap_layout(struct mm_str
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_MPX)
+		return "[mpx]";
+	return NULL;
+}
diff -puN arch/x86/mm/mpx.c~x86-mpx-do-not-set-vm_ops-on-mpx-vmas arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~x86-mpx-do-not-set-vm_ops-on-mpx-vmas
+++ a/arch/x86/mm/mpx.c
@@ -20,20 +20,6 @@
 #define CREATE_TRACE_POINTS
 #include <asm/trace/mpx.h>
 
-static const char *mpx_mapping_name(struct vm_area_struct *vma)
-{
-	return "[mpx]";
-}
-
-static struct vm_operations_struct mpx_vma_ops = {
-	.name = mpx_mapping_name,
-};
-
-static int is_mpx_vma(struct vm_area_struct *vma)
-{
-	return (vma->vm_ops == &mpx_vma_ops);
-}
-
 static inline unsigned long mpx_bd_size_bytes(struct mm_struct *mm)
 {
 	if (is_64bit_mm(mm))
@@ -53,9 +39,6 @@ static inline unsigned long mpx_bt_size_
 /*
  * This is really a simplified "vm_mmap". it only handles MPX
  * bounds tables (the bounds directory is user-allocated).
- *
- * Later on, we use the vma->vm_ops to uniquely identify these
- * VMAs.
  */
 static unsigned long mpx_mmap(unsigned long len)
 {
@@ -101,7 +84,6 @@ static unsigned long mpx_mmap(unsigned l
 		ret = -ENOMEM;
 		goto out;
 	}
-	vma->vm_ops = &mpx_vma_ops;
 
 	if (vm_flags & VM_LOCKED) {
 		up_write(&mm->mmap_sem);
@@ -812,7 +794,7 @@ static noinline int zap_bt_entries_mappi
 		 * so stop immediately and return an error.  This
 		 * probably results in a SIGSEGV.
 		 */
-		if (!is_mpx_vma(vma))
+		if (!(vma->vm_flags & VM_MPX))
 			return -EINVAL;
 
 		len = min(vma->vm_end, end) - addr;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-status-code-move_pages-returns-for-zero-page.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-mark-most-vm_operations_struct-const.patch
x86-mpx-do-not-set-vm_ops-on-mpx-vmas.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

