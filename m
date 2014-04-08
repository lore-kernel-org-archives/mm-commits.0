From: akpm@linux-foundation.org
Subject: [merged] mempool-add-unlikely-and-likely-hints.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:47:39 -0700
Message-ID: <5344606b.wN8iObHCqyjAmY7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, mpatocka@redhat.com

Subject: [merged] mempool-add-unlikely-and-likely-hints.patch removed from -mm tree
To: mpatocka@redhat.com,mingo@elte.hu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:47:39 -0700


The patch titled
     Subject: mempool: add unlikely and likely hints
has been removed from the -mm tree.  Its filename was
     mempool-add-unlikely-and-likely-hints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

