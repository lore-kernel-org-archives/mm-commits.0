From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mremap_dontunmap-to-mremap-v7.patch added to -mm
 tree
Date: Sun, 23 Feb 2020 20:08:43 -0800
Message-ID: <20200224040843.aPOlZsC1w%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbgBXEIp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 23:08:45 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, arnd@arndb.de, bgeffon@google.com, fweimer@redhat.com, joel@joelfernandes.org, jsbarnes@google.com, kirill@shutemov.name, lokeshgidra@google.com, luto@amacapital.net, minchan@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, natechancellor@gmail.com, sonnyrao@google.com, will@kernel.org, yuzhao@google.com


The patch titled
     Subject: mm-add-mremap_dontunmap-to-mremap-v7
has been added to the -mm tree.  Its filename is
     mm-add-mremap_dontunmap-to-mremap-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-mremap_dontunmap-to-mremap-v7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-mremap_dontunmap-to-mremap-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm-add-mremap_dontunmap-to-mremap-v7

Don't allow resizing VMA as part of MREMAP_DONTUNMAP.  There is no clear
use case at the moment and it can be added later as it simplifies the
implementation for now.

Link: http://lkml.kernel.org/r/20200221174248.244748-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Tested-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Deacon <will@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jesse Barnes <jsbarnes@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

--- a/mm/mremap.c~mm-add-mremap_dontunmap-to-mremap-v7
+++ a/mm/mremap.c
@@ -416,24 +416,10 @@ static unsigned long move_vma(struct vm_
 			vm_acct_memory(vma_pages(new_vma));
 		}
 
-		/*
-		 * locked_vm accounting: if the mapping remained the same size
-		 * it will have just moved and we don't need to touch locked_vm
-		 * because we skip the do_unmap. If the mapping shrunk before
-		 * being moved then the do_unmap on that portion will have
-		 * adjusted vm_locked. Only if the mapping grows do we need to
-		 * do something special; the reason is locked_vm only accounts
-		 * for old_len, but we're now adding new_len - old_len locked
-		 * bytes to the new mapping.
-		 */
-		if (vm_flags & VM_LOCKED && new_len > old_len) {
-			mm->locked_vm += (new_len - old_len) >> PAGE_SHIFT;
-			*locked = true;
-		}
-
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
+		/* Because we won't unmap we don't need to touch locked_vm */
 		goto out;
 	}
 
@@ -588,13 +574,9 @@ static unsigned long mremap_to(unsigned
 		goto out;
 	}
 
-	/*
-	 * MREMAP_DONTUNMAP expands by new_len - (new_len - old_len), we will
-	 * check that we can expand by new_len and vma_to_resize will handle
-	 * the vma growing which is (new_len - old_len).
-	 */
+	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
 	if (flags & MREMAP_DONTUNMAP &&
-		!may_expand_vm(mm, vma->vm_flags, new_len >> PAGE_SHIFT)) {
+		!may_expand_vm(mm, vma->vm_flags, old_len >> PAGE_SHIFT)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -670,10 +652,15 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
 		return ret;
 
-	/* MREMAP_DONTUNMAP is always a move */
-	if (flags & MREMAP_DONTUNMAP && !(flags & MREMAP_MAYMOVE))
+	/*
+	 * MREMAP_DONTUNMAP is always a move and it does not allow resizing
+	 * in the process.
+	 */
+	if (flags & MREMAP_DONTUNMAP &&
+			(!(flags & MREMAP_MAYMOVE) || old_len != new_len))
 		return ret;
 
+
 	if (offset_in_page(addr))
 		return ret;
 
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-add-mremap_dontunmap-to-mremap.patch
mm-add-mremap_dontunmap-to-mremap-v6.patch
mm-add-mremap_dontunmap-to-mremap-v7.patch
selftest-add-mremap_dontunmap-selftest.patch
selftest-add-mremap_dontunmap-selftest-v7.patch
