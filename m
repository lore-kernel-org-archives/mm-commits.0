Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357FBC43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A77E613A9
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhD3F6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhD3F6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D976C6147D;
        Fri, 30 Apr 2021 05:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762276;
        bh=4CTjNp29YkDniqT/yai+T4tCx8274zs77/pB9qwZRFg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m4h1UE6T7fe8tHoMwi3qwfQfilxse5Lty+VvPbZzJYmmH0Zk9PtefyaiFlp6PLDWN
         ohTqY54TzBH8vZJhDJM/JwM9c1dj+aKXHhl3uP1czNG/X4cBYf1C5P9A8/1pPEHnS0
         7+CLYL48dvoz9Qq2+ipCL45R7K4gRcas1rUooIhQ=
Date:   Thu, 29 Apr 2021 22:57:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 092/178] mm/dmapool: switch from strlcpy to
 strscpy
Message-ID: <20210430055755.2CTXvgTSk%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/dmapool: switch from strlcpy to strscpy

strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
and there is no functional difference when the caller expects truncation
(when not checking the return value). strscpy is relatively better as it
also avoids scanning the whole source string.

Link: https://lkml.kernel.org/r/1613962050-14188-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/dmapool.c~mm-dmapool-switch-from-strlcpy-to-strscpy
+++ a/mm/dmapool.c
@@ -157,7 +157,7 @@ struct dma_pool *dma_pool_create(const c
 	if (!retval)
 		return retval;
 
-	strlcpy(retval->name, name, sizeof(retval->name));
+	strscpy(retval->name, name, sizeof(retval->name));
 
 	retval->dev = dev;
 
_
