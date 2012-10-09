From: akpm@linux-foundation.org
Subject: [merged] mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:06 -0700
Message-ID: <20121009180706.E1E3B1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40838 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:07 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so573446yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, avi@redhat.com, hughd@google.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmu_notifier: fix inconsistent memory between secondary MMU and host
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: add comment from Andrea]
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host
+++ a/include/linux/mmu_notifier.h
@@ -311,14 +311,24 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
 
+/*
+ * set_pte_at_notify() sets the pte _after_ running the notifier.
+ * This is safe to start by updating the secondary MMUs, because the primary MMU
+ * pte invalidate must have already happened with a ptep_clear_flush() before
+ * set_pte_at_notify() has been invoked.  Updating the secondary MMUs first is
+ * required when we change both the protection of the mapping from read-only to
+ * read-write and the pfn (like during copy on write page faults). Otherwise the
+ * old page would remain mapped readonly in the secondary MMUs after the new
+ * page is already writable by some CPU through the primary MMU.
+ */
 #define set_pte_at_notify(__mm, __address, __ptep, __pte)		\
 ({									\
 	struct mm_struct *___mm = __mm;					\
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

origin.patch
linux-next.patch

