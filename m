From: akpm@linux-foundation.org
Subject: + connector-convert-to-single-threaded-workqueue.patch added to -mm tree
Date: Thu, 06 Mar 2008 13:15:40 -0800
Message-ID: <200803062115.m26LFeCt018075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYCFVQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 16:16:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, davem@davemloft.net


The patch titled
     connector: convert to single-threaded workqueue
has been added to the -mm tree.  Its filename is
     connector-convert-to-single-threaded-workqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

connector-convert-to-single-threaded-workqueue.patch

