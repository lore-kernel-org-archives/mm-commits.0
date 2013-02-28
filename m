From: akpm@linux-foundation.org
Subject: [merged] memstick-move-the-dereference-below-the-null-test.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:42 -0800
Message-ID: <20130228201742.A912C31C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42657 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3B1URn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:43 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246802yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: move the dereference below the NULL test
has been removed from the -mm tree.  Its filename was
     memstick-move-the-dereference-below-the-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: memstick: move the dereference below the NULL test

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/memstick/host/r592.c~memstick-move-the-dereference-below-the-null-test drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-move-the-dereference-below-the-null-test
+++ a/drivers/memstick/host/r592.c
@@ -454,7 +454,7 @@ static int r592_transfer_fifo_pio(struct
 /* Executes one TPC (data is read/written from small or large fifo) */
 static void r592_execute_tpc(struct r592_device *dev)
 {
-	bool is_write = dev->req->tpc >= MS_TPC_SET_RW_REG_ADRS;
+	bool is_write;
 	int len, error;
 	u32 status, reg;
 
@@ -463,6 +463,7 @@ static void r592_execute_tpc(struct r592
 		return;
 	}
 
+	is_write = dev->req->tpc >= MS_TPC_SET_RW_REG_ADRS;
 	len = dev->req->long_data ?
 		dev->req->sg.length : dev->req->data_len;
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

