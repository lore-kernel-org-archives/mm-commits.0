Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F413B5B3
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757193; cv=none; b=b5TAcIlwU8XynNSmJsVfyiSwRINuCROr3IRqFmX0LcyasvXsSLdgb3W3HCG4uQQY505MT1vqgozLJ4gncBn43qMFn5d4fREHqbjquLhVmFpJg2v/9n2fMXdkgDi8Nstx0NrnrDhCOPbpNLiLk3axZRwQjGTxU7wSGDcPl4zFrfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757193; c=relaxed/simple;
	bh=vkQOv6yynFMOBYDgs46ecQlhoaFjSO7BfFJzslFTzX0=;
	h=Date:To:From:Subject:Message-Id; b=kcWtBPejtXQ2x6zU1W/DTS4u22dHNroKGPVo4lhpUuD5n8QZ0IYwoGPDaI6TXwGF4tO4jjjoFeAPE0uHbQDMdDYB1qNkc+WELViFgCcQNvV14uXz1Yn/s0dvl7hKlx7AZlO1BEwka80RWT34qSjNLNEGwZf/G76tvl0PVNI+rx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mSI9WlTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mSI9WlTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9365F1F0089B;
	Sun, 11 Oct 2026 22:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757192;
	bh=apGICPAcuJAeH4Gne5xnsrlxtVnzLhfNQ8TnXNQ4MyI=;
	h=Date:To:From:Subject;
	b=mSI9WlThcC+FzLpXU1pEbx65pvM5Iu4DINQz59gELkBQYFi+kt+FrNkxzSbi5l0la
	 RWLJWcJa8VtLGGG8ti7elqQ7rIgNKOoK+kUnkBzOQkxKoXdGBiNeuJw9Znd6vMM9sR
	 SxZ0Mm7yPxqKVhMTI0E8DTGOyK4tnP6jSq9jdPlQ=
Date: Sun, 11 Oct 2026 15:19:52 -0700
To: mm-commits@vger.kernel.org,vkoul@kernel.org,mporter@kernel.crashing.org,kees@kernel.org,error27@gmail.com,alex.bou9@gmail.com,Frank.Li@nxp.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-use-dmaengine_get_dma_device-instead-of-chan-device-dev.patch removed from -mm tree
Message-Id: <20261011221952.9365F1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: use dmaengine_get_dma_device() instead of chan->device->dev
has been removed from the -mm tree.  Its filename was
     rapidio-use-dmaengine_get_dma_device-instead-of-chan-device-dev.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260917205016.1293317-1-Frank.Li@oss.nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
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


