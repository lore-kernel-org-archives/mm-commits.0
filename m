From: akpm@linux-foundation.org
Subject: + drivers-net-irda-sir_devc-remove-spin_is_locked.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:15 -0700
Message-ID: <20120329213915.2B023A05B5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:46148 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933906Ab2C2VjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:39:21 -0400
Received: by ghbz15 with SMTP id z15so323615ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, davem@davemloft.net, samuel@sortiz.org


The patch titled
     Subject: drivers/net/irda/sir_dev.c: remove spin_is_locked()
has been added to the -mm tree.  Its filename is
     drivers-net-irda-sir_devc-remove-spin_is_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: drivers/net/irda/sir_dev.c: remove spin_is_locked()

It's hard to imagine how this spin_is_locked() debugging check is not
totally racy.  Remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/sir_dev.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/net/irda/sir_dev.c~drivers-net-irda-sir_devc-remove-spin_is_locked drivers/net/irda/sir_dev.c
--- a/drivers/net/irda/sir_dev.c~drivers-net-irda-sir_devc-remove-spin_is_locked
+++ a/drivers/net/irda/sir_dev.c
@@ -632,11 +632,6 @@ static netdev_tx_t sirdev_hard_xmit(stru
 	/* Init tx buffer*/
 	dev->tx_buff.data = dev->tx_buff.head;
 
-	/* Check problems */
-	if(spin_is_locked(&dev->tx_lock)) {
-		IRDA_DEBUG(3, "%s(), write not completed\n", __func__);
-	}
