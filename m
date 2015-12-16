From: akpm@linux-foundation.org
Subject: +
 mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd.patch added to -mm tree
Date: Wed, 16 Dec 2015 14:09:15 -0800
Message-ID: <5671e10b./W/eu1VzAh3/uGj5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbbLPWJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2015 17:09:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/pid/clear_refs: no need to clear VM_SOFTDIRTY in clear_soft_dirty_pmd()
has been added to the -mm tree.  Its filename is
     mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-pid-clear_refs-no-need-to-clear-vm_softdirty-in-clear_soft_dirty_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
