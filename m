From: akpm@linux-foundation.org
Subject: [patch 90/96] drivers: s390: move static and inline before
 return type
Date: Wed, 12 Jul 2017 14:37:34 -0700
Message-ID: <20170712213734.BYX5qrS__%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, joe@perches.com, jwi@linux.vnet.ibm.com, mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, torvalds@linux-foundation.org, ubraun@linux.vnet.ibm.com

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
