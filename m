From: akpm@linux-foundation.org
Subject: + cciss-remove-useless-set-memory-to-zero-use-memset.patch added to -mm tree
Date: Fri, 31 Aug 2012 16:00:14 -0700
Message-ID: <20120831230014.A0CC71E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34143 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2HaXAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 19:00:15 -0400
Received: by vcqp1 with SMTP id p1so400157vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 16:00:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, axboe@kernel.dk, mike.miller@hp.com, scameron@beardog.cce.hp.com


The patch titled
     Subject: cciss: remove unneeded memset()
has been added to the -mm tree.  Its filename is
     cciss-remove-useless-set-memory-to-zero-use-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cciss-remove-useless-set-memory-to-zero-use-memset.patch

