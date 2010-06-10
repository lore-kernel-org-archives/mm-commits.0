From: akpm@linux-foundation.org
Subject: + genalloc-fix-allocation-from-end-of-pool.patch added to -mm tree
Date: Thu, 10 Jun 2010 14:13:56 -0700
Message-ID: <201006102113.o5ALDuv8023970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab0FJVOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 17:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@nokia.com, akinobu.mita@gmail.com, tj@kernel.org, zygo.blaxell@xandros.com


The patch titled
     genalloc: fix allocation from end of pool
has been added to the -mm tree.  Its filename is
     genalloc-fix-allocation-from-end-of-pool.patch

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
Subject: genalloc: fix allocation from end of pool
From: Imre Deak <imre.deak@nokia.com>

bitmap_find_next_zero_area requires the size of the bitmap, we instead
passed the last suitable position.  This made it impossible to allocate
from the end of the pool.

Fixes a regression introduced by 243797f59b748f679ab88d456fcc4f92236d724b
("genalloc: use bitmap_find_next_zero_area").

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Cc: Zygo Blaxell <zygo.blaxell@xandros.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/genalloc.c~genalloc-fix-allocation-from-end-of-pool lib/genalloc.c
--- a/lib/genalloc.c~genalloc-fix-allocation-from-end-of-pool
+++ a/lib/genalloc.c
@@ -128,7 +128,6 @@ unsigned long gen_pool_alloc(struct gen_
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 
 		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
-		end_bit -= nbits + 1;
 
 		spin_lock_irqsave(&chunk->lock, flags);
 		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit, 0,
_

Patches currently in -mm which might be from imre.deak@nokia.com are

genalloc-fix-allocation-from-end-of-pool.patch

