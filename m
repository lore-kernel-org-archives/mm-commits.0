From: akpm@linux-foundation.org
Subject: + mm-check-that-we-have-the-right-vma-in-__access_remote_vm.patch added to -mm tree
Date: Mon, 11 Apr 2011 16:50:58 -0700
Message-ID: <201104112350.p3BNowll011529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756476Ab1DKXvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 19:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, hughd@google.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: check that we have the right vma in __access_remote_vm()
has been added to the -mm tree.  Its filename is
     mm-check-that-we-have-the-right-vma-in-__access_remote_vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: check that we have the right vma in __access_remote_vm()
From: Michael Ellerman <michael@ellerman.id.au>

In __access_remote_vm() we need to check that we have found the right vma,
not the following vma before we try to access it.  Otherwise we might call
the vma's access routine with an address which does not fall inside the
vma.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-check-that-we-have-the-right-vma-in-__access_remote_vm mm/memory.c
--- a/mm/memory.c~mm-check-that-we-have-the-right-vma-in-__access_remote_vm
+++ a/mm/memory.c
@@ -3678,7 +3678,7 @@ static int __access_remote_vm(struct tas
 			 */
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 			vma = find_vma(mm, addr);
-			if (!vma)
+			if (!vma || vma->vm_start > addr)
 				break;
 			if (vma->vm_ops && vma->vm_ops->access)
 				ret = vma->vm_ops->access(vma, addr, buf,
_

Patches currently in -mm which might be from michael@ellerman.id.au are

mm-check-that-we-have-the-right-vma-in-__access_remote_vm.patch

