From: akpm@linux-foundation.org
Subject: [merged] mm-mark-remap_file_pages-syscall-as-deprecated.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:41:01 -0700
Message-ID: <53960dcd.XHEOjSjuL/d4m8Ea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaFITlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, davej@redhat.com, arigo@tunes.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-mark-remap_file_pages-syscall-as-deprecated.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,arigo@tunes.org,davej@redhat.com,mingo@kernel.org,peterz@infradead.org,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:01 -0700


The patch titled
     Subject: mm: mark remap_file_pages() syscall as deprecated
has been removed from the -mm tree.  Its filename was
     mm-mark-remap_file_pages-syscall-as-deprecated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: mark remap_file_pages() syscall as deprecated

The remap_file_pages() system call is used to create a nonlinear mapping,
that is, a mapping in which the pages of the file are mapped into a
nonsequential order in memory.  The advantage of using remap_file_pages()
over using repeated calls to mmap(2) is that the former approach does not
require the kernel to create additional VMA (Virtual Memory Area) data
structures.

Supporting of nonlinear mapping requires significant amount of non-trivial
code in kernel virtual memory subsystem including hot paths.  Also to get
nonlinear mapping work kernel need a way to distinguish normal page table
entries from entries with file offset (pte_file).  Kernel reserves flag in
PTE for this purpose.  PTE flags are scarce resource especially on some
CPU architectures.  It would be nice to free up the flag for other usage.

Fortunately, there are not many users of remap_file_pages() in the wild. 
It's only known that one enterprise RDBMS implementation uses the syscall
on 32-bit systems to map files bigger than can linearly fit into 32-bit
virtual address space.  This use-case is not critical anymore since 64-bit
systems are widely available.

The plan is to deprecate the syscall and replace it with an emulation. 
The emulation will create new VMAs instead of nonlinear mappings.  It's
going to work slower for rare users of remap_file_pages() but ABI is
preserved.

One side effect of emulation (apart from performance) is that user can hit
vm.max_map_count limit more easily due to additional VMAs.  See comment
for DEFAULT_MAX_MAP_COUNT for more details on the limit.

[akpm@linux-foundation.org: fix spello]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Armin Rigo <arigo@tunes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/remap_file_pages.txt |   28 ++++++++++++++++++++++++
 mm/fremap.c                           |    4 +++
 2 files changed, 32 insertions(+)

diff -puN /dev/null Documentation/vm/remap_file_pages.txt
--- /dev/null
+++ a/Documentation/vm/remap_file_pages.txt
@@ -0,0 +1,28 @@
+The remap_file_pages() system call is used to create a nonlinear mapping,
+that is, a mapping in which the pages of the file are mapped into a
+nonsequential order in memory. The advantage of using remap_file_pages()
+over using repeated calls to mmap(2) is that the former approach does not
+require the kernel to create additional VMA (Virtual Memory Area) data
+structures.
+
+Supporting of nonlinear mapping requires significant amount of non-trivial
+code in kernel virtual memory subsystem including hot paths. Also to get
+nonlinear mapping work kernel need a way to distinguish normal page table
+entries from entries with file offset (pte_file). Kernel reserves flag in
+PTE for this purpose. PTE flags are scarce resource especially on some CPU
+architectures. It would be nice to free up the flag for other usage.
+
+Fortunately, there are not many users of remap_file_pages() in the wild.
+It's only known that one enterprise RDBMS implementation uses the syscall
+on 32-bit systems to map files bigger than can linearly fit into 32-bit
+virtual address space. This use-case is not critical anymore since 64-bit
+systems are widely available.
+
+The plan is to deprecate the syscall and replace it with an emulation.
+The emulation will create new VMAs instead of nonlinear mappings. It's
+going to work slower for rare users of remap_file_pages() but ABI is
+preserved.
+
+One side effect of emulation (apart from performance) is that user can hit
+vm.max_map_count limit more easily due to additional VMAs. See comment for
+DEFAULT_MAX_MAP_COUNT for more details on the limit.
diff -puN mm/fremap.c~mm-mark-remap_file_pages-syscall-as-deprecated mm/fremap.c
--- a/mm/fremap.c~mm-mark-remap_file_pages-syscall-as-deprecated
+++ a/mm/fremap.c
@@ -149,6 +149,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	int has_write_lock = 0;
 	vm_flags_t vm_flags = 0;
 
+	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
+			"See Documentation/vm/remap_file_pages.txt.\n",
+			current->comm, current->pid);
+
 	if (prot)
 		return err;
 	/*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

