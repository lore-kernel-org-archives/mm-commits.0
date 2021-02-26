Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AA5C43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58FB64F33
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZBTs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhBZBT3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A63C64F2D;
        Fri, 26 Feb 2021 01:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302329;
        bh=vJm911EVMjSxlFFawOBOUPYT5JOFBmhG2jYg/shh7W4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sAEfXD95svZsggWYJuV/zP1l0siZFvgv3Vk4A+e9e5LUXl+3DP2XVDe9CIRREsem3
         lYoYRER1tTauHWQYde9Y6HD4pkm4tYrwYpzbO3tqdx8dkY7gbck43cxFsOTPx8RPQa
         mLwiSVAzGXlQ3LW5CNn7V0jZOjEIl9N0kAphDSKU=
Date:   Thu, 25 Feb 2021 17:18:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stephenzhangzsd@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 055/118] mm/early_ioremap.c: use __func__ instead
 of function name
Message-ID: <20210226011848.78gxatB5c%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
