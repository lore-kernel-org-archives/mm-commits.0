Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9D0C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiANWHc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48818 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiANWHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 078F461FE2
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C11C36AE5;
        Fri, 14 Jan 2022 22:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198051;
        bh=dWuzg1DeLjJJExaIBfZZunBr+biz1Xgp5Yu22jkp1ko=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Mn+YUkXtCbLDa1vPhshtRpwXRiQNLCg75Oi1OAeBakU4lTBtlDb149z6AinnUkVrx
         LFIT868pk8VIZHKmIzzF+RlxwfzQXlc2UkFyflaDDVHsvtjmwtT+K/bHFGeQAT3/PL
         6cV+ue4DKKmcIok3Dewl956SKnHXTWbiSFJJgKoY=
Date:   Fri, 14 Jan 2022 14:07:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        miles.chen@mediatek.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 083/146] include/linux/gfp.h: further document
 GFP_DMA32
Message-ID: <20220114220730.NH9yCa_p7%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>
Subject: include/linux/gfp.h: further document GFP_DMA32

kmalloc(..., GFP_DMA32) does not return DMA32 memory because the DMA32
kmalloc cache array is not implemented.  (Reason: there is no such user in
kernel).

Put a short comment about this so people can understand this by reading
the comment.

[1] https://lists.linuxfoundation.org/pipermail/iommu/2018-December/031696.html

Link: https://lkml.kernel.org/r/20211207093610.6406-1-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/gfp.h~gfp-further-document-gfp_dma32
+++ a/include/linux/gfp.h
@@ -302,7 +302,9 @@ struct vm_area_struct;
  * lowest zone as a type of emergency reserve.
  *
  * %GFP_DMA32 is similar to %GFP_DMA except that the caller requires a 32-bit
- * address.
+ * address. Note that kmalloc(..., GFP_DMA32) does not return DMA32 memory
+ * because the DMA32 kmalloc cache array is not implemented.
+ * (Reason: there is no such user in kernel).
  *
  * %GFP_HIGHUSER is for userspace allocations that may be mapped to userspace,
  * do not need to be directly accessible by the kernel but that cannot
_
