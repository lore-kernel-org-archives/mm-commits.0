From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:14 -0700
Message-ID: <56f2d4fe.rBlSXI9nit/YQbc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbcCWRkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@mjdsystems.ca, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: avoid KASAN marking mempool poison checks as use-after-free
has been removed from the -mm tree.  Its filename was
     mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Dawson <matthew@mjdsystems.ca>
Subject: mm/mempool: avoid KASAN marking mempool poison checks as use-after-free

When removing an element from the mempool, mark it as unpoisoned in KASAN
before verifying its contents for SLUB/SLAB debugging.  Otherwise KASAN
will flag the reads checking the element use-after-free writes as
use-after-free reads.

Signed-off-by: Matthew Dawson <matthew@mjdsystems.ca>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempool.c~mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free mm/mempool.c
--- a/mm/mempool.c~mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free
+++ a/mm/mempool.c
@@ -135,8 +135,8 @@ static void *remove_element(mempool_t *p
 	void *element = pool->elements[--pool->curr_nr];
 
 	BUG_ON(pool->curr_nr < 0);
-	check_element(pool, element);
 	kasan_unpoison_element(pool, element);
+	check_element(pool, element);
 	return element;
 }
 
_

Patches currently in -mm which might be from matthew@mjdsystems.ca are


