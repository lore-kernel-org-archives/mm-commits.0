From: akpm@linux-foundation.org
Subject: + arch-um-fix-kunmap_atomic-call-in-skas-uaccessc.patch added to -mm tree
Date: Wed, 02 Jun 2010 11:53:51 -0700
Message-ID: <201006021853.o52IrpNd010607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081Ab0FBSyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 14:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, jdike@addtoit.com


The patch titled
     arch/um: fix kunmap_atomic() call in skas/uaccess.c
has been added to the -mm tree.  Its filename is
     arch-um-fix-kunmap_atomic-call-in-skas-uaccessc.patch

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
Subject: arch/um: fix kunmap_atomic() call in skas/uaccess.c
From: Cesar Eduardo Barros <cesarb@cesarb.net>

kunmap_atomic() takes a pointer to within the page, not the struct page.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/uaccess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/skas/uaccess.c~arch-um-fix-kunmap_atomic-call-in-skas-uaccessc arch/um/kernel/skas/uaccess.c
--- a/arch/um/kernel/skas/uaccess.c~arch-um-fix-kunmap_atomic-call-in-skas-uaccessc
+++ a/arch/um/kernel/skas/uaccess.c
@@ -81,7 +81,7 @@ static int do_op_one_page(unsigned long 
 
 	current->thread.fault_catcher = NULL;
 
-	kunmap_atomic(page, KM_UML_USERCOPY);
+	kunmap_atomic((void *)addr, KM_UML_USERCOPY);
 
 	return n;
 }
_

Patches currently in -mm which might be from cesarb@cesarb.net are

arch-um-fix-kunmap_atomic-call-in-skas-uaccessc.patch

