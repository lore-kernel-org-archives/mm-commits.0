Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7ECC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhKXAfO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhKXAfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:35:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B4E608FB;
        Wed, 24 Nov 2021 00:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637713918;
        bh=GZ2K4t5PvbWOgYUOKE1WYMuizdBFs+OWGtPfPy7vSXY=;
        h=Date:From:To:Subject:From;
        b=VN2G0QStamfRUxo4MQx0QRi0AvtvB5j18O37bYiwfFGnAhnqBl62fohSOL7+ggbEm
         i6v5NJoOr74zs3MLmOwr3pO0A7A3JFOCW+gW75dm8k37xnPg1eCaLevtlbHpF3ams+
         Yhzlvj3t6AfIqrUgIVsZJEazbPOTydxeN5n1xP3Q=
Date:   Tue, 23 Nov 2021 16:31:58 -0800
From:   akpm@linux-foundation.org
To:     calvinzhang.cool@gmail.com, catalin.marinas@arm.com,
        frowand.list@gmail.com, mm-commits@vger.kernel.org,
        robh+dt@kernel.org
Subject:  +
 mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch
 added to -mm tree
Message-ID: <20211124003158._R9_f7jfe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: alloc gray object for reserved region with direct map.
has been added to the -mm tree.  Its filename is
     mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Calvin Zhang <calvinzhang.cool@gmail.com>
Subject: mm: kmemleak: alloc gray object for reserved region with direct map.

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

mm-kmemleak-alloc-gray-object-for-reserved-region-with-direct-map.patch

