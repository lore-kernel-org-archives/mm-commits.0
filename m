From: akpm@linux-foundation.org
Subject: + mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:27:41 -0700
Message-ID: <20120611222741.971D4A0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34085 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab2FKW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2012 18:27:44 -0400
Received: by lagr15 with SMTP id r15so251598lag.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:27:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com


The patch titled
     Subject: mm, thp: print useful information when mmap_sem is unlocked in zap_pmd_range
has been added to the -mm tree.  Its filename is
     mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: print useful information when mmap_sem is unlocked in zap_pmd_range

Andrea asked for addr, end, vma->vm_start, and vma->vm_end to be emitted
when !rwsem_is_locked(&tlb->mm->mmap_sem).  Otherwise, debugging the
underlying issue is more difficult.

Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range mm/memory.c
--- a/mm/memory.c~mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range
+++ a/mm/memory.c
@@ -1227,7 +1227,15 @@ static inline unsigned long zap_pmd_rang
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
-				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
+#ifdef CONFIG_DEBUG_VM
+				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
+					pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
+						__func__, addr, end,
+						vma->vm_start,
+						vma->vm_end);
+					BUG();
+				}
+#endif
 				split_huge_page_pmd(vma->vm_mm, pmd);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
_
Subject: Subject: mm, thp: print useful information when mmap_sem is unlocked in zap_pmd_range

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-oom-fix-and-cleanup-oom-score-calculations.patch
mm-thp-print-useful-information-when-mmap_sem-is-unlocked-in-zap_pmd_range.patch
slab-move-full-state-transition-to-an-initcall.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch

