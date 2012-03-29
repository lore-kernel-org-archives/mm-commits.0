From: akpm@linux-foundation.org
Subject: + mm-huge_memoryc-use-lockdep_assert_held.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:09 -0700
Message-ID: <20120329213910.027F6A06A4@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:44739 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245Ab2C2VjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:39:11 -0400
Received: by vcbfk26 with SMTP id fk26so321177vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, hughd@google.com


The patch titled
     Subject: mm/huge_memory.c: use lockdep_assert_held()
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-use-lockdep_assert_held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: mm/huge_memory.c: use lockdep_assert_held()

Use lockdep_assert_held() to check for locks instead of an opencoded
variant.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/swap.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-use-lockdep_assert_held mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-use-lockdep_assert_held
+++ a/mm/huge_memory.c
@@ -2076,7 +2076,7 @@ static void collect_mm_slot(struct mm_sl
 {
 	struct mm_struct *mm = mm_slot->mm;
 
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
+	lockdep_assert_held(&khugepaged_mm_lock);
 
 	if (khugepaged_test_exit(mm)) {
 		/* free mm_slot */
@@ -2106,7 +2106,7 @@ static unsigned int khugepaged_scan_mm_s
 	int progress = 0;
 
 	VM_BUG_ON(!pages);
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
+	lockdep_assert_held(&khugepaged_mm_lock);
 
 	if (khugepaged_scan.mm_slot)
 		mm_slot = khugepaged_scan.mm_slot;
diff -puN mm/swap.c~mm-huge_memoryc-use-lockdep_assert_held mm/swap.c
--- a/mm/swap.c~mm-huge_memoryc-use-lockdep_assert_held
+++ a/mm/swap.c
@@ -653,7 +653,7 @@ void lru_add_page_tail(struct zone* zone
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
 	VM_BUG_ON(PageLRU(page_tail));
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&zone->lru_lock));
+	lockdep_assert_held(&zone->lru_lock);
 
 	SetPageLRU(page_tail);
 
_
Subject: Subject: mm/huge_memory.c: use lockdep_assert_held()

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
brlocks-lglocks-cleanups.patch
block-use-lockdep_assert_held-for-queue-locking.patch
sgi-xp-use-lockdep_assert_held.patch
drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked.patch
xfs-fix-lock-assert-on-up.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
futex-use-lockdep_assert_held-for-lock-checking.patch
drivers-net-irda-sir_devc-remove-spin_is_locked.patch
drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch
include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch
checkpatch-check-for-spin_is_locked.patch

