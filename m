Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C07C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF52122D07
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhAXBNN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAXBNM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:13:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC89522CB9;
        Sun, 24 Jan 2021 01:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611450752;
        bh=yzA1Wvzh2QtAXS3i1PS4s38amrb5MZWICqWJ4nivm9g=;
        h=Date:From:To:Subject:From;
        b=VdL3Y4RxSz9mv08fKkNtUt8gPt9H1Uh1RTb2vxbATVQ1VNOJ3fnfnUX9zUjSL7hez
         YSxGZzmM3bOnhKf+tc7uBl57p3zDBeLMU70nT8L3HsoRQSwbZqDfB1GF1p8nTyGYkB
         avTOg4UKkIlLnWnJ2Bmr82PwhuYsg9yYrxX7YhhQ=
Date:   Sat, 23 Jan 2021 17:12:31 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stephenzhangzsd@gmail.com
Subject:  +
 mm-early_ioremapc-use-__func__-instead-of-function-name.patch added to -mm
 tree
Message-ID: <20210124011231.WUHcujNOz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap.c: use __func__ instead of function name
has been added to the -mm tree.  Its filename is
     mm-early_ioremapc-use-__func__-instead-of-function-name.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-early_ioremapc-use-__func__-instead-of-function-name.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-early_ioremapc-use-__func__-instead-of-function-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-early_ioremapc-use-__func__-instead-of-function-name.patch

