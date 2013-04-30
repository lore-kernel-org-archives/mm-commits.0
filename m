From: akpm@linux-foundation.org
Subject: [merged] rpmsg-fix-error-return-code-in-rpmsg_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:36 -0700
Message-ID: <20130430185036.8026B5A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:64234 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab3D3Suh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:37 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86235ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, ohad@wizery.com, rusty@rustcorp.com.au, sboyd@codeaurora.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rpmsg/virtio_rpmsg_bus.c: fix error return code in rpmsg_probe()
has been removed from the -mm tree.  Its filename was
     rpmsg-fix-error-return-code-in-rpmsg_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/rpmsg/virtio_rpmsg_bus.c: fix error return code in rpmsg_probe()

Return a negative error code from the error handling case instead of 0, as
returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rpmsg/virtio_rpmsg_bus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-fix-error-return-code-in-rpmsg_probe drivers/rpmsg/virtio_rpmsg_bus.c
--- a/drivers/rpmsg/virtio_rpmsg_bus.c~rpmsg-fix-error-return-code-in-rpmsg_probe
+++ a/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -951,8 +951,10 @@ static int rpmsg_probe(struct virtio_dev
 	bufs_va = dma_alloc_coherent(vdev->dev.parent->parent,
 				RPMSG_TOTAL_BUF_SPACE,
 				&vrp->bufs_dma, GFP_KERNEL);
-	if (!bufs_va)
+	if (!bufs_va) {
+		err = -ENOMEM;
 		goto vqs_del;
+	}
 
 	dev_dbg(&vdev->dev, "buffers: va %p, dma 0x%llx\n", bufs_va,
 					(unsigned long long)vrp->bufs_dma);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch
drivers-w1-slaves-w1_ds2780c-fix-the-error-handling-in-w1_ds2780_add_slave.patch
drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch
drivers-w1-slaves-w1_ds2760c-fix-the-error-handling-in-w1_ds2760_add_slave.patch

