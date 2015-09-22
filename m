From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
 removed from -mm tree
Date: Tue, 22 Sep 2015 14:55:19 -0700
Message-ID: <5601ce47./RLcGQXNWwDSSNja%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbbIVVzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 17:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix
has been removed from the -mm tree.  Its filename was
     mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch

This patch was dropped because it was folded into mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix

add local vm_ops to avoid 80-cols mess

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix mm/mmap.c
--- a/mm/mmap.c~mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix
+++ a/mm/mmap.c
@@ -1490,14 +1490,14 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
 int vma_wants_writenotify(struct vm_area_struct *vma)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
 
 	/* If it was private or non-writable, the write bit is already clear */
 	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
 		return 0;
 
 	/* The backer wishes to know when pages are first written to? */
-	if (vma->vm_ops &&
-			(vma->vm_ops->page_mkwrite || vma->vm_ops->pfn_mkwrite))
+	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
 		return 1;
 
 	/* The open routine did something to the protections that pgprot_modify
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch
x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

