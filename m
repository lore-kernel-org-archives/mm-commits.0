Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AA2C49EA5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81EA7613CD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhFPXKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234350AbhFPXKO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 19:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7892061246;
        Wed, 16 Jun 2021 23:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623884887;
        bh=VVR2QLj+FQ/4NVhpo7VriOmOht8Avv6GyjJpuAL2PeQ=;
        h=Date:From:To:Subject:From;
        b=ZPSAKh6jgDpOVOqIOWo4YCNSuJ0LbaJ7v5LMJR5DEaMX/RcHUUBigz9XVEW/MjFUl
         JCq0V65+1Eld7Us8gJ7p/oG4aCfrovhMcpau13bDI1Cl4yJzNO2mZEDjU2ocfBcyAx
         ZF1JKy6MOm8nugRQ15XsA85DrIfBBFXV5hEgdgTE=
Date:   Wed, 16 Jun 2021 16:08:07 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [to-be-updated]
 =?US-ASCII?Q?mm-rename-pud=5Fpage=5Fvaddr-to-pud=5Fpgtable-and-make-it-?=
 =?US-ASCII?Q?return-pmd=5Ft-fix-2.patch?= removed from -mm tree
Message-ID: <20210616230807.zhB39rSJW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2
has been removed from the -mm tree.  Its filename was
     mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2

Link: https://lkml.kernel.org/r/87wnqtnb60.fsf@linux.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2
+++ a/arch/alpha/include/asm/pgtable.h
@@ -236,7 +236,7 @@ pmd_page_vaddr(pmd_t pmd)
 #define pmd_page(pmd)	(pfn_to_page(pmd_val(pmd) >> 32))
 #define pud_page(pud)	(pfn_to_page(pud_val(pud) >> 32))
 
-static inline pmd_t *pud_pgtable(pud_t pgd)
+extern inline pmd_t *pud_pgtable(pud_t pgd)
 {
 	return (pmd_t *)(PAGE_OFFSET + ((pud_val(pgd) & _PFN_MASK) >> (32-PAGE_SHIFT)));
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

