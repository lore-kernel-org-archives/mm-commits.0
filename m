From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 69/94] drivers/rapidio/devices/rio_mport_cdev.c: fix
 resource leak in error handling path in 'rio_dma_transfer()'
Date: Fri, 17 Nov 2017 15:37:57 -0800
Message-ID: <20171117153757.cd4b2666b2c95ad982092995@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56608 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030470AbdKQXh7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:37:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Logan Gunthorpe <logang@deltatee.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Jesper Nilsson <jesper.nilsson@axis.com>, Christian =?ISO-8859-1?Q?K=F6ni?= =?ISO-8859-1?Q?g?= <christian.koenig@amd.com>, mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: drivers/rapidio/devices/rio_mport_cdev.c: fix resource leak in error handling path in 'rio_dma_transfer()'

If 'dma_map_sg()', we should branch to the existing error handling path to
free some resources before returning.

Link: http://lkml.kernel.org/r/61292a4f369229eee03394247385e955027283f8.1505687047.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Christian K_nig <christian.koenig@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-resources-leak-in-error-handling-path-in-rio_dma_transfer drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-resources-leak-in-error-handling-path-in-rio_dma_transfer
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -963,7 +963,8 @@ rio_dma_transfer(struct file *filp, u32
 			   req->sgt.sgl, req->sgt.nents, dir);
 	if (nents == -EFAULT) {
 		rmcd_error("Failed to map SG list");
-		return -EFAULT;
+		ret = -EFAULT;
+		goto err_pg;
 	}
 
 	ret = do_dma_request(req, xfer, sync, nents);
_

