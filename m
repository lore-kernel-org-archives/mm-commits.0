From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:31 -0700
Message-ID: <20130325194531.7981331C1B3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44783 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab3CYTpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:32 -0400
Received: by mail-qa0-f74.google.com with SMTP id k4so436602qaq.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, axboe@kernel.dk, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: fix invalid use of sizeof in cciss_find_cfgtables()
has been removed from the -mm tree.  Its filename was
     cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: cciss: fix invalid use of sizeof in cciss_find_cfgtables()

sizeof() when applied to a pointer typed expression gives the size of the
pointer, not that of the pointed data.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables
+++ a/drivers/block/cciss.c
@@ -4206,7 +4206,7 @@ static int cciss_find_cfgtables(ctlr_inf
 	if (rc)
 		return rc;
 	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
-		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
+		cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
 	if (!h->cfgtable)
 		return -ENOMEM;
 	rc = write_driver_ver_to_cfgtable(h->cfgtable);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch

