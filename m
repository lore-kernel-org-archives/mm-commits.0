Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08113C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFB746141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWnX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhEHWnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7362461402;
        Sat,  8 May 2021 22:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513740;
        bh=gHCj2wcDzytQ7SFSIZWPma6tfSjbx9Dkx1YTLtjfQ+U=;
        h=Date:From:To:Subject:From;
        b=YNo9d6immeNvR0xFiB1H317sV5SJ15xEOIDzJRpKpHo1/4czKIvqyat6mggAE/bSS
         0Nj3hfYWcayEny3Nh3Ou71gJCLS1urfnu4MtktFAxF9kuyJiG98O22DVNBqAAhdrn1
         3CqlWuy9hypWHd3Lby99qQCzO3oQ78wiGSLrIpbY=
Date:   Sat, 08 May 2021 15:42:20 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [merged] mm-dmapool-switch-from-strlcpy-to-strscpy.patch
 removed from -mm tree
Message-ID: <20210508224220.rUR43ALUE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool: switch from strlcpy to strscpy
has been removed from the -mm tree.  Its filename was
     mm-dmapool-switch-from-strlcpy-to-strscpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are


