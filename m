From: akpm@linux-foundation.org
Subject: +
 mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free.patch added to -mm tree
Date: Wed, 09 Mar 2016 14:49:39 -0800
Message-ID: <56e0a883.KpRc8H7L5x1/wEZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbcCIWtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 17:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@mjdsystems.ca, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: Avoid KASAN marking mempool posion checks as use-after-free
has been added to the -mm tree.  Its filename is
     mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Dawson <matthew@mjdsystems.ca>
Subject: mm/mempool: Avoid KASAN marking mempool posion checks as use-after-free

When removing an element from the mempool, mark it as unpoisoned in KASAN
before verifying its contents for SLUB/SLAB debugging.  Otherwise KASAN
will flag the reads checking the element use-after-free writes as
use-after-free reads.

Signed-off-by: Matthew Dawson <matthew@mjdsystems.ca>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
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

mm-mempool-avoid-kasan-marking-mempool-posion-checks-as-use-after-free.patch

