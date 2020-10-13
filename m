Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34105C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D549021D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633268;
	bh=urIscRN6b2NWazdmmVVzJmomivzZi/DubZe+O9kZBIE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fruCm09xozWiZ/OgL64K1mwg99XTODKpFU1CjCBl+O3V/fCZU48wP0FkSEbD6ssph
	 +iYDYY44+znEt7kHH+jEji5K8HS1JGHTSupGjB1fEghAYZ7MtL0Rj3lGsipYtENViS
	 RjwEiJVcIBzmqIysAflyLdiki6nliwg1kW1H0XCU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgJMXy2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgJMXy2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C1E422200;
        Tue, 13 Oct 2020 23:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633266;
        bh=urIscRN6b2NWazdmmVVzJmomivzZi/DubZe+O9kZBIE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DarDBxBgyjyRT0zhTm3rpTVp/i/boPM4EAmiW+72VrpLTM+VuFgFVZ3IBmimrOb8K
         DMz+QqUpZzGz42dlBq1ed3MGeiIFLZmy7hZzO1gmDoAlaS3E7+M4GfsZr7/eL8u31e
         dC/y+WgazfRB69vDHGA4teMPp0xvCaMiXYk8iBmM=
Date:   Tue, 13 Oct 2020 16:54:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yulei.kernel@gmail.com, yuleixzhang@tencent.com, ziy@nvidia.com
Subject:  [patch 110/181] include/linux/huge_mm.h: remove
 mincore_huge_pmd declaration
Message-ID: <20201013235425.Fb1wZIvh2%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: yuleixzhang <yulei.kernel@gmail.com>
Subject: include/linux/huge_mm.h: remove mincore_huge_pmd declaration

As mincore_huge_pmd() was dropped, remove the declaration from the header
file.

Link: https://lkml.kernel.org/r/20200922083423.15074-1-yuleixzhang@tencent.com
Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-cleanup-mincore_huge_pmd
+++ a/include/linux/huge_mm.h
@@ -38,9 +38,6 @@ extern int zap_huge_pmd(struct mmu_gathe
 extern int zap_huge_pud(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pud_t *pud, unsigned long addr);
-extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec);
 extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			 unsigned long new_addr,
 			 pmd_t *old_pmd, pmd_t *new_pmd);
_
