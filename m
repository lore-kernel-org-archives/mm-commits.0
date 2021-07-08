Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E65C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA9F61CD3
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhGHAhR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAhQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:37:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CA9B61CCF;
        Thu,  8 Jul 2021 00:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704475;
        bh=1ywRq0wDj3qEU0ZVbvhaGEc1xujfRBZKhrXiSaVKMuA=;
        h=Date:From:To:Subject:From;
        b=VewQ5Dp0WrmWsPige68BUYhf7GY1oywYKL8QekIIBdfQKT7GyQ/CFMAYDyI4KYz6s
         9WKf4iVFVoPUl0NsDntOCE6SVdXVWkmyBVRya3Vge6NEKf3M0HOPasIz0KG6NvkR2G
         4alD0GGrP9gOXSbyWBcJHW0zihwCvpCQ9fgTZaIA=
Date:   Wed, 07 Jul 2021 17:34:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-3.patch
 removed from -mm tree
Message-ID: <20210708003434.zBwyl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm: rename pud_page_vaddr to pud_pgtable and make it return pmd_t * fix
has been removed from the -mm tree.  Its filename was
     mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-3.patch

This patch was dropped because it was folded into mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] mm: rename pud_page_vaddr to pud_pgtable and make it return pmd_t * fix

Link: https://lkml.kernel.org/r/20210619134410.89559-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/include/asm/pgtable_32.h~mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-3
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -154,7 +154,7 @@ static inline unsigned long pmd_page_vad
 static inline pmd_t *pud_pgtable(pud_t pud)
 {
 	if (srmmu_device_memory(pud_val(pud))) {
-		return ~0;
+		return (pmd_t *)~0;
 	} else {
 		unsigned long v = pud_val(pud) & SRMMU_PTD_PMASK;
 		return (pmd_t *)__nocache_va(v << 4);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch

