Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38814C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377810AbiATVXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347569AbiATVXs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EDCC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72C00618A0
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A834EC340E0;
        Thu, 20 Jan 2022 21:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713825;
        bh=OEQTUMuIyvMnIxTAIHh/86KsmcAEkrJyc4Qpw6kllfM=;
        h=Date:From:To:Subject:From;
        b=HPlo8Chx6snNdXhfpJDwu8Ao7qyk3rq++7+4x6ujY9Hf1HWUAw6/AaZkynv7Npewm
         SLEdoL6IicmG2RKfWLYCxtWt7ITz5W3u2SC1PmrPleqg5Fjz5k6PZgckQ3gxQktdSX
         afTNGaVlWtOUwez77fXqG7OoVps0prub7hNxDO6A=
Date:   Thu, 20 Jan 2022 13:23:45 -0800
From:   akpm@linux-foundation.org
To:     calvinzhang.cool@gmail.com, catalin.marinas@arm.com,
        frowand.list@gmail.com, mm-commits@vger.kernel.org,
        robh+dt@kernel.org
Subject:  [merged]
 mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch
 removed from -mm tree
Message-ID: <20220120212345.9KnmrS2G8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: alloc gray object for reserved region with direct map
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from calvinzhang.cool@gmail.com are


