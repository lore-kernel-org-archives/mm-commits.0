From: akpm@linux-foundation.org
Subject: [merged] aio-fix-wrong-comment-in-aio_complete.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:18 -0700
Message-ID: <51db14ee.s01JM3dn3LTkdP8T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3GHThS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com

Subject: [merged] aio-fix-wrong-comment-in-aio_complete.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:18 -0700


The patch titled
     Subject: aio: fix wrong comment in aio_complete()
has been removed from the -mm tree.  Its filename was
     aio-fix-wrong-comment-in-aio_complete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: aio: fix wrong comment in aio_complete()

ctx->ctx_lock should be ctx->completion_lock.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/aio.c~aio-fix-wrong-comment-in-aio_complete fs/aio.c
--- a/fs/aio.c~aio-fix-wrong-comment-in-aio_complete
+++ a/fs/aio.c
@@ -625,7 +625,7 @@ void aio_complete(struct kiocb *iocb, lo
 
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
+	 * ctx->completion_lock to prevent other code from messing with the tail
 	 * pointer since we might be called from irq context.
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch
mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch
mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node.patch

