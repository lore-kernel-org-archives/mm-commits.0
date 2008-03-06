From: akpm@linux-foundation.org
Subject: + numa-slab-allocator-migration-bugfix.patch added to -mm tree
Date: Wed, 05 Mar 2008 21:53:50 -0800
Message-ID: <200803060553.m265ro0b011510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbYCFFyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 00:54:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.korty@ccur.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     NUMA slab allocator migration bugfix
has been added to the -mm tree.  Its filename is
     numa-slab-allocator-migration-bugfix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NUMA slab allocator migration bugfix
From: Joe Korty <joe.korty@ccur.com>

NUMA slab allocator cpu migration bugfix

The NUMA slab allocator (specifically, cache_alloc_refill) is not refreshing
its local copies of what cpu and what numa node it is on, when it drops and
reacquires the irq block that it inherited from its caller.  As a result those
values become invalid if an attempt to migrate the process to another numa
node occured while the irq block had been dropped.

The solution is to make cache_alloc_refill reload these variables whenever it
drops and reacquires the irq block.

The error is very difficult to hit.  When it does occur, one gets the
following oops + stack traceback bits in check_spinlock_acquired:

	kernel BUG at mm/slab.c:2417
	cache_alloc_refill+0xe6
	kmem_cache_alloc+0xd0
	...

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~numa-slab-allocator-migration-bugfix mm/slab.c
--- a/mm/slab.c~numa-slab-allocator-migration-bugfix
+++ a/mm/slab.c
@@ -2960,11 +2960,10 @@ static void *cache_alloc_refill(struct k
 	struct array_cache *ac;
 	int node;
 
-	node = numa_node_id();
