From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 16:55:37 -0800
Message-ID: <20200210005537.qQwDHfEGi%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgBJAzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 19:55:38 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, riel@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: set vm_next and vm_prev to NULL in vm_area_dup()
has been added to the -mm tree.  Its filename is
     mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: set vm_next and vm_prev to NULL in vm_area_dup()

Set ->vm_next and ->vm_prev to NULL to prevent potential misuse from the
new duplicated vma.

Currently, only in fork path there are misuse for handling anon_vma.  No
other bugs been revealed with this patch applied.

Link: http://lkml.kernel.org/r/1581150928-3214-4-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
@@ -561,7 +562,6 @@ static __latent_entropy int dup_mmap(str
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
-		tmp->vm_next = tmp->vm_prev = NULL;
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file_inode(file);
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork.patch
revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch
mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch
