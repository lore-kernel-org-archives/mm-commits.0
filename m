From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 30 Jun 2020 15:46:39 -0700
Message-ID: <20200630224639.cyIZkNlFn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgF3Wqk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 18:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c              |    4 ----
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c |    5 -----
 net/xfrm/xfrm_device.c                 |    7 -------
 3 files changed, 16 deletions(-)

--- a/drivers/cpuidle/cpuidle.c~linux-next-git-rejects
+++ a/drivers/cpuidle/cpuidle.c
@@ -187,11 +187,7 @@ int cpuidle_enter_s2idle(struct cpuidle_
 	 * be frozen safely.
 	 */
 	index = find_deepest_state(drv, dev, U64_MAX, 0, true);
-<<<<<<< HEAD
-	if (index > 0) {
-=======
 	if (index > 0 && !current_clr_polling_and_test())
->>>>>>> linux-next/akpm-base
 		enter_s2idle_proper(drv, dev, index);
 		local_irq_enable();
 	}
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1300,13 +1300,8 @@ static int sdma_v5_0_sw_fini(void *handl
 	int i;
 
 	for (i = 0; i < adev->sdma.num_instances; i++) {
-<<<<<<< HEAD
-		if (adev->sdma.instance[i].fw != NULL)
-			release_firmware(adev->sdma.instance[i].fw);
-=======
 		release_firmware(adev->sdma.instance[i].fw);
 		adev->sdma.instance[i].fw = NULL;
->>>>>>> linux-next/akpm-base
 
 		amdgpu_ring_fini(&adev->sdma.instance[i].ring);
 	}
--- a/net/xfrm/xfrm_device.c~linux-next-git-rejects
+++ a/net/xfrm/xfrm_device.c
@@ -135,13 +135,6 @@ struct sk_buff *validate_xmit_xfrm(struc
 	}
 
 	xo->flags |= XFRM_XMIT;
-<<<<<<< HEAD
-
-	if (skb_is_gso(skb)) {
-		struct net_device *dev = skb->dev;
-=======
->>>>>>> linux-next/akpm-base
