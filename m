Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527C1C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F4D36141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEHWkI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWkH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1DF613EA;
        Sat,  8 May 2021 22:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513545;
        bh=PCz+dl20ZDbap8eks6FjBmFKU61P8DxPZc5SBK4hskk=;
        h=Date:From:To:Subject:From;
        b=w1CWR2nOFPNM/drLTzqNy3jz5YqEtrHGmoV2PJsusFNdZtPtNBDR2iowxJ5WLLY+3
         QtbqmgsXkUqU/zuJVbRQ3RwiH6wdUnG3v23LTKkl84nEFlDlUZ07wi0+YdvvKT+H6k
         gY0x6tRBHZlIjGVmVVQ8dTcZgo4cmAcSumJmyHPY=
Date:   Sat, 08 May 2021 15:39:05 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org,
        slyfox@gentoo.org
Subject:  [merged]
 ia64-simplify-code-flow-around-swiotlb-init.patch removed from -mm tree
Message-ID: <20210508223905.DWa7GcE6O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: simplify code flow around swiotlb init
has been removed from the -mm tree.  Its filename was
     ia64-simplify-code-flow-around-swiotlb-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from slyfox@gentoo.org are


