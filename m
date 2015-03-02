From: akpm@linux-foundation.org
Subject: [alternative-merged] mips-rename-brk_rnd-to-mmap_rnd.patch
 removed from -mm tree
Date: Mon, 02 Mar 2015 13:57:58 -0800
Message-ID: <54f4dce6.+RcgGBXkNDO94Lmt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbbCBV57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 16:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hecmargi@upv.es, iripoll@upv.es, keescook@chromium.org, mingo@kernel.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: rename brk_rnd() to mmap_rnd()
has been removed from the -mm tree.  Its filename was
     mips-rename-brk_rnd-to-mmap_rnd.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mips: rename brk_rnd() to mmap_rnd()

To match the other architectures.

Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Ismael Ripoll <iripoll@upv.es>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/mm/mmap.c~mips-rename-brk_rnd-to-mmap_rnd arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~mips-rename-brk_rnd-to-mmap_rnd
+++ a/arch/mips/mm/mmap.c
@@ -164,7 +164,7 @@ void arch_pick_mmap_layout(struct mm_str
 	}
 }
 
-static inline unsigned long brk_rnd(void)
+static inline unsigned long mmap_rnd(void)
 {
 	unsigned long rnd = get_random_int();
 
@@ -183,7 +183,7 @@ unsigned long arch_randomize_brk(struct
 	unsigned long base = mm->brk;
 	unsigned long ret;
 
-	ret = PAGE_ALIGN(base + brk_rnd());
+	ret = PAGE_ALIGN(base + mmap_rnd());
 
 	if (ret < mm->brk)
 		return mm->brk;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

