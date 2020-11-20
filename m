Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC5FC388F9
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 01:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5957B22256
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 01:25:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZifFPW3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgKTBZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Nov 2020 20:25:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgKTBZq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Nov 2020 20:25:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E182F22254;
        Fri, 20 Nov 2020 01:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605835546;
        bh=Wuc+OIblcghswG+fPfmEEO4gEZv3pVQrUI1H7b7aj0k=;
        h=Date:From:To:Subject:From;
        b=ZifFPW3bbP1qGwsD7Z8dMIAtaTFs3T/4PF6BbTOdBeWIBforNUMDVbxxHhhjTarPW
         EZ6g6lkcwG/KWz+GvynbsDRNk6RmVxDDDeGVA5vvw3ikhZ+d9prYGYKHeD6sWxj+e/
         /KJ94AjpcISyhC4dVJRSYXbeD/Yy8vzWTUPDE0iU=
Date:   Thu, 19 Nov 2020 17:25:45 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, nsaenzjulienne@suse.de
Subject:  + mm-remove-examples-from-enum-zone_type-comment.patch
 added to -mm tree
Message-ID: <20201120012545.MqVoEa_L3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: remove examples from enum zone_type comment
has been added to the -mm tree.  Its filename is
     mm-remove-examples-from-enum-zone_type-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-examples-from-enum-zone_type-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-examples-from-enum-zone_type-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Subject: include/linux/mmzone.h: remove examples from enum zone_type comment

We can't really list every setup in common code.  On top of that they are
unlikely to stay true for long as things change in the arch trees
independently of this comment.

Link: https://lkml.kernel.org/r/20201119175400.9995-8-nsaenzjulienne@suse.de
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/include/linux/mmzone.h~mm-remove-examples-from-enum-zone_type-comment
+++ a/include/linux/mmzone.h
@@ -355,26 +355,6 @@ enum zone_type {
 	 * DMA mask is assumed when ZONE_DMA32 is defined. Some 64-bit
 	 * platforms may need both zones as they support peripherals with
 	 * different DMA addressing limitations.
-	 *
-	 * Some examples:
-	 *
-	 *  - i386 and x86_64 have a fixed 16M ZONE_DMA and ZONE_DMA32 for the
-	 *    rest of the lower 4G.
-	 *
-	 *  - arm only uses ZONE_DMA, the size, up to 4G, may vary depending on
-	 *    the specific device.
-	 *
-	 *  - arm64 has a fixed 1G ZONE_DMA and ZONE_DMA32 for the rest of the
-	 *    lower 4G.
-	 *
-	 *  - powerpc only uses ZONE_DMA, the size, up to 2G, may vary
-	 *    depending on the specific device.
-	 *
-	 *  - s390 uses ZONE_DMA fixed to the lower 2G.
-	 *
-	 *  - ia64 and riscv only use ZONE_DMA32.
-	 *
-	 *  - parisc uses neither.
 	 */
 #ifdef CONFIG_ZONE_DMA
 	ZONE_DMA,
_

Patches currently in -mm which might be from nsaenzjulienne@suse.de are

mm-remove-examples-from-enum-zone_type-comment.patch

