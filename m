From: akpm@linux-foundation.org
Subject: + hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch added to -mm tree
Date: Thu, 17 Nov 2011 15:29:00 -0800
Message-ID: <201111172329.pAHNT0YY014583@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:45084 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1KQX3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 18:29:05 -0500
Received: by wwe5 with SMTP id 5so54945wwe.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 15:29:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david.daney@cavium.com, rientjes@google.com


The patch titled
     Subject: hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix
has been added to the -mm tree.  Its filename is
     hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch

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
Subject: Subject: hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
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

