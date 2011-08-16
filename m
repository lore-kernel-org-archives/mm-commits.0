From: akpm@linux-foundation.org
Subject: + mm-fix-fixup_user_fault-for-mmu=n.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:41:21 -0700
Message-ID: <201108161638.p7GGcT73003009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab1HPQjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, dhowells@redhat.com


The patch titled
     mm: fix fixup_user_fault() for MMU=n
has been added to the -mm tree.  Its filename is
     mm-fix-fixup_user_fault-for-mmu=n.patch

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
Subject: mm: fix fixup_user_fault() for MMU=n
From: Peter Zijlstra <peterz@infradead.org>

In commit 2efaca927 ("mm/futex: fix futex writes on archs with SW tracking
of dirty & young") we forgot about MMU=n.  This patch fixes that.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-fix-fixup_user_fault-for-mmu=n include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-fixup_user_fault-for-mmu=n
+++ a/include/linux/mm.h
@@ -962,6 +962,8 @@ int invalidate_inode_page(struct page *p
 #ifdef CONFIG_MMU
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
+extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+			    unsigned long address, unsigned int fault_flags);
 #else
 static inline int handle_mm_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
@@ -971,6 +973,14 @@ static inline int handle_mm_fault(struct
 	BUG();
 	return VM_FAULT_SIGBUS;
 }
+static inline int fixup_user_fault(struct task_struct *tsk,
+		struct mm_struct *mm, unsigned long address,
+		unsigned int fault_flags)
+{
+	/* should never happen if there's no MMU */
+	BUG();
+	return -EFAULT;
+}
 #endif
 
 extern int make_pages_present(unsigned long addr, unsigned long end);
@@ -988,8 +998,6 @@ int get_user_pages(struct task_struct *t
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct page *get_dump_page(unsigned long addr);
-extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
-			    unsigned long address, unsigned int fault_flags);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
mm-fix-fixup_user_fault-for-mmu=n.patch

