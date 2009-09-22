From: akpm@linux-foundation.org
Subject: [merged] vmallocc-fix-double-error-checking.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:58 -0700
Message-ID: <200909222038.n8MKcwx3002497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbZIVUnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: figo1802@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmalloc.c: fix double error checking
has been removed from the -mm tree.  Its filename was
     vmallocc-fix-double-error-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

