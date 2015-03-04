From: akpm@linux-foundation.org
Subject: +
 tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch added to -mm tree
Date: Wed, 04 Mar 2015 14:31:36 -0800
Message-ID: <54f787c8.SOSNlZQ4zRcSJ+0o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbbCDWbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:31:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbueso@suse.de, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch

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
Subject: tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes

Sumeone needs to buy a tab key.


WARNING: please, no spaces at the start of a line
#29: FILE: security/tomoyo/util.c:951:
+       struct file *exe_file;$

WARNING: please, no spaces at the start of a line
#30: FILE: security/tomoyo/util.c:952:
+       const char *cp;$

WARNING: please, no spaces at the start of a line
#31: FILE: security/tomoyo/util.c:953:
+       struct mm_struct *mm = current->mm;$

WARNING: please, no spaces at the start of a line
#40: FILE: security/tomoyo/util.c:955:
+       if (!mm)$

WARNING: suspect code indent for conditional statements (7, 15)
#40: FILE: security/tomoyo/util.c:955:
+       if (!mm)
+	       return NULL;

WARNING: please, no spaces at the start of a line
#42: FILE: security/tomoyo/util.c:957:
+       exe_file = get_mm_exe_file(mm);$

WARNING: please, no spaces at the start of a line
#43: FILE: security/tomoyo/util.c:958:
+       if (!exe_file)$

WARNING: suspect code indent for conditional statements (7, 15)
#43: FILE: security/tomoyo/util.c:958:
+       if (!exe_file)
+	       return NULL;

WARNING: please, no spaces at the start of a line
#46: FILE: security/tomoyo/util.c:961:
+       cp = tomoyo_realpath_from_path(&exe_file->f_path);$

WARNING: please, no spaces at the start of a line
#47: FILE: security/tomoyo/util.c:962:
+       fput(exe_file);$

WARNING: please, no spaces at the start of a line
#48: FILE: security/tomoyo/util.c:963:
+       return cp;$

total: 0 errors, 11 warnings, 28 lines checked

./patches/tomoyo-reduce-mmap_sem-hold-for-mm-exe_file.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: James Morris <jmorris@namei.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/tomoyo/util.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes security/tomoyo/util.c
--- a/security/tomoyo/util.c~tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes
+++ a/security/tomoyo/util.c
@@ -948,19 +948,19 @@ bool tomoyo_path_matches_pattern(const s
  */
 const char *tomoyo_get_exe(void)
 {
-       struct file *exe_file;
-       const char *cp;
-       struct mm_struct *mm = current->mm;
+	struct file *exe_file;
+	const char *cp;
+	struct mm_struct *mm = current->mm;
 
-       if (!mm)
-	       return NULL;
-       exe_file = get_mm_exe_file(mm);
-       if (!exe_file)
-	       return NULL;
+	if (!mm)
+		return NULL;
+	exe_file = get_mm_exe_file(mm);
+	if (!exe_file)
+		return NULL;
 
-       cp = tomoyo_realpath_from_path(&exe_file->f_path);
-       fput(exe_file);
-       return cp;
+	cp = tomoyo_realpath_from_path(&exe_file->f_path);
+	fput(exe_file);
+	return cp;
 }
 
 /**
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
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

