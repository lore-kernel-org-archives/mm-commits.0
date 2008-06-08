From: akpm@linux-foundation.org
Subject: - uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:58 -0700
Message-ID: <200806081949.m58JnwWS017722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680AbYFHTua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: activate_mm: remove the dead PF_BORROWED_MM check
has been removed from the -mm tree.  Its filename was
     uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: activate_mm: remove the dead PF_BORROWED_MM check
From: Oleg Nesterov <oleg@tv-sign.ru>

use_mm() was changed to use switch_mm() instead of activate_mm(), since
then nobody calls (and nobody should call) activate_mm() with
PF_BORROWED_MM bit set.

As Jeff Dike pointed out, we can also remove the "old != new" check, it is
always true.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                     |    4 ----
 include/asm-um/mmu_context.h |   12 +++---------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN fs/aio.c~uml-activate_mm-remove-the-dead-pf_borrowed_mm-check fs/aio.c
--- a/fs/aio.c~uml-activate_mm-remove-the-dead-pf_borrowed_mm-check
+++ a/fs/aio.c
@@ -591,10 +591,6 @@ static void use_mm(struct mm_struct *mm)
 	atomic_inc(&mm->mm_count);
 	tsk->mm = mm;
 	tsk->active_mm = mm;
-	/*
-	 * Note that on UML this *requires* PF_BORROWED_MM to be set, otherwise
-	 * it won't work. Update it accordingly if you change it here
-	 */
 	switch_mm(active_mm, mm, tsk);
 	task_unlock(tsk);
 
diff -puN include/asm-um/mmu_context.h~uml-activate_mm-remove-the-dead-pf_borrowed_mm-check include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~uml-activate_mm-remove-the-dead-pf_borrowed_mm-check
+++ a/include/asm-um/mmu_context.h
@@ -22,16 +22,10 @@ extern void force_flush_all(void);
 static inline void activate_mm(struct mm_struct *old, struct mm_struct *new)
 {
 	/*
-	 * This is called by fs/exec.c and fs/aio.c. In the first case, for an
-	 * exec, we don't need to do anything as we're called from userspace
-	 * and thus going to use a new host PID. In the second, we're called
-	 * from a kernel thread, and thus need to go doing the mmap's on the
-	 * host. Since they're very expensive, we want to avoid that as far as
-	 * possible.
+	 * This is called by fs/exec.c and sys_unshare()
+	 * when the new ->mm is used for the first time.
 	 */
-	if (old != new && (current->flags & PF_BORROWED_MM))
-		__switch_mm(&new->context.id);
