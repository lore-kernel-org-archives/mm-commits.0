From: akpm@linux-foundation.org
Subject: +
 x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 27 Jan 2016 12:30:13 -0800
Message-ID: <56a928d5.i+VjVe91+okoLUJ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934135AbcA0UaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:30:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch

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
Subject: x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes

ERROR: space prohibited before that ',' (ctx:WxW)
#201: FILE: arch/x86/include/asm/pgtable.h:820:
+				     pud_t *pudp , pud_t pud)
 				                 ^

WARNING: line over 80 characters
#230: FILE: arch/x86/include/asm/pgtable.h:932:
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm, unsigned long addr,

WARNING: Block comments use * on subsequent lines
#263: FILE: arch/x86/include/asm/pgtable_64.h:115:
+	/* native_local_pudp_get_and_clear,
+	   but duplicated because of cyclic dependency */

WARNING: Block comments use a trailing */ on a separate line
#263: FILE: arch/x86/include/asm/pgtable_64.h:115:
+	   but duplicated because of cyclic dependency */

WARNING: Missing a blank line after declarations
#265: FILE: arch/x86/include/asm/pgtable_64.h:117:
+	pud_t ret = *pudp;
+	native_pud_clear(pudp);

total: 1 errors, 4 warnings, 265 lines checked

./patches/x86-add-support-for-pud-sized-transparent-hugepages.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h    |    2 +-
 arch/x86/include/asm/pgtable_64.h |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes
+++ a/arch/x86/include/asm/pgtable.h
@@ -817,7 +817,7 @@ static inline void native_set_pmd_at(str
 }
 
 static inline void native_set_pud_at(struct mm_struct *mm, unsigned long addr,
-				     pud_t *pudp , pud_t pud)
+				     pud_t *pudp, pud_t pud)
 {
 	native_set_pud(pudp, pud);
 }
diff -puN arch/x86/include/asm/pgtable_64.h~x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -111,8 +111,10 @@ static inline pud_t native_pudp_get_and_
 #ifdef CONFIG_SMP
 	return native_make_pud(xchg(&pudp->pud, 0));
 #else
-	/* native_local_pudp_get_and_clear,
-	   but duplicated because of cyclic dependency */
+	/*
+	 * native_local_pudp_get_and_clear, but duplicated because of cyclic
+	 * dependency
+	 */
 	pud_t ret = *pudp;
 	native_pud_clear(pudp);
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

