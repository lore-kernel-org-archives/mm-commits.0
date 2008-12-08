From: akpm@linux-foundation.org
Subject: - hysdn-fix-writing-outside-the-field-on-64-bits.patch removed from -mm tree
Date: Mon, 08 Dec 2008 15:24:11 -0800
Message-ID: <200812082324.mB8NOBVf006849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbYLHXYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:24:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pterjan@mandriva.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     hysdn: fix writing outside the field on 64 bits
has been removed from the -mm tree.  Its filename was
     hysdn-fix-writing-outside-the-field-on-64-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hysdn: fix writing outside the field on 64 bits
From: Pascal Terjan <pterjan@mandriva.com>

ifa_local is assumed to be unsigned long which lead to writing the address
at dev->dev_addr-2 instead of +2

noticed thanks to gcc:

drivers/isdn/hysdn/hysdn_net.c: In function `net_open':
drivers/isdn/hysdn/hysdn_net.c:91: warning: array subscript is below array bounds

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/hysdn_net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/hysdn/hysdn_net.c~hysdn-fix-writing-outside-the-field-on-64-bits drivers/isdn/hysdn/hysdn_net.c
--- a/drivers/isdn/hysdn/hysdn_net.c~hysdn-fix-writing-outside-the-field-on-64-bits
+++ a/drivers/isdn/hysdn/hysdn_net.c
@@ -83,12 +83,12 @@ net_open(struct net_device *dev)
 
 	/* Fill in the MAC-level header (if not already set) */
 	if (!card->mac_addr[0]) {
-		for (i = 0; i < ETH_ALEN - sizeof(unsigned long); i++)
+		for (i = 0; i < ETH_ALEN; i++)
 			dev->dev_addr[i] = 0xfc;
 		if ((in_dev = dev->ip_ptr) != NULL) {
 			struct in_ifaddr *ifa = in_dev->ifa_list;
 			if (ifa != NULL)
-				memcpy(dev->dev_addr + (ETH_ALEN - sizeof(unsigned long)), &ifa->ifa_local, sizeof(unsigned long));
+				memcpy(dev->dev_addr + (ETH_ALEN - sizeof(ifa->ifa_local)), &ifa->ifa_local, sizeof(ifa->ifa_local));
 		}
 	} else
 		memcpy(dev->dev_addr, card->mac_addr, ETH_ALEN);
_

Patches currently in -mm which might be from pterjan@mandriva.com are

linux-next.patch

