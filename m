From: akpm@linux-foundation.org
Subject: [merged] fork-use-vma_pages-to-simplify-the-code.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:52 -0700
Message-ID: <20120731185352.AC68F1E007A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab2GaSxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:53 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: use vma_pages() to simplify the code
has been removed from the -mm tree.  Its filename was
     fork-use-vma_pages-to-simplify-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Shijie <shijie8@gmail.com>
Subject: fork: use vma_pages() to simplify the code

The current code can be replaced by vma_pages().  So use it to simplify
the code.

[akpm@linux-foundation.org: initialise `len' at its definition site]
Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~fork-use-vma_pages-to-simplify-the-code kernel/fork.c
--- a/kernel/fork.c~fork-use-vma_pages-to-simplify-the-code
+++ a/kernel/fork.c
@@ -391,8 +391,8 @@ static int dup_mmap(struct mm_struct *mm
 		}
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned long len;
-			len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			unsigned long len = vma_pages(mpnt);
+
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
_

Patches currently in -mm which might be from shijie8@gmail.com are

origin.patch
mm-account-the-total_vm-in-the-vm_stat_account.patch
linux-next.patch

