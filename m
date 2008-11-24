From: akpm@linux-foundation.org
Subject: + tokenring-3c359c-prevent-possible-mem-leak-when-open-failed.patch added to -mm tree
Date: Mon, 24 Nov 2008 15:46:44 -0800
Message-ID: <200811242346.mAONki82002510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbYKXXqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 18:46:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirka@pirko.cz


The patch titled
     tokenring/3c359.c: Prevent possible mem leak when open failed
has been added to the -mm tree.  Its filename is
     tokenring-3c359c-prevent-possible-mem-leak-when-open-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tokenring/3c359.c: Prevent possible mem leak when open failed
From: Jirka Pirko <jirka@pirko.cz>

Freeing previously allocated buffers in case of error.

Signed-off-by: Jirka Pirko <jirka@pirko.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tokenring/3c359.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/tokenring/3c359.c~tokenring-3c359c-prevent-possible-mem-leak-when-open-failed drivers/net/tokenring/3c359.c
--- a/drivers/net/tokenring/3c359.c~tokenring-3c359c-prevent-possible-mem-leak-when-open-failed
+++ a/drivers/net/tokenring/3c359.c
@@ -669,6 +669,8 @@ static int xl_open(struct net_device *de
 	if (i==0) { 
 		printk(KERN_WARNING "%s: Not enough memory to allocate rx buffers. Adapter disabled \n",dev->name) ; 
 		free_irq(dev->irq,dev) ; 
+		kfree(xl_priv->xl_tx_ring);
+		kfree(xl_priv->xl_rx_ring);
 		return -EIO ; 
 	} 
 
_

Patches currently in -mm which might be from jirka@pirko.cz are

tokenring-3c359c-fix-allocation-null-check.patch
tokenring-3c359c-fix-error-message-when-allocating-tx_ring.patch
tokenring-3c359c-prevent-possible-mem-leak-when-open-failed.patch

