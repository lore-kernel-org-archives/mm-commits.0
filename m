From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 70/94] drivers/rapidio/devices/rio_mport_cdev.c: fix error
 handling in 'rio_dma_transfer()'
Date: Fri, 17 Nov 2017 15:38:03 -0800
Message-ID: <20171117153803.d60fa14b2c9c337a5bc07d82@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56630 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423308AbdKQXiF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:38:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Logan Gunthorpe <logang@deltatee.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Jesper Nilsson <jesper.nilsson@axis.com>, Christian =?ISO-8859-1?Q?K=F6ni?= =?ISO-8859-1?Q?g?= <christian.koenig@amd.com>, mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

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
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Christian K_nig <christian.koenig@amd.com>
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

