From: akpm@linux-foundation.org
Subject: + vmallocc-fix-double-error-checking.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:04:18 -0700
Message-ID: <200907212304.n6LN4Iim002843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756422AbZGUXFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: figo1802@gmail.com, tj@kernel.org


The patch titled
     vmalloc.c: fix double error checking
has been added to the -mm tree.  Its filename is
     vmallocc-fix-double-error-checking.patch

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
Subject: vmalloc.c: fix double error checking
From: "Figo.zhang" <figo1802@gmail.com>

There is no need for double error checking.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/vmalloc.c~vmallocc-fix-double-error-checking mm/vmalloc.c
--- a/mm/vmalloc.c~vmallocc-fix-double-error-checking
+++ a/mm/vmalloc.c
@@ -168,11 +168,9 @@ static int vmap_page_range_noflush(unsig
 		next = pgd_addr_end(addr, end);
 		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
 		if (err)
-			break;
+			return err;
 	} while (pgd++, addr = next, addr != end);
 
-	if (unlikely(err))
-		return err;
 	return nr;
 }
 
_

Patches currently in -mm which might be from figo1802@gmail.com are

linux-next.patch
vmallocc-fix-double-error-checking.patch

