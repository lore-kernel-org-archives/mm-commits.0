Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE45428315D
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 00:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689785; cv=none; b=lwfZcmh6wzixR72PuX25dmbzRFl26M8G4QC59qu76ugvrYB2rwds9oBGwd/Br4hyXP69xFfmDs4azbMCSon5ws8Q0Loaj+ZYE2AiG7rHq0lExSKYV7irrBR4AnWAtokUM2gokSiLa5SN55d73QaqdNeSFghXxr7x9snt7LbZm8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689785; c=relaxed/simple;
	bh=X8c5C2Zu02hfQnODV0pdKXJa1dtf8PGKWM5p3O20qeE=;
	h=Date:To:From:Subject:Message-Id; b=Rw6sdDtCBEWbCJlyQqErXM/La5XGeTMLZVy9Bn1+1ga5m4rmfrHhfyGQ++kNmXW7hh05Tfnme+Mr5qALKAd5Oek9v0gyVLIfAfckN3Fw1reTVNM9MMGqqEudumjUT/RmRfXVwri4pNN3Fr1MOD0ZcSG0VzTHWDpOMLgH9HMabx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ycH4tzEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ycH4tzEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA0B1F000FF;
	Fri, 18 Sep 2026 00:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789689779;
	bh=s0Jqmp4RjfASRO8BLeBN7rc5Lxtq+WxH1yW+hT8Bvg0=;
	h=Date:To:From:Subject;
	b=ycH4tzEVsNP4CK5hTQ+VqwamkWqjjOUvEBcCIxEjTtv/7O/k5j/Os/4Gbojo7otBJ
	 bSMF7Tv5kqHU8qoGKdjxJoZ9TUVNnUk+lAR7TvYqIYOuFsf6pULy+zZXTAk4j+6gS1
	 T+Hd2VH110BVX/EeYR8yHupWm74PbUOP7a0tdZoY=
Date: Thu, 17 Sep 2026 17:02:58 -0700
To: mm-commits@vger.kernel.org,vkoul@kernel.org,mporter@kernel.crashing.org,kees@kernel.org,error27@gmail.com,alex.bou9@gmail.com,Frank.Li@nxp.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-use-dmaengine_get_dma_device-instead-of-chan-device-dev.patch added to mm-nonmm-unstable branch
Message-Id: <20260918000258.DAA0B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: use dmaengine_get_dma_device() instead of chan->device->dev
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-use-dmaengine_get_dma_device-instead-of-chan-device-dev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-use-dmaengine_get_dma_device-instead-of-chan-device-dev.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Frank Li <Frank.Li@nxp.com>
Subject: rapidio: use dmaengine_get_dma_device() instead of chan->device->dev
Date: Thu, 17 Sep 2026 16:50:12 -0400

Replace direct dma_chan::device::dev access with the proper
dmaengine_get_dma_device() for consumer API.

chan->device->dev is not always the device used for DMA mapping.  Some DMA
engines support per-channel IOMMU mappings, so different channels may use
different DMA devices.  dmaengine_get_dma_device() returns the correct
device for each channel.

This also prepares for making the DMA engine provider data structures
private.  DMA consumers should not access DMA engine internals directly.

Assisted-by: LLM
Link: https://lore.kernel.org/20260917205016.1293317-1-Frank.Li@oss.nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Vinod Koul <vkoul@kernel.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-use-dmaengine_get_dma_device-instead-of-chan-device-dev
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -555,7 +555,7 @@ static void dma_req_free(struct kref *re
 			refcount);
 	struct mport_cdev_priv *priv = req->priv;
 
-	dma_unmap_sg(req->dmach->device->dev,
+	dma_unmap_sg(dmaengine_get_dma_device(req->dmach),
 		     req->sgt.sgl, req->sgt.nents, req->dir);
 	sg_free_table(&req->sgt);
 	if (req->page_list) {
@@ -916,7 +916,7 @@ rio_dma_transfer(struct file *filp, u32
 				xfer->offset, xfer->length);
 	}
 
-	nents = dma_map_sg(chan->device->dev,
+	nents = dma_map_sg(dmaengine_get_dma_device(chan),
 			   req->sgt.sgl, req->sgt.nents, dir);
 	if (nents == 0) {
 		rmcd_error("Failed to map SG list");
_

Patches currently in -mm which might be from Frank.Li@nxp.com are

rapidio-use-dmaengine_get_dma_device-instead-of-chan-device-dev.patch

