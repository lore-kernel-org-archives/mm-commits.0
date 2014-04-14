From: akpm@linux-foundation.org
Subject: +
 mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch added to -mm tree
Date: Mon, 14 Apr 2014 15:28:35 -0700
Message-ID: <534c6113.IdlRctJMGkNXph/n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbaDNW2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Apr 2014 18:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, hughd@google.com, gorcunov@openvz.org

Subject: + mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch added to -mm tree
To: gorcunov@openvz.org,hughd@google.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 14 Apr 2014 15:28:35 -0700


The patch titled
     Subject: mm: softdirty: clear VM_SOFTDIRTY flag inside clear_refs_write() instead of clear_soft_dirty()
has been added to the -mm tree.  Its filename is
     mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: softdirty: clear VM_SOFTDIRTY flag inside clear_refs_write() instead of clear_soft_dirty()

clear_refs_write() is called earlier than clear_soft_dirty() and it is
more natural to clear VM_SOFTDIRTY (which belongs to VMA entry but not
PTEs) that early instead of clearing it a way deeper inside call chain.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty
+++ a/fs/proc/task_mmu.c
@@ -737,9 +737,6 @@ static inline void clear_soft_dirty(stru
 		ptent = pte_file_clear_soft_dirty(ptent);
 	}
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		vma->vm_flags &= ~VM_SOFTDIRTY;
