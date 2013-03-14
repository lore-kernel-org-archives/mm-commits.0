From: akpm@linux-foundation.org
Subject: + cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables.patch added to -mm tree
Date: Thu, 14 Mar 2013 13:29:56 -0700
Message-ID: <20130314202956.72CFB5A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43428 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3CNU35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 16:29:57 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so284329qaj.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 13:29:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, axboe@kernel.dk, scameron@beardog.cce.hp.com


The patch titled
     Subject: cciss: fix invalid use of sizeof in cciss_find_cfgtables()
has been added to the -mm tree.  Its filename is
     cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables.patch

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

linux-next.patch
cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables.patch

