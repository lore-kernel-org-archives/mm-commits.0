Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5474AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiANWEN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiANWEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1054C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DBC961FF8
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B25C36AE5;
        Fri, 14 Jan 2022 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197848;
        bh=OSe+im9JFy8BViBq6/nlfLKffW+SXhkaPqS3wYcfOMA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0LFyw2uk2AX7UAqxELXZ6XtVZCfadT8Y1bVx40Spjp3AZJ3/bQzAycVU8GkxKsiJe
         UUNbqJxruID8s0Fn85JMVukRF1qu1Jrt2d4DGOksgt+6Iu7AkBBgHR5QWcsNb3Y97f
         bDBp4JgQ+u5lm8Fwi4rb1aoGUQQcAdLhtPJZ9NqM=
Date:   Fri, 14 Jan 2022 14:04:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, calvinzhang.cool@gmail.com,
        catalin.marinas@arm.com, frowand.list@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, robh+dt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 024/146] mm: kmemleak: alloc gray object for
 reserved region with direct map
Message-ID: <20220114220408.0dD7Bxyv7%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Calvin Zhang <calvinzhang.cool@gmail.com>
Subject: mm: kmemleak: alloc gray object for reserved region with direct map

Reserved regions with direct mapping may contain references to other
regions.  CMA region with fixed location is reserved without creating
kmemleak_object for it.

So add them as gray kmemleak objects.

Link: https://lkml.kernel.org/r/20211123090641.3654006-1-calvinzhang.cool@gmail.com
Signed-off-by: Calvin Zhang <calvinzhang.cool@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/fdt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/of/fdt.c~mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map
+++ a/drivers/of/fdt.c
@@ -26,6 +26,7 @@
 #include <linux/serial_core.h>
 #include <linux/sysfs.h>
 #include <linux/random.h>
+#include <linux/kmemleak.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -522,9 +523,12 @@ static int __init __reserved_mem_reserve
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 
 		if (size &&
-		    early_init_dt_reserve_memory_arch(base, size, nomap) == 0)
+		    early_init_dt_reserve_memory_arch(base, size, nomap) == 0) {
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
+			if (!nomap)
+				kmemleak_alloc_phys(base, size, 0, 0);
+		}
 		else
 			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
_
