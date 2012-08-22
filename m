From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch added to -mm tree
Date: Wed, 22 Aug 2012 12:15:52 -0700
Message-ID: <20120822191553.3ED535C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33351 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965012Ab2HVTP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2012 15:15:56 -0400
Received: by lagw12 with SMTP id w12so63300lag.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 12:15:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, avi@redhat.com, hughd@google.com, mtosatti@redhat.com


The patch titled
     Subject: mm: mmu_notifier: fix inconsistent memory between secondary MMU and host
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: mm: mmu_notifier: fix inconsistent memory between secondary MMU and host

There is a bug in set_pte_at_notify() which always sets the pte to the new
page before releasing the old page in the secondary MMU.  At this time,
the process will access on the new page, but the secondary MMU still
access on the old page, the memory is inconsistent between them

The below scenario shows the bug more clearly:

at the beginning: *p = 0, and p is write-protected by KSM or shared with
parent process

CPU 0                                       CPU 1
write 1 to p to trigger COW,
set_pte_at_notify will be called:
  *pte = new_page + W; /* The W bit of pte is set */

                                     *p = 1; /* pte is valid, so no #PF */

                                     return back to secondary MMU, then
                                     the secondary MMU read p, but get:
                                     *p == 0;

                         /*
                          * !!!!!!
                          * the host has already set p to 1, but the secondary
                          * MMU still get the old value 0
                          */

  call mmu_notifier_change_pte to release
  old page in secondary MMU

We can fix it by release old page first, then set the pte to the new
page.

Note, the new page will be firstly used in secondary MMU before it is
mapped into the page table of the process, but this is safe because it
is protected by the page table lock, there is no race to change the pte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host
+++ a/include/linux/mmu_notifier.h
@@ -317,8 +317,8 @@ static inline void mmu_notifier_mm_destr
 	unsigned long ___address = __address;				\
 	pte_t ___pte = __pte;						\
 									\
-	set_pte_at(___mm, ___address, __ptep, ___pte);			\
 	mmu_notifier_change_pte(___mm, ___address, ___pte);		\
+	set_pte_at(___mm, ___address, __ptep, ___pte);			\
 })
 
 #else /* CONFIG_MMU_NOTIFIER */
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

linux-next.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch

