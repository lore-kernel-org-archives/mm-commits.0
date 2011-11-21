From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch added to -mm tree
Date: Mon, 21 Nov 2011 14:27:40 -0800
Message-ID: <201111212227.pALMRf6B009634@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:65057 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1KUW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 17:27:44 -0500
Received: by wwe5 with SMTP id 5so179138wwe.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 14:27:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix

use &=

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix
+++ a/mm/hugetlb.c
@@ -2639,7 +2639,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 	struct hstate *h = hstate_vma(vma);
 
-	address = address & huge_page_mask(h);
+	address &= huge_page_mask(h);
 
 	ptep = huge_pte_offset(mm, address);
 	if (ptep) {
_
Subject: Subject: mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix

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
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
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

