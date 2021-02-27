Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DC5C4332D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF0B64F45
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhB0CbR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhB0Ca4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 605D864F21;
        Sat, 27 Feb 2021 02:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393025;
        bh=A6R16SVpe/GE5WUYkIlVOvwvu5vlVVo49Rmc3/XptVA=;
        h=Date:From:To:Subject:From;
        b=YsxksuGUE40STTtrvOxSLTvhuqrmJ2hCoBEzlT8D0Ci5yp300SM7xzP7mSK5LqLEu
         BZni2j6U0T66bnjJe01ETG3Cku1fSFGvbNvFOVRrr90ynfbUrlLqDGcsAc1bd1shmb
         aAm1vOlo2mBgNI+fh9AKCd/FBDWzBanhV8Exlleg=
Date:   Fri, 26 Feb 2021 18:30:25 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stephenzhangzsd@gmail.com
Subject:  [merged]
 mm-early_ioremapc-use-__func__-instead-of-function-name.patch removed from
 -mm tree
Message-ID: <20210227023025.ySKBdXI1J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap.c: use __func__ instead of function name
has been removed from the -mm tree.  Its filename was
     mm-early_ioremapc-use-__func__-instead-of-function-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: mm/early_ioremap.c: use __func__ instead of function name

It is better to use __func__ instead of function name.

Link: https://lkml.kernel.org/r/1611385587-4209-1-git-send-email-stephenzhangzsd@gmail.com
Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/early_ioremap.c~mm-early_ioremapc-use-__func__-instead-of-function-name
+++ a/mm/early_ioremap.c
@@ -181,17 +181,17 @@ void __init early_iounmap(void __iomem *
 		}
 	}
 
-	if (WARN(slot < 0, "early_iounmap(%p, %08lx) not found slot\n",
-		 addr, size))
+	if (WARN(slot < 0, "%s(%p, %08lx) not found slot\n",
+		  __func__, addr, size))
 		return;
 
 	if (WARN(prev_size[slot] != size,
-		 "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
-		 addr, size, slot, prev_size[slot]))
+		 "%s(%p, %08lx) [%d] size not consistent %08lx\n",
+		  __func__, addr, size, slot, prev_size[slot]))
 		return;
 
-	WARN(early_ioremap_debug, "early_iounmap(%p, %08lx) [%d]\n",
-	     addr, size, slot);
+	WARN(early_ioremap_debug, "%s(%p, %08lx) [%d]\n",
+	      __func__, addr, size, slot);
 
 	virt_addr = (unsigned long)addr;
 	if (WARN_ON(virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)))
_

Patches currently in -mm which might be from stephenzhangzsd@gmail.com are


