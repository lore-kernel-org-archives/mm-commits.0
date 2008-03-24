From: akpm@linux-foundation.org
Subject: - connector-convert-to-single-threaded-workqueue.patch removed from -mm tree
Date: Mon, 24 Mar 2008 12:25:01 -0700
Message-ID: <200803241925.m2OJP1DF021489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760910AbYCXTgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 15:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     connector: convert to single-threaded workqueue
has been removed from the -mm tree.  Its filename was
     connector-convert-to-single-threaded-workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: connector: convert to single-threaded workqueue
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

We don't need one cqueue thread for each CPU.  cqueue is used for receiving
userspace datagrams, which are very rare and thus will happily live with a
single queue.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/connector/cn_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/connector/cn_queue.c~connector-convert-to-single-threaded-workqueue drivers/connector/cn_queue.c
--- a/drivers/connector/cn_queue.c~connector-convert-to-single-threaded-workqueue
+++ a/drivers/connector/cn_queue.c
@@ -146,7 +146,7 @@ struct cn_queue_dev *cn_queue_alloc_dev(
 
 	dev->nls = nls;
 
-	dev->cn_queue = create_workqueue(dev->name);
+	dev->cn_queue = create_singlethread_workqueue(dev->name);
 	if (!dev->cn_queue) {
 		kfree(dev);
 		return NULL;
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

git-net.patch

