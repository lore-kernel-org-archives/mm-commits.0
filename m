From: akpm@linux-foundation.org
Subject: [merged] cciss-remove-useless-set-memory-to-zero-use-memset.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:33:12 -0700
Message-ID: <20120911193312.AFD98100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:54593 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:33:13 -0400
Received: by yhl10 with SMTP id 10so95675yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:33:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, axboe@kernel.dk, mike.miller@hp.com, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: remove unneeded memset()
has been removed from the -mm tree.  Its filename was
     cciss-remove-useless-set-memory-to-zero-use-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: cciss: remove unneeded memset()

The memory return by kzalloc() or kmem_cache_zalloc() has already be set
to zero, so remove useless memset(0).

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-remove-useless-set-memory-to-zero-use-memset drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-useless-set-memory-to-zero-use-memset
+++ a/drivers/block/cciss.c
@@ -5198,7 +5198,6 @@ static void cciss_shutdown(struct pci_de
 		return;
 	}
 	/* write all data in the battery backed cache to disk */
-	memset(flush_buf, 0, 4);
 	return_code = sendcmd_withirq(h, CCISS_CACHE_FLUSH, flush_buf,
 		4, 0, CTLR_LUNID, TYPE_CMD);
 	kfree(flush_buf);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
kdump-remove-unneeded-include.patch

