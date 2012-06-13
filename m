From: akpm@linux-foundation.org
Subject: + fork-use-vma_pages-to-simplify-the-code.patch added to -mm tree
Date: Wed, 13 Jun 2012 14:42:21 -0700
Message-ID: <20120613214222.25049A02A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57997 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2FMVmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 17:42:23 -0400
Received: by vcbfl13 with SMTP id fl13so97261vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 14:42:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com


The patch titled
     Subject: fork: use vma_pages() to simplify the code
has been added to the -mm tree.  Its filename is
     fork-use-vma_pages-to-simplify-the-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <shijie8@gmail.com>
Subject: fork: use vma_pages() to simplify the code

The current code can be replaced by vma_pages().  So use it to simplify
the code.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~fork-use-vma_pages-to-simplify-the-code kernel/fork.c
--- a/kernel/fork.c~fork-use-vma_pages-to-simplify-the-code
+++ a/kernel/fork.c
@@ -384,7 +384,7 @@ static int dup_mmap(struct mm_struct *mm
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len;
-			len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			len = vma_pages(mpnt);
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
_
Subject: Subject: fork: use vma_pages() to simplify the code

Patches currently in -mm which might be from shijie8@gmail.com are

linux-next.patch
mm-account-the-total_vm-in-the-vm_stat_account.patch
fork-use-vma_pages-to-simplify-the-code.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch

