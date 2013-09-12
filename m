From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempoolc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:51 -0700
Message-ID: <523219ef.KCAacas1FTfYIkYZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab3ILTpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] mm-mempoolc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:51 -0700


The patch titled
     Subject: mm/mempool.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
has been removed from the -mm tree.  Its filename was
     mm-mempoolc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm/mempool.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempool.c~mm-mempoolc-convert-kmalloc_nodegfp_zero-to-kzalloc_node mm/mempool.c
--- a/mm/mempool.c~mm-mempoolc-convert-kmalloc_nodegfp_zero-to-kzalloc_node
+++ a/mm/mempool.c
@@ -73,7 +73,7 @@ mempool_t *mempool_create_node(int min_n
 			       gfp_t gfp_mask, int node_id)
 {
 	mempool_t *pool;
-	pool = kmalloc_node(sizeof(*pool), gfp_mask | __GFP_ZERO, node_id);
+	pool = kzalloc_node(sizeof(*pool), gfp_mask, node_id);
 	if (!pool)
 		return NULL;
 	pool->elements = kmalloc_node(min_nr * sizeof(void *),
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch

