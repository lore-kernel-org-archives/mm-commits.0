From: akpm@linux-foundation.org
Subject: - ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:02 -0700
Message-ID: <200806122037.m5CKb2gp005398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbYFLUhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jeff@garzik.org, romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     ipg: fix receivemode IPG_RM_RECEIVEMULTICAST{,HASH} in ipg_nic_set_multicast_list()
has been removed from the -mm tree.  Its filename was
     ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipg: fix receivemode IPG_RM_RECEIVEMULTICAST{,HASH} in ipg_nic_set_multicast_list()
From: Roel Kluin <roel.kluin@gmail.com>

The branches are dead code.  even when dev->flag IFF_MULTICAST (defined
0x1000) is set, dev->flags & IFF_MULTICAST & [boolean] always evaluates to
0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ipg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ipg.c~ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list drivers/net/ipg.c
--- a/drivers/net/ipg.c~ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list
+++ a/drivers/net/ipg.c
@@ -577,12 +577,12 @@ static void ipg_nic_set_multicast_list(s
 		/* NIC to be configured in promiscuous mode. */
 		receivemode = IPG_RM_RECEIVEALLFRAMES;
 	} else if ((dev->flags & IFF_ALLMULTI) ||
-		   (dev->flags & IFF_MULTICAST &
+		   ((dev->flags & IFF_MULTICAST) &&
 		    (dev->mc_count > IPG_MULTICAST_HASHTABLE_SIZE))) {
 		/* NIC to be configured to receive all multicast
 		 * frames. */
 		receivemode |= IPG_RM_RECEIVEMULTICAST;
-	} else if (dev->flags & IFF_MULTICAST & (dev->mc_count > 0)) {
+	} else if ((dev->flags & IFF_MULTICAST) && (dev->mc_count > 0)) {
 		/* NIC to be configured to receive selected
 		 * multicast addresses. */
 		receivemode |= IPG_RM_RECEIVEMULTICASTHASH;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

git-net.patch

