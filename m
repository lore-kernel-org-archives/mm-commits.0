From: akpm@linux-foundation.org
Subject: [merged] dmaengine-correct-onstack-wait_queue_head-declaration.patch removed from -mm tree
Date: Mon, 08 Feb 2010 11:52:30 -0800
Message-ID: <201002081952.o18JqU2b031421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab0BHTwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 14:52:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.zhang0@gmail.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     dmaengine: correct onstack wait_queue_head declaration
has been removed from the -mm tree.  Its filename was
     dmaengine-correct-onstack-wait_queue_head-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmaengine: correct onstack wait_queue_head declaration
From: Yong Zhang <yong.zhang0@gmail.com>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK() to make lockdep happy.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/dmatest.c~dmaengine-correct-onstack-wait_queue_head-declaration drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmaengine-correct-onstack-wait_queue_head-declaration
+++ a/drivers/dma/dmatest.c
@@ -467,7 +467,7 @@ err_srcs:
 
 	if (iterations > 0)
 		while (!kthread_should_stop()) {
-			DECLARE_WAIT_QUEUE_HEAD(wait_dmatest_exit);
+			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
 			interruptible_sleep_on(&wait_dmatest_exit);
 		}
 
_

Patches currently in -mm which might be from yong.zhang0@gmail.com are

linux-next.patch

