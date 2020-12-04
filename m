Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0CBC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039C022D5A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgLDWzo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 17:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgLDWzo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 17:55:44 -0500
Date:   Fri, 04 Dec 2020 14:55:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607122504;
        bh=0x2/+f201t+ObTgKdy5dOKpT3v1v4o74+yZY5nVMTTU=;
        h=From:To:Subject:From;
        b=e9XsZm16ktmrbalOknatdbiIxFsZaYGDq1ROfqZPctJSy5OxRwH7ZDhxKtlQBIpMM
         d41cukucP43ZCXNbCvJ1mUMmheFWGlY8oTI5SktqC055YEUm/4PzSieVhZo0erDf4p
         8uCdjCHB/y7KT9TSl4JFrCqoCer0S/6SCBvqqid0=
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, nsaenzjulienne@suse.de
Subject:  [merged]
 mm-remove-examples-from-enum-zone_type-comment.patch removed from -mm tree
Message-ID: <20201204225503.sfZsL1pzw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: remove examples from enum zone_type comment
has been removed from the -mm tree.  Its filename was
     mm-remove-examples-from-enum-zone_type-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


