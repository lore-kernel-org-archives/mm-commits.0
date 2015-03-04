From: akpm@linux-foundation.org
Subject: + oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch added
 to -mm tree
Date: Wed, 04 Mar 2015 15:49:50 -0800
Message-ID: <54f79a1e.2vlLMSjd8IF6PDjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbbCDXtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 18:49:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, rric@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix
has been added to the -mm tree.  Its filename is
     oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch

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
Subject: oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix

export get_mm_exe_file for arch/x86/oprofile/oprofile.ko

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Robert Richter <rric@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix kernel/fork.c
--- a/kernel/fork.c~oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix
+++ a/kernel/fork.c
@@ -695,6 +695,7 @@ struct file *get_mm_exe_file(struct mm_s
 	up_read(&mm->mmap_sem);
 	return exe_file;
 }
+EXPORT_SYMBOL(get_mm_exe_file);
 
 static void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
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
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-git-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

