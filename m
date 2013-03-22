From: akpm@linux-foundation.org
Subject: + rpmsg-fix-error-return-code-in-rpmsg_probe.patch added to -mm tree
Date: Fri, 22 Mar 2013 12:40:18 -0700
Message-ID: <20130322194018.742AB5A4CCA@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59517 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3CVTkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 15:40:19 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so411746ggn.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 12:40:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, ohad@wizery.com, rusty@rustcorp.com.au, sboyd@codeaurora.org, tj@kernel.org


The patch titled
     Subject: drivers/rpmsg/virtio_rpmsg_bus.c: fix error return code in rpmsg_probe()
has been added to the -mm tree.  Its filename is
     rpmsg-fix-error-return-code-in-rpmsg_probe.patch

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
cciss-fix-invalid-use-of-sizeof-in-cciss_find_cfgtables.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch

