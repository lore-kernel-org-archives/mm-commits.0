From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:04:36 -0800
Message-ID: <548d0c54.COnzdgFvXOCqUnoM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaLNEE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:04:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c                     |    1 +
 tools/testing/selftests/Makefile |    1 +
 2 files changed, 2 insertions(+)

diff -puN mm/hugetlb.c~linux-next-rejects mm/hugetlb.c
--- a/mm/hugetlb.c~linux-next-rejects
+++ a/mm/hugetlb.c
@@ -3380,6 +3380,7 @@ unsigned long hugetlb_change_protection(
 	 * and that page table be reused and filled with junk.
 	 */
 	flush_tlb_range(vma, start, end);
+	mmu_notifier_invalidate_range(mm, start, end);
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	mmu_notifier_invalidate_range_end(mm, start, end);
 
diff -puN tools/testing/selftests/Makefile~linux-next-rejects tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~linux-next-rejects
+++ a/tools/testing/selftests/Makefile
@@ -15,6 +15,7 @@ TARGETS += user
 TARGETS += sysctl
 TARGETS += firmware
 TARGETS += ftrace
+TARGETS += size
 TARGETS += exec
 
 TARGETS_HOTPLUG = cpu-hotplug
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
sysctl-terminate-strings-also-on-r-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

