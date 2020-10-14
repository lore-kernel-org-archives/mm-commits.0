Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC770C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E6E22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709317;
	bh=3Qn5VFnwVXKOH2NPdprRAaxBtfYF8klzlpRYa/uOW6o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=j2NdMy+2I2HT+wH8BIWhT8BU2h35MZHaP8me6i+bBLKDIfS3s5XvpstK7Y6DQ/zdr
	 hg+DB5hS1xsUdY3X9mbqubH1SgnwC86rlBpuTEypd6SJgpoFKdQZFnbYM8ewPLV65z
	 kF97Ae5CxesJy+JkDLF6eULK1PNAZv5mOaJANyWw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbgJNVBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbgJNVBt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C74622248;
        Wed, 14 Oct 2020 21:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709297;
        bh=3Qn5VFnwVXKOH2NPdprRAaxBtfYF8klzlpRYa/uOW6o=;
        h=Date:From:To:Subject:From;
        b=W3otJMyF8YhCyDAI5gDIoDk+8ePnXIqyo4cHOjdOX5e8/bESjUNL90VKQRVngoqPm
         E0dcpwh3r2cK0La0ikrHEju59FYL+xVOnc0rUJjeKe4/T1qYV8ZQd8NBTHuf+Fmcgn
         Q3lQacV5WZSfHEPQ6wII/nDOvzzdTXOvug1+Jtt0=
Date:   Wed, 14 Oct 2020 14:01:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yulei.kernel@gmail.com,
        yuleixzhang@tencent.com, ziy@nvidia.com
Subject:  [merged] mm-cleanup-mincore_huge_pmd.patch removed from
 -mm tree
Message-ID: <20201014210137.4zfBjXWNA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/huge_mm.h: remove mincore_huge_pmd declaration
has been removed from the -mm tree.  Its filename was
     mm-cleanup-mincore_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yulei.kernel@gmail.com are


