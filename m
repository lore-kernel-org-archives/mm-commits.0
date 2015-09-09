From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:45:38 -0700
Message-ID: <55f08c62.Hg1EPSylKFBEbuL8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbIITpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: allow NULL `pool' pointer in mempool_destroy()
has been removed from the -mm tree.  Its filename was
     mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: mm/mempool: allow NULL `pool' pointer in mempool_destroy()

mempool_destroy() does not tolerate a NULL mempool_t pointer argument and
performs a NULL-pointer dereference.  This requires additional attention
and effort from developers/reviewers and forces all mempool_destroy()
callers to do a NULL check

	if (pool)
		mempool_destroy(pool);

Or, otherwise, be invalid mempool_destroy() users.

Tweak mempool_destroy() and NULL-check the pointer there.

Proposed by Andrew Morton.

Link: https://lkml.org/lkml/2015/6/8/583
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mempool.c~mm-mempool-allow-null-pool-pointer-in-mempool_destroy mm/mempool.c
--- a/mm/mempool.c~mm-mempool-allow-null-pool-pointer-in-mempool_destroy
+++ a/mm/mempool.c
@@ -150,6 +150,9 @@ static void *remove_element(mempool_t *p
  */
 void mempool_destroy(mempool_t *pool)
 {
+	if (unlikely(!pool))
+		return;
+
 	while (pool->curr_nr) {
 		void *element = remove_element(pool);
 		pool->free(element, pool->pool_data);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


