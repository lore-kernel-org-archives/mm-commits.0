Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51272C48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29EED613BE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWVvA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWVu7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 17:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8D8D613BD;
        Wed, 23 Jun 2021 21:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624484919;
        bh=9s0eE69DTwQst3u6J7q59nm+B9aPHsaO2oTvp4XJHiY=;
        h=Date:From:To:Subject:From;
        b=jXOm4osj1Y2ScCXSw6rxr6s+MCdOxwxe56lZB1aBQOBd+47vNZyUCkyMSQhw/JkNl
         K/C7XRx//um4PwETLY5xPCDZSrNlE1cpDo9TCvZHW3SE+zgU+jRiHOb2FWfDszLbKL
         1HSW+pSymoi+VuEuoFjHVyZY+Ry6GrDPwU91n3KA=
Date:   Wed, 23 Jun 2021 14:48:39 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 =?US-ASCII?Q?mm-rename-pud=5Fpage=5Fvaddr-to-pud=5Fpgtable-and-make-it-?=
 =?US-ASCII?Q?return-pmd=5Ft-fix-3.patch?= added to -mm tree
Message-ID: <20210623214839.B5soFi4HG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm: rename pud_page_vaddr to pud_pgtable and make it return pmd_t * fix
has been added to the -mm tree.  Its filename is
     mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-3.patch

