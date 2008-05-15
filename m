From: akpm@linux-foundation.org
Subject: + ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list.patch added to -mm tree
Date: Thu, 15 May 2008 14:28:35 -0700
Message-ID: <200805152128.m4FLSaM2011434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037AbYEOV3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:29:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jeff@garzik.org, romieu@fr.zoreil.com


The patch titled
     ipg: fix receivemode IPG_RM_RECEIVEMULTICAST{,HASH} in ipg_nic_set_multicast_list()
has been added to the -mm tree.  Its filename is
     ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list.patch

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

ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list.patch
wireless-airo-waitbusy-wont-delay.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch

