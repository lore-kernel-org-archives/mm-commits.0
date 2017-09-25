From: akpm@linux-foundation.org
Subject: + rapidio-fix-an-error-handling-in-rio_dma_transfer.patch added
 to -mm tree
Date: Mon, 25 Sep 2017 16:21:29 -0700
Message-ID: <59c98f79.wImTjCMQlyb+pfTM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965659AbdIYXVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2017 19:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org, alexandre.bounine@idt.com, christian.koenig@amd.com, jesper.nilsson@axis.com, logang@deltatee.com, lstoakes@gmail.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/devices/rio_mport_cdev.c: fix error handling in 'rio_dma_transfer()'
has been added to the -mm tree.  Its filename is
     rapidio-fix-an-error-handling-in-rio_dma_transfer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-fix-an-error-handling-in-rio_dma_transfer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-fix-an-error-handling-in-rio_dma_transfer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: drivers/rapidio/devices/rio_mport_cdev.c: fix error handling in 'rio_dma_transfer()'

In case of error, 'dma_map_sg()' returns 0, not a negative value.  There
is BUG_ON() in 'dma_map_sg_attrs()' which makes sure of that.

Link: http://lkml.kernel.org/r/d4235bd2b9274e99f6c86ea71b1fa1c7bd8d0c08.1505687047.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-an-error-handling-in-rio_dma_transfer drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-an-error-handling-in-rio_dma_transfer
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -961,7 +961,7 @@ rio_dma_transfer(struct file *filp, u32
 
 	nents = dma_map_sg(chan->device->dev,
 			   req->sgt.sgl, req->sgt.nents, dir);
-	if (nents == -EFAULT) {
+	if (nents == 0) {
 		rmcd_error("Failed to map SG list");
 		ret = -EFAULT;
 		goto err_pg;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

rapidio-fix-resources-leak-in-error-handling-path-in-rio_dma_transfer.patch
rapidio-fix-an-error-handling-in-rio_dma_transfer.patch

