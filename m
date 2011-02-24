From: akpm@linux-foundation.org
Subject: + skge-dont-mark-carrier-down-at-start.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:52:49 -0800
Message-ID: <201102240052.p1O0qnDD002449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab1BXAxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, davem@davemloft.net, gbillios@gmail.com, shemminger@vyatta.com


The patch titled
     skge: don't mark carrier down at start
has been added to the -mm tree.  Its filename is
     skge-dont-mark-carrier-down-at-start.patch

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
Subject: skge: don't mark carrier down at start
From: Stephen Hemminger <shemminger@linux-foundation.org>

The API for network devices has changed so that setting carrier off at
probe is no longer required.  This should fix the IPv6 addrconf issue.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=29612

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Reported-by: George Billios <gbillios@gmail.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/net/skge.c~skge-dont-mark-carrier-down-at-start drivers/net/skge.c
--- a/drivers/net/skge.c~skge-dont-mark-carrier-down-at-start
+++ a/drivers/net/skge.c
@@ -3856,9 +3856,6 @@ static struct net_device *skge_devinit(s
 	memcpy_fromio(dev->dev_addr, hw->regs + B2_MAC_1 + port*8, ETH_ALEN);
 	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
 
-	/* device is off until link detection */
-	netif_carrier_off(dev);
