Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE43C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A22A461456
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhD3FyX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhD3FyV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D7861452;
        Fri, 30 Apr 2021 05:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762014;
        bh=rAr4jp0h18Rs0Uz/pkg0Q5FuGrCt99WBLtLAPp79m3I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ANaOQBCbw9pERDbK+kB+hssNCNhpn48x2hWEcsUY94uuD3kITyXJslAYSZNSD3JxA
         Dsr/OFrYw6pvFdhIZTmCDvktmU3PPNi4O12p0MVc7Ayg5nyoA2cc9ANhcYN/cIV1ds
         SPBgSNqJzZO19Pg7QQtqmoXPWF7KkPO++SOUgLAg=
Date:   Thu, 29 Apr 2021 22:53:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, slyfox@gentoo.org,
        torvalds@linux-foundation.org
Subject:  [patch 006/178] ia64: simplify code flow around swiotlb
 init
Message-ID: <20210430055333.a5s5n6ytU%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: simplify code flow around swiotlb init

Before the change CONFIG_INTEL_IOMMU && !CONFIG_SWIOTLB && !CONFIG_FLATMEM
could skip `set_max_mapnr(max_low_pfn);` if iommu is not present on
system.

Link: https://lkml.kernel.org/r/20210328202439.403601-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/ia64/mm/init.c~ia64-simplify-code-flow-around-swiotlb-init
+++ a/arch/ia64/mm/init.c
@@ -644,13 +644,16 @@ mem_init (void)
 	 * _before_ any drivers that may need the PCI DMA interface are
 	 * initialized or bootmem has been freed.
 	 */
+	do {
 #ifdef CONFIG_INTEL_IOMMU
-	detect_intel_iommu();
-	if (!iommu_detected)
+		detect_intel_iommu();
+		if (iommu_detected)
+			break;
 #endif
 #ifdef CONFIG_SWIOTLB
 		swiotlb_init(1);
 #endif
+	} while (0);
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
_
