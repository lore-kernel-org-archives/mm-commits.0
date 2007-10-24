From: akpm@linux-foundation.org
Subject: - net-fix-xfrm-build-missing-scatterlisth-include.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:34 -0700
Message-ID: <200710242141.l9OLfYi8013966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757746AbXJXVmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, davem@davemloft.net, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     net: fix xfrm build - missing scatterlist.h include
has been removed from the -mm tree.  Its filename was
     net-fix-xfrm-build-missing-scatterlisth-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net: fix xfrm build - missing scatterlist.h include
From: Heiko Carstens <heiko.carstens@de.ibm.com>

net/xfrm/xfrm_algo.c: In function 'skb_icv_walk':
net/xfrm/xfrm_algo.c:555: error: implicit declaration of function 'sg_set_page'
make[2]: *** [net/xfrm/xfrm_algo.o] Error 1

Cc: David Miller <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/xfrm/xfrm_algo.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/xfrm/xfrm_algo.c~net-fix-xfrm-build-missing-scatterlisth-include net/xfrm/xfrm_algo.c
--- a/net/xfrm/xfrm_algo.c~net-fix-xfrm-build-missing-scatterlisth-include
+++ a/net/xfrm/xfrm_algo.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/pfkeyv2.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <net/xfrm.h>
 #if defined(CONFIG_INET_AH) || defined(CONFIG_INET_AH_MODULE) || defined(CONFIG_INET6_AH) || defined(CONFIG_INET6_AH_MODULE)
 #include <net/ah.h>
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are
