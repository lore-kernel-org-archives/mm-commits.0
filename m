From: akpm@linux-foundation.org
Subject: [merged] fix-memory-ordering-bug-in-mm-vmallocc.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:08:22 -0800
Message-ID: <548d0d36.VY3bVmOFF5BAlHWi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaLNEIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, edumazet@google.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix memory ordering bug
has been removed from the -mm tree.  Its filename was
     fix-memory-ordering-bug-in-mm-vmallocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: mm/vmalloc.c: fix memory ordering bug

Read memory barriers must follow the read operations.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~fix-memory-ordering-bug-in-mm-vmallocc mm/vmalloc.c
--- a/mm/vmalloc.c~fix-memory-ordering-bug-in-mm-vmallocc
+++ a/mm/vmalloc.c
@@ -2574,10 +2574,10 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
-		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-		smp_rmb();
 		if (v->flags & VM_UNINITIALIZED)
 			return;
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
 
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
_

Patches currently in -mm which might be from dvyukov@google.com are

origin.patch

