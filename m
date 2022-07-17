Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90687C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiGQX2I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiGQX2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC23B12602
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7563560C56
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA46BC341C0;
        Sun, 17 Jul 2022 23:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100483;
        bh=rLM4kgZyuvZYUN5FC8qJYGC/p031UnI39RHlrM7CYWc=;
        h=Date:To:From:Subject:From;
        b=fE1i/3VfaMlcneiA926pStAKB5qPEQRfuyotui0wWErLwteGMuunztQoGSxfLOrHM
         EZ/GjoGSXuu1S3GkwfBsNtjUk+0XShXi7EyXyrZJ2L882fTLAzL5OX2K9uutrgns8u
         eRfBhKCcQyRHoHZ3bUB7rlVuSBo3wnF4FPD7H2a0=
Date:   Sun, 17 Jul 2022 16:28:03 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch removed from -mm tree
Message-Id: <20220717232803.CA46BC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix
has been removed from the -mm tree.  Its filename was
     arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch

This patch was dropped because it was folded into arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix
Date: Mon, 27 Jun 2022 13:55:37 +0800

I missed the case that '__PAGETABLE_PMD_FOLDED', was defined, which PUD is
same with PMD.

Link: https://lkml.kernel.org/r/a14e7b39-6a8a-4609-b4a1-84ac574f5c96@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -373,8 +373,10 @@ unsigned long hugetlb_mask_last_page(str
 	unsigned long hp_size = huge_page_size(h);
 
 	switch (hp_size) {
+#ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
 		return PGDIR_SIZE - PUD_SIZE;
+#endif
 	case CONT_PMD_SIZE:
 		return PUD_SIZE - CONT_PMD_SIZE;
 	case PMD_SIZE:
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch

