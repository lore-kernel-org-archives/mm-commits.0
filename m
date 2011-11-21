From: akpm@linux-foundation.org
Subject: [wrecked] hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch removed from -mm tree
Date: Mon, 21 Nov 2011 12:39:27 -0800
Message-ID: <201111212039.pALKdRA4030132@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:53216 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1KUUja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 15:39:30 -0500
Received: by fabs1 with SMTP id s1so82832fab.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 12:39:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david.daney@cavium.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix

improve the comment

Cc: David Daney <david.daney@cavium.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix
+++ a/include/linux/hugetlb.h
@@ -111,7 +111,11 @@ static inline void copy_huge_page(struct
 #define hugetlb_change_protection(vma, address, end, newprot)
 
 #ifndef HPAGE_MASK
-/* Keep the compiler happy with some dummy (but BUGgy) values */
+/*
+ * HPAGE_MASK and friends are defined if !CONFIG_HUGETLB_PAGE as an
+ * ifdef-avoiding convenience.  However they should never be evaluated at
+ * runtime if !CONFIG_HUGETLB_PAGE.
+ */
 #define HPAGE_MASK	({BUG(); 0; })
 #define HPAGE_SIZE	({BUG(); 0; })
 #define HPAGE_SHIFT	({BUG(); 0; })
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

