From: akpm@linux-foundation.org
Subject: [merged]
 mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 18:56:23 -0700
Message-ID: <20200408015623.vCSl23Bn6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgDHB4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, riel@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: set vm_next and vm_prev to NULL in vm_area_dup()
has been removed from the -mm tree.  Its filename was
     mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: set vm_next and vm_prev to NULL in vm_area_dup()

Set ->vm_next and ->vm_prev to NULL to prevent potential misuse from the
new duplicated vma.

Currently, only in fork path there are misuse for handling anon_vma.  No
other bugs been revealed with this patch applied.

Link: http://lkml.kernel.org/r/1581150928-3214-4-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup
+++ a/kernel/fork.c
@@ -361,6 +361,7 @@ struct vm_area_struct *vm_area_dup(struc
 	if (new) {
 		*new = *orig;
 		INIT_LIST_HEAD(&new->anon_vma_chain);
+		new->vm_next = new->vm_prev = NULL;
 	}
 	return new;
 }
@@ -562,7 +563,6 @@ static __latent_entropy int dup_mmap(str
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
-		tmp->vm_next = tmp->vm_prev = NULL;
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file_inode(file);
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are
