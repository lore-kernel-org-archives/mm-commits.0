From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Mon, 16 Mar 2015 11:02:12 -0700
Message-ID: <55071aa4.u4DdI6QE3isW9Zok%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbbCPSCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/mmap.c |   28 ----------------------------
 fs/fat/inode.c      |    1 -
 2 files changed, 29 deletions(-)

diff -puN arch/s390/mm/mmap.c~linux-next-rejects arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~linux-next-rejects
+++ a/arch/s390/mm/mmap.c
@@ -177,34 +177,6 @@ arch_get_unmapped_area_topdown(struct fi
 	return addr;
 }
 
-#ifndef CONFIG_64BIT
-
-/*
- * This function, called very early during the creation of a new
- * process VM image, sets up which VM layout function to use:
- */
-void arch_pick_mmap_layout(struct mm_struct *mm)
-{
-	unsigned long random_factor = 0UL;
-
-	if (current->flags & PF_RANDOMIZE)
-		random_factor = arch_mmap_rnd();
-
-	/*
-	 * Fall back to the standard layout if the personality
-	 * bit is set, or if the expected stack growth is unlimited:
-	 */
-	if (mmap_is_legacy()) {
-		mm->mmap_base = mmap_base_legacy(random_factor);
-		mm->get_unmapped_area = arch_get_unmapped_area;
-	} else {
-		mm->mmap_base = mmap_base(random_factor);
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-	}
-}
-
-#else
-
 int s390_mmap_check(unsigned long addr, unsigned long len, unsigned long flags)
 {
 	if (is_compat_task() || (TASK_SIZE >= (1UL << 53)))
diff -puN fs/fat/inode.c~linux-next-rejects fs/fat/inode.c
--- a/fs/fat/inode.c~linux-next-rejects
+++ a/fs/fat/inode.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
-#include <linux/aio.h>
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/parser.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

