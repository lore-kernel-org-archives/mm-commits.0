From: akpm@linux-foundation.org
Subject: [merged]
 mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd.patch removed from -mm tree
Date: Tue, 19 Jan 2016 11:59:59 -0800
Message-ID: <569e95bf.YUsDtRT25m2htKdk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcAST77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 14:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/pid/clear_refs: no need to clear VM_SOFTDIRTY in clear_soft_dirty_pmd()
has been removed from the -mm tree.  Its filename was
     mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: /proc/pid/clear_refs: no need to clear VM_SOFTDIRTY in clear_soft_dirty_pmd()

clear_soft_dirty_pmd() is called by clear_refs_write(CLEAR_REFS_SOFT_DIRTY),
VM_SOFTDIRTY was already cleared before walk_page_range().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd
+++ a/fs/proc/task_mmu.c
@@ -881,9 +881,6 @@ static inline void clear_soft_dirty_pmd(
 	pmd = pmd_wrprotect(pmd);
 	pmd = pmd_clear_soft_dirty(pmd);
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		vma->vm_flags &= ~VM_SOFTDIRTY;
