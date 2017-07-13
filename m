From: akpm@linux-foundation.org
Subject: [merged]
 drivers-s390-move-static-and-inline-before-return-type.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:43:33 -0700
Message-ID: <20170713204333.EpAx5rzF7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59914 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUne (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, joe@perches.com, jwi@linux.vnet.ibm.com, mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, ubraun@linux.vnet.ibm.com


The patch titled
     Subject: drivers: s390: move static and inline before return type
has been removed from the -mm tree.  Its filename was
     drivers-s390-move-static-and-inline-before-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers: s390: move static and inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/3f980cd89084ae09716353aba3171e4b3815e690.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julian Wiedmann <jwi@linux.vnet.ibm.com>
Cc: Ursula Braun <ubraun@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/ctcm_main.c    |    2 +-
 drivers/s390/net/qeth_l3_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/s390/net/ctcm_main.c~drivers-s390-move-static-and-inline-before-return-type drivers/s390/net/ctcm_main.c
--- a/drivers/s390/net/ctcm_main.c~drivers-s390-move-static-and-inline-before-return-type
+++ a/drivers/s390/net/ctcm_main.c
@@ -1115,7 +1115,7 @@ static const struct net_device_ops ctcm_
 	.ndo_start_xmit		= ctcmpc_tx,
 };
 
-void static ctcm_dev_setup(struct net_device *dev)
+static void ctcm_dev_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 100;
diff -puN drivers/s390/net/qeth_l3_main.c~drivers-s390-move-static-and-inline-before-return-type drivers/s390/net/qeth_l3_main.c
--- a/drivers/s390/net/qeth_l3_main.c~drivers-s390-move-static-and-inline-before-return-type
+++ a/drivers/s390/net/qeth_l3_main.c
@@ -2408,7 +2408,7 @@ static int qeth_l3_do_ioctl(struct net_d
 	return rc;
 }
 
-int inline qeth_l3_get_cast_type(struct qeth_card *card, struct sk_buff *skb)
+inline int qeth_l3_get_cast_type(struct qeth_card *card, struct sk_buff *skb)
 {
 	int cast_type = RTN_UNSPEC;
 	struct neighbour *n = NULL;
_

Patches currently in -mm which might be from joe@perches.com are


