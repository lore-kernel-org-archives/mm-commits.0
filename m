From: akpm@linux-foundation.org
Subject: + net-fix-xfrm-build-missing-scatterlisth-include.patch added to -mm tree
Date: Mon, 22 Oct 2007 23:52:21 -0700
Message-ID: <200710230652.l9N6qLK6004502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbXJWGxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, davem@davemloft.net, jens.axboe@oracle.com


The patch titled
     net: fix xfrm build - missing scatterlist.h include
has been added to the -mm tree.  Its filename is
     net-fix-xfrm-build-missing-scatterlisth-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
fix-ll_rw_blkc-build-on-s390.patch
net-fix-xfrm-build-missing-scatterlisth-include.patch
