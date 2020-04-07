From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 004/166] mm: set vm_next and vm_prev to NULL in
 vm_area_dup()
Date: Mon, 06 Apr 2020 20:03:39 -0700
Message-ID: <20200407030339.s4peScfXi%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDDl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:03:41 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org, willy@infradead.org

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
