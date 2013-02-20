From: akpm@linux-foundation.org
Subject: + memstick-move-the-dereference-below-the-null-test.patch added to -mm tree
Date: Wed, 20 Feb 2013 15:58:18 -0800
Message-ID: <20130220235818.B31145A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:47097 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3BTX6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 18:58:20 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so862191ves.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 15:58:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, maximlevitsky@gmail.com


The patch titled
     Subject: memstick: move the dereference below the NULL test
has been added to the -mm tree.  Its filename is
     memstick-move-the-dereference-below-the-null-test.patch

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

linux-next.patch
mn10300-use-for_each_pci_dev-to-simplify-the-code.patch
configfs-move-the-dereference-below-the-null-test.patch
memstick-move-the-dereference-below-the-null-test.patch

