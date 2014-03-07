From: akpm@linux-foundation.org
Subject: + mempool-add-unlikely-and-likely-hints.patch added to -mm tree
Date: Fri, 07 Mar 2014 14:58:35 -0800
Message-ID: <531a4f1b.z69GSFMoSIz2NAuY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaCGW6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2014 17:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, mpatocka@redhat.com

Subject: + mempool-add-unlikely-and-likely-hints.patch added to -mm tree
To: mpatocka@redhat.com,mingo@elte.hu
From: akpm@linux-foundation.org
Date: Fri, 07 Mar 2014 14:58:35 -0800


The patch titled
     Subject: mempool: add unlikely and likely hints
has been added to the -mm tree.  Its filename is
     mempool-add-unlikely-and-likely-hints.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempool-add-unlikely-and-likely-hints.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempool-add-unlikely-and-likely-hints.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mempool: add unlikely and likely hints

Add unlikely and likely hints to the function mempool_free.  It lays out
the code in such a way that the common path is executed straighforward and
saves a cache line.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mempool.c~mempool-add-unlikely-and-likely-hints mm/mempool.c
--- a/mm/mempool.c~mempool-add-unlikely-and-likely-hints
+++ a/mm/mempool.c
@@ -304,9 +304,9 @@ void mempool_free(void *element, mempool
 	 * ensures that there will be frees which return elements to the
 	 * pool waking up the waiters.
 	 */
-	if (pool->curr_nr < pool->min_nr) {
+	if (unlikely(pool->curr_nr < pool->min_nr)) {
 		spin_lock_irqsave(&pool->lock, flags);
-		if (pool->curr_nr < pool->min_nr) {
+		if (likely(pool->curr_nr < pool->min_nr)) {
 			add_element(pool, element);
 			spin_unlock_irqrestore(&pool->lock, flags);
 			wake_up(&pool->wait);
_

Patches currently in -mm which might be from mpatocka@redhat.com are

mempool-add-unlikely-and-likely-hints.patch
linux-next.patch

