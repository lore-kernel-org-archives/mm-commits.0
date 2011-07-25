From: akpm@linux-foundation.org
Subject: [folded] mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:58:46 -0700
Message-ID: <201107252358.p6PNwkGG006359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab1GYX6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, darren.hart@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix
has been removed from the -mm tree.  Its filename was
     mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch

This patch was dropped because it was folded into mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix some nits Darren saw, fiddle comment layout

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Darren Hart <darren.hart@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff -puN include/linux/mm.h~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix include/linux/mm.h
diff -puN kernel/futex.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix kernel/futex.c
diff -puN mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix mm/memory.c
--- a/mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix
+++ a/mm/memory.c
@@ -1806,30 +1806,29 @@ next_page:
 EXPORT_SYMBOL(__get_user_pages);
 
 /*
- * fixup_user_fault() - manually resolve a user page  fault
+ * fixup_user_fault() - manually resolve a user page fault
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
  * @mm:		mm_struct of target mm
  * @address:	user address
  * @fault_flags:flags to pass down to handle_mm_fault()
  *
- * This is meant to be called in the specific scenario where for
- * locking reasons we try to access user memory in atomic context
- * (within a pagefault_disable() section), this returns -EFAULT,
- * and we want to resolve the user fault before trying again.
+ * This is meant to be called in the specific scenario where for locking reasons
+ * we try to access user memory in atomic context (within a pagefault_disable()
+ * section), this returns -EFAULT, and we want to resolve the user fault before
+ * trying again.
  *
  * Typically this is meant to be used by the futex code.
  *
- * The main difference with get_user_pages() is that this function
- * will unconditionally call handle_mm_fault() which will in turn
- * perform all the necessary SW fixup of the dirty and young bits
- * in the PTE, while handle_mm_fault() only guarantees to update
- * these in the struct page.
- *
- * This is important for some architectures where those bits also
- * gate the access permission to the page because their are
- * maintained in software. On such architecture, gup() will not
- * be enough to make a subsequent access succeed.
+ * The main difference with get_user_pages() is that this function will
+ * unconditionally call handle_mm_fault() which will in turn perform all the
+ * necessary SW fixup of the dirty and young bits in the PTE, while
+ * handle_mm_fault() only guarantees to update these in the struct page.
+ *
+ * This is important for some architectures where those bits also gate the
+ * access permission to the page because they are maintained in software.  On
+ * such architectures, gup() will not be enough to make a subsequent access
+ * succeed.
  *
  * This should be called with the mm_sem held for read.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
pagewalk-add-locking-rule-comments.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

