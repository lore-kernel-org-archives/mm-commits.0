Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AF2C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9606864F1B
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBZAkW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231614AbhBZAkQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:40:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4AAA64F21;
        Fri, 26 Feb 2021 00:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614299969;
        bh=leyFSUXcODB71AtS3AqOkrI+Wh2soTIwKNtwT2Iy90Q=;
        h=Date:From:To:Subject:From;
        b=kppOctRSqP4E/GufEWrJwcaxrIoNivmjVniKQ37UuiT2qR55gWNfGT3BvzXGFhJ7f
         4fqqtJ21OW3eGX88OU197JaFL91FAlnynRCHRQ+4pFZGHRWaLUDTB0OC8Mr+8oEMK4
         sY+7VBjeO3wP8J/qAJiX09Wb68dGOtZmXSAPx43g=
Date:   Thu, 25 Feb 2021 16:39:28 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org, rppt@kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-cma-allocate-cma-areas-bottom-up-fix-3.patch removed from -mm tree
Message-ID: <20210226003928.5y_GhKR_Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3
has been removed from the -mm tree.  Its filename was
     mm-cma-allocate-cma-areas-bottom-up-fix-3.patch

This patch was dropped because it was folded into mm-cma-allocate-cma-areas-bottom-up.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3

> 32-bit systems can have more than 32 bit in the physical address.
> I think a better option would be to use CONFIG_PHYS_ADDR_T_64BIT

I agree. An updated fixup below.

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix-3
+++ a/mm/cma.c
@@ -344,7 +344,7 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
-#if BITS_PER_LONG > 32
+#if CONFIG_PHYS_ADDR_T_64BIT
 		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
_

Patches currently in -mm which might be from guro@fb.com are

mm-cma-allocate-cma-areas-bottom-up.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

