Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8854BC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 00:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242781AbhLHA0q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbhLHA0q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 19:26:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35112C061746
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 16:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 790AFCE1ECE
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 00:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D2BC341D9;
        Wed,  8 Dec 2021 00:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638922991;
        bh=D9mylkQijo35p2S31Q1pV2YmKeGlAcLk0ImP+CztAvk=;
        h=Date:From:To:Subject:From;
        b=sshx8AUMcy+qs7Z3xoh7azaFESBk5Arac86fRgdPsKAJkTL08knxsL5VKUI6MV3wK
         a6/Y2qSf8S3ApneFiIV3o/GQjmnZB8dvBGtd3/tS7pzZYuyBFB2J3tV7hkCgVbh0j/
         irTevtnOQX8iniPfsRPhpLnhe1D7+9lgJwSJsoB8=
Date:   Tue, 07 Dec 2021 16:23:11 -0800
From:   akpm@linux-foundation.org
To:     miles.chen@mediatek.com, mm-commits@vger.kernel.org
Subject:  + gfp-further-document-gfp_dma32.patch added to -mm tree
Message-ID: <20211208002311.zm9jX_yRg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/gfp.h: further document GFP_DMA32
has been added to the -mm tree.  Its filename is
     gfp-further-document-gfp_dma32.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gfp-further-document-gfp_dma32.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gfp-further-document-gfp_dma32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -298,7 +298,9 @@ struct vm_area_struct;
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

gfp-further-document-gfp_dma32.patch

