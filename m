Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A948CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377852AbiATV0d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58002 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347710AbiATV0d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED994B81E6A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5CFC340E0;
        Thu, 20 Jan 2022 21:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713990;
        bh=ikuOLXx9dHeDfuPB2w2/5MVnM7GIU978Vy7p+vEd310=;
        h=Date:From:To:Subject:From;
        b=aQ4fJf59p2CPeP3whuZdxSe1tKHj3ZZHQN3mYE2i1snO9Z8080ryD5m2Uqiv3j94j
         HRhEexLisidLHCfD8eV6HgAceDZJ8GSKXp/mMmHtpMymG3czu82VHpU+9ZSEE97QOV
         9pf/FZaG1mm+wkOG1qC1djQOMEwDbEnLDsJB/U2U=
Date:   Thu, 20 Jan 2022 13:26:30 -0800
From:   akpm@linux-foundation.org
To:     miles.chen@mediatek.com, mm-commits@vger.kernel.org
Subject:  [merged] gfp-further-document-gfp_dma32.patch removed
 from -mm tree
Message-ID: <20220120212630.GY1yQ_1YF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/gfp.h: further document GFP_DMA32
has been removed from the -mm tree.  Its filename was
     gfp-further-document-gfp_dma32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from miles.chen@mediatek.com are


