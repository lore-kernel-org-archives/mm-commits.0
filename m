From: akpm@linux-foundation.org
Subject: [merged]
 mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch removed from
 -mm tree
Date: Fri, 19 Dec 2014 12:36:50 -0800
Message-ID: <54948c62.3n20fX+4FiJ/geGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaLSUgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 15:36:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, dave.hansen@linux.intel.com, kirill@shutemov.name, lliubbo@gmail.com, matthew.r.wilcox@intel.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c:do_shared_fault(): add comment
has been removed from the -mm tree.  Its filename was
     mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memory.c:do_shared_fault(): add comment

Belatedly document the changes in f0c6d4d295e4ea ("mm: introduce
do_shared_fault() and drop do_fault()").

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memory.c~mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix mm/memory.c
--- a/mm/memory.c~mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix
+++ a/mm/memory.c
@@ -2996,6 +2996,12 @@ static int do_shared_fault(struct mm_str
 
 	if (set_page_dirty(fault_page))
 		dirtied = 1;
+	/*
+	 * Take a local copy of the address_space - page.mapping may be zeroed
+	 * by truncate after unlock_page().   The address_space itself remains
+	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
+	 * release semantics to prevent the compiler from undoing this copying.
+	 */
 	mapping = fault_page->mapping;
 	unlock_page(fault_page);
 	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

